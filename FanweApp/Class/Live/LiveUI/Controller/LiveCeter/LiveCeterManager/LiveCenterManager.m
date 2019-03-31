//
//  LiveCenterManager.m
//  FanweApp
//
//  Created by 岳克奎 on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "LiveCenterManager.h"

@implementation LiveCenterManager

FanweSingletonM(Instance);


#pragma mark ------------------------------------------- 直播间开启部分  -------------------------------------------
#pragma mark  主播开直播
/**
 主播开直播开直播
 
 @param dic API请求直播需要dic的参数
 @param isSusWindow 是否开启悬浮
 @param isSmallScreen 是否小屏幕直播
 @param block 处理回调
 
 * @Step:1 .首先API请求
 * @Step:2. 创建直播对应类型下的直播间VC
 * @Step:3. 悬浮部分 显示window层
 * @Step:4  处理手势  手势里回调+动画
 * @Step:5  动画加载悬浮
 *
 * @discussion:  1.主播开直播 先请求拿到后台直播类型 云||互动  代码包含 悬浮和非悬浮  悬浮部分要动画加载
 * @attention : 一定要注意参数，如果调悬浮达不到预想结果，请优先查看参数，特别是 isSusWindow和isSmallScreen   还有有些方法传递的直播间VC 和直播间UIVC，一定要区分！！！
 
 */
- (void)showLiveOfAPIPramaDic:(NSMutableDictionary *)dic isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block
{
    [[AppDelegate sharedAppDelegate] isShowHud:YES hideTime:6];
    // 悬浮记录悬浮状态
    SUS_WINDOW.isSusWindow = isSusWindow;
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    
    __weak typeof(self)weak_Self = self;
    // H1 首先API请求   内部悬浮记录 直播类型+是不是观众
    [[LiveCenterAPIManager sharedInstance] liveCenterAPIOfShowHostLiveOfDic:dic block:^(NSDictionary *responseJson, BOOL finished, NSError *error) {
        
        [[AppDelegate sharedAppDelegate] hideHud];
        
        if (finished && !error && responseJson)
        {
            // H2 API请求成功后 设置房间信息
            IMAHost *host = [IMAPlatform sharedInstance].host;
            TCShowUser *user = [[TCShowUser alloc] init];
            user.avatar = [host imUserIconUrl];
            user.uid = [host imUserId];
            user.username = [host imUserName];
            
            TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
            liveRoom.host = user;
            liveRoom.avRoomId = [responseJson toInt:@"room_id"];
            liveRoom.title = [NSString stringWithFormat:@"%d",liveRoom.avRoomId];
            liveRoom.vagueImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict toString:@"head_image"];
            // SUS_WINDOW 去记录直播间类型  这是不是观众
            liveRoom.liveType = SUS_WINDOW.liveType;
            liveRoom.isHost = SUS_WINDOW.isHost;
            // 2 开直播间  直播间类型很多需要判断
            UIViewController *tempLiveViewController = [weak_Self showNewLiveOfTCShowLiveListItem:liveRoom];
            // h3 如果开启了悬浮  悬浮动画处理+加载处理  非悬浮不做处理
            if(isSusWindow)
            {
                [weak_Self showSusWindowPartOfIsSusWindow:isSusWindow isSmallScreen:isSmallScreen liveViewControleller:tempLiveViewController block:^(BOOL isFinished) {
                    
                    if(block)
                    {
                        block(isFinished);
                    }
                    
                }];
            }
            else
            {
                if(block)
                {
                    block(YES);
                }
            }
        }
        else
        {
            if(block)
            {
                block(NO);
            }
        }
    }];
}

/**
 开启直播
 
 @param responseJson 开播参数
 @param isSusWindow 是否需要悬浮窗
 @param isSmallScreen 是否需要悬浮小屏
 @param block 回调
 */
- (void)showLiveOfAPIResponseJson:(NSMutableDictionary *)responseJson isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block
{
    // 悬浮记录悬浮状态
    SUS_WINDOW.isSusWindow = isSusWindow;
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    
    __weak typeof(self)weak_Self = self;
    // API请求成功后，设置房间信息
    IMAHost *host = [IMAPlatform sharedInstance].host;
    if (!host)
    {
        [[FWIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        if (block)
        {
            block(NO);
        }
        return;
    }
    TCShowUser *user = [[TCShowUser alloc] init];
    user.avatar = [host imUserIconUrl];
    user.uid = [host imUserId];
    user.username = [host imUserName];
    
    TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
    liveRoom.host = user;
    liveRoom.avRoomId = [responseJson toInt:@"room_id"];
    liveRoom.title = [NSString stringWithFormat:@"%d",liveRoom.avRoomId];
    liveRoom.vagueImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict toString:@"head_image"];
    //SUS_WINDOW 去记录直播间类型  这是不是观众
    liveRoom.liveType = SUS_WINDOW.liveType;
    liveRoom.isHost = SUS_WINDOW.isHost;
    //2 开直播间  直播间类型很多需要判断
    UIViewController *tempLiveViewController = [weak_Self showNewLiveOfTCShowLiveListItem:liveRoom];
    //h3 如果开启了悬浮  悬浮动画处理+加载处理  非悬浮不做处理
    if(isSusWindow)
    {
        [weak_Self showSusWindowPartOfIsSusWindow:isSusWindow isSmallScreen:isSmallScreen liveViewControleller:tempLiveViewController block:^(BOOL isFinished) {
            if(block)
            {
                block(isFinished);
            }
        }];
    }
    else
    {
        if(block)
        {
            block(YES);
        }
    }
}

/**
 观众进直播
 
 @param dic 参数
 @param isSusWindow 是否需要悬浮Window
 @param isSmallScreen 是否需要悬浮小Window
 @param block 回调
 */
- (void)showLiveOfAudienceLiveofPramaDic:(NSMutableDictionary *)dic isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block
{
    //判断是否实现协议  isSusWindow  为NO  isSmallScreen 必须也为NO
    if (!isSusWindow && isSmallScreen)
    {
        [FanweMessage alertHUD:@"直播间预加载参数出错"];
    }
    
    if (![[IMAPlatform sharedInstance].host conformsToProtocol:@protocol(AVUserAble)])
    {
        [[FWHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
            [[FWIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        } completion:^{
            
        }];
        return;
    }
    
//    // 判断dic  是否符合要求
//    if(![[dic allKeys] containsObject:@"group_id"] || ![[dic allKeys] containsObject:@"room_id"] || ![[dic allKeys] containsObject:@"head_image"] || ![[dic allKeys] containsObject:@"user_id"] || ![[dic allKeys] containsObject:@"live_in"])
//    {
//        [FanweMessage alertHUD:@"抱歉，房间信息出错"];
//        return;
//    }
    
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
    item.chatRoomId = dic[@"group_id"];
    item.avRoomId = (int)[dic[@"room_id"] integerValue];
    item.title = StringFromInt(item.avRoomId);
    item.vagueImgUrl = dic[@"head_image"];
    
    TCShowUser *showUser = [[TCShowUser alloc]init];
    showUser.uid = dic[@"user_id"];
    showUser.avatar =  item.vagueImgUrl;
    item.host = showUser;
    
    if ([dic[@"live_in"] integerValue] == FW_LIVE_STATE_ING)
    {
        item.liveType = FW_LIVE_TYPE_AUDIENCE;
    }
    else if ([dic[@"live_in"] integerValue] == FW_LIVE_STATE_RELIVE)
    {
        item.liveType = FW_LIVE_TYPE_RELIVE;
    }
    else
    {
        [FanweMessage alert:@"视频已结束或正在创建中！"];
        return;
    }
    
#warning 由于把腾讯SDK和金山SDK发在一块后，用腾讯SDK光看回看会闪退，所以回看默认用金山SDK，后期有待观察
    int sdk_type = FW_LIVESDK_TYPE_TXY;
//    if (item.liveType == FW_LIVE_TYPE_RELIVE)
//    {
//        sdk_type = FW_LIVESDK_TYPE_KSY;
//    }
//    else
//    {
//        sdk_type = FW_LIVESDK_TYPE_TXY;
//    }
    
    SUS_WINDOW.sdkType = sdk_type;
    SUS_WINDOW.liveType = (int)item.liveType;
    SUS_WINDOW.isSusWindow = isSusWindow;
    // 应该是这样理解，当前处于满屏状态。。然后呢，经过动画处理就变成了 小屏幕
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    SUS_WINDOW.isHost = NO;
    __weak typeof(self)weak_Self = self;
    //G 1
    UIViewController *tempLiveViewController =  [weak_Self showNewLiveOfTCShowLiveListItem:item];
    //G 2
    if(SUS_WINDOW.isSusWindow)
    {
        [SUS_WINDOW makeKeyWindow];
        SUS_WINDOW.hidden = NO;
        [weak_Self showSusWindowPartOfIsSusWindow:isSusWindow isSmallScreen:isSmallScreen liveViewControleller:tempLiveViewController block:^(BOOL isFinished) {
        }];
    }
}

/**
 观众进直播
 
 @param item 进入直播间实体
 @param isSusWindow 是否需要悬浮Window
 @param isSmallScreen 是否需要悬浮小Window
 @param block 回调
 */
- (void)showLiveOfAudienceLiveofTCShowLiveListItem:(TCShowLiveListItem *)item isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block
{
#warning 由于把腾讯SDK和金山SDK发在一块后，用腾讯SDK光看回看会闪退，所以回看默认用金山SDK，后期有待观察
//    if (item.liveType == FW_LIVE_TYPE_RELIVE)
//    {
//        SUS_WINDOW.sdkType = FW_LIVESDK_TYPE_KSY;
//    }
    SUS_WINDOW.liveType = (int)item.liveType;
    SUS_WINDOW.isSusWindow = isSusWindow;
    // 应该是这样理解，当前处于满屏状态。。然后呢，经过动画处理就变成了 小屏幕
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    SUS_WINDOW.isHost = NO;
    __weak typeof(self)weak_Self = self;
    //G 1
    UIViewController *tempLiveViewController =  [weak_Self showNewLiveOfTCShowLiveListItem:item];
    //G 2
    if(SUS_WINDOW.isSusWindow)
    {
        [SUS_WINDOW makeKeyWindow];
        SUS_WINDOW.hidden = NO;
        [weak_Self showSusWindowPartOfIsSusWindow:isSusWindow isSmallScreen:isSmallScreen liveViewControleller:tempLiveViewController block:^(BOOL isFinished) {
        }];
    }
}


#pragma mark -private methods ------------------------------------------ 私人方法区域 ------------------------------------------
/**
 开创直播间VC，主播、观众直播通用代码，注意这里未开悬浮状态下是：[APP_DELEGATE pushViewController:liveVC];
 
 @param item 进入直播间实体
 @return 返回当前vc
 */
- (UIViewController *)showNewLiveOfTCShowLiveListItem:(TCShowLiveListItem *)item
{
    // 云 主播  ||  云观众
    if(SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_TXY)
    {
        FWTLiveController *liveVC = [[FWTLiveController alloc]initWith:item];
        SUS_WINDOW.recordFWTLiveController = liveVC;
        if (SUS_WINDOW.isSusWindow)
        {
            // 如果开启悬浮
            SUS_WINDOW.rootViewController =  [[UINavigationController alloc]initWithRootViewController:liveVC];
        }
        else
        {
            [APP_DELEGATE pushViewController:liveVC];
        }
        return liveVC;
    }
    else if(SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_KSY)
    {
        FWKSYLiveController *liveVC = [[FWKSYLiveController alloc]initWith:item];
        SUS_WINDOW.threeFWKSYLiveController = liveVC;
        if (SUS_WINDOW.isSusWindow)
        {
            // 如果开启悬浮
            SUS_WINDOW.rootViewController =  [[UINavigationController alloc]initWithRootViewController:liveVC];
        }
        else
        {
            [APP_DELEGATE pushViewController:liveVC];
        }
        return liveVC;
    }
    return nil;
}

/**
 先设置参数再利用参数判断动画，主播、观众通用代码
 
 @param isSusWindow 是否需要悬浮Window
 @param isSmallScreen 是否需要悬浮小Window
 @param liveViewControleller 直播vc
 @param block 回调
 */
- (void)showSusWindowPartOfIsSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen liveViewControleller:(UIViewController *)liveViewControleller block:(FWIsFinishedBlock)block
{
    [SUS_WINDOW makeKeyWindow];
    SUS_WINDOW.hidden = NO;
    SUS_WINDOW.isSusWindow = isSusWindow;
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    //H4
    [SuspenionWindow showLoadGeatureOfSusWindow];
    //H5
    [SuspenionWindow showAnimationOfSusWindowSizeBlock:^(BOOL finished) {
        if (finished)
        {
            //手势 处理
        }
        if(block)
        {
            block(finished);
        }
    }];
}

#pragma mark ------------------------------------------- 直播间关闭 部分  -------------------------------------------
#pragma mark - 直播间关闭启动预处理
/**
 开始启动直播间关闭处理
 
 @param liveViewController 需要退出的vc
 @param paiTimeNum 用来判断竞拍倒计时是否存在
 @param isDirectCloseLive 是否直接关闭直播
 @param isHostShowAlert 主播是否显示关闭直播的提示
 @param block 回调
 */
- (void)closeLiveOfPramaOfLiveViewController:(UIViewController *)liveViewController paiTimeNum:(int)paiTimeNum alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert colseLivecomplete:(FWIsFinishedBlock)block
{
    // 音乐存在必须 要关闭
    //    if (ST_M_CENTER.stMusicPlayingState != STMusicPlayingStateDefault)
    //    {
    //        [ST_M_CENTER setStMusicPlayingState:STMusicPlayingStateDefault];
    //    }
    MUSIC_CENTER_MANAGER.musicPlayingState = NO;
    // 这个判断这里执行。后面再调方法没必要判断
    if (!liveViewController)
    {
        if(block)
        {
            block(NO);// 不退出
        }
        return;
    }
    
    // 参数的记录感觉 放在 这里
    SUS_WINDOW.isDirectCloseLive = isDirectCloseLive; //记录 当前需不需要 finishVC  NO需要
    SUS_WINDOW.isHostShowAlert = isHostShowAlert;//记录当前需不需要  提示
    
    // 键盘退出
    [FWUtils closeKeyboard];
    
    __weak typeof(self)weak_Self = self;
    // 悬浮类有关   假如存在悬浮 优先让悬浮恢复到满屏  再做退出处理
    // 悬浮的写在  悬浮类里面
    [SuspenionWindow closeSuswindowUIComplete:^(BOOL finished) {
        SUS_WINDOW.window_Pan_Ges.enabled  = NO;
        // 执行直播层（非悬浮）退出 先判断+后真退出
        
        if(finished)
        {
            [weak_Self closeLiveAfterClosedOfSusWindowUIOfLiveViewController:liveViewController paiTimeNum:paiTimeNum closeComplete:^(BOOL isFinished) {
                if(block)
                {
                    block(isFinished);
                }
            }];
        }
    }];
}

/**
 非悬浮关闭处理：
 1.判断悬浮；
 2.判断音乐；
 3.判断是不是主播  观众基本直接退出去；
 4.悬浮参数的退出；
 
 @param liveViewControlelr 直播vc
 @param paiTimeNum 竞拍倒计时
 @param block 回调
 */
- (void)closeLiveAfterClosedOfSusWindowUIOfLiveViewController:(UIViewController *)liveViewControlelr paiTimeNum:(int)paiTimeNum closeComplete:(FWIsFinishedBlock)block
{
    // 拿到对应liveC
    __weak typeof(self)weak_Self = self;
    __weak FWTLiveController  *tLiveC;
    __weak FWKSYLiveController  *ksyLiveC;
    
    if(SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_TXY)
    {
        tLiveC =(FWTLiveController *)liveViewControlelr;
        tLiveC.isDirectCloseLive = SUS_WINDOW.isDirectCloseLive;
        // 暂停播放背景音乐
        [tLiveC.publishController.txLivePublisher pauseBGM];
    }
    if(SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_KSY)
    {
        ksyLiveC =(FWKSYLiveController *)liveViewControlelr;
        ksyLiveC.isDirectCloseLive = SUS_WINDOW.isDirectCloseLive;
    }
    
    // 判断 提示  竞拍存在
    // 竞拍 之 云 主0  互主 3 host
    if (paiTimeNum)
    {
        if (SUS_WINDOW.liveType == FW_LIVE_TYPE_HOST)
        {
            if(block)
            {
                block(NO); // 不退出
            }
            return;
        }
        else if (SUS_WINDOW.liveType == FW_LIVE_TYPE_AUDIENCE)
        {
            if(SUS_WINDOW.isHostShowAlert)
            {
                // 调退出直播方法
                [weak_Self closeLiveRealOfSDKWithLiveViewController:liveViewControlelr complete:^(BOOL isFinished) {
                    if(block)
                    {
                        block(YES);
                    }
                }];
            }
        }
    }
    
    // 云主 0  观主   3
    if(SUS_WINDOW.liveType == FW_LIVE_TYPE_HOST)
    {
        if(SUS_WINDOW.isHostShowAlert)
        {
            [FanweMessage alert:nil message:@"确定退出当前直播？" destructiveAction:^{
                
                // 调退出直播方法
                [weak_Self closeLiveRealOfSDKWithLiveViewController:liveViewControlelr complete:^(BOOL isFinished) {
                    if(block)
                    {
                        block(YES);
                    }
                }];
                
            } cancelAction:^{
                
                // 不退出
                if(block)
                {
                    block(NO);
                }
                
            }];
        }
        else
        {
            // 调退出直播方法
            [weak_Self closeLiveRealOfSDKWithLiveViewController:liveViewControlelr complete:^(BOOL isFinished) {
                if(block)
                {
                    block(YES);
                }
            }];
        }
    }
    
    // 观众 直接退出
    if (SUS_WINDOW.liveType == FW_LIVE_TYPE_RELIVE || SUS_WINDOW.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        // 调退出直播方法
        [weak_Self closeLiveRealOfSDKWithLiveViewController:liveViewControlelr complete:^(BOOL isFinished) {
            if(block)
            {
                block(YES);
            }
        }];
    }
}


#pragma mark -private methods ------------------------------------------ 私人方法区域 ------------------------------------------
/**
 调SDK等相关退出
 
 @param liveViewController 需要退出的vc，要区分一下开始掉关闭预加载时候的参数，让悬浮去记录
 @param block 回到
 */
- (void)closeLiveRealOfSDKWithLiveViewController:(UIViewController *)liveViewController complete:(FWIsFinishedBlock)block
{
    // 目前 下面走的是 NO  需要
    __weak FWTLiveController  *tLiveC;
    __weak FWKSYLiveController  *ksyLiveC;
    
    __weak typeof(self)weak_self = self;
    
    // 云部分
    if(SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_TXY)
    {
        tLiveC =(FWTLiveController *)liveViewController;
        
        //执行退出
        [tLiveC realExitLive:^{
            [weak_self  resetSuswindowPramaComple:^(BOOL isFinished) {
                if(block)
                {
                    block(YES);
                }
            }];
        } failed:^(int errId, NSString *errMsg) {
            
            [weak_self  resetSuswindowPramaComple:^(BOOL isFinished) {
                if(block)
                {
                    block(YES);
                }
            }];
        }];
    }
    
    if(SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_KSY)
    {
        ksyLiveC = (FWKSYLiveController *)liveViewController;
        
        // 执行退出
        [ksyLiveC realExitLive:^{
            [weak_self resetSuswindowPramaComple:^(BOOL isFinished) {
                if(block)
                {
                    block(YES);
                }
            }];
        } failed:^(int errId, NSString *errMsg) {
            
            [weak_self  resetSuswindowPramaComple:^(BOOL isFinished) {
                if(block)
                {
                    block(YES);
                }
            }];
        }];
    }
}

- (void)resetSuswindowPramaComple:(FWIsFinishedBlock)block
{
    if (![FWUtils isBlankString:SUS_WINDOW.switchedRoomId])
    {
        NSString *tmpStr = SUS_WINDOW.switchedRoomId;
        SUS_WINDOW.switchedRoomId = nil;
        
        [FWLiveSDKViewModel checkVideoStatus:tmpStr successBlock:^(NSDictionary *responseJson) {
            
            TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
            item.chatRoomId = [responseJson toString:@"group_id"];
            item.avRoomId = [[responseJson toString:@"room_id"] intValue];
            item.title = [responseJson toString:@"room_id"];
            
            NSInteger live_in = [responseJson toInt:@"live_in"];
            
            if (live_in == FW_LIVE_STATE_ING)
            {
                item.liveType = FW_LIVE_TYPE_AUDIENCE;
                BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
                [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofTCShowLiveListItem:item isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
                }];
            }
            else
            {
                [FanweMessage alert:@"该直播已结束"];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
    // 为NO 需要finish界面
    if(!SUS_WINDOW.isDirectCloseLive)
    {
        if(block)
        {
            block(NO);
        }
        return;
    }
    // 悬浮层处理
    [SuspenionWindow resetSusWindowPramaWhenLiveClosedComplete:^(BOOL finished) {
        if (block)
        {
            block(finished);
        }
    }];
}

/**
 屏幕大小缩放处理，使用前提：需要悬浮挂起或挂起小屏幕后再恢复满屏幕
 
 @param isSmallScreen 是否悬浮小Window
 @param block 回调
 */
- (void)showChangeLiveScreenSOfIsSmallScreen:(BOOL)isSmallScreen complete:(FWIsFinishedBlock)block
{
    if (!SUS_WINDOW.isSusWindow)
    {
        return;
    }
    
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    //动画
    [SuspenionWindow showAnimationOfSusWindowSizeBlock:^(BOOL finished) {
        if (block)
        {
            block(finished);
        }
    }];
}


#pragma mark ----------------------------------------- 竞拍区域 ------------------------------------------------------
/**
 竞拍屏幕处理大小处理，使用前提：竞拍开启直播后，需要悬浮挂起或挂起小屏幕后再恢复满屏幕
 
 @param isSmallScreen 是否悬浮小Window
 @param nextViewController 你回到满屏，可为nil
 @param delegateWindowRCNameStr 当你去下个VC，可为nil
 @param block 回调
 */
- (void)showChangeAuctionLiveScreenSOfIsSmallScreen:(BOOL)isSmallScreen nextViewController:(UIViewController *)nextViewController delegateWindowRCNameStr:(NSString *)delegateWindowRCNameStr complete:(FWIsFinishedBlock)block
{
    // 判断
    if (!SUS_WINDOW.isSusWindow)
    {
        return;
    }
    // 最好做安全判断
    if (!((isSmallScreen&&nextViewController) || (!isSmallScreen&& ![delegateWindowRCNameStr isEmpty])))
    {
        [FanweMessage alertHUD:@"参数错误!"];
        return;
    }
    
    // 记录屏幕状态
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    // 去下个界面，要优先于动画
    if (isSmallScreen&&nextViewController)
    {
        FWNavigationController *nav = [[FWNavigationController alloc] initWithRootViewController:nextViewController];
        APP_DELEGATE.window.rootViewController = nav;
    }
    // 回到满屏幕
    [SuspenionWindow showAnimationOfSusWindowSizeBlock:^(BOOL finished) {
        // 恢复满屏幕路  动画要优先执行完毕
        if (finished)
        {
            if( !isSmallScreen&& ![delegateWindowRCNameStr isEmpty])
            {
                [SuspenionWindow closeSanwichLayerOfNetRootVCStr:delegateWindowRCNameStr complete:^(BOOL finished) {
                    if (block)
                    {
                        block(finished);
                    }
                }];
            }
            else
            {
                if (block)
                {
                    block(finished);
                }
            }
        }
    }];
}


#pragma mark ---------------------------------------- 踢下线通知 -------------------------------------------------------
/**
 踢下线通知
 
 @param imAPlatform 里监听到有互踢消息执行对应的方法，这个方法主要解决先视频的退出问题
 @param block 回调
 */
- (void)showOffLineWarningwithIMAPlatform:(IMAPlatform *)imAPlatform complete:(FWIsFinishedBlock)block
{
    //音乐存在的话，必须先关闭
    //    if (ST_M_CENTER.stMusicPlayingState != STMusicPlayingStateDefault)
    //    {
    //        [ST_M_CENTER setStMusicPlayingState:STMusicPlayingStateDefault];
    //    }
    
    [FanweMessage alert:@"下线通知" message:@"您的帐号于另一台手机上登录，是否重新登录？" destructiveAction:^{
        
        if (block)
        {
            block(YES);
        }
        [imAPlatform offlineLogin];
        // 重新登录
        [imAPlatform login:imAPlatform.host.loginParm succ:nil fail:^(int code, NSString *msg) {
            [APP_DELEGATE enterLoginUI];
        }];
        
    } cancelAction:^{
        
        if (block)
        {
            block(YES);
        }
        // 退出
        if(SUS_WINDOW.liveType == 0 || SUS_WINDOW.liveType == 1 || SUS_WINDOW.liveType == 2)
        {
            if (SUS_WINDOW.recordFWTLiveController)
            {
                [SUS_WINDOW.recordFWTLiveController  alertExitLive:YES isHostShowAlert:NO succ:^{
                    [imAPlatform doLogout];
                    
                } failed:^(int errId, NSString *errMsg) {
                    [imAPlatform doLogout];
                    
                }];
            }
            else if (SUS_WINDOW.threeFWKSYLiveController)
            {
                [SUS_WINDOW.threeFWKSYLiveController  alertExitLive:YES isHostShowAlert:NO succ:^{
                    [imAPlatform doLogout];
                    
                } failed:^(int errId, NSString *errMsg) {
                    [imAPlatform doLogout];
                    
                }];
            }
            else
            {
                [imAPlatform doLogout];
            }
        }
        
    }];
}

/**
 进入直播
 
 @param liveListItem 进入直播间实体
 @param liveWindowType LiveWindowType
 @param liveType 视频类型
 @param liveSDKType SDK类型
 @param block 回调
 */
- (void)showLiveOfTCShowLiveListItem:(TCShowLiveListItem *)liveListItem andLiveWindowType:(LiveWindowType)liveWindowType andLiveType:(FW_LIVE_TYPE)liveType andLiveSDKType:(FW_LIVESDK_TYPE)liveSDKType andCompleteBlock:(FWIsFinishedBlock)block
{
    // 开直播间  直播间类型很多需要判断
    BOOL isOpenSusWindow = false;
    BOOL isOpenNormalWindow = false;
    UIViewController *liveVC;
    //云
    if(liveSDKType == FW_LIVESDK_TYPE_TXY)
    {
        liveVC = [[FWTLiveController alloc]initWith:liveListItem];
        //创建liveVC后需要设置悬浮代理
        [_stSuspensionWindow setDelegate:(FWTLiveController *)liveVC];
        //悬浮
        if(liveWindowType == liveWindowTypeOfSusOfFullSize || liveWindowType ==LiveWindowTypeOfSusSmallSize)
        {
            //如果开启悬浮
            isOpenSusWindow = YES;
            //非悬浮
        }else if(liveWindowType ==LiveWindowTypeOfNormolOfFullSize || liveWindowType == LiveWindowTypeOfNormolSmallSize){
            isOpenNormalWindow = YES;
        }else{
            //1.请正确方式填写枚举类型，不准用数字代替 //目前只扩展了4种，默认情况上面已经过滤
        }
    }
    //金山
    else if(liveSDKType == FW_LIVESDK_TYPE_KSY)
    {
        liveVC = [FWKSYLiveController showLiveViewCwith:liveListItem];
        //创建liveVC后需要设置悬浮代理
        [_stSuspensionWindow setDelegate:(FWKSYLiveController *)liveVC];
        if(liveWindowType == liveWindowTypeOfSusOfFullSize || liveWindowType == LiveWindowTypeOfSusSmallSize)
        {
            //如果开启悬浮
            isOpenSusWindow = YES;
            //非悬浮
        }
        else if (liveWindowType ==LiveWindowTypeOfNormolOfFullSize || liveWindowType == LiveWindowTypeOfNormolSmallSize)
        {
            isOpenNormalWindow = YES;
        }
        else
        {
            //1.请正确方式填写枚举类型，不准用数字代替 //目前只扩展了4种，默认情况上面已经过滤
        }
    }
    else
    {
        //其他直播代码暂时不支持
    }
    
    //悬浮和非悬浮必定有个为YES
    if ((isOpenSusWindow && !isOpenNormalWindow)||(!isOpenSusWindow && isOpenNormalWindow))
    {
        //悬浮
        if (isOpenSusWindow && !isOpenNormalWindow)
        {
            _stSuspensionWindow.rootViewController =  [[UINavigationController alloc]initWithRootViewController:liveVC];
            _stSuspensionWindow.windowLevel = 3005;
            [_stSuspensionWindow makeKeyWindow];
            _stSuspensionWindow.hidden = NO;
        }
        else
        {
            //非悬浮
            [APP_DELEGATE pushViewController:liveVC];
        }
        //只有开启了直播，必须是动画完成才是真正赋值管理中心采取 记录最新状态，否则管理中心数据为默认无直播状态
        [self setLiveSDKType:liveSDKType];
        [self setLiveType:liveType];
        [self setRecordLiveViewC:liveVC];
        [self setLiveWindowType:liveWindowType];
        if(block)
        {
            block(YES);
        }
        //动画加载出来
    }
    else
    {
        //参数设置出问题，检查代码
        if(block){
            block(NO);
        }
    }
}

#pragma mark ---------------------------------------- 关直播 -------------------------------------------------------
// 键盘退出 最好写在外面
// 音乐暂停
- (void)showCloseLiveComplete:(FWIsFinishedBlock)block
{
    // 直播得存在
    if (!_recordLiveViewC)
    {
        if (block)
        {
            block(NO);
        }
        return;
    }
    // 键盘退出
    [FWUtils closeKeyboard];
    
    // 处理满屏问题
    // 因为进直播的时候已经记录直播类型
    // 当前为悬浮小
    if (_liveWindowType == LiveWindowTypeOfSusSmallSize )
    {
        // 小-->大
        [self setLiveWindowType:liveWindowTypeOfSusOfFullSize];
    }
    // 当前为满屏
    else if(_liveWindowType == liveWindowTypeOfSusOfFullSize || _liveWindowType == LiveWindowTypeOfNormolOfFullSize)
    {
        [self setLiveWindowType:_liveWindowType];
    }
    else
    {
        // 暂时其余枚举类型，代码不支持
        if (block)
        {
            block(NO);
        }
        return;
    }
    // 只有当悬浮层退出后，才真正执行直播退出
    if (block)
    {
        block(YES);
    }
}

// 判断是否需要悬浮Window
- (BOOL)judgeIsSusWindow
{
    BOOL isSusWindow = NO;
//    if(kSupportH5Shopping)
//    {
//        isSusWindow = NO;
//    }
//    else if ([GlobalVariables sharedInstance].appModel.open_podcast_goods == 1)
//    {
//        isSusWindow = NO;
//    }
//    else if ([[GlobalVariables sharedInstance].appModel.shopping_goods integerValue] == 1 || [[GlobalVariables sharedInstance].appModel.open_pai_module integerValue] == 1)
//    {
//        isSusWindow = YES;
//    }
//    else
//    {
//        isSusWindow = NO;
//    }
    return isSusWindow;
}

// 判断是否需要悬浮小Window
- (BOOL)judgeIsSmallSusWindow
{
    if ([self judgeIsSusWindow])
    {
        return NO;
    }
    else
    {
        return NO;
    }
}

#pragma mark --------------------------- get方法区域
- (STSuspensionWindow *)stSuspensionWindow
{
    if (!_stSuspensionWindow)
    {
        _stSuspensionWindow = [STSuspensionWindow showWindowTypeOfSTBaseSuspensionWindowOfFrameRect:CGRectMake(0, 0, kScreenW, kScreenH) ofSTBaseSuspensionWindowLevelValue: 3050 complete:^(BOOL finished, STSuspensionWindow *stSuspensionWindow) {
            
        }];
    }
    return _stSuspensionWindow;
}


#pragma mark --------------------------- set方法区域
- (void)setLiveWindowType:(LiveWindowType)liveWindowType
{
    if (_liveWindowType != liveWindowType)
    {
        if(_stSuspensionWindow)
        {
            _liveWindowType = liveWindowType;
        }
        
        // 动画
        [_stSuspensionWindow setStSusWindowShowState:stSusWindowShowYES];
        [_stSuspensionWindow setIsSmallSize:(liveWindowType == LiveWindowTypeOfNormolSmallSize ? YES : NO)];
    }
}

@end
