//
//  ContributionListViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ContributionListViewController.h"
#import "SHomePageVC.h"
#import "LeaderboardViewController.h"
#import "SContributionView.h"

@interface ContributionListViewController ()<SegmentViewDelegate,ContriButionDeleGate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView            *cScrollView;
@property (nonatomic, assign) NSInteger               startPage;
@property (nonatomic, assign) CGRect                  segmentFrame;
@property (nonatomic, strong) UITableView             *myTableview;
@property (nonatomic, strong) SContributionView       *contributionV1;       //当前排行
@property (nonatomic, strong) SContributionView       *contributionV2;       //累计排行

@end

@implementation ContributionListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.title = [NSString stringWithFormat:@"%@贡献榜",self.fanweApp.appModel.ticket_name];
    self.view.backgroundColor = kBackGroundColor;
    
    if ([self.type intValue] == 1)
    {
        NSArray* items = [NSArray arrayWithObjects:@"当天排行", @"累计排行", nil];
        _segmentFrame = CGRectMake(0,0,  kScreenW, 40);
        _listSegmentView = [[SegmentView alloc]initWithFrame:_segmentFrame andItems:items andSize:17 border:NO isrankingRist:NO];
        _listSegmentView.backgroundColor = kWhiteColor;
        _listSegmentView.frame = _segmentFrame;
        _listSegmentView.delegate = self;
        [self.view addSubview:_listSegmentView];
  
    }
    
    _cScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_listSegmentView.frame), kScreenW,kScreenH-kNavigationBarHeight-kStatusBarHeight-_listSegmentView.height)];
    _cScrollView.backgroundColor = kBackGroundColor;
    if ([self.type intValue] == 1)
    {
      _cScrollView.contentSize = CGSizeMake(2*kScreenW, 0);
    }else
    {
     _cScrollView.contentSize = CGSizeMake(kScreenW, 0);
    }
    _cScrollView.pagingEnabled = YES;
    _cScrollView.bounces = NO;
    _cScrollView.showsHorizontalScrollIndicator = NO;
    _cScrollView.delegate = self;
    [self.view addSubview:_cScrollView];
    [_listSegmentView setSelectIndex:0];
    
    if ([self.type intValue] == 1)
    {
        //当日排行
        if (!_contributionV1)
        {
            _contributionV1 = [[SContributionView alloc]initWithFrame:CGRectMake(10, 0,_cScrollView.width-20, _cScrollView.height) andDataType:1 andUserId:self.user_id andLiveRoomId:self.liveAVRoomId];
            _contributionV1.CDelegate = self;
            [_cScrollView addSubview:_contributionV1];
        }
    }
  
    
    //累计排行
    if (!_contributionV2)
    {
        if ([self.type intValue] == 1)
        {
          _contributionV2 = [[SContributionView alloc]initWithFrame:CGRectMake(kScreenW+10, 0,_cScrollView.width-20, _cScrollView.height) andDataType:2 andUserId:self.user_id andLiveRoomId:self.liveAVRoomId];
        }else
        {
        _contributionV2 = [[SContributionView alloc]initWithFrame:CGRectMake(10, 0,_cScrollView.width-20, _cScrollView.height) andDataType:2 andUserId:self.user_id andLiveRoomId:self.liveAVRoomId];
        }
      
        _contributionV2.CDelegate = self;
     [_cScrollView addSubview:_contributionV2];
    }
    
    
    if ([self.type intValue]== 1)
    {
      [_cScrollView scrollRectToVisible:CGRectMake(10, 0, _cScrollView.width, CGRectGetHeight(_cScrollView.frame)) animated:NO];
    }else
    {
      [_cScrollView scrollRectToVisible:CGRectMake(_cScrollView.width+10, 0, _cScrollView.width, CGRectGetHeight(_cScrollView.frame)) animated:NO];
      _cScrollView.alwaysBounceHorizontal = NO;
    }
   
    if ([self.fanweApp.appModel.open_ranking_list intValue] ==1)
    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 5, 50, 30);
        rightButton.tag = 1;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [rightButton setTitle:@"总榜" forState:UIControlStateNormal];
        [rightButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [rightButton setTitleColor:kAppGrayColor4 forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(totalListClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
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

- (void)goToHomeWithModel:(UserModel *)model
{
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = model.user_id;
    tmpController.type = 0;
    [self.navigationController pushViewController:tmpController animated:NO];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)totalListClick:(UIButton *)button
{
    LeaderboardViewController *boardVC = [[LeaderboardViewController alloc]init];
    boardVC.isHiddenTabbar = YES;
    if (self.liveHost_id.length)
    {
        boardVC.hostLiveId = self.liveHost_id;
    }
    [self.navigationController pushViewController:boardVC animated:YES];
}


@end
