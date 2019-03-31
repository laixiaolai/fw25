//
//  FWConversationSegmentController.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWConversationSegmentController.h"
#import "FWChatSegmentScrollController.h"
#import "FWConversationListController.h"
#import "FWConversationStrangerController.h"
#import "FWConversationTradeController.h"
static NSString const *kChatTrade = @"交易";
static NSString const *kChatFriend = @"好友";
static NSString const *kChatStranger = @"未关注";

NSInteger kSelectedSegmentIndex = 1; // segmentedControl默认选中的index

@interface FWConversationSegmentController () <UIScrollViewDelegate, ConversationListViewDelegate, FWConversationStrangerViewDelegate>
{
    int _selectIndex; //1.交易  2.好友  3.未关注
    FWConversationListController *_conversationListVC;
    FWConversationStrangerController *_conversationStrangerVC;
    FWConversationTradeController *_conversationTradeVC;
}
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL isClickedSegmented;// 是否点击了Segmented的滑块
@property (nonatomic, strong) FWChatSegmentScrollController *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) NSMutableArray *itemMutableArray;

@end

@implementation FWConversationSegmentController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_mbhalf)
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMChatMsgNotficationInList:) name:g_notif_chatmsg object:nil];
}

#pragma mrak-- ------------------------消息通知-- ------------------------

- (void)IMChatMsgNotficationInList:(NSNotification *)notfication
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(IMChatMsgNotficationInList:) withObject:notfication waitUntilDone:NO];
        return;
    }

    [self loadBtnBadageData];
}

- (void)initFWUI
{
    [super initFWUI];
    self.fanweApp = [GlobalVariables sharedInstance];
    if ([self.fanweApp.appModel.open_pai_module intValue] == 1 || [self.fanweApp.appModel.shopping_goods integerValue] == 1)
    {
        self.itemMutableArray = [NSMutableArray arrayWithObjects:kChatTrade, kChatFriend, kChatStranger, nil];
        kSelectedSegmentIndex = 1;
    }
    else
    {
        self.itemMutableArray = [NSMutableArray arrayWithObjects:kChatFriend, kChatStranger, nil];
        kSelectedSegmentIndex = 0;
    }

    CGFloat viewWidth = kScreenW;
    CGFloat viewHeight = kScreenH;
    CGFloat navPointY = 0.0f;
    CGFloat scrollViewHeight = viewHeight - 64;
    CGFloat childViewPointY = 0;
    CGFloat navHeight;
    if (_mbhalf == YES)
    {
        navHeight = 44;
        scrollViewHeight = viewHeight / 2 - 44;
    }
    else
    {
        navHeight = kNavigationBarHeight+kStatusBarHeight;
    }
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, navPointY, kScreenW, navHeight)];
    _navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navView];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight - 0.5, kScreenW, 0.5f)];
    lineView.backgroundColor = kAppSpaceColor;
    [_navView addSubview:lineView];

    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, navHeight - 44, 22, 44)];
    [backBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];

    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(kScreenW / 2 - 100, navHeight - 41, 200, 40)];
    self.segmentedControl.sectionTitles = self.itemMutableArray;
    self.segmentedControl.selectedSegmentIndex = kSelectedSegmentIndex;
    self.segmentedControl.backgroundColor = kWhiteColor;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: kAppGrayColor3, NSFontAttributeName: [UIFont systemFontOfSize:15]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: kAppGrayColor1, NSBackgroundColorAttributeName: kClearColor, NSFontAttributeName: [UIFont systemFontOfSize:15]};
    self.segmentedControl.selectionIndicatorColor = kAppGrayColor1;
    self.segmentedControl.selectionIndicatorHeight = 3;
    self.segmentedControl.selectionIndicatorBoxColor = kClearColor;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    FWWeakify(self)
        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {

            FWStrongify(self)
                [self.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, CGRectGetHeight(self.scrollView.frame))
                                            animated:YES];
            self.isClickedSegmented = YES;
        }];
    [_navView addSubview:_segmentedControl];

    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 70, navHeight - 36, 60, 30)];
    [rightBtn setTitle:@"忽略未读" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [rightBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickedunread:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:rightBtn];

    self.scrollView = [[FWChatSegmentScrollController alloc] initWithFrame:CGRectMake(0, lineView.bottom, viewWidth, scrollViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = kClearColor;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.scrollView setDelaysContentTouches:NO];
    [self.scrollView setCanCancelContentTouches:NO];
    self.scrollView.contentSize = CGSizeMake(viewWidth * [self.itemMutableArray count], CGRectGetHeight(self.scrollView.frame));
    [self.scrollView scrollRectToVisible:CGRectMake(kSelectedSegmentIndex * viewWidth, 0, viewWidth, CGRectGetHeight(self.scrollView.frame)) animated:NO];
    [self.view addSubview:self.scrollView];

    // 交易
    if ([self.itemMutableArray containsObject:kChatTrade])
    {
        _conversationTradeVC = [[FWConversationTradeController alloc] init];
        _conversationTradeVC.isHaveLive = _mbhalf;
        _conversationTradeVC.view.frame = CGRectMake(viewWidth * [self.itemMutableArray indexOfObject:kChatTrade], childViewPointY, viewWidth, _scrollView.bounds.size.height);
        [_conversationTradeVC updateTableViewFrame];
        [_scrollView addSubview:_conversationTradeVC.view];
    }
    // 好友
    if ([self.itemMutableArray containsObject:kChatFriend])
    {
        _conversationListVC = [[FWConversationListController alloc] init];
        _conversationListVC.view.frame = CGRectMake(viewWidth * [self.itemMutableArray indexOfObject:kChatFriend], childViewPointY, viewWidth, _scrollView.bounds.size.height);
        _conversationListVC.isHaveLive = _mbhalf;
        _conversationListVC.delegate = self;
        [_conversationListVC updateTableViewFrame];
        [_scrollView addSubview:_conversationListVC.view];
    }
    if ([self.itemMutableArray containsObject:kChatStranger])
    {
        _conversationStrangerVC = [[FWConversationStrangerController alloc] init];
        _conversationStrangerVC.view.frame = CGRectMake(viewWidth * [self.itemMutableArray indexOfObject:kChatStranger], childViewPointY, viewWidth, _scrollView.bounds.size.height);
        _conversationStrangerVC.isHaveLive = _mbhalf;
        _conversationStrangerVC.delegate = self;
        [_conversationStrangerVC updateTableViewFrame];
        [_scrollView addSubview:_conversationStrangerVC.view];
    }
    CGFloat badgeBtnPointX;
    CGFloat badgeBtn2PointX;
    if (_itemMutableArray.count == 2)
    {
        badgeBtnPointX = self.segmentedControl.width / 2 - 35;
        badgeBtn2PointX = badgeBtnPointX +105;
    }
    else
    {
        badgeBtnPointX = self.segmentedControl.width / 3 * 2 - 20;
        badgeBtn2PointX = badgeBtnPointX +75;
    }
    UIButton *friendBtn = [[UIButton alloc] initWithFrame:CGRectMake(badgeBtnPointX, 10, 10, 10)];
    friendBtn.backgroundColor = [UIColor clearColor];
    [_segmentedControl addSubview:friendBtn];
    [self initFriendBadgeBtn:friendBtn];
    
    UIButton *strangerBtn = [[UIButton alloc] initWithFrame:CGRectMake(badgeBtn2PointX, 10, 10, 10)];
    strangerBtn.backgroundColor = [UIColor clearColor];
    [_segmentedControl addSubview:strangerBtn];
    [self initStrangerBadgeBtn:strangerBtn];
    //[self loadBtnBadageData];
}

//忽略未读点击事件
- (void)clickedunread:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"操作中..."];
    NSArray *friendConversationArr = _conversationListVC.conversationArr;
    NSArray *strangerConversationArr = _conversationStrangerVC.conversationArr;
    [SFriendObj ignoreMsg:friendConversationArr
                    block:^(SResBase *resb) {

                        if (resb.msuccess)
                        {
                            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                            kNotifPost(@"clearJsbadge", nil);
                            self.badgeFriend.badgeText = nil;
                            [_conversationListVC.mTableView reloadData];
                        }
                        else
                            [SVProgressHUD showErrorWithStatus:resb.mmsg];
                    }];
    [SFriendObj ignoreMsg:strangerConversationArr
                    block:^(SResBase *resb) {

                        if (resb.msuccess)
                        {
                            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                            self.badgeStranger.badgeText = nil;
                            [_conversationStrangerVC.mTableView reloadData];
                        }
                        else
                            [SVProgressHUD showErrorWithStatus:resb.mmsg];
                    }];
}
#pragma mark - ----------------------- segment代理 -----------------------

#pragma mark 解决Segmented的滑块快速滑动时的延迟，同时把点击滑块的情况排除在外
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isClickedSegmented)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
        float tmpPage2 = scrollView.contentOffset.x / pageWidth;
        NSInteger page = tmpPage2 - tmpPage >= 0.5 ? tmpPage + 1 : tmpPage;
        
        if (kSelectedSegmentIndex != page)
        {
            [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
            kSelectedSegmentIndex = page;
        }
    }
}

#pragma mark 页面滚动，同时调起Segmented的滑块滑动起来等

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    self.isClickedSegmented = NO;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

- (void)backClick
{
    //1
    kNotifPost(@"reloadunread", nil);
    //2
    if (self.mbhalf == YES)
    {
        [self goNextVCBlock:1:nil]; //1 返回
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark-----------------------  半VC 相关部分 ----------------------------
#pragma mark -goNextVC 半VC去下个半界面block
/**
 *    @author Yue
 *
 *    @brief 半VC 去下个界面
 *    @discussion  1.不能push／present，因弹出半Vc，保证直播VC还能点击，addChildVC处理的
 *                 2.vc。view 切动画弹出，达到push效果
 */
- (void)goNextVCBlock:(int)tag:(SFriendObj *)friend_Obj
{
    NSLog(@"%s", __func__);

    if (self.goNextVCBlock)
    {
        self.goNextVCBlock(tag, friend_Obj);
    }
}

#pragma mark - 创建半ChatVC
/**
 *    @author Yue
 *
 *    @brief 创建半VC，成为直播VC的子VC，并把View加到直播view，动画切出来半VC.View
 *   @prama1.0   imChat_VC    nib加载
 *   @prama1.1   mbhalf       最好创建完就设置，如果写在block完成后，会有问题
 *   @prama1.2   frame        先放到屏幕下方
 *   @prama1.3   animate      动画切出。类似模态弹出效果
 *
 *   @prama2.0  live_VC      不直接传，是因为要考虑重播。。这个为啥没区分重播？？？
 *   @prama2.1   child       子VC  子View  并 置前
 */
//ykk  半VC 成为子VC 加载到直播VC
+ (FWConversationSegmentController *)createIMChatVCWithHalf:(UIViewController *)full_VC isRelive:(BOOL)sender
{
    //1.0
    FWConversationSegmentController *conversationListVC = [[FWConversationSegmentController alloc] init];
    //1.2
    conversationListVC.mbhalf = YES;
    //1.1
    conversationListVC.view.frame = CGRectMake(0, kScreenH, kScreenW, kScreenH / 2);
    //1.3
    [UIView animateWithDuration:kHalfVCViewanimation
                     animations:^{
                         //移动到 半下方  不用transform  容易出问题
                         conversationListVC.view.y = kScreenH / 2;
                     }
                     completion:^(BOOL finished){
                     }];
    //2.
    FWLiveServiceController *live_VC = (FWLiveServiceController *) full_VC;
    [live_VC addChildViewController:conversationListVC];
    [live_VC.view addSubview:conversationListVC.view];
    [live_VC.view bringSubviewToFront:conversationListVC.view];
    return conversationListVC;
}

+ (void)showIMChatInVCWithHalf:(UIViewController *)vc inView:(UIView *)inView
{
    FWConversationSegmentController *conListVC = [[FWConversationSegmentController alloc] init];
    conListVC.mbhalf = YES;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:conListVC];
    //[vc addChildViewController:nav];
    nav.navigationBarHidden = YES;
    nav.view.backgroundColor = [UIColor clearColor];
    //[vc.view addSubview:nav.view];
    nav.modalPresentationStyle = UIModalPresentationCustom;

    [vc presentViewController:nav
                     animated:NO
                   completion:^{

                       CGRect fff = nav.view.frame;
                       fff.origin.y = inView.bounds.size.height / 3.0f;
                       fff.size.height = inView.bounds.size.height * (2.0f / 3.0f);
                       nav.view.frame = fff;

                       UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, -fff.origin.y, inView.bounds.size.width, fff.origin.y)];
                       bt.backgroundColor = [UIColor yellowColor];
                       [bt addTarget:conListVC action:@selector(halfbtclicked:) forControlEvents:UIControlEventTouchUpInside];
                       //        [nav.view.window addSubview:bt];
                   }];
}

- (void)loadBtnBadageData
{

        [SFriendObj getMyFocusFriendUnReadMsgNumIsFriend:1
                                                   block:^(int unReadNum) {
                                                       int scount = unReadNum;
                                                       if (scount)
                                                       {
                                                           if (scount > 98)
                                                           {
                                                               self.badgeFriend.badgeText = @"99+";
                                                           }
                                                           else
                                                           {
                                                               self.badgeFriend.badgeText = [NSString stringWithFormat:@"%d", scount];
                                                           }
                                                       }
                                                       else
                                                       {
                                                           self.badgeFriend.badgeText = nil;
                                                       }
                                                   }];
    
        [SFriendObj getMyFocusFriendUnReadMsgNumIsFriend:2
                                                   block:^(int unReadNum) {
                                                       int scount = unReadNum;
                                                       if (scount)
                                                       {
                                                           if (scount > 98)
                                                           {
                                                               self.badgeStranger.badgeText = @"99+";
                                                           }
                                                           else
                                                           {
                                                               self.badgeStranger.badgeText = [NSString stringWithFormat:@"%d", scount];
                                                           }
                                                       }
                                                       else
                                                       {
                                                           self.badgeStranger.badgeText = nil;
                                                       }
                                                   }];
}

/**
 设置 角标
 
 @param sender 对应的控件
 */
- (void)initFriendBadgeBtn:(UIButton *)sender
{
    //-好友
    self.badgeFriend = [[JSBadgeView alloc] initWithParentView:sender alignment:JSBadgeViewAlignmentTopRight];
}
- (void)initStrangerBadgeBtn:(UIButton *)sender
{
    self.badgeStranger = [[JSBadgeView alloc] initWithParentView:sender alignment:JSBadgeViewAlignmentTopRight];
}

- (void)clickFriendItem:(SFriendObj *)obj
{
    [self goNextVCBlock:2:obj];
}

- (void)reloadChatBadge:(int)selectItem
{
    [SFriendObj getMyFocusFriendUnReadMsgNumIsFriend:selectItem-1
                                               block:^(int unReadNum) {
                                                   int scount = unReadNum;
                                                   if (selectItem == 2)
                                                   {
                                                       if (scount)
                                                       {
                                                           if (scount > 98)
                                                           {
                                                               self.badgeFriend.badgeText = @"99+";
                                                           }
                                                           else
                                                           {
                                                               self.badgeFriend.badgeText = [NSString stringWithFormat:@"%d", scount];
                                                           }
                                                       }
                                                       else
                                                       {
                                                           self.badgeFriend.badgeText = nil;
                                                       }
                                                   }
                                                   else if (selectItem == 3)
                                                   {
                                                       if (scount)
                                                       {
                                                           if (scount > 98)
                                                           {
                                                               self.badgeStranger.badgeText = @"99+";
                                                           }
                                                           else
                                                           {
                                                               self.badgeStranger.badgeText = [NSString stringWithFormat:@"%d", scount];
                                                           }
                                                       }
                                                       else
                                                       {
                                                           self.badgeStranger.badgeText = nil;
                                                       }
                                                   }
                                                   
                                               }];
}

- (void)updateChatFriendBadge:(int)unReadNum
{
    if (unReadNum)
    {
        if (unReadNum > 98)
        {
            self.badgeFriend.badgeText = @"99+";
        }
        else
        {
            self.badgeFriend.badgeText = [NSString stringWithFormat:@"%d", unReadNum];
        }
    }
    else
    {
        self.badgeFriend.badgeText = nil;
    }

}

- (void)updateChatStrangerBadge:(int)unReadNum
{
    if (unReadNum)
    {
        if (unReadNum > 98)
        {
            self.badgeStranger.badgeText = @"99+";
        }
        else
        {
            self.badgeStranger.badgeText = [NSString stringWithFormat:@"%d", unReadNum];
        }
    }
    else
    {
        self.badgeStranger.badgeText = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
