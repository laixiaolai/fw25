//
//  PopMenuCenter.m
//  FanweApp
//
//  Created by 岳克奎 on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PopMenuCenter.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "PublishLivestViewController.h"
#import "AgreementViewController.h"

@implementation PopMenuCenter
#pragma mark ----------------------- life cycle生命周期管控区域 -------------------
/**
 * @brief: 单利
 *
 * @discussion:我的想法是，用单例管理，这样能够通过的player对应的控制器来控制。播放，暂停。如果不这样，需要频繁的
 */
static PopMenuCenter *signleton = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signleton = [super allocWithZone:zone];
    });
    return signleton;
}

+(PopMenuCenter *)sharePopMenuCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signleton = [[self alloc] init];
    });
    
    return signleton;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return signleton;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return signleton;
}
#pragma mark ********************************** Delegate 协议区域**************************
#pragma mark ----------- <STPop的menu菜单delegate>
/**
 * @brief:  根据点击索引，加载对应模块
 * @prama:  popMenuView   动态菜单底层管理层
 * @prama:  index         点击索引
 */
-(void)popMenuView:(HyPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index{
    
    //开直播
    if (index == 0)
    {
        IMALoginParam *loginParam = [IMALoginParam loadFromLocal];
        if (loginParam.isAgree ==1)
        {
            PublishLivestViewController *pvc = [[PublishLivestViewController alloc] init];
            [[AppDelegate sharedAppDelegate] presentViewController:pvc animated:YES completion:^{
                
            }];
        }
        else
        {
            AgreementViewController *agreeVC = [AgreementViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.agreement_link isShowIndicator:YES isShowNavBar:YES];
            [[AppDelegate sharedAppDelegate] presentViewController:agreeVC animated:YES completion:^{
                
            }];
        }
    }
    //小视频
    else if (index== 1)
    {
        [self showVideoDynamicViewC];
    }
}
#pragma mark **************************** Private methods  私有方法区域*********************
#pragma mark -加载前PopView权限与判断
-(void)showPopView
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];//获取权限状态
    if(author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied)//无权限
    {
        //无权限
    }
    // iOS 8 后，全部都要授权
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted)
                {
                    //第一次用户接
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showMenu];
                    });
                }else
                {
                    //用户拒绝
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            [self showMenu];// 已经开启授权，可继续
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied || AVAuthorizationStatusRestricted)
            {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"相册权限"
                                                                                message:@"无法访问相册，请在系统设置中允许访问"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertC addAction:cancelAction];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                    
                }];
                [alertC addAction:confirmAction];
                [[AppDelegate sharedAppDelegate] presentViewController:alertC
                                                              animated:YES
                                                            completion:nil];
            }
            break;
        default:
            break;
    }
}
#pragma mark- 加载PopView
-(void)showMenu
{
    if (!_menu)
    {
        [self menu];
    }
    NSMutableArray *tempDSMArray = @[].mutableCopy;
    NSMutableArray *picStrMArray = @[@"st_play_live",
                                     @"st_vedio_goods",
                                     ].mutableCopy;
    NSMutableArray *titleStrMArray = @[@"发起直播",
                                       @"发布小视频",
                                       ].mutableCopy;
    
    if (picStrMArray.count == titleStrMArray.count)
    {
        for (int i = 0;i<picStrMArray.count;i++)
        {
            [tempDSMArray addObject: [PopMenuModel
                                      allocPopMenuModelWithImageNameString:picStrMArray[i]
                                      AtTitleString:titleStrMArray[i]
                                      AtTextColor:kAppGrayColor1
                                      AtTransitionType:PopMenuTransitionTypeSystemApi
                                      AtTransitionRenderingColor:nil]];
        }
    }
    _menu.dataSource = tempDSMArray.copy;
    [_menu openMenu];
}

#pragma mark -  5 - 视频动态页面
-(void)showVideoDynamicViewC
{
    self.videoDynamicViewC = (VideoDynamicViewC *)[VideoDynamicViewC showSTBaseViewCOnSuperViewC:_tabBarC.selectedViewController
                                                                                    andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                                        andSTViewCTransitionType:STViewCTransitionTypeOfModal
                                                                                     andComplete:^(BOOL finished,
                                                                                                   STBaseViewC *stBaseViewC) {
                                                                                         
                                                                                     }];
    self.videoDynamicViewC.recordTabBarC = _tabBarC;
    [self.videoDynamicViewC videoDynamicView];
    
    // 开启IQ
    self.videoDynamicViewC.isOpenIQKeyboardManager = YES;
    // 加载View层
    //[videoDynamicViewC graphicDynamicView];
    //跳转
    //找到当前ViewC
    UIViewController *currentViewC = _tabBarC.selectedViewController.childViewControllers[0];
    //TabBarc隐藏
    currentViewC.hidesBottomBarWhenPushed=YES;
    currentViewC.navigationController.navigationBar.tintColor = kAppGrayColor1;
    self.videoDynamicViewC.navigationController.navigationBar.hidden = NO;
    self.videoDynamicViewC.title = @"发布小视频";
    self.videoDynamicViewC.navigationController.navigationBar.tintColor =kAppGrayColor1;
    //改变颜色  必须跳转后
    self.videoDynamicViewC.navigationController.navigationBar.hidden = NO;
    [self.videoDynamicViewC.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:kAppGrayColor1}];
    currentViewC.hidesBottomBarWhenPushed=NO;
    
    UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [headImgSheet addButtonWithTitle:@"拍摄视频"];
    [headImgSheet addButtonWithTitle:@"相册中获取视频"];
    [headImgSheet addButtonWithTitle:@"取消"];
    headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
    headImgSheet.delegate = self;
    [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
}
//VideoDynamicViewC
#pragma mark ****************************** Setter ******************************
// 外部控制菜单弹出
-(void)setStPopMenuShowState:(STPopMenuShowState)stPopMenuShowState
{
    if (!_menu)
    {
        [self menu];
    }
    switch (stPopMenuShowState)
    {
        case STPopMenuHidden:
            [_menu closeMenu];
            
            break;
        case STPopMenuShow:
            [self showPopView];
            break;
            
        default:
            break;
    }
    _stPopMenuShowState = stPopMenuShowState;
}
#pragma mark ***************************** Getter  ****************************
#pragma mark - pop menu 控制菜单View
-(HyPopMenuView *)menu
{
    if (!_menu)
    {
        _menu = [HyPopMenuView sharedPopMenuManager];
        _menu.delegate = self;
        _menu.popMenuSpeed = 12.0f;
        //自动填充颜色
        _menu.automaticIdentificationColor = false;
        //pop动画类型
        _menu.animationType = HyPopMenuViewAnimationTypeSina;
        _menu.backgroundType = HyPopMenuViewBackgroundTypeLightTranslucent;
    }
    return _menu;
}
#pragma mark ************************** Plublic 公有方法 **************************
// 认证状态判断+未读动态数
-(void)showCheckAuthentication:(void(^)(BOOL haveAuthentication,NSString *dynamicCountStr))block
{
    [[NetHttpsManager manager]POSTWithParameters:@{@"ctl":@"publish",@"act":@"check_type",@"itype":@"xr"}.mutableCopy
                                    SuccessBlock:^(NSDictionary *responseJson) {
                                        if ([[responseJson allKeys]containsObject:@"status"]
                                            &&[responseJson[@"status"] integerValue] == 1
                                            &&[[responseJson allKeys]containsObject:@"info"]
                                            &&[responseJson[@"info"][@"is_authentication"] integerValue]==2)
                                        {
                                            if (block)
                                            {
                                                block(YES,responseJson[@"info"][@"weibo_count"]);
                                            }
                                        }else
                                        {
                                            if (block)
                                            {
                                                block(NO,responseJson[@"info"][@"weibo_count"]);
                                            }
                                        }
                                    } FailureBlock:^(NSError *error){
                                        if (block)
                                        {
                                            block(NO,@"0");
                                        }
                                    }];
    
}

#pragma mark UIActionSheet的代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    [[AppDelegate sharedAppDelegate]pushViewController:self.videoDynamicViewC];
    [self.videoDynamicViewC ceartVideoViewWithType:(int)buttonIndex];
}







@end
