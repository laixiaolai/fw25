//
//  STSuspensionWindow.m
//  FanweApp
//
//  Created by 岳克奎 on 17/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STSuspensionWindow.h"

@implementation STSuspensionWindow

//new STBaseSuspensionWindow
+ (STSuspensionWindow *)showWindowTypeOfSTBaseSuspensionWindowOfFrameRect:(CGRect)frameRect
                                       ofSTBaseSuspensionWindowLevelValue:(CGFloat)stSuspensionWindowLevelValue
                                                                 complete:(void(^)(BOOL finished,
                                                                                   STSuspensionWindow *stSuspensionWindow))block
{
    //
    STSuspensionWindow *stSuspensionWindow = [[STSuspensionWindow alloc]initWithFrame:frameRect];
    //
    stSuspensionWindow.windowLevel = stSuspensionWindowLevelValue;
    //
    //[stSuspensionWindow makeKeyWindow];
    //
    stSuspensionWindow.hidden = YES;
    //test
    stSuspensionWindow.backgroundColor = [UIColor redColor];
    
    if (block)
    {
        block(YES,stSuspensionWindow);
    }
    return stSuspensionWindow;
    
}
//控制 widnow的显示  前提存在window
- (void)setStSusWindowShowState:(STSusWindowShowState )stSusWindowShowState
{
    _stSusWindowShowState = stSusWindowShowState;
    if(stSusWindowShowState == stSusWindowShowYES)
    {
        [self makeKeyWindow];
        self.hidden = NO;
    }
    else
    {
        [self resignKeyWindow];
        self.hidden = YES;
    }
}

#pragma mark ------------------------------------------- private methods
#pragma mark - 重写手势方法
/**
 tap子重写
 
 @param tapGestureRecognizer 放大
 */
- (void)tapGestureRecognizerClick:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //回调调度中心
    // [ST_LIVE_CENTER_MANAGER setStSusAnimationType:stSusAnimationTypeOfFull];
    
}

//tap 子重写
- (void)panGestureRecognizerClick:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self showPanClickForSTWindowOfPoint:[self.panGestureRecognizer locationInView:self] andMovePoint:[self.panGestureRecognizer translationInView: self]];
}

/**
 *
 * @brief:悬浮动画（缩放）
 *
 *@prama  :    stSusAnimationType    动画类型  small+full
 *@prama  :    stLiveModel
 *@prama  :    liveViewC             需要处理 关闭btn，liveView，liveViewC
 *@prama  :    stSuspensionWindow    处理尺寸问题
 *
 *
 *@discussion: 1. 能进来说明必定是悬浮类
 *             2. 动画需要  拿到ViewC
 *
 *@attention :
 *
 *@return :    BOOL  YES动画加载成功  NO 未启动动画
 *
 */
//+ (void)showSTSusAnimationType:(LiveWindowType)liveWindowType
//                andSTLiveType:(FW_LIVE_TYPE )liveType
//                andLivewViewC:(UIViewController *)liveViewC
//        andSTSuspensionWindow:(STSuspensionWindow *)stSuspensionWindow
//                     complete:(void(^)(BOOL finished))block{
//
//    FWTLiveController *fwTLiveController;
//    FWHDLiveController *fwHDLiveController;
//    UIButton *closeBtn;
//    UIView   *liveView;
//    //互动
//    if (stLiveType == stLiveTypeOfHDHost||stLiveType == stLiveTypeOfHDAudience) {
//        fwHDLiveController = (FWHDLiveController *) liveViewC;
//        closeBtn = fwHDLiveController.liveServiceController.closeBtn;
//        liveView= fwHDLiveController.liveServiceController.liveUIViewController.liveView;
//    }
//    //云
//    if(stLiveType== stLiveTypeOfYunHost ||stLiveType == stLiveTypeOfYunPlayback ||stLiveType == stLiveTypeOfYunAudience){
//        fwTLiveController =(FWTLiveController *)liveViewC;
//        closeBtn = fwTLiveController.liveServiceController.closeBtn;
//        liveView= fwTLiveController.liveServiceController.liveUIViewController.liveView;
//
//    }
//    if (stSusAnimationType == stSusAnimationTypeOfSmall) {
//        liveView.hidden = YES;
//        stSuspensionWindow.transform = CGAffineTransformMakeScale(0.4, 0.6*kScreenW/kScreenH);
//        stSuspensionWindow.tapGestureRecognizer.enabled = YES;
//        stSuspensionWindow.panGestureRecognizer.enabled = YES;
//        fwTLiveController.liveServiceController.liveUIViewController.panGestureRec.enabled = NO;
//
//
//    }
//    if (stSusAnimationType == stSusAnimationTypeOfFull) {
//        stSuspensionWindow.transform = CGAffineTransformIdentity;
//        stSuspensionWindow.tapGestureRecognizer.enabled = NO;
//        stSuspensionWindow.panGestureRecognizer.enabled = NO;
//        liveView.hidden = NO;
//        fwTLiveController.liveServiceController.liveUIViewController.panGestureRec.enabled = YES;
//        stSuspensionWindow.frame = CGRectMake(0, 0, kScreenW, kScreenH);
//    }
//
//    if (block) {
//        block(YES);
//    }
//
//}


- (void)setIsSmallSize:(BOOL)isSmallSize
{
    if (_isSmallSize == isSmallSize)
    {
        
    }
    else
    {
        if (isSmallSize)
        {
            //缩小
            self.transform = CGAffineTransformMakeScale(0.4, 0.6*kScreenW/kScreenH);
            self.tapGestureRecognizer.enabled = YES;
            self.panGestureRecognizer.enabled = YES;
        }
        else
        {
            //如果悬浮放大
            self.transform = CGAffineTransformIdentity;
            self.tapGestureRecognizer.enabled = NO;
            self.panGestureRecognizer.enabled = NO;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(showAnimationComplete:)])
        {
            [_delegate showAnimationComplete:^(BOOL finished) {
                //带block 万一传2个以上参数呢，，
                _isSmallSize = isSmallSize;
            }];
        }
    }
    //满屏处理完毕
    if (!_isSmallSize&& _delegate &&[_delegate respondsToSelector:@selector(showFullScreenFinished:)])
    {
        [_delegate showFullScreenFinished:^(BOOL finished) {
            
        }];
    }
}

@end
