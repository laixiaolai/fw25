//
//  FWMJRefreshManager.h
//  FanweApp
//
//  Created by xfg on 2017/7/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewModel.h"
#import "MJRefresh.h"

/**
 进入刷新状态的回调
 */
typedef void (^FWRefreshComponentRefreshingBlock)();

@interface FWMJRefreshManager : FWBaseViewModel

/**
 刷新方法：基础
 
 @param refreshedView 需要被刷新的View
 @param target target
 @param headerRereshAction 头部刷新，调用时默认头部刷新，如果为nil即表示隐藏头部刷新
 @param footerRereshAction 尾部刷新，如果为nil即表示隐藏尾部刷新
 */
+ (void)refresh:(UIScrollView *)refreshedView target:(id)target headerRereshAction:(SEL)headerRereshAction footerRereshAction:(SEL)footerRereshAction;

/**
 刷新方法：头部是否在调用时自动刷新
 
 @param refreshedView 需要被刷新的View
 @param target target
 @param headerRereshAction 头部刷新，如果为nil即表示隐藏头部刷新
 @param shouldHeaderBeginRefresh 是否需要开始刷新，如果设置为NO时记得首次需要主动调用自己的相关业务
 @param footerRereshAction 尾部刷新，如果为nil即表示隐藏尾部刷新
 */
+ (void)refresh:(UIScrollView *)refreshedView target:(id)target headerRereshAction:(SEL)headerRereshAction shouldHeaderBeginRefresh:(BOOL)shouldHeaderBeginRefresh footerRereshAction:(SEL)footerRereshAction;

/**
 刷新方法：刷新方法：1、头部是否在调用时自动刷新； 2、MJRefreshFooter的类型
 
 @param refreshedView 需要被刷新的View
 @param target target
 @param headerRereshAction 头部刷新，如果为nil即表示隐藏头部刷新
 @param shouldHeaderBeginRefresh 是否需要开始刷新，如果设置为NO时记得首次需要主动调用自己的相关业务
 @param footerRereshAction 尾部刷新，如果为nil即表示隐藏尾部刷新
 @param refreshFooterType MJRefreshFooter的类型，如：MJRefreshBackNormalFooter，MJRefreshBackGifFooter 等等 默认：MJRefreshBackNormalFooter
 */
+ (void)refresh:(UIScrollView *)refreshedView target:(id)target headerRereshAction:(SEL)headerRereshAction shouldHeaderBeginRefresh:(BOOL)shouldHeaderBeginRefresh footerRereshAction:(SEL)footerRereshAction refreshFooterType:(NSString *)refreshFooterType;

/**
 刷新方法：刷新方法：1、头部是否在调用时自动刷新；2、MJRefreshComponentRefreshingBlock回调 3、MJRefreshFooter的类型
 
 @param refreshedView 需要被刷新的View
 @param target target
 @param headerRereshAction 头部刷新，headerRereshAction || headerWithRefreshingBlock ==》不隐藏头部，反之隐藏头部
 @param shouldHeaderBeginRefresh 是否需要开始刷新，如果设置为NO时记得首次需要主动调用自己的相关业务
 @param headerWithRefreshingBlock MJRefreshComponentRefreshingBlock回调
 @param footerRereshAction 尾部刷新，如果为nil即表示隐藏尾部刷新
 @param refreshFooterType MJRefreshFooter的类型，如：MJRefreshBackNormalFooter，MJRefreshBackGifFooter 等等 默认：MJRefreshBackNormalFooter
 */
+ (void)refresh:(UIScrollView *)refreshedView target:(id)target headerRereshAction:(SEL)headerRereshAction shouldHeaderBeginRefresh:(BOOL)shouldHeaderBeginRefresh headerWithRefreshingBlock:(FWRefreshComponentRefreshingBlock)headerWithRefreshingBlock footerRereshAction:(SEL)footerRereshAction refreshFooterType:(NSString *)refreshFooterType;

/**
 停止刷新
 
 @param refreshedView 被刷新的View
 */
+ (void)endRefresh:(UIScrollView *)refreshedView;

@end
