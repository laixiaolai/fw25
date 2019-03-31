//
//  MPersonCenterVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/19.
//  Copyright © 2017年 xfg. All rights reserved.
//


#import "MPersonCenterVC.h"
#import "userPageModel.h"
#import "SSearchVC.h"
#import "PersonCenterModel.h"
#import "MPersonCenterCell.h"
#import "MPCHeadView.h"

@interface MPersonCenterVC ()<UITableViewDataSource,UITableViewDelegate>

@property ( nonatomic,strong) NSMutableArray         *titleArray;              //setion名字
@property ( nonatomic,strong) NSMutableArray         *imageArray;              //setion图片
@property ( nonatomic,strong) NSMutableArray         *detailArray;             //setion详情
@property ( nonatomic,strong) UITableView            *tableView;               //tableView
@property ( nonatomic,strong) userPageModel          *userModel;               //userModel
@property ( nonatomic,assign) BOOL                   isUserNav;                //是否使用导航栏
@property ( nonatomic,strong) UIButton               *topBtn;                  //tableView
@property ( nonatomic,strong) MPCHeadView            *tableHeadView;           //tableHeadView
@property ( nonatomic,strong) UIView                 *myLFFView;               //直播关注粉丝底部的view
@property ( nonatomic,strong) PersonCenterModel      *personCModel;            //处理UI的model
@property ( nonatomic,assign) BOOL                   isFirstLoad;              //是否第一次加载
@property ( nonatomic,assign) float                  scrollH;                  //滚动的高度

@end

@implementation MPersonCenterVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNetData) name:@"updateCoin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(IMChatHaveNewMsgNotification:) name:g_notif_chatmsg object:nil];
}

- (void)initFWUI
{
    [super initFWUI];
    self.view.backgroundColor = kBackGroundColor;
    self.personCModel = [[PersonCenterModel alloc]init];
    self.tableHeadView = [[MPCHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 315) andHeadType:1];
    FWWeakify(self)
    [self.tableHeadView setHeadViewBlock:^(int btnIndex){
        FWStrongify(self)
        int section = btnIndex-100;
        if      (section == 0)  section = 24;   //搜索
        else if (section == 1)  section = 25;   //IM消息
        else if (section == 2)  section = 26;   //头像
        else if (section == 3)  section = 27;   //编辑
        else if (section == 4)  section = 21;   //直播
        else if (section == 5)  section = 28;   //关注
        else if (section == 6)  section = 22;   //粉丝
        else if (section == 7)  section = 23;   //小视频
        [self.personCModel didSelectWithModel:self.userModel andSection:section];
    }];
    [self.view addSubview:self.tableView];
}

- (void)initFWData
{
    [super initFWData];
    [self loadNetData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isFirstLoad)
    {
        [self loadNetData];
    }
    self.isFirstLoad = NO;
    [self userNavigation];
    [self.personCModel loadBadageDataWithView:self.tableHeadView];
    [self.personCModel createExchangeCoinViewWithVC:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isUserNav ==NO)
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



#pragma mark 导航栏相关操作的处理
- (void)userNavigation
{
    if (self.isUserNav ==NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self setStateBackColor];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
}

- (void)clickButtonTag:(UIButton *)button
{
    [self.personCModel didSelectWithModel:_userModel andSection:(int)button.tag+20];
}

- (void)loadNetData
{
    if (![IMAPlatform isAutoLogin])// 如果没有登录，就不需要后续操作
    {
        return;
    }
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"userinfo" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             _userModel = [userPageModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];
             self.fanweApp.appModel.h5_url = [AppUrlModel mj_objectWithKeyValues:[responseJson objectForKey:@"h5_url"]];
             [self sectionTitle];
             [self.tableHeadView setCellWithModel:_userModel];
             self.tableView.tableHeaderView = self.tableHeadView;
             [self.personCModel creatUIWithModel:_userModel andMArr:self.detailArray andMyView:self.myLFFView];
             [self.tableView reloadData];
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         [FWMJRefreshManager endRefresh:self.tableView];
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.tableView];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MPPTableCCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.personCModel getMyHeightWithModel:_userModel andFanweApp:self.fanweApp andSection:(int)section andType:1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*kAppRowHScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.personCModel getMyHeightWithModel:_userModel andFanweApp:self.fanweApp andSection:(int)section andType:2];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == MPCSetSection)
    {
        return 10*kAppRowHScale;
    }else
    {
        return 0.01;
    }
}

#pragma mark HomePageDelegate 0搜索 3IM消息 4更换头像 5编辑
- (void)sentTagCount:(int)tagIndex
{
    if (tagIndex == 0)
    {
        tagIndex = 2;
    }
    [self.personCModel didSelectWithModel:_userModel andSection:22+tagIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int  section = (int)indexPath.section;
    MPersonCenterCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"MPersonCenterCell"];
    cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    [cell creatCellWithImgStr:self.imageArray[section] andLeftStr:self.titleArray[section] andRightStr:self.detailArray[section] andSection:section];
    if (section == MPCRenZhenSection && [_userModel.is_authentication integerValue] == 2)
    {
        cell.rightLabel.textColor = kAppGrayColor1;
    }else
    {
        cell.rightLabel.textColor  = kAppGrayColor3;
    }
    
    if (self.fanweApp.appModel.game_distribution !=1)// 游戏分享收益不存在  分享收益横线处理
    {
        if (self.fanweApp.appModel.distribution==1)
        {
            if (section == MPCShareISection)
            {
                cell.lineView.hidden = YES;
            }
        }
    }
    
    if ([self.fanweApp.appModel.shop_shopping_cart integerValue] != 1)//我的购物车不存在  订单管理 我的订单 商品管理横线处理
    {
        if (![_userModel.show_podcast_order isEqualToString:@""] &&[_userModel.show_podcast_order intValue] !=0)
        {
            if (section == MPCOrderMSection)
            {
                cell.lineView.hidden = YES;
            }
        }else
        {
            if (![_userModel.show_user_order isEqualToString:@""] &&[_userModel.show_user_order intValue] !=0)
            {
                if (section == MPCMyOrderSection)
                {
                    cell.lineView.hidden = YES;
                }
            }else
            {
                if (![_userModel.show_podcast_goods isEqualToString:@""] &&[_userModel.show_podcast_goods intValue] !=0)
                {
                    if (section == MPCGoodsMSection)
                    {
                        cell.lineView.hidden = YES;
                    }
                }
            }
        }
    }
    
    if ([self.fanweApp.appModel.open_society_module integerValue] !=1)//我的公会不存在  我的家族横线处理
    {
        if ([self.fanweApp.appModel.open_family_module integerValue]==1)
        {
            if (section == MPCFamilySection)
            {
                cell.lineView.hidden = YES;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MPCexchangeCoinsSection)//兑换游戏币
    {
        [self.personCModel exchangeGaomeCoinsWithModel:_userModel];
    }else if (indexPath.section == MPCFamilySection)//我的家族
    {
        if ([_userModel.family_id intValue] == 0)
        {
            [self.personCModel createFamilyViewWithVC:self andModel:_userModel];
        }
        else
        {
            [self.personCModel goToFamilyDesVCWithModel:_userModel];
        }
    }else if (indexPath.section == MPCTradeSection)//我的公会
    {
        if ([_userModel.society_id intValue] == 0)
        {
            [self.personCModel createSocietyViewWithVC:self andModel:_userModel];
        }
        else
        {
            [self.personCModel goToSocietyDesVCWithModel:_userModel];
        }
    }else
    {
        [self.personCModel didSelectWithModel:_userModel andSection:(int)indexPath.section];
    }
}

#pragma mark 通知
- (void)IMChatHaveNewMsgNotification:(NSNotification*)notification
{
    [self.personCModel loadBadageDataWithView:self.tableHeadView];
}

#pragma mark 解决Segmented的滑块快速滑动时的延迟，同时把点击滑块的情况排除在外
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isUserNav)
    {
        self.scrollH = scrollView.contentOffset.y;
        [self setStateBackColor];
    }
}
#pragma mark 状态栏颜色的控制
- (void)setStateBackColor
{
    if (self.scrollH > self.tableHeadView.height-60)
    {
        CGRect rect      =  _tableView.frame;
        rect.origin.y    = kStatusBarHeight;
        rect.size.height = kScreenH- kStatusBarHeight-kTabBarHeight;
        _tableView.frame = rect;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else
    {
        CGRect rect      =  _tableView.frame;
        rect.origin.y    = 0;
        rect.size.height = kScreenH-kTabBarHeight;
        _tableView.frame = rect;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

#pragma mark ===============================================get方法==========================================================
- (void)sectionTitle
{
    NSString *societyName = @"";
    societyName = [_userModel.society_id intValue] == 0 ? @"创建公会" : @"我的公会";
    _titleArray = [[NSMutableArray alloc]initWithObjects:
                   @"账户",@"收益",@"VIP会员",@"兑换游戏币",@"直播间收支记录",@"送出",
                   @"等级",@"认证",[NSString stringWithFormat:@"%@贡献榜",self.fanweApp.appModel.ticket_name],
                   @"分享收益",@"游戏分享收益",
                   @"商品管理",@"我的订单",@"订单管理",
                   @"我的购物车",
                   @"我的竞拍",@"竞拍管理",
                   @"我的小店",
                   @"我的家族",societyName,
                   @"设置", nil];
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [[NSMutableArray alloc]initWithObjects:
                       @"fw_me_account",@"fw_me_earnings",@"fw_me_vip",@"fw_me_exchange",@"fw_me_charger",@"fw_me_outPut",
                       @"fw_me_level",@"fw_me_certification",@"fw_me_contribution",
                       @"fw_me_shareIncome",@"fw_me_gameShareIncome",
                       @"fw_me_goodsManagement",@"fw_me_myOrder",@"fw_me_orderManagement",@"fw_me_shoppingCart",
                       @"fw_me_myAuction",@"fw_me_auctionManager",
                       @"fw_me_myStore",
                       @"fw_me_myFamily",@"fw_me_tradeUnion",
                       @"fw_me_set", nil];
    }
    return _imageArray;
}

- (NSMutableArray *)detailArray
{
    if (!_detailArray)
    {
        _detailArray = [[NSMutableArray alloc]initWithObjects:
                        [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name],@"0印票",@"未开通",@"0游戏币",@"",[NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name],
                        @"0级",@"未认证",@"",
                        @"",@"",
                        @"0 个商品",@"0 个订单",@"0 个订单",@"0 个商品",
                        @"0 个竞拍",@"0 个竞拍",
                        @"0 个商品",
                        @"",@"",
                        @"", nil];
    }
    return _detailArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        if (self.isUserNav ==NO)
        {
            _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTabBarHeight) style:UITableViewStyleGrouped];
        }
        else
        {
            _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource =self;
        _tableView.delegate =self;
        _tableView.backgroundColor = kBackGroundColor;
        [_tableView registerNib:[UINib nibWithNibName:@"MPersonCenterCell" bundle:nil] forCellReuseIdentifier:@"MPersonCenterCell"];
        _tableView.tableHeaderView = self.tableHeadView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //        [FWMJRefreshManager refresh:_tableView target:self headerRereshAction:@selector(loadNetData) shouldHeaderBeginRefresh:YES footerRereshAction:nil];
    }
    return _tableView;
}






@end
