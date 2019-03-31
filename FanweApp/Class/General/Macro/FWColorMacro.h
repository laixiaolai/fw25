//
//  FWColorMacro.h
//  FanweApp
//
//  Created by xfg on 16/7/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef FWColorMacro_h
#define FWColorMacro_h

#import "UIColor+MLPFlatColors.h"
#import "UIColor+HEX.h"
#import "FWCommonMacro.h"

// ====================================取色值相关的方法==========================================

#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
                            green:(g)/255.f \
                            blue:(b)/255.f \
                            alpha:1.f]

#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.f \
                            green:(g)/255.f \
                            blue:(b)/255.f \
                            alpha:(a)]

#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                            blue:((float)(rgbValue & 0xFF))/255.0 \
                            alpha:1.0]

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
                            green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
                            blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
                            alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBAOF(v, a)        [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
                            green:((float)(((v) & 0x00FF00) >> 8))/255.0 \
                            blue:((float)(v & 0x0000FF))/255.0 \
                            alpha:a]
#define kColorWithStr(colorStr)      [UIColor colorWithHexString:colorStr]


// =====================================通用颜色=========================================

#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]
#define kRandomFlatColor    [UIColor randomFlatColor]


// =====================================以下为大众色值（可能整个app都有用到）=========================================

#define kAppMainColor               AppMainColor()              // app主色调
static __inline__ UIColor* AppMainColor()
{
    if (kIsEqualCheckingVersion)
    {
        return kCheckVMainColor;
    }
    else
    {
        return RGB(51, 51, 51);     // #333333
    }
}


#define kAppSecondaryColor          RGB(254, 226, 4)            // app辅色调，#fee204
#define kNavBarThemeColor           [UIColor whiteColor]        // 导航主色调

// 默认背景色
#define kBackGroundColor            RGB(248, 248, 248)          // #f8f8f8

// 灰色字体(颜色：由深到浅)
#define kAppGrayColor1              RGB(51, 51, 51)             // #333333
#define kAppGrayColor2              RGB(102, 102, 102)          // #666666
#define kAppGrayColor3              RGB(153, 153, 153)          // #999999
#define kAppGrayColor4              RGB(203, 203, 203)          // 新版用到的地方较少

#define kAppGrayColor5              RGB(28, 28, 28)             // 竞拍主页竞拍记录等文字的颜色
#define kAppGrayColor6              RGB(78, 83, 90)             // 竞拍失败最下面的颜色
#define kAppGrayColor7              RGB(107, 115, 123)          // 竞拍失败(主播关闭竞拍)的颜色
#define kAppGrayColor8              RGB(238, 237, 237)

// 间隔、线条颜色
#define kAppSpaceColor              RGB(231, 231, 241)
#define kAppSpaceColor2             RGB(235, 238, 238)
#define kAppSpaceColor3             RGB(248, 248, 248)
#define kAppSpaceColor4             RGB(231, 231, 241)          // e7e7f1

#define kAppRechargeBtnColor        RGB(255,159,134)            // 充值按钮的未选中的时候的颜色
#define kAppBorderColor             [(kAppSpaceColor) CGColor]  // 边框颜色
#define kAppRechargeSelectColor     kWhiteColor                 //充值按钮选中时候的颜色

// 黑色透明色（透明度：由高到低）
#define kGrayTransparentColor1      [[UIColor blackColor] colorWithAlphaComponent:0.1]
#define kGrayTransparentColor2      [[UIColor blackColor] colorWithAlphaComponent:0.2]
#define kGrayTransparentColor2_1    [[UIColor blackColor] colorWithAlphaComponent:0.3]
#define kGrayTransparentColor3      [[UIColor blackColor] colorWithAlphaComponent:0.4]
#define kGrayTransparentColor3_1    [[UIColor blackColor] colorWithAlphaComponent:0.5]
#define kGrayTransparentColor4      [[UIColor blackColor] colorWithAlphaComponent:0.6]
#define kGrayTransparentColor4_1    [[UIColor blackColor] colorWithAlphaComponent:0.7]
#define kGrayTransparentColor5      [[UIColor blackColor] colorWithAlphaComponent:0.85]
#define kGrayTransparentColor6      [[UIColor blackColor] colorWithAlphaComponent:0.95]

#define kAuctionBtnColor                RGB(255, 117, 81)

// ====================================以下为小众色值（可能单纯某个类用到）==========================================

// 竞拍
#define kAppPurpleColor                 RGB(255, 245, 246)          // 竞拍详情的淡粉色

#define kAuctionBtnColor                RGB(255, 117, 81)

// 直播页的相关色值
#define myTextColorUser                 RGB(255, 206, 107)          // 用户名
#define myTextColorCommonMessage        RGB(255, 255, 255)          // 普通消息颜色
#define myTextColorSendGift             RGB(247, 103, 118)          // 送礼物时的颜色
#define myTextColorLivingMessage        RGB(191,239,128)            // 直播消息颜色
#define myTextColorRedPackage           RGB(247, 103, 118)          // 红包消息颜色
#define kTextColorSendLight             RGB(255, 255, 255)          // 点亮消息颜色
#define kTextColorSenderName            kWhiteColor                 // 送礼物者的名字颜色
#define myTextRedColorLivingMessage     kRedColor                   // 竞拍的名字颜色
#define kAppPluginSpaceColor            RGB(153,153,153)            // 插件中心分隔线颜色

//page点的颜色
#define myPageColor                     RGB(255, 117, 81)           // pageController点的颜色
#define myCurrentPageColor              RGB(13, 13, 13)             // 当前点的颜色
#define kAppRedColor                    RGB(251, 207, 206)          // 认证页面的红色

//字体颜色
#define myTextColor                 [UIColor grayColor]
#define myTextColor1                [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:1]
#define myTextColor2                [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]
#define myTextColor3                [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]
#define myTextColorLine1            [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:0.2]
#define myTextColorLine2            [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:0.1]
#define myTextColorLine3            [[UIColor blackColor] colorWithAlphaComponent:0.2]
#define myTextColorLine4            [[UIColor blackColor] colorWithAlphaComponent:0.05]
#define myTextColorLine5            [[UIColor blackColor] colorWithAlphaComponent:0.1]
#define myTextColorLine6            [[UIColor blackColor] colorWithAlphaComponent:0.5]
#define myTextColorLine7            [[UIColor whiteColor] colorWithAlphaComponent:0.2]
#define myTextColorLine8            [[UIColor whiteColor] colorWithAlphaComponent:0.5]
#define myTextColorLine9            [[UIColor whiteColor] colorWithAlphaComponent:0.1]

#define textColor1                  RGB(100,107,109)
#define textColor2                  RGB(217,224,225)
#define textColor3                  RGB(240,161,163)
#define textColor4                  RGB(85,85,85)       // 贡献榜字的颜色
#define textColor5                  RGB(129,210,235)    // 音乐歌手名字的颜色

// 家族
#define kFamilyBackGroundColor      RGB(236,236,236)    // 家族详情背景的颜色
#define kAppFamilyBtnColor          RGB(95,204,174)     // 家族相关按钮颜色（拒绝按钮，创建家族按钮颜色）

// 游戏相关颜色
#define goldColor                   RGB(255, 215, 0)    // 金色
#define lightGoldColor              RGB(250, 250, 210)  // 亮金色
#define kGoldFolwerColor            RGB(251, 56, 70)    // 炸金花描边颜色
#define kBullPokerColor             RGB(255, 175, 61)   // 斗牛描边颜色

#define kAppH5MainColor             RGB(247, 52, 45)    // H5颜色

#endif /* FWColorMacro_h */
