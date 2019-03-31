//
//  FWMJRefreshManager.m
//  FanweApp
//
//  Created by xfg on 2017/7/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWMJRefreshManager.h"

@implementation FWMJRefreshManager

+ (void)refresh:(UIScrollView *)refreshedView target:(id)target headerRereshAction:(SEL)headerRereshAction footerRereshAction:(SEL)footerRereshAction
{
    [FWMJRefreshManager refresh:refreshedView target:target headerRereshAction:headerRereshAction shouldHeaderBeginRefresh:YES footerRereshAction:footerRereshAction];
}

+ (void)refresh:(UIScrollView *)refreshedView target:(id)target headerRereshAction:(SEL)headerRereshAction shouldHeaderBeginRefresh:(BOOL)shouldHeaderBeginRefresh footerRereshAction:(SEL)footerRereshAction
{
    [FWMJRefreshManager refresh:refreshedView target:target headerRereshAction:headerRereshAction shouldHeaderBeginRefresh:shouldHeaderBeginRefresh footerRereshAction:footerRereshAction refreshFooterType:@"MJRefreshBackNormalFooter"];
}

+ (void)refresh:(UIScrollView *)refreshedView target:(id)target headerRereshAction:(SEL)headerRereshAction shouldHeaderBeginRefresh:(BOOL)shouldHeaderBeginRefresh footerRereshAction:(SEL)footerRereshAction refreshFooterType:(NSString *)refreshFooterType
{
    [self refresh:refreshedView target:target headerRereshAction:headerRereshAction shouldHeaderBeginRefresh:shouldHeaderBeginRefresh headerWithRefreshingBlock:nil footerRereshAction:footerRereshAction refreshFooterType:refreshFooterType];
}

+ (void)refresh:(UIScrollView *)refreshedView target:(id)target headerRereshAction:(SEL)headerRereshAction shouldHeaderBeginRefresh:(BOOL)shouldHeaderBeginRefresh headerWithRefreshingBlock:(FWRefreshComponentRefreshingBlock)headerWithRefreshingBlock footerRereshAction:(SEL)footerRereshAction refreshFooterType:(NSString *)refreshFooterType
{
    if (headerRereshAction || headerWithRefreshingBlock)
    {
        // 上下拉刷新
        MJRefreshGifHeader *header;
        if (headerWithRefreshingBlock)
        {
            header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                headerWithRefreshingBlock();
            }];
        }
        else
        {
            header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:headerRereshAction];
        }
        
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        header.stateLabel.hidden = YES;
        
        NSMutableArray *pullingImages = [NSMutableArray array];
        
        UIImage *image = [UIImage imageNamed:@"refresh_header_start"];
        [pullingImages addObject:image];
        
        UIImage *image2 = [UIImage imageNamed:@"refresh_header_start"];
        [pullingImages addObject:image2];
        
        NSArray *arrimg = [NSArray arrayWithObject:[pullingImages firstObject]];
        [header setImages:arrimg  forState:MJRefreshStateIdle];
        
        NSArray *arrimg2 = [NSArray arrayWithObject:[pullingImages lastObject]];
        [header setImages:arrimg2  forState:MJRefreshStatePulling];
        
        NSMutableArray *progressImage = [NSMutableArray array];
        for (NSUInteger i = 1; i <= kRefreshImgCount; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_header_%ld", i]];
            if (image)
            {
                [progressImage addObject:image];
            }
        }
        [header setImages:progressImage duration:0.04*progressImage.count forState:MJRefreshStateRefreshing];
        refreshedView.mj_header = header;
        
        if (shouldHeaderBeginRefresh)
        {
            [header beginRefreshing];
        }
    }
    else
    {
        refreshedView.mj_header = nil;
    }
    
    if (footerRereshAction)
    {
        refreshedView.mj_footer.automaticallyHidden = YES;
        if (![FWUtils isBlankString:refreshFooterType])
        {
            Class tabBarClass = NSClassFromString(refreshFooterType);
            refreshedView.mj_footer = [tabBarClass footerWithRefreshingTarget:target refreshingAction:footerRereshAction];
        }
        else
        {
            refreshedView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:footerRereshAction];
        }
    }
    else
    {
        refreshedView.mj_footer = nil;
    }
}

+ (void)endRefresh:(UIScrollView *)refreshedView
{
    if (refreshedView.mj_header)
    {
        [refreshedView.mj_header endRefreshing];
    }
    if (refreshedView.mj_footer)
    {
        [refreshedView.mj_footer endRefreshing];
    }
}

@end
