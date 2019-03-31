//
//  MyOrderViewController.m
//  FanweApp
//
//  Created by yy on 16/11/17.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "MyOrderViewController.h"

NS_ENUM(NSInteger,orderScroll)
{
    Eorder_shopping,        //购物
    Eorder_auction,         //竞拍
    Eorder_count,
};
@interface MyOrderViewController ()<SegmentViewDelegate,UIScrollViewDelegate>
{
    FWMainWebViewController   *_shoppingVC;     //购物
    FWMainWebViewController   *_auctionVC;      //竞拍
    GlobalVariables     *_fanweApp;
    NSArray             *_listItems;
    UIView              *_headView;
    CGRect              _listSegmentFrame;
    UIScrollView        *_tScrollView;
}
@end

@implementation MyOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _headView.hidden = NO;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _fanweApp = [GlobalVariables sharedInstance];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    self.view.backgroundColor = kNavBarThemeColor;
    //分段视图
    _listItems =[NSArray arrayWithObjects:@"购物",@"竞拍", nil];
    [self createHeadView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _headView.hidden = YES;
}

#pragma mark    导航栏部分
- (void)createHeadView
{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/4, 0, kScreenW/2, 44)];
    _headView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:_headView];
    _listSegmentFrame =CGRectMake(0, 0,  kScreenW/2, 44);
    _listSegmentView = [[SegmentView alloc]initWithFrame:_listSegmentFrame andItems:_listItems andSize:17 border:NO isrankingRist:YES];
    _listSegmentView.backgroundColor = [UIColor clearColor];
    _listSegmentView.delegate = self;
    [_listSegmentView setSelectIndex:0];
    [_headView addSubview:_listSegmentView];
    
    _tScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kNavigationBarHeight-kStatusBarHeight )];
    _tScrollView.backgroundColor = [UIColor whiteColor];
    _tScrollView.contentSize = CGSizeMake(Eorder_count*kScreenW, 0);
    _tScrollView.pagingEnabled = YES;
    _tScrollView.bounces = NO;
    _tScrollView.showsHorizontalScrollIndicator = NO;
    _tScrollView.delegate = self;
    [self.view addSubview:_tScrollView];
    _tScrollView.contentOffset = CGPointMake(0, 0);
    
    // 购物
    if (!_shoppingVC)
    {
        _shoppingVC = [FWMainWebViewController webControlerWithUrlStr:_fanweApp.appModel.h5_url.url_user_order isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        _shoppingVC.isFrontRefresh = YES;
        _shoppingVC.isViewWillAppearRefresh = YES;
        _shoppingVC.view.frame = CGRectMake(kScreenW * Eorder_shopping, 0, kScreenW, _tScrollView.bounds.size.height);
        _shoppingVC.view.backgroundColor = [UIColor whiteColor];
        [_tScrollView addSubview:_shoppingVC.view];
    }
    
    // 竞拍
    if (!_auctionVC)
    {
        _auctionVC = [FWMainWebViewController webControlerWithUrlStr:_fanweApp.appModel.h5_url.url_user_pai isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        _auctionVC.isFrontRefresh = YES;
        _auctionVC.isViewWillAppearRefresh = YES;
        _auctionVC.view.frame = CGRectMake(kScreenW * Eorder_auction, 0, kScreenW, _tScrollView.bounds.size.height );
        _auctionVC.view.backgroundColor = [UIColor whiteColor];
        [_tScrollView addSubview:_auctionVC.view];
    }
}

#pragma mark --SegmentView代理方法
- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index{
    NSLog(@"index==%d",(int)index);
    [UIView animateWithDuration:0.2f animations:^{
        _tScrollView.contentOffset = CGPointMake(_tScrollView.frame.size.width*index, 0);
    }];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _tScrollView.contentOffset;
    NSInteger page = (offset.x + _tScrollView.frame.size.width/2) / _tScrollView.frame.size.width;
    self.segmentView.indicatorView.hidden = NO;
    [_listSegmentView setSelectIndex:page];
    
}
//后退返回
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
