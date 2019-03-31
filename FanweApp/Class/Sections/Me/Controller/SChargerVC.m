//
//  SChargerVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/28.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SChargerVC.h"
#import "SFeeRecordV.h"

@interface SChargerVC ()<UIScrollViewDelegate,SegmentViewDelegate>

@property ( nonatomic, strong) NSMutableArray            *feeItemsArray;
@property ( nonatomic, strong) NSMutableArray            *recordItemsArray;
@property ( nonatomic, strong) UIScrollView              *myScrollView;
@property ( nonatomic, strong) SFeeRecordV               *feeRecordV1;       //按时收费 付费记录的view
@property ( nonatomic, strong) SFeeRecordV               *feeRecordV2;       //按时收费 收费记录的view
@property ( nonatomic, strong) SFeeRecordV               *feeRecordV3;       //按场收费 付费记录的view
@property ( nonatomic, strong) SFeeRecordV               *feeRecordV4;       //按场收费 收费记录的view
@property ( nonatomic, assign) NSInteger                 startPage;          // 起始页

@end

@implementation SChargerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startPage = 0;
    self.view.backgroundColor = kWhiteColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.feeSegmentView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.feeSegmentView.hidden = YES;
}

-(void)initFWUI
{
    [super initFWUI];
    self.feeItemsArray = [[NSMutableArray alloc]init];
    if (self.fanweApp.appModel.live_pay_time == 1)
    {
        [self.feeItemsArray addObject:@"按时收费"];
    }
    if (self.fanweApp.appModel.live_pay_scene == 1)
    {
        [self.feeItemsArray addObject:@"按场收费"];
    }
    self.recordItemsArray = [[NSMutableArray alloc]initWithObjects:@"付费记录",@"收费记录", nil];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(returnCenterVC) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    self.feeSegmentView = [[SegmentView alloc]initWithFrame:CGRectMake(kScreenW*0.15, 0, kScreenW*0.7, 44) andItems:self.feeItemsArray andSize:16 border:NO  isrankingRist:NO];
    self.feeSegmentView.backgroundColor = kWhiteColor;
    self.feeSegmentView.delegate = self;
    [self.feeSegmentView setSelectIndex:self.feeIndex];
    [self.navigationController.navigationBar addSubview:self.feeSegmentView];
    
    self.recordSegmentView = [[SegmentView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSegmentedHeight) andItems:self.recordItemsArray andSize:12 border:NO  isrankingRist:NO];
    self.recordSegmentView.backgroundColor = kWhiteColor;
    self.recordSegmentView.delegate = self;
    [self.recordSegmentView setSelectIndex:self.recordIndex];
    [self.view addSubview:self.recordSegmentView];
    
    
    self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kSegmentedHeight, self.view.frame.size.width, kScreenH-kNavigationBarHeight-kStatusBarHeight-kSegmentedHeight)];
    self.myScrollView.backgroundColor = kRedColor;
    self.myScrollView.contentSize = CGSizeMake(4*kScreenW, 0);
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.bounces = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.delegate = self;
    [self.view addSubview:self.myScrollView];
    [self.myScrollView scrollRectToVisible:CGRectMake(kScreenW*self.feeIndex, 50, kScreenW, self.myScrollView.height) animated:YES];

    
    self.feeRecordV1 =[[SFeeRecordV alloc]initWithFrame:CGRectMake(0, 0, self.myScrollView.width, self.myScrollView.height) andfeeType:0 andRecordType:0];
    FWWeakify(self)
    [self.feeRecordV1 setFeeRecordBlock:^(NSString *userId){
        FWStrongify(self)
        [self pushToHomePageVVWithUserId:userId];
    }];
    [self.myScrollView addSubview:self.feeRecordV1];
    
    self.feeRecordV2 = [[SFeeRecordV alloc]initWithFrame:CGRectMake(self.myScrollView.width, 0, self.myScrollView.width, self.myScrollView.height) andfeeType:0 andRecordType:1];
    [self.feeRecordV2 setFeeRecordBlock:^(NSString *userId){
        FWStrongify(self)
        [self pushToHomePageVVWithUserId:userId];
    }];
    [self.myScrollView addSubview:self.feeRecordV2];
    
    self.feeRecordV3 = [[SFeeRecordV alloc]initWithFrame:CGRectMake(self.myScrollView.width*2, 0, self.myScrollView.width, self.myScrollView.height) andfeeType:1 andRecordType:0];
    [self.feeRecordV3 setFeeRecordBlock:^(NSString *userId){
        FWStrongify(self)
        [self pushToHomePageVVWithUserId:userId];
    }];
    [self.myScrollView addSubview:self.feeRecordV3];
    
    self.feeRecordV4 =[[SFeeRecordV alloc]initWithFrame:CGRectMake(self.myScrollView.width*3, 0, self.myScrollView.width, self.myScrollView.height) andfeeType:1 andRecordType:1];
    [self.feeRecordV4 setFeeRecordBlock:^(NSString *userId){
        FWStrongify(self)
        [self pushToHomePageVVWithUserId:userId];
    }];
    [self.myScrollView addSubview:self.feeRecordV4];
}

#pragma mark --SegmentView代理方法
- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index
{
    if (segmentView == self.feeSegmentView)
    {
        self.feeIndex = (int)index;
        
    }else
    {
        self.recordIndex =(int)index;
        
    }
    [UIView animateWithDuration:0.2f animations:^{
        self.myScrollView.contentOffset = CGPointMake(self.myScrollView.frame.size.width*(self.feeIndex*2+self.recordIndex), 0);
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
    float tmpPage2 = scrollView.contentOffset.x / pageWidth;
    NSInteger page = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
    
    if (self.startPage != page)
    {
        if (page >1)
        {
            [self.feeSegmentView setSelectIndex:1];
            [self.recordSegmentView setSelectIndex:page-2];
            self.feeIndex = 1;
            self.recordIndex = (int)page-2;
        }else
        {
            [self.feeSegmentView setSelectIndex:0];
            [self.recordSegmentView setSelectIndex:page];
            self.feeIndex = 0;
            self.recordIndex = (int)page;
        }
        self.startPage = page;
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
//{
//    CGPoint offset = self.myScrollView.contentOffset;
//    NSInteger page = (offset.x + self.myScrollView.frame.size.width/2) / self.myScrollView.frame.size.width;
//    if (page >1)
//    {
//        [self.feeSegmentView setSelectIndex:1];
//        [self.recordSegmentView setSelectIndex:page-2];
//        self.feeIndex = 1;
//        self.recordIndex = (int)page-2;
//    }else
//    {
//        [self.feeSegmentView setSelectIndex:0];
//        [self.recordSegmentView setSelectIndex:page];
//        self.feeIndex = 0;
//        self.recordIndex = (int)page;
//    }
//}

- (void)returnCenterVC
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

- (void)pushToHomePageVVWithUserId:(NSString *)userId
{
    SHomePageVC *homeVC = [[SHomePageVC alloc]init];
    homeVC.user_id = userId;
    homeVC.type = 0;
    [[AppDelegate sharedAppDelegate] pushViewController:homeVC];
}



@end
