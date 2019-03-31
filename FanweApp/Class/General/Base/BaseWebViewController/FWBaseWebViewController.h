//
//  FWBaseWebViewController.h
//  FanweApp
//
//  Created by xfg on 2017/6/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, RightBarBtnItem)
{
    RightBarBtnItemRefresh          =   0,  // 导航栏右侧 刷新按钮，刷新按钮再点击后会有个隐藏
    RightBarBtnItemBackLiveVC       =   1,  // 导航栏右侧 回到直播间按钮
};

@interface FWBaseWebViewController : FWBaseViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView  *webView;                      // wkwebview
@property (nonatomic, strong) WKUserContentController *userContentC;
@property (nonatomic, copy) NSString    *urlStr;                        // url地址
@property (nonatomic, copy) NSString    *httpMethodStr;                 // 请求方式：GET、POST，默认为POST
@property (nonatomic, copy) NSString    *navTitleStr;                   // 标题栏

@property (nonatomic, assign) BOOL      isShowNavBar;                   // 是否显示导航栏
@property (nonatomic, assign) BOOL      isShowTabBar;                   // 是否显示tabBar
@property (nonatomic, assign) BOOL      isShowBackBtn;                  // 是否显示返回按钮
@property (nonatomic, assign) BOOL      isShowCloseBtn;                 // 是否显示关闭按钮（前提是 isShowBackBtn==YES）
@property (nonatomic, assign) BOOL      isShowIndicator;                // 是否显示指示器（当前指示器指的是：菊花转转，后期可以用进度条等替换）
@property (nonatomic, assign) BOOL      isShowLaunchImgView;            // 是否显示launchImgView，等webview加载完成后再隐藏

@property (nonatomic, assign) BOOL      isFrontRefresh;                 // 是否允许进入前台时进行刷新
@property (nonatomic, assign) BOOL      isViewWillAppearRefresh;        // 是否允许ViewWillAppear的时候进行刷新

@property (nonatomic, assign) BOOL      isShouldOpenBounces;            // 是否需要开启WebView回弹效果（注意：默认是禁止的）

@property (nonatomic, assign) BOOL      isSmallScreen;                  // 是否有小屏


/**
 类方法初始1

 @param urlStr WebView加载地址
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr;

/**
 类方法初始2
 
 @param urlStr urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator;

/**
 类方法初始3
 
 @param urlStr urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @param isShowNavBar 是否显示导航栏
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator isShowNavBar:(BOOL)isShowNavBar;

/**
 类方法初始4

 @param urlStr urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @param isShowNavBar 是否显示导航栏
 @param isShowTabBar 是否显示tabBar
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator isShowNavBar:(BOOL)isShowNavBar isShowTabBar:(BOOL)isShowTabBar;

/**
 类方法初始5
 
 @param urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @param isShowNavBar 是否显示导航栏
 @param isShowBackBtn 是否显示返回按钮
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator isShowNavBar:(BOOL)isShowNavBar isShowBackBtn:(BOOL)isShowBackBtn;

/**
 类方法初始6

 @param urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @param isShowNavBar 是否显示导航栏
 @param isShowBackBtn 是否显示返回按钮
 @param isShowCloseBtn 是否显示关闭按钮（前提是 isShowBackBtn==YES）
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator isShowNavBar:(BOOL)isShowNavBar isShowBackBtn:(BOOL)isShowBackBtn isShowCloseBtn:(BOOL)isShowCloseBtn;

/**
 加载当前WKWebView
 */
- (void)loadCurrentWKWebView;

/**
 重新加载当前WKWebView
 */
- (void)reLoadCurrentWKWebView;

/**
 显示HUD

 @param statusStr 显示的文字
 */
- (void)showMyHud:(NSString *)statusStr;

/**
 隐藏HUD
 */
- (void)hideMyHud;

/**
 添加导航栏右侧按钮

 @param type 类型，如需拓展，请拓展枚举RightBarBtnItem
 @param titleStr 按钮显得名称
 */
- (void)initRightBarBtnItemWithType:(RightBarBtnItem)type titleStr:(NSString *)titleStr;

/**
 移除ScriptMessageHandler，防止退出时内存泄露
 */
- (void)removeScriptMessageHandler;

@end
