//
//  FWCommonMacro.h
//  FanweApp
//
//  Created by xfg on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  综合宏

#ifndef FWCommonMacro_h
#define FWCommonMacro_h

#import "GlobalVariables.h"

// 以下为大众宏（可能整个app都有用到）

// weakself strongself
#define FWWeakify(o)                __weak   typeof(self) fwwo = o;
#define FWStrongify(o)              __strong typeof(self) o = fwwo;

#define kDefaultMargin              DefaultMargin()   // 边距
static __inline__ CGFloat DefaultMargin()
{
    if (([UIScreen mainScreen].bounds.size.width >= 375.0f))
    {
        return 8;
    }
    else
    {
        return 7;
    }
}

#define kAppMargin2                 10  // 边距
#define kBorderWidth                1   // 边框宽度
#define kCornerRadius               4   // 圆角大小
#define myLineHight1                1   // 分割线高度
#define myLineHight2                2   // 个人中心横分割线2
#define myLineHight3                3   // 个人中心竖直分割线
#define myDotelineHight             1   // 虚线分割线高度
#define pluginMargin                10  // 插件中心边距宽度
#define pluginTitleHeight           44  // 插件中心标题高度
#define pluginLineHeight            0.5 // 插件中心线的高度
#define betButtonWidth              30  // 押注按钮的宽度
#define betButtonInterval           5   // 押注按钮之间的间隔
#define kTicketContrainerViewHeight 22      // 印票父视图的高度
#define kRechargeMargin             (kScreenW-300)/2

#define kDefaultPreloadHeadImg      [UIImage imageNamed:@"com_preload_head_img"]        // 预加载头像
#define kDefaultPreloadImgSquare    [UIImage imageNamed:@"com_preload_img_square"]      // 预加载图片(正方形)
#define kDefaultPreloadImgRectangle [UIImage imageNamed:@"com_preload_img_rectangle"]   // 预加载图片(长方形)
#define kDefaultPreloadVideoHeadImg [UIImage imageNamed:@"preload_sVideo_head_img"]     // 小视频详情预加载头像
#define kDefaultCoverColor          RGB(238, 238, 238)                                  // 预加载颜色

// 检测当前版本是否审核版本
#define kIsEqualCheckingVersion     [VersionNum isEqualToString:[GlobalVariables sharedInstance].appModel.ios_check_version]

// 当前屏幕方向
typedef NS_ENUM(NSUInteger, kDirectionType)
{
    kDirectionTypeDefault        = 0,   // home在下
    kDirectionTypeLeft           = 1,   // home在左
    kDirectionTypeRight          = 2,   // home在右
    kDirectionTypeTop            = 3,   // home在上
};


//=======================================================================================================================

// 以下为小众宏（可能单纯某个类用到）

#define kSegmentedHeight                35  // 首页Segmented高度
#define kAdvsTimeInterval               4   // 广告位间隔轮播时间
#define kRefreshWithNewaTimeInterval    20  // 主页热门定时刷新的时间
#define kAdvsPageWidth                  4   // 广告轮播组件的那个引导点的宽度
#define kIsTCShowSupportIMCustom        1   // 是否支持IM自定义

#define kHostNetLowTip1                 @"亲，您的网络有点小卡哦！" // 主播网络卡顿提示1
#define kHostNetLowTip2                 @"亲，您的网络开小差啦！"   // 主播网络卡顿提示2

static const NSTimeInterval kMoveAnimationDuration = 0.4;       //金币移动时间
static const NSTimeInterval kNarrowAnimationDuration = 0.3;     //金币缩小时间
static const NSTimeInterval kCoinMoveAnimationDuration = kMoveAnimationDuration + kNarrowAnimationDuration; //金币动画总的时间

#define kMyBtnWidth1                MyBtnWidth1()  // 按钮宽度
static __inline__ CGFloat MyBtnWidth1()
{
    if (([UIScreen mainScreen].bounds.size.width >= 375.0f))
    {
        return 35;
    }
    else
    {
        return 30;
    }
}

#define kRechargeViewHeight                  RechargeViewHeight ()   // 充值界面的高度
static __inline__ CGFloat RechargeViewHeight()
{
    if (([UIScreen mainScreen].bounds.size.width >= 375.0f))
    {
        return 436;
    }
    else
    {
        return kScreenH-180;
    }
}

#define kNumberBoardHeight                  NumberBoardHeight ()   // 数字键盘高度
static __inline__ CGFloat  NumberBoardHeight()
{
    if (kScreenW > 375.0f)
    {
        return 228;
    }
    else
    {
        return 218;
    }
}

// 插件中心高度
#define kPluginCenterHeight     PluginCenterHeight()
static __inline__ CGFloat PluginCenterHeight()
{
    if (([UIScreen mainScreen].bounds.size.height==568.0f))
    {
        return kScreenH * 0.68;
    }
    else if ([UIScreen mainScreen].bounds.size.height==667.0f)
    {
        return kScreenH * 0.62;
    }
    else if ([UIScreen mainScreen].bounds.size.height==736.0f)
    {
        return kScreenH * 0.6;
    }
    else
    {
        return kScreenH * 0.72;
    }
}

// 插件中心Y起始位置
#define kPluginCenterY      kScreenH-kPluginCenterHeight-kDefaultMargin

// 个人中心设置按钮高度
#define kCenterBtnHeight        CenterBtnHeight()
static __inline__ CGFloat CenterBtnHeight()
{
    if (([UIScreen mainScreen].bounds.size.height==568.0f))
    {
        return kScreenH * 0.088;
    }
    else if ([UIScreen mainScreen].bounds.size.height==667.0f)
    {
        return kScreenH * 0.0803;
    }
    else if ([UIScreen mainScreen].bounds.size.height==736.0f)
    {
        return kScreenH * 0.0801;
    }
    else
    {
        return kScreenH * 0.088;
    }
}

// row 的高度随着手机屏幕高度的比例
#define kAppRowHScale        AppRowHScale()
static __inline__ CGFloat AppRowHScale()
{
    if (([UIScreen mainScreen].bounds.size.height==568.0f))
    {
        return 0.88f;
    }
    else if ([UIScreen mainScreen].bounds.size.height==667.0f)
    {
        return 1.00f;
    }
    else
    {
        return 1.12f;
    }
}


#endif /* FWCommonMacro_h */
