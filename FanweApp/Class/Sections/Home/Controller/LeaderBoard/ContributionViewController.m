//
//  ContributionViewController.m
//  FanweApp
//
//  Created by yy on 16/10/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ContributionViewController.h"

NS_ENUM(NSInteger, ContriClassColl)
{
    EClassColl_ContriDay,     //日榜
    EClassColl_ContriMonth,   //月榜
    EClassColl_ContriTotal,   //总榜
    EClass_Count,
};
@interface ContributionViewController ()<UIScrollViewDelegate,SegmentViewDelegate>
{
    CGRect          _segmentFrame;
    UIScrollView    *_bScrollView;
    NSInteger       _startPage;
}
@end

@implementation ContributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kAppSpaceColor3;
    [self createScroll];
}

- (void)createScroll
{
    //分段视图
    NSArray* items = [NSArray arrayWithObjects:@"日榜", @"月榜", @"总榜", nil];
    _segmentFrame = CGRectMake(kScreenW/8, 20,  kScreenW - 40, 44);
    _contriSegmentView = [[SegmentView alloc]initWithFrame:_segmentFrame andItems:items andSize:12 border:NO  isrankingRist:NO];
    _contriSegmentView.backgroundColor = kWhiteColor;
    _contriSegmentView.frame = CGRectMake(20, 0, kScreenW - 40, 44);
    _contriSegmentView.delegate = self;
    [self.view addSubview:_contriSegmentView];
    
    
    if (self.isHiddenTabbar)
    {
        _bScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenH-64 - 44)];
    }else
    {
        _bScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenH-64-49-44)];
    }
    _bScrollView.backgroundColor = kClearColor;
    _bScrollView.contentSize = CGSizeMake(EClass_Count*kScreenW, 0);
    _bScrollView.pagingEnabled = YES;
    _bScrollView.bounces = NO;
    _bScrollView.showsHorizontalScrollIndicator = NO;
    _bScrollView.delegate = self;
    [self.view addSubview:_bScrollView];
    _bScrollView.contentOffset = CGPointMake(0, 0);
    [_contriSegmentView setSelectIndex:0];
    //日榜
    if (!_ContriDayViewController) {
        _ContriDayViewController = [[ListDayViewController alloc]init];
        _ContriDayViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriDayViewController.type = 4;
        _ContriDayViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriDay, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriDayViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_bScrollView addSubview:_ContriDayViewController.view];
    //月榜
    if (!_ContriMonthViewController) {
        _ContriMonthViewController = [[ListDayViewController alloc]init];
        _ContriMonthViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriMonthViewController.type = 5;
        _ContriMonthViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriMonth, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriMonthViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_bScrollView addSubview:_ContriMonthViewController.view];
    //总榜
    if (!_ContriTotalViewController) {
        _ContriTotalViewController = [[ListDayViewController alloc]init];
        _ContriTotalViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriTotalViewController.type = 6;
        _ContriTotalViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriTotal, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriTotalViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_bScrollView addSubview:_ContriTotalViewController.view];
    
}

#pragma mark --SegmentView代理方法
- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2f animations:^{
        _bScrollView.contentOffset = CGPointMake(_bScrollView.frame.size.width*index, 0);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _bScrollView.contentOffset;
    NSInteger page = (offset.x + _bScrollView.frame.size.width/2) / _bScrollView.frame.size.width;
    self.contriSegmentView.indicatorView.hidden = NO;
    [_contriSegmentView setSelectIndex:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
    float tmpPage2    = scrollView.contentOffset.x / pageWidth;
    NSInteger page    = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
    
    if (_startPage != page)
    {
        [_contriSegmentView setSelectIndex:page];
        _startPage = page;
    }
}


@end
