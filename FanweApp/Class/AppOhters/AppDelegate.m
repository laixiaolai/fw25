//
//  AppDelegate.m
//  FanweApp
//
//  Created by xfg on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.


#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "NewFeatureController.h"
#import "UMessage.h"
#import "UMSocialWechatHandler.h"
#import "AppModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CustomMessageModel.h"
#import "LoginViewController.h"
#import "GTMBase64.h"
#import "UserModel.h"
#import "dataModel.h"
#import <UserNotifications/UserNotifications.h>
#import "AdJumpViewModel.h"
#import "UMMobClick/MobClick.h"
#import "FLAnimatedImage.h"
#import "FWInterface.h"
#import "SHomePageVC.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

#define SavePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"user.archive"]

#define kAdImgViewLoadFromNetTimes  1     // 启动广告图从网络下载的最大时间，如果超过该时间则该次启动不显示

static SystemSoundID shake_sound_male_id = 0;

@interface AppDelegate ()<NewFeatureControllerDelegate,NewFeatureControllerDatasourse,WXApiDelegate,QMapLocationViewDelegate>
{
    NetHttpsManager         *_httpsManager;
    MBProgressHUD           *_HUD;
    
    QMapLocationView        *_mapLocationView;          // 腾讯地图
    IMALoginParam           *_loginParam;               // 判断是否登录
    
    FLAnimatedImageView     *_advImgView;
    HMHotBannerModel        *_adModel;
    BOOL                    _isAdTouched;               // 广告图是否能够点击
    
    NSString                *_pboardString;             // 粘贴板的字符串
    
    NSDictionary            *_pushInfoDict;
    
    BOOL                    _isEnterForeground;         // YES:在前台，NO:在后台或程序还没有启动
    BOOL                    _isFirstLoad;               // YES:第一次启动
    BOOL                    _isFirstLoadInit;           // 是否第一次加载初始化接口
    
    BOOL                    _isShowAdImgViewIng;        // 是否正在显示启动广告图
    NSInteger               _currentMainUrlIndex;       // 当前域名对应备用域名数组的所在下标
    
    NSInteger               _netChangedTimes;           // 网络变化次数
    NSTimeInterval          _willResignActiveDate;      // 将要进入后台的时间（秒）
}

@property (nonatomic, strong) GlobalVariables       *fanweApp;
@property (nonatomic, assign) BOOL                  isShowAdImgView;    // 是否需要显示启动广告图
@property (nonatomic, copy) NSString                *homePageUserId;    // 私密直播关闭之后用户的userID，目的进入主页看回看
@property (nonatomic, strong) UserModel             *pushUserModel;

@end


@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef __IPHONE_11_0
    if (@available(ios 11.0,*))
    {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
#endif
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0)
    {
        NSLog(@"NSFoundationVersionNumber==%d",(int)NSFoundationVersionNumber);
    }
    
    // iOS 10之前
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:settings];
    
    // iOS 10
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"request authorization succeeded!");
        }
    }];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
    
    _sus_window = [[SuspenionWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [_sus_window makeKeyWindow];
    _sus_window.hidden = YES;
    
    // 用来延时遮盖，等异步请求初始化接口成功后替换掉
    UIViewController *tmpController = [[UIViewController alloc]init];
    UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    tmpImgView.contentMode = UIViewContentModeScaleToFill;
    [tmpImgView setImage:[UIImage imageNamed:@"wel"]];
    [tmpController.view addSubview:tmpImgView];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tmpController;
    [self.window makeKeyAndVisible];
    
    _isFirstLoad = YES;
    _isShowAdImgView = YES;
    
    self.fanweApp = [GlobalVariables sharedInstance];
    _httpsManager = [NetHttpsManager manager];
    _pushInfoDict = [NSDictionary dictionary];
    
    // 异步加载初始化接口
    _isFirstLoadInit = YES;
    [self asyncInit];
    
    // 网络监听
    [self performSelector:@selector(startMonitor) withObject:nil afterDelay:3];
    
    // 配置第三方sdk
    [self configureOhter:launchOptions];
    
    // 地图定位
    _mapLocationView = [QMapLocationView sharedInstance];
    _mapLocationView.delegate = self;
    [_mapLocationView startLocate];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    return YES;
}

#pragma mark 配置第三方sdk
- (void)configureOhter:(NSDictionary *)launchOptions
{
    // 设置ILiveSDK日志级别
    //    [[TIMManager sharedInstance] initLogSettings:YES logPath:[[TIMManager sharedInstance] getLogPath]];
    //    [[TIMManager sharedInstance] setLogLevel:TIM_LOG_NONE];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengKey];
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:WeixinAppId
                                       appSecret:WeixinSecret
                                     redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:QQAppId
                                       appSecret:QQSecret
                                     redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:SinaAppId
                                       appSecret:SinaSecret
                                     redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    // 友盟统计
    UMConfigInstance.appKey = UmengKey;
    UMConfigInstance.secret = UmengSecret;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    // set AppKey and AppSecret
    [UMessage startWithAppkey:UmengKey launchOptions:launchOptions];
    
    // 腾讯地图
    [QMapServices sharedServices].apiKey = QQMapKey;
    [[QMapServices sharedServices] setApiKey:QQMapKey];
    [[QMSSearchServices sharedServices] setApiKey:QQMapKey];
    
    // 友盟推送
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
    
    // for log
    [UMessage setLogEnabled:NO];
    
    //BMK
    [self showBMK];
    
    // 键盘事件
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    // jubao pay
    if (WeixinAppId.length>0)
    {
        [FWInterface init:JBFAppId useAPI:YES withWXAppId:WeixinAppId];
    }
    else
    {
        [FWInterface init:JBFAppId useAPI:YES withWXAppId:nil];
    }
}


#pragma mark ------ BMK
- (void)showBMK
{
    BMKMapManager *manager = [[BMKMapManager alloc]init];
    BOOL result = [manager start:BaiduMapKey generalDelegate:nil];
    if (result)
    {
        
    }
    else
    {
        
    }
}

#pragma mark - ----------------------- 进入相关页面 -----------------------
- (void)beginEnterMianUI
{
    if (![NSKeyedUnarchiver unarchiveObjectWithFile:SavePath] && [IsNeedFirstIntroduce isEqualToString:@"YES"])
    {
        [self setNewFeatureVisiable];
    }
    else
    {
        if (kSupportH5Shopping == 1)
        {
            [self loadH5MianView];
        }
        else
        {
            BOOL isAutoLogin = [IMAPlatform isAutoLogin];
            if (isAutoLogin)
            {
                _isTabBarShouldLoginIMSDK = YES;
                [self enterMainUI];
            }
            else
            {
                _isTabBarShouldLoginIMSDK = NO;
                [self enterLoginUI];
            }
        }
    }
}

#pragma mark 进入登录页面
- (void)enterLoginUI
{
    [FWIMLoginManager sharedInstance].isIMSDKOK = NO;
    if (!kSupportH5Shopping)
    {
        if ([self.window.rootViewController isKindOfClass:[FWTabBarController class]])
        {
            FWTabBarController *tmpNav = (FWTabBarController *)self.window.rootViewController;
            for (UIViewController *vc in tmpNav.childViewControllers)
            {
                if ([vc isKindOfClass:[LoginViewController class]])
                {
                    return;
                }
            }
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:kIMAPlatform_AutoLogin_Key];
        [userDefaults removeObjectForKey:kIMALoginParamUserKey];
        [userDefaults removeObjectForKey:kMyCookies];
        [userDefaults synchronize];
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
        for (id obj in cookieArray)
        {
            [cookieJar deleteCookie:obj];
        }
        
        LoginViewController *login = [[LoginViewController alloc]init];
        FWNavigationController *nav = [[FWNavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController = nav;
    }
}

#pragma mark 加载h5主页
- (void)loadH5MianView
{
    if (!_webViewNav)
    {
        NSString *tmpUrl;
        if ([self.fanweApp.appModel.site_url length]>7)
        {
            tmpUrl = self.fanweApp.appModel.site_url;
        }
        else
        {
            tmpUrl = H5MainUrlStr;
        }
        
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:tmpUrl isShowIndicator:YES];
        tmpController.isShowLaunchImgView = YES;
        _webViewNav = [[FWNavigationController alloc] initWithRootViewController:tmpController];
        
        self.window.rootViewController = _webViewNav;
    }
    else
    {
        self.window.rootViewController = _webViewNav;
    }
}

#pragma mark 加载原生主页
- (void)enterMainUI
{
    if (_isTabBarShouldLoginIMSDK)
    {
        _isTabBarShouldLoginIMSDK = NO;
        [[FWIMLoginManager sharedInstance] loginImSDK:NO succ:nil failed:nil];
    }
    [FWTabBarController sharedInstance].selectedIndex = 0;
    self.window.rootViewController = [FWTabBarController sharedInstance];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"haveLanch"];
    // 换号登录发出这个通知，才会再一次调动每日首次登陆奖励,否则登录提示不会显示
    [[NSNotificationCenter defaultCenter]postNotificationName:@"rewardView" object:nil];
}

#pragma mark进入tabBar
- (void)entertabBar
{
    UITabBarController *tabBars = [FWTabBarController sharedInstance];
#if  kSupportH5Shopping
    tabBars.selectedIndex = 1;
#endif
    self.window.rootViewController = tabBars;
}

- (void)validateCurrentUrl
{
    if (self.fanweApp.doMainUrlArray)
    {
        for (NSString *tmpUrl in self.fanweApp.doMainUrlArray)
        {
            [FWUtils validateUrl:[NSURL URLWithString:tmpUrl]validateResult:^(NSURL *currentUrl, BOOL isSucc) {
                
            }];
        }
    }
}

#pragma mark - ----------------------- 初始化接口 -----------------------
#pragma mark 异步加载初始化接口
- (void)asyncInit
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"init" forKey:@"act"];
    
    NSString *postUrl;
    
#if kSupportH5Shopping
    postUrl = H5InitUrlStr;
#else
    postUrl = self.fanweApp.currentDoMianUrlStr;
#endif
    
    __weak AppDelegate *ws = self;
    [_httpsManager POSTWithUrl:postUrl paramDict:parmDict SuccessBlock:^(NSDictionary *responseJson){
        
        if (responseJson)
        {
            [ws setFirstLoad:responseJson];
        }
        else
        {
            [ws loadInitError];
        }
        
        [ws.fanweApp storageAppCurrentMainUrl:ws.fanweApp.currentDoMianUrlStr];
        
    } FailureBlock:^(NSError *error) {
        
        NSLog(@"=====初始化接口失败，错误码：%ld",error.code);
        
        // 如果非网络原因导致的错误，尝试切换域名
        if (error.code != NSURLErrorNetworkConnectionLost && error.code != NSURLErrorNotConnectedToInternet)
        {
            if (_currentMainUrlIndex < [ws.fanweApp.doMainUrlArray count])
            {
                NSString *tmpMainUrl = [ws.fanweApp.doMainUrlArray objectAtIndex:_currentMainUrlIndex];
                tmpMainUrl = [tmpMainUrl stringByAppendingString:AppDoMainUrlSuffix];
                ws.fanweApp.currentDoMianUrlStr = tmpMainUrl;
            }
            
            if (_currentMainUrlIndex >= [ws.fanweApp.doMainUrlArray count]-1)
            {
                _currentMainUrlIndex = 0;
            }
            else
            {
                _currentMainUrlIndex ++;
            }
        }
        
        [ws loadInitError];
        
    }];
}

#pragma mark 首次加载的时候相关的业务逻辑
- (void)setFirstLoad:(NSDictionary *)responseDict
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self setInitData:responseDict];
    
    [self setAppConfig];
    
    if (_isFirstLoadInit)
    {
        _isFirstLoadInit = NO;
        
        [self initAdvView:responseDict];
        
        // 如果有启动广告图，则暂不加载主页
        NSArray *addArray = [responseDict objectForKey:@"start_diagram"];
        if (addArray && [addArray isKindOfClass:[NSArray class]])
        {
            if (addArray.count)
            {
                if (![FWUtils isBlankString:_adModel.image])
                {
                    return;
                }
            }
        }
        
        [self beginEnterMianUI];
    }
}

#pragma mark 初始化接口接在失败的情况
- (void)loadInitError
{
    [self setAppConfig];
    [self setAppLoginType];
    if (_isFirstLoadInit)
    {
        _isFirstLoadInit = NO;
        
        [self beginEnterMianUI];
    }
    
    [self performSelector:@selector(asyncInit) withObject:nil afterDelay:5];
}

#pragma mark 接收初始化接口的参数
- (void)setInitData:(NSDictionary *)responseDict
{
    self.fanweApp.appModel = [AppModel mj_objectWithKeyValues:responseDict];
    self.fanweApp.appModel.isInitSucceed = YES;
    
    NSArray *domainArray = [responseDict objectForKey:@"domain_list"];
    if (domainArray && [domainArray isKindOfClass:[NSArray class]])
    {
        [self.fanweApp storageAppMainUrls:domainArray];
    }
    
    if (self.fanweApp.listMsgMArray)
    {
        [self.fanweApp.listMsgMArray removeAllObjects];
    }
    NSArray *listmsg = [responseDict objectForKey:@"listmsg"];
    if (listmsg && [listmsg isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *tmpDic in listmsg)
        {
            CustomMessageModel *customMessageModel = [CustomMessageModel mj_objectWithKeyValues:tmpDic];
            [customMessageModel prepareForRender];
            [self.fanweApp.listMsgMArray addObject:customMessageModel];
        }
    }
    
    if (self.fanweApp.appModel.version.has_upgrade == 1)
    {
        self.fanweApp.ios_down_url = self.fanweApp.appModel.version.ios_down_url;
        
        //强制升级:forced_upgrade ; 0:非强制升级，可取消; 1:强制升级
        if (self.fanweApp.appModel.version.forced_upgrade == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fanweApp.ios_down_url]];
        }
        else
        {
            FWWeakify(self)
            [FanweMessage alert:@"提示" message:@"发现新版本，需要升级吗？" destructiveAction:^{
                
                FWStrongify(self)
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fanweApp.ios_down_url]];
                
            } cancelAction:^{
                
            }];
        }
    }
}

#pragma mark 配置app内的相关称呼
- (void)setAppConfig
{
    if (!self.fanweApp.appModel.short_name || [self.fanweApp.appModel.short_name isEqualToString:@""])
    {
        self.fanweApp.appModel.short_name = ShortNameStr;
    }
    if (!self.fanweApp.appModel.ticket_name || [self.fanweApp.appModel.ticket_name isEqualToString:@""])
    {
        self.fanweApp.appModel.ticket_name = TicketNameStr;
    }
    if (!self.fanweApp.appModel.account_name || [self.fanweApp.appModel.account_name isEqualToString:@""])
    {
        self.fanweApp.appModel.account_name = AccountNameStr;
    }
    if (!self.fanweApp.appModel.diamond_name || [self.fanweApp.appModel.diamond_name isEqualToString:@""])
    {
        self.fanweApp.appModel.diamond_name = DiamondNameStr;
    }
}

#pragma mark 如果异步初始化接口失败，则显示所有的登录方式
- (void)setAppLoginType
{
    if (![FWUtils isBlankString:WeixinAppId])
    {
        self.fanweApp.appModel.has_wx_login = 1;
    }
    if (![FWUtils isBlankString:QQAppId])
    {
        self.fanweApp.appModel.has_qq_login = 1;
    }
    if (![FWUtils isBlankString:SinaAppId])
    {
        self.fanweApp.appModel.has_sina_login = 1;
    }
    
    self.fanweApp.appModel.has_mobile_login = 1;
}


#pragma mark - ----------------------- 启动广告图 -----------------------
#pragma mark 初始化广告图
- (void)initAdvView:(NSDictionary *)responseDict
{
    if (![NSKeyedUnarchiver unarchiveObjectWithFile:SavePath] && [IsNeedFirstIntroduce isEqualToString:@"YES"])
    {
        return;
    }
    
    // 启动广告图
    NSArray *addArray = [responseDict objectForKey:@"start_diagram"];
    if (addArray && [addArray isKindOfClass:[NSArray class]])
    {
        if (addArray.count)
        {
            _adModel = [HMHotBannerModel mj_objectWithKeyValues:[addArray firstObject]];
            
            _advImgView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            _advImgView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToAdView)];
            [_advImgView addGestureRecognizer:singleRecognizer];
            
            [self performSelector:@selector(changeShowAdImgView) withObject:nil afterDelay:kAdImgViewLoadFromNetTimes];
            
            if ([FWUtils isBlankString:_adModel.image])
            {
                return;
            }
            
            FWWeakify(self)
            [_advImgView sd_setImageWithURL:[NSURL URLWithString:_adModel.image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                FWStrongify(self)
                
                if (self.isShowAdImgView)
                {
                    [self beginEnterMianUI];
                    [self.window addSubview:_advImgView];
                    [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:3];
                    self.isShowAdImgView = NO;
                }
                
            }];
        }
    }
}

- (void)changeShowAdImgView
{
    if (self.isShowAdImgView)
    {
        [self beginEnterMianUI];
    }
    _isShowAdImgView = NO;
}

#pragma mark 退出广告图
- (void)removeAdvImage
{
    [UIView animateWithDuration:0.3f animations:^{
        _advImgView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _advImgView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_advImgView removeFromSuperview];
    }];
}

#pragma mark 启动广告图的点击跳转
- (void)jumpToAdView
{
    if (_adModel.url && !_isAdTouched)
    {
        if (kSupportH5Shopping)
        {
            [self loadH5MianView];
        }
        else
        {
            if ([AdJumpViewModel adToOthersWith:_adModel])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"adjump" object:[AdJumpViewModel adToOthersWith:_adModel]];
            }
        }
    }
    _isAdTouched = YES;
}


#pragma mark - ----------------------- 首次安装简介 -----------------------
#pragma mark 首次安装显示的多张简介图
- (void)setNewFeatureVisiable
{
    [NSKeyedArchiver archiveRootObject:@"NOFirst_login" toFile:SavePath];
    NewFeatureController *controller = [[NewFeatureController alloc]init];
    controller.delegate=self;
    controller.Datasourse=self;
    __weak AppDelegate *weakSelf = self;
    [controller setStartAppBlock:^{
        //[weakSelf enterMainUI];
        
        BOOL isAutoLogin = [IMAPlatform isAutoLogin];
        if (isAutoLogin)
        {
            _isTabBarShouldLoginIMSDK = YES;
            [weakSelf enterMainUI];
        }
        else
        {
            _isTabBarShouldLoginIMSDK = NO;
            [weakSelf enterLoginUI];
        }
    }];
    self.window.rootViewController=controller;
}

#pragma mark NewFeatureControllerDatasourse (数据源代理，告诉控制器显示几张图片，和显示什么图片)
- (NSInteger)NewFeatureControllerPhotosNumber
{
    NSString *countStr = FirstIntroduceImgCount;
    return [countStr integerValue];
}

-(UIImageView*)NewFeatureControllerImageViewIndex:(NSUInteger)index
{
    NSString *imageName=[NSString stringWithFormat:@"new_feature_%ld.jpg",(unsigned long)index];
    return [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}


#pragma mark - ----------------------- 监听网络 -----------------------
- (void)startMonitor
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring]; //开始监听网络状态变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)ReachabilityDidChange:(NSNotification *)not
{
    BOOL netConnected;
    
    NSDictionary *userInfo = not.userInfo;
    _reachabilityStatus = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    NSLog(@"============:ReachabilityDidChange");
    switch (_reachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            netConnected = NO;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            netConnected = NO;
            [[FWHUDHelper sharedInstance] tipMessage:@"哎呀！网络不大给力！"];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            netConnected = YES;
            NSLog(@"您正在使用手机自带网络进行访问");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            netConnected = YES;
            NSLog(@"您正在使用wifi进行访问");
            break;
        default:
            break;
    }
    
    if (_netChangedTimes >= 1 && netConnected && !self.fanweApp.appModel.isInitSucceed)
    {
        [self loadInitError];
        [_mapLocationView startLocate];
    }
    
    _netChangedTimes ++;
}


#pragma mark - ----------------------- 应用回调 -----------------------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleAllUrl:application url:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleAllUrl:application url:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [self handleAllUrl:app url:url];
}

- (BOOL)handleAllUrl:(UIApplication*)app url:(NSURL*)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    
    if ([url.host isEqualToString:@"safepay"])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    else if([url.absoluteString rangeOfString:WeixinAppId].location != NSNotFound)
    {
        // 微信支付
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return result;
}

//微信支付回调处理
- (void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]])
    {
        // 支付返回结果，实际支付结果需要去微信服务器端查询
        if([SResBase shareClient].mg_pay_block)
        {
            // 充值界面的支付回掉处理
            SResBase* retobj = SResBase.new;
            if( resp.errCode == -1 )
            {
                retobj.msuccess = NO;
                retobj.mmsg = @"支付出现异常";
            }
            else if( resp.errCode == -2 )
            {
                retobj.msuccess = NO;
                retobj.mmsg = @"用户取消了支付";
            }
            else
            {
                retobj.msuccess = YES;
                retobj.mmsg = @"支付成功";
            }
            
            [SResBase shareClient].mg_pay_block( retobj );
            return;
        }
        
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode)
        {
                // retcode 0:支付成功 -1：支付失败 -2：用户取消
            case WXSuccess:
                strMsg = @"支付成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccess" object:nil];
                
                break;
            default:
                if (resp.errCode == -2)
                {
                    strMsg = @"用户取消";
                }
                else if(resp.errCode == -1)
                {
                    strMsg = @"支付失败";
                }
                NSLog(@"支付结果：错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        [FanweMessage alert:strMsg];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *myresp = (SendAuthResp *)resp;
        
        NSString *jsonStr = [NSString stringWithFormat:@"{\"login_sdk_type\":\"wxlogin\",\"code\":\"%@\",\"err_code\":\"%d\"}",myresp.code,resp.errCode];
        [[NSNotificationCenter defaultCenter]postNotificationName:kWXLoginBack object:jsonStr];
        
        switch (resp.errCode)
        {
                // retcode: 0：用户同意 -4：用户拒绝授权 -2：用户取消
            case -4:
                strMsg = @"用户拒绝授权！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case -2:
                strMsg = @"用户取消！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                
                break;
        }
    }
}

#pragma mark - ----------------------- 推送相关 -----------------------
#pragma mark 推送设置
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    
    NSLog(@"deviceToken=%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""]);
    self.fanweApp.deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                                 stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getDeviceTokenComplete" object:nil];
    
    [self performSelector:@selector(configApns) withObject:nil afterDelay:5];
}

#pragma mark 上传设备id（友盟推送）
- (void)configApns
{
    [AppViewModel updateApnsCode];
}

#pragma mark 播放自定义推送声音
- (void)playCustomSound
{
    //声音文件格式转换代码
    //afconvert /System/Library/Sounds/Submarine.aiff ~/Desktop/sub.caf -d ima4 -f caff -v
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mycustomsound2" ofType:@"aiff"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s",__func__);
    NSLog(@"%@",userInfo);
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"%s",__func__);
    NSLog(@"%@",userInfo);
    
    if ([userInfo toInt:@"type"] == 0)//检查直播状态
    {
        [self checkVideoStatus:userInfo andTag:0];
    }
    else if ([userInfo toInt:@"type"] == 5)//友盟推送到付款界面
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_user_pai isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = @"我的竞拍";
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
    else if ([userInfo toInt:@"type"] == 4)//会员中心
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:[userInfo toString:@"url"] isShowIndicator:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
    else
    {
        if (_isEnterForeground)
        {
            [self playCustomSound];//播放自定义推送声音
        }
    }
}

#pragma mark - ----------------------- 其他 -----------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%s",__func__);
    
    if ([FWIMLoginManager sharedInstance].isIMSDKOK)
    {
        [AppViewModel userStateChange:@"Login"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHome object:nil userInfo:nil];
        
        [self getInformation];
    }
    
    if (!_isFirstLoad && [IMAPlatform sharedInstance].host.imUserId)
    {
        if ([[IMAPlatform sharedInstance].host.imUserId intValue])
        {
            [[IMAPlatform sharedInstance].host getMyInfo:nil];
        }
    }
    
    NSDate *nowDate = [NSDate date];
    self.fanweApp.foreGroundTime = [nowDate timeIntervalSince1970];
    
#if kSupportH5Shopping
    
    //    if (!_isFirstLoad) {
    //
    //        NSTimeInterval nowInterval = [nowDate timeIntervalSince1970];
    //
    //        if (nowInterval - _willResignActiveDate > self.fanweApp.appModel.reload_time)
    //        {
    //            [self loadH5MianView];
    //        }
    //    }
#endif
    
    _isFirstLoad = NO;
    _isEnterForeground =  YES;
    
    // 必须
    // FW code start
    [FWInterface applicationWillEnterForeground:application];
    // FW code end
}

#pragma mark 已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%s",__func__);
    
    [AppViewModel userStateChange:@"Logout"];
    
    NSDate *nowDate = [NSDate date];
    self.fanweApp.backGroundTime = [nowDate timeIntervalSince1970];
    
#if kSupportH5Shopping
    
    if (self.fanweApp.appModel.reload_time>0)
    {
        
        _willResignActiveDate = [nowDate timeIntervalSince1970];
    }
    
#endif
    
    _isEnterForeground = NO;
}

#pragma mark 获取粘贴板的信息
- (void)getInformation
{
    self.fanweApp = [GlobalVariables sharedInstance];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    _pboardString = pboard.string;
    NSString *keyString =[GTMBase64 decodeBase64:@"8J+UkQ=="];
    
    if ([_pboardString rangeOfString:keyString].location != NSNotFound)
    {
        self.fanweApp.privateKeyString = (NSString *) [[[[_pboardString componentsSeparatedByString:keyString] objectAtIndex:1] componentsSeparatedByString:keyString] objectAtIndex:0];
        if (self.fanweApp.privateKeyString)
        {
            if ([self.fanweApp.privateKeyString length])
            {
                NSDictionary *dict = [NSDictionary dictionary];
                [self checkVideoStatus:dict andTag:1];
            }
        }
    }
}

#pragma mark 检查直播状态 tag: 0：推送 1：私密直播
// 私密直播的提示:首先如果直播结束跳转到个人中心，否则判断是否在直播间，不在直播间就进入直播间否则做已在直播间的提示
- (void)checkVideoStatus:(NSDictionary *)dict andTag:(NSInteger)tag
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"check_status" forKey:@"act"];
    
    NSString *room_id = [dict toString:@"room_id"];
    
    if (tag == 0 && room_id && ![room_id isEqualToString:@""])
    {
        [mDict setObject:[dict toString:@"room_id"] forKey:@"room_id"];
    }
    if (tag == 1 && self.fanweApp.privateKeyString.length > 0)
    {
        [mDict setObject:self.fanweApp.privateKeyString forKey:@"private_key"];
    }
    
    FWWeakify(self)
    [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"live_in"] == FW_LIVE_STATE_ING) //正在直播
        {
            self.pushUserModel = [UserModel mj_objectWithKeyValues:responseJson];
            
            if (![IMAPlatform isHost:self.pushUserModel.user_id])
            {
                if ([self.fanweApp.liveState.roomId intValue] && tag == 1) // 当前正在直播间
                {
                    // 表示当前用户正在直播间（可能是直播或者看直播）
                    if (self.fanweApp.liveState.isLiveHost == YES) // 主播
                    {
                        [[FWHUDHelper sharedInstance] tipMessage:@"您当前正在直播"];
                        self.fanweApp.privateKeyString = @"";
                        return ;
                    }
                    else//不是主播
                    {
                        if ([self.fanweApp.liveState.roomId isEqualToString:self.pushUserModel.room_id])//正在直播间
                        {
                            [[FWHUDHelper sharedInstance] tipMessage:@"您当前正在直播间内"];
                            self.fanweApp.privateKeyString = @"";
                            return;
                        }
                        else
                        {
                            [[FWHUDHelper sharedInstance] tipMessage:@"您当前正在直播间内"];
                            return;
                        }
                    }
                }
                else // 当前不在直播间内，接收到推送或者私密直播
                {
                    if (tag == 0)
                    { // 推送
                        [self showAlert:responseJson tag:2];
                    }
                    else
                    { // 私密直播
                        [self showAlert:responseJson tag:3];
                    }
                }
            }
        }
        else if ([responseJson toInt:@"live_in"] == FW_LIVE_STATE_OVER)
        {
            [UIPasteboard generalPasteboard].string = @"";
            [self showAlert:responseJson tag:8];
            self.homePageUserId = [responseJson toString:@"user_id"];
            self.fanweApp.privateKeyString = @"";
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)showAlert:(NSDictionary *)responseJson tag:(int)tag
{
    FWWeakify(self)
    [FanweMessage alert:nil message:[responseJson toString:@"content"] destructiveAction:^{
        
        FWStrongify(self)
        if (tag == 2)
        { //用户正在前台时收到推送
            [self enterNowLive];
        }
        else if (tag == 3)
        { //私密直播
            [self enterNowLive];
        }
        else if (tag == 8)
        {
            SHomePageVC *tmpController= [[SHomePageVC alloc]init];
            tmpController.user_id = self.homePageUserId;
            tmpController.type = 0;
            [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        }
        
    } cancelAction:^{
        
    }];
}

- (void)enterNowLive
{
    UserModel *model = _pushUserModel;
    
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
    item.chatRoomId = model.group_id;
    item.avRoomId = [model.room_id intValue];
    item.title = model.room_id;
    item.vagueImgUrl = model.head_image;
    
    TCShowUser *showUser = [[TCShowUser alloc]init];
    showUser.uid = model.user_id;
    showUser.avatar = model.head_image;
    item.host = showUser;
    
    if (self.fanweApp.liveState.isInPubViewController)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLiveView" object:nil];
    }
    item.liveType = FW_LIVE_TYPE_AUDIENCE;
    
    BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
    [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofTCShowLiveListItem:item isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
        
    }];
}

//// 切换当前直播间
//- (void)changeNowLive
//{
//    [FanweMessage alertHUD:@"请退出当前直播间后重新尝试！"];
//}

#pragma mark 是否显示hud
- (void)isShowHud:(BOOL)isShow hideTime:(float)hideTime
{
    if (isShow && !_HUD)
    {
        _HUD = [[FWHUDHelper sharedInstance] loading:@""];
        if (hideTime)
        {
            [self performSelector:@selector(hideHud) withObject:nil afterDelay:hideTime];
        }
    }
    else
    {
        [self hideHud];
    }
}

- (void)hideHud
{
    if (_HUD)
    {
        [[FWHUDHelper sharedInstance] stopLoading:_HUD];
        _HUD = nil;
    }
}

@end
