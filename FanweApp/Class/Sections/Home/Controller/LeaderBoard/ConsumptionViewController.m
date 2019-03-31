//
//  ConsumptionViewController.m
//  FanweApp
//
//  Created by yy on 16/10/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ConsumptionViewController.h"

NS_ENUM(NSInteger, ListClassColl)
{
    EClassColl_ListDay,     //日榜
    EClassColl_ListMonth,   //月榜
    EClassColl_ListTotal,   //总榜
    EClassColl_Count,
};

@interface ConsumptionViewController ()<UIScrollViewDelegate,SegmentViewDelegate>
{
    CGRect          _segmentFrame;
    UIScrollView    *_cScrollView;
    NSInteger       _startPage;
}
@end

@implementation ConsumptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kAppSpaceColor3;
    [self createScrollView];
}

- (void)createScrollView
{
    //分段视图
    NSArray* items = [NSArray arrayWithObjects:@"日榜", @"月榜", @"总榜", nil];
    _segmentFrame = CGRectMake(kScreenW/8, 20,  kScreenW - 40, 44);
    _listSegmentView = [[SegmentView alloc]initWithFrame:_segmentFrame andItems:items andSize:12 border:NO isrankingRist:NO];
    _listSegmentView.backgroundColor = kWhiteColor;
    _listSegmentView.frame = CGRectMake(20, 0, kScreenW - 40, 44);
    _listSegmentView.delegate = self;
    [self.view addSubview:_listSegmentView];
    
    if (self.isHiddenTabbar)
    {
      _cScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenH-64 - 44)];
    }else
    {
      _cScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenH-64-49-44)];
    }
    _cScrollView.backgroundColor = kClearColor;
    _cScrollView.contentSize = CGSizeMake(EClassColl_Count*kScreenW, 0);
    _cScrollView.pagingEnabled = YES;
    _cScrollView.bounces = NO;
    _cScrollView.showsHorizontalScrollIndicator = NO;
    _cScrollView.delegate = self;
    [self.view addSubview:_cScrollView];
    _cScrollView.contentOffset = CGPointMake(0, 0);
    [_listSegmentView setSelectIndex:0];
    //日榜
    if (!_listDayViewController) {
        _listDayViewController = [[ListDayViewController alloc]init];
        _listDayViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listDayViewController.type = 1;
        _listDayViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListDay, 0, kScreenW, _cScrollView.bounds.size.height);
        _listDayViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_cScrollView addSubview:_listDayViewController.view];
    //月榜
    if (!_listMonthViewController) {
        _listMonthViewController = [[ListDayViewController alloc]init];
        _listMonthViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listMonthViewController.type = 2;
        _listMonthViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListMonth, 0, kScreenW, _cScrollView.bounds.size.height);
        _listMonthViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_cScrollView addSubview:_listMonthViewController.view];
    //总榜
    if (!_listTotalViewController) {
        _listTotalViewController = [[ListDayViewController alloc]init];
        _listTotalViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listTotalViewController.type = 3;
        _listTotalViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListTotal, 0, kScreenW, _cScrollView.bounds.size.height);
        _listTotalViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_cScrollView addSubview:_listTotalViewController.view];

}

#pragma mark --SegmentView代理方法
- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2f animations:^{
        _cScrollView.contentOffset = CGPointMake(_cScrollView.frame.size.width*index, 0);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _cScrollView.contentOffset;
    NSInteger page = (offset.x + _cScrollView.frame.size.width/2) / _cScrollView.frame.size.width;
    self.listSegmentView.indicatorView.hidden = NO;
    [_listSegmentView setSelectIndex:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
    float tmpPage2 = scrollView.contentOffset.x / pageWidth;
    NSInteger page = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
    
    if (_startPage != page)
    {
        [_listSegmentView setSelectIndex:page];
        _startPage = page;
    }
}


@end
