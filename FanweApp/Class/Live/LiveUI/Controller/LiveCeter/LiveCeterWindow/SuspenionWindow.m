//
//  SuspenionWindow.m
//  FanweApp
//
//  Created by 岳克奎 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SuspenionWindow.h"

@implementation SuspenionWindow

#pragma mark ------------处理pan移动问题
/**
 *
 * @brief:       移动到边界处理
 * @discussion： 当移动屏幕超出 默认window（界面）时，结束手势状态下，动画设置回弹效果 确保在屏幕内部
 *
 *
 */
- (void)setPanGesForSmallSuspenionWindow:(CGPoint)panPoint withModeValue:(CGPoint)moveVlue
{
    self.transform = CGAffineTransformTranslate( self.transform, moveVlue.x, moveVlue.y);
    [self.window_Pan_Ges setTranslation:CGPointZero inView:self];
    if (self.window_Pan_Ges.state == UIGestureRecognizerStateBegan)
    {
    }
    if (self.window_Pan_Ges.state == UIGestureRecognizerStateChanged)
    {
    }
    if (self.window_Pan_Ges.state == UIGestureRecognizerStateEnded)
    {
        if(self.x<0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.x = 0;
            }completion:^(BOOL finished) {
                
            }];
        }
        
        if(self.frame.origin.y<0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.y = 0;
            }completion:^(BOOL finished) {
                
            }];
        }
        
        if(self.frame.origin.y> kScreenH-0.6*kScreenW)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.y = kScreenH-0.6*kScreenW;
            }completion:^(BOOL finished) {
                
            }];
        }
        
        if(self.x>kScreenW-0.4*kScreenW)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.x = kScreenW-0.4*kScreenW;
            }completion:^(BOOL finished) {
                
            }];
        }
    }
}


#pragma mark ---------------------------------------- 悬浮层开启 部分 ---------------------------------------
#pragma mark - Geature Of Suswindow
/**
 *  手势处理
 *
 * @Step: tap手势 动画
 * @Step: pan手势
 *
 *
 */
+ (void)showLoadGeatureOfSusWindow
{
    [FWUtils closeKeyboard];
    //5.1
    SUS_WINDOW.susBaseWindowTapGesBlock =^(){
        //  这里进一步配置
        if(SUS_WINDOW.isSmallSusWindow)
        {
            SUS_WINDOW.isSmallSusWindow = NO;
        }
        [SuspenionWindow showAnimationOfSusWindowSizeBlock:^(BOOL finished) {
            if (finished)
            {
                
            }
        }];
    };
    
    SUS_WINDOW.susBaseWindowPanGesBlock = ^(){
        [SUS_WINDOW setPanGesForSmallSuspenionWindow:[SUS_WINDOW.window_Pan_Ges locationInView:SUS_WINDOW] withModeValue:[SUS_WINDOW.window_Pan_Ges translationInView:SUS_WINDOW]];
    };
}

#pragma mark - Animation of SusWindow Size
/**
 * 悬浮动画
 *
 *
 *
 * @discusion: 1注意既然代码能走到这里 必定悬浮啦。VC可以delegate找！
 *             2 CGRectMake(kScreenW-kDefaultMargin-kLogoContainerViewHeight, kStatusBarHeight+kDefaultMargin/2, kLogoContainerViewHeight, kLogoContainerViewHeight)
 */
+ (void)showAnimationOfSusWindowSizeBlock:(void(^)(BOOL finished))block
{
    //处理键盘 js 弹出键盘遗留在直播间问题
    if(!SUS_WINDOW.isSmallSusWindow)
    {
        [SuspenionWindow closeSanwichLayerOfNetRootVCStr:@"FWTabBarController" complete:^(BOOL finished) {
            
        }];
    }
    
    [FWUtils closeKeyboard];
    
    FWTLiveController  *tLiveC;
    FWKSYLiveController *ksyLiveC;
    UIView *oneLiveView;
    UIButton *closeLiveBtn;
    if(SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_TXY)
    {
        tLiveC = (FWTLiveController *)SUS_WINDOW.rootViewController.childViewControllers[0];
        closeLiveBtn = tLiveC.liveServiceController.closeBtn;
        oneLiveView = tLiveC.liveServiceController.liveUIViewController.liveView;
    }
    if(SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_KSY)
    {
        //        ksyLiveC = (FWKSYLiveController *)SUS_WINDOW.rootViewController.childViewControllers[0];
        ksyLiveC = (FWKSYLiveController *)SUS_WINDOW.threeFWKSYLiveController;
        closeLiveBtn = ksyLiveC.liveServiceController.closeBtn;
        oneLiveView = ksyLiveC.liveServiceController.liveUIViewController.liveView;
    }
    if (!tLiveC)
    {
        if (block)
        {
            block(NO);
        }
    }
    oneLiveView.hidden = SUS_WINDOW.isSmallSusWindow?YES:NO;
    SUS_WINDOW.layer.masksToBounds = YES;
    SUS_WINDOW.layer.cornerRadius = SUS_WINDOW.isSmallSusWindow == YES?8.0f:0;
    if((!SUS_WINDOW.reccordSusWidnowSale&&SUS_WINDOW.isSmallSusWindow)||(SUS_WINDOW.reccordSusWidnowSale && !SUS_WINDOW.isSmallSusWindow)){
        //缩放 后肚饿widnwo尺寸
        [UIView animateWithDuration:0.5 animations:^{
            //进行缩放   当前满屏幕 记录要求小屏幕
            if (!SUS_WINDOW.reccordSusWidnowSale&&SUS_WINDOW.isSmallSusWindow)
            {
                SUS_WINDOW.reccordSusWidnowSale = YES;
                
                SUS_WINDOW.transform = CGAffineTransformMakeScale(0.4, 0.6*kScreenW/kScreenH);
                SUS_WINDOW.x = 0.6*kScreenW;
                SUS_WINDOW.y = 0;
                
                closeLiveBtn.width = kLogoContainerViewHeight*2;
                closeLiveBtn.height = kLogoContainerViewHeight*2;
                closeLiveBtn.x =0.6*kScreenW -kLogoContainerViewHeight;
            }
            // 放大   当前是小屏幕  记录不是满屏
            if (SUS_WINDOW.reccordSusWidnowSale && !SUS_WINDOW.isSmallSusWindow)
            {
                [IQKeyboardManager sharedManager].enable = NO;
                [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
                
                // 关闭键盘
                [FWUtils closeKeyboard];
                
                if ([IQKeyboardManager sharedManager].keyboardShowing)
                {
                    [FanweMessage alert:@"请先关闭键盘"];
                    return;
                }
                
                SUS_WINDOW.transform = CGAffineTransformIdentity;
                SUS_WINDOW.x = 0;
                SUS_WINDOW.y = 0;
                SUS_WINDOW.layer.masksToBounds = NO;
                closeLiveBtn.frame = CGRectMake(kScreenW-kDefaultMargin-kLogoContainerViewHeight, kStatusBarHeight+kDefaultMargin/2, kLogoContainerViewHeight, kLogoContainerViewHeight);
                SUS_WINDOW.reccordSusWidnowSale = NO;
            }
        }completion:^(BOOL finished) {
            if (finished)
            {
                //动画完毕  suswindow的参数要调整
                SUS_WINDOW.window_Tap_Ges.enabled =SUS_WINDOW.isSmallSusWindow;
                SUS_WINDOW.window_Pan_Ges.enabled = SUS_WINDOW.isSmallSusWindow;
            }
            if (block)
            {
                block(finished);
            }
        }];
    }
    else
    {
        SUS_WINDOW.window_Tap_Ges.enabled =SUS_WINDOW.isSmallSusWindow;
        SUS_WINDOW.window_Pan_Ges.enabled = SUS_WINDOW.isSmallSusWindow;
        SUS_WINDOW.reccordSusWidnowSale = SUS_WINDOW.isSmallSusWindow;
        
        if (block)
        {
            block(YES);
        }
    }
}


#pragma mark ---------------------------------------- 悬浮层 关闭 部分 ---------------------------------------
/**
 * @brief:悬浮层 直播间关闭 处理
 *
 * @Step: 1.小屏幕  先放大回来
 * @Step: 2.夹心层
 *
 */
+ (void)closeSuswindowUIComplete:(void(^)(BOOL finished))block
{
    if (SUS_WINDOW.isSusWindow)
    {
        [APP_DELEGATE popViewController];
    }
    if (APP_DELEGATE.sus_window.isSmallSusWindow)
    {
        SUS_WINDOW.isSmallSusWindow = NO;
        [SuspenionWindow showAnimationOfSusWindowSizeBlock:^(BOOL finished) {
            [SuspenionWindow closeSanwichLayerOfNetRootVCStr:@"FWTabBarController" complete:^(BOOL finished) {
                if (block)
                {
                    block(finished);
                }
            }];
        }];
    }
    else
    {
        [SuspenionWindow closeSanwichLayerOfNetRootVCStr:@"FWTabBarController" complete:^(BOOL finished) {
            if (block)
            {
                block(finished);
            }
        }];
    }
}

#pragma mark - 夹心层的退出
/**
 * @brief:  竞拍层的退出
 *
 * @prama: nextRootVCStr  竞拍层退出的时候，悬浮widnow需要动画恢复满屏幕。底层widnwo需要将RootVC 由竞拍层恢复到主页上
 * @prama: block回调
 *
 * @discussion: 千万别写错 APP_DELEGATE.window  宏容易错写为宏Sus——widnow  window 容易错写成suswindow
 *
 */
+ (void)closeSanwichLayerOfNetRootVCStr:(NSString *)nextRootVCStr complete:(void(^)(BOOL finished))block
{
    if (SUS_WINDOW.isSusWindow)
    {
        [APP_DELEGATE popViewController];
    }
    
    Class tabBarClass = NSClassFromString(nextRootVCStr);
    if (![APP_DELEGATE.window.rootViewController isKindOfClass:[tabBarClass class]])
    {
        APP_DELEGATE.window.rootViewController = [FWTabBarController sharedInstance];
    }
    
    if (block)
    {
        block(YES);
    }
}

#pragma mark - 悬浮层真正退出后悬浮参数处理
/**
 * @brief: 悬浮层真正退出后悬浮参数处理
 *
 * @discussion: 如果动画不执行 那是因为这个方法走了2次
 *
 * @user:直播间退出的时候
 */
+ (void)resetSusWindowPramaWhenLiveClosedComplete:(void(^)(BOOL finished))block
{
    // 加动画移除   否则有点闪屏 感觉
    [UIView animateWithDuration:0.3 animations:^{
        
        SUS_WINDOW.x = kScreenW;
        
        SUS_WINDOW.hidden = YES;
        SUS_WINDOW.isHost = NO;
        SUS_WINDOW.isSmallSusWindow = NO;
        SUS_WINDOW.isPushStreamIng = NO;
        //SUS_WINDOW.isSusWindow  这个保留  千万别调整
        [SUS_WINDOW resignKeyWindow];
        //SUS_WINDOW.liveType   这个保留
        if (SUS_WINDOW.rootViewController)
        {
            SUS_WINDOW.rootViewController = nil;
        }
        SUS_WINDOW.isHostShowAlert = NO;
        SUS_WINDOW.isHostShowAlert = NO;
        SUS_WINDOW.x = 0;
        
        SUS_WINDOW.recordFWTLiveController = nil;
        SUS_WINDOW.threeFWKSYLiveController = nil;
        
        SUS_WINDOW.isShowMention = NO;
        SUS_WINDOW.isShowLivePay = NO;
        
        if ([[[FWTabBarController sharedInstance] selectedViewController].childViewControllers[0] isKindOfClass:[HMHomeViewController class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHome object:nil userInfo:nil];
        }
        
    } completion:^(BOOL finished) {
        
        if (block)
        {
            block(finished);
        }
        
    }];
}

@end
