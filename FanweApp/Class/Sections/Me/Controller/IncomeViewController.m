//
//  IncomeViewController.m
//  FanweApp
//
//  Created by 岳克奎 on 16/8/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "IncomeViewController.h"
#import "myProfitModel.h"
#import "ConverViewController.h"
#import "ReceiverRecordViewController.h"
#import "LPhoneLoginVC.h"
#import "WXContextViewController.h"
#import "MyProfitConverModel.h"
#import "BingdingStateModel.h"
#import "SaleCell.h"
#import "AuctionCell.h"
#import "InComeDataCell.h"
#import "YInComeHeaderView.h"
#import "GainsAccountBindVC.h"
#import "AuctionAloneCell.h"
#import "GainsWithdrawVC.h"
#import "ExplainCell.h"
#pragma mark----------------数据宏定义 ---------------
#define viewHeight          120
#define labelHeight         50
//3种行高
#define kRowHightOne        50
#define kRowHightSecond     100
#define kRowHightThird      90
#define kHeaderViewHight    240+1+12

@interface IncomeViewController ()<UITableViewDelegate,UITableViewDataSource,AInComeDataCellDelegate,AuctionAloneCellDelegate>
{
    NSString *binding_wx;//是否绑定微信
    NSString *mobile_exist;//是否绑定手机
    NSString *subscribe; //是否关注微信号
    NSString *subscription; //微信平台名称
    NSString *binding_alipay;
    NSString *refund_exist;
    BOOL __isOpen[10];
    BOOL _isFirstLoad;
}

@property (nonatomic, strong) NSMutableArray        *withdrawdeposiArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) BingdingStateModel * model;

@end


@implementation IncomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_isFirstLoad)
    {
        [self headerReresh];
    }
    _isFirstLoad = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isFirstLoad = YES;
}

#pragma mark 初始化变量
- (void)initFWVariables
{
    [super initFWVariables];
    
    _withdrawdeposiArray = [NSMutableArray array];
}

#pragma mark UI创建
- (void)initFWUI
{
    [super initFWUI];
    self.navigationItem.title = @"收益";
    self.view.backgroundColor = kBackGroundColor;
    
    [self initRefresh];
    
    [self initTableView];
    
    [self setNavItem];
}

#pragma mark 加载数据
- (void)initFWData
{
    [super initFWData];
}

#pragma initRefresh
- (void)initRefresh
{
    [FWMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:nil];
}

#pragma mark - headerReresh
- (void)headerReresh
{
    [self myProfitRequest];
    [self myProfitConverRequest];
}

#pragma mark -Item
- (void)setNavItem
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
    
    if (![VersionNum isEqualToString:self.fanweApp.appModel.ios_check_version] )
    {
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-80, 5, 70, 30)];
        [rightButton setTitle:@"领取记录" forState:0];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightButton setTitleColor:kAppGrayColor1 forState:0];
        [rightButton addTarget:self action:@selector(receiveAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
        [rightButton setTintColor:kAppGrayColor2];
    }
}

#pragma mark -tableView
- (void)initTableView
{
    [self registCell];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self initHeaderViewWithModel:nil];
    _tableView.backgroundColor = kBackGroundColor;
    _tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -HeaderView
#pragma mark -
- (void)setTableViewHeaderView
{
    ReceiverRecordViewController *receiveVC =[[ReceiverRecordViewController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:receiveVC];
}

#pragma mark －表头 自定义
- (void)initHeaderViewWithModel:(BingdingStateModel*)model
{
    //隐藏
    CGRect rect;
    if ([VersionNum isEqualToString:self.fanweApp.appModel.ios_check_version])
    {
        rect = CGRectMake(0, 0, kScreenW, kHeaderViewHight-75-45);
    }
    else
    {
        rect = CGRectMake(0, 0, kScreenW, kHeaderViewHight);
    }
    UIView  *header_F_View =[[UIView alloc]initWithFrame:rect];
    YInComeHeaderView *header_S_View =[YInComeHeaderView createYInComeHeaderViewWithFram:rect];
    header_S_View.model = model;
    [header_F_View addSubview:header_S_View];
    _tableView.tableHeaderView = header_F_View;
    [_tableView reloadData];
}

#pragma mark --------------------- cell部分 -------------------------
#pragma mark -regist -Cell
- (void)registCell
{
    //0 区cell
    [self.tableView registerNib:[UINib nibWithNibName:@"AuctionCell" bundle:nil] forCellReuseIdentifier:@"AuctionCell"];
    // 1 区cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SaleCell" bundle:nil] forCellReuseIdentifier:@"SaleCell"];
    //
    [self.tableView registerNib:[UINib nibWithNibName:@"InComeDataCell" bundle:nil] forCellReuseIdentifier:@"InComeDataCell"];
}

#pragma mark -row  行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.fanweApp.appModel.open_pai_module integerValue] == 1)
    {
        if (section == 0 ||section == 2)
        {
            return 0;
        }
        if (section == 1)
        {
            if (!__isOpen[section])
            {
                return 0;
            }
            else
            {
                return 0;
            }
        }
        if (section == 3)
        {
            if (!__isOpen[section])
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
    }
    if (section ==4)
    {
        return _withdrawdeposiArray.count;
    }
    else if (section == 5)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#pragma mark -rowHight 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2)
    {
        return kRowHightOne;
    }
    else if(indexPath.section == 1 || indexPath.section == 3)
    {
        return kRowHightSecond;
    }
    else if (indexPath.section == 5)
    {
        return self.model.explainCellHeight;
    }
    else
    {
        return kRowHightThird;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return kRowHightOne;
    }else if(indexPath.section == 1 || indexPath.section == 3)
    {
        return kRowHightSecond;
    }else{
        return kRowHightThird;
    }
}
#pragma mark  －cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0|| indexPath.section == 2)
    {
        SaleCell* cell =[tableView dequeueReusableCellWithIdentifier:@"SaleCell" forIndexPath:indexPath];
        if (indexPath.section == 0)
        {
            cell.left_Name_Lab.text = @"我拍卖的商品收入";
        }
        else
        {
            cell.left_Name_Lab.text = @"我销售的商品收入";
        }
        return cell;
    }
    else if(indexPath.section == 1|| indexPath.section == 3)
    {
        InComeDataCell* cell =[tableView dequeueReusableCellWithIdentifier:@"InComeDataCell" forIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.section == 4)
    {
        AuctionAloneCell *cell = [AuctionAloneCell cellWithTbaleview:tableView];
        cell.tile = _withdrawdeposiArray[indexPath.row];
        cell.delegate =self;
        return cell;
    }
    else
    {
        ExplainCell * cell = [ExplainCell cellWithTableView:tableView];
        if (_model) {
            cell.model = self.model;
        }
        return cell;
    }
}

#pragma mark -sectionNum 区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.model.refund_explain && self.model.refund_explain.count>0)
    {
        return 6;
    }
    else
    {
        return 5;
    }
}

#pragma mark - sectionHight 区高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 16.0f;
    }
    else
    {
        return 0.7f;
    }
}

#pragma mark -section_View 区试图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int add_Width =0;
    if (section ==4)
    {
        add_Width =7+8;
    }
    if (section == 0)
    {
        add_Width =10;
    }
    UIView *section_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1+add_Width)];
    section_View.backgroundColor = kBackGroundColor;
    return section_View;
}

#pragma mark  -----------------Method  方法 部分-----------------
#pragma mark -didSelect -选择cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 || indexPath.section == 2)
    {
        __isOpen[indexPath.section+1] = ! __isOpen[indexPath.section+1];
        
        //刷新下个区
        NSIndexSet *indexSet_next=[[NSIndexSet alloc]initWithIndex:indexPath.section+1];
        [self.tableView reloadSections:indexSet_next withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //找到cell
        SaleCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (__isOpen[indexPath.section+1])
        {
            [self rorateAnimation:cell.expand_ImgView];
        }
        else
        {
            [self resumeAnimation:cell.expand_ImgView];
        }
    }
}

#pragma mark - resumeAnimation- 区打开标志 打开
- (void)rorateAnimation:(UIImageView *)sender
{
    sender.transform = CGAffineTransformMakeRotation(M_PI);
}

#pragma mark - resumeAnimation- 区打开标志 闭合
#pragma mark - 恢复
- (void)resumeAnimation:(UIImageView *)sender
{
    sender.transform = CGAffineTransformIdentity;
}

#pragma mark -去兑换／微信提现VC
- (void)goNextVC:(UIButton *)sender
{
    //兑换  1  ／／微信提现 2
    if(sender.tag ==1)
    {
        ConverViewController *converVC =[[ConverViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:converVC];
    }
    else if(sender.tag ==2)
    {
        [self weixinRequest];
    }
    else if (sender.tag == 3)
    {
        GainsAccountBindVC *vc = [[GainsAccountBindVC alloc] initWithNibName:@"GainsAccountBindVC" bundle:nil];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
}

- (void)buttonActionGoNetVC:(NSString *)tile
{
    if ([tile isEqualToString:@"兑换"])
    {
        ConverViewController *converVC =[[ConverViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:converVC];
    }
    else if ([tile isEqualToString:@"微信提现"])
    {
        if ([refund_exist integerValue] == 1)
        {
            [FanweMessage alert:@"您还有未处理的提现"];
            return;
        }
        [self weixinRequest];
    }
    else if ([tile isEqualToString:@"支付宝提现"])
    {
        if ([refund_exist integerValue] == 1)
        {
            [FanweMessage alert:@"您还有未处理的提现"];
            return;
        }
        [self judgereDrawWithAlipay];
    }
}

#pragma mark -roratesign 标签转动(不好封装)
- (void)rorateSign:(UIButton *)sender
{
    //不好封装到对应的cell
}

#pragma mark － 跳转到领取记录
- (void)receiveAction
{
    ReceiverRecordViewController *receiveVC =[[ReceiverRecordViewController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:receiveVC];
}

#pragma mark -竞拍管理(未实现----预留)
- (void)auctionManagementBtnClick:(UIButton *)sender
{
    
}

#pragma mark ------------------------ 数 据 部 分 -------------------
#pragma mark- 我的 收益 初始化
- (void)myProfitRequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"profit" forKey:@"act"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] ==1)
         {
             [self.withdrawdeposiArray removeAllObjects];
             [self.withdrawdeposiArray addObject:@"兑换"];
             
             self.model = [BingdingStateModel mj_objectWithKeyValues:responseJson];
             BingdingStateModel *model =[[BingdingStateModel alloc]init];
             model =[BingdingStateModel mj_objectWithKeyValues: responseJson];
             binding_wx =model.binding_wx;
             mobile_exist =model.mobile_exist;
             subscribe =model.subscribe;
             subscription =model.subscription;
             binding_alipay = model.binding_alipay;
             refund_exist = model.refund_exist;
             [self.tableView reloadData];
             if ([model.withdrawals_wx integerValue] == 1)
             {
                 [self.withdrawdeposiArray addObject:@"微信提现"];
             }
             if ([model.withdrawals_alipay integerValue] == 1 )
             {
                 [self.withdrawdeposiArray addObject:@"支付宝提现"];
             }
             
             //必须重新 调用
             [self initHeaderViewWithModel:model];
             if ([VersionNum isEqualToString:self.fanweApp.appModel.ios_check_version])
             {
                 [self.withdrawdeposiArray removeAllObjects];
             }
             [self.tableView reloadData];
         }
         
         [FWMJRefreshManager endRefresh:self.tableView];
         
     } FailureBlock:^(NSError *error)
     {
         [FWMJRefreshManager endRefresh:self.tableView];
     }];
}

#pragma marlk 我的收益兑换初始化
- (void)myProfitConverRequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"exchange" forKey:@"act"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ((NSNull *)responseJson != [NSNull null])
         {
             if ([responseJson toInt:@"status"] ==1)
             {
                 MyProfitConverModel *model = [[MyProfitConverModel alloc]init];
                 model =[MyProfitConverModel mj_objectWithKeyValues: responseJson];
                 [self.tableView reloadData];
             }
         }
         
         [FWMJRefreshManager endRefresh:self.tableView];
         
     } FailureBlock:^(NSError *error)
     {
         [FWMJRefreshManager endRefresh:self.tableView];
     }];
}

#pragma marlk 微信提现初始化
- (void)weixinRequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"money_carry_wx" forKey:@"act"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ((NSNull *)responseJson != [NSNull null])
         {
             if ([responseJson toInt:@"status"] ==1)
             {
                 [self judgereDraw];
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
     }];
}

#pragma marlk 判断提现条件
- (void)judgereDraw
{
    if ([binding_wx intValue] ==0 )
    {
        [self loginByWechat];
    }
    if ([binding_wx intValue] == 1 && [mobile_exist intValue] == 1)
    {
        if ([subscribe intValue]==0)
        {
            UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
            pasteboard.string = subscription;
            [[FWHUDHelper sharedInstance] tipMessage:@"复制成功"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];
        }
        else
        {
            [FanweMessage alert:[NSString stringWithFormat:@"请前往“%@”公众号进行提现", subscription]];
        }
    }
    if ([binding_wx intValue] ==1 &&[mobile_exist intValue]==0)
    {
        LPhoneLoginVC *phoneVC =[[LPhoneLoginVC alloc]init];
        phoneVC.LSecBPhone = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:phoneVC];
    }
}

- (void)judgereDrawWithAlipay
{
    if ([binding_alipay integerValue] == 0)
    {
        GainsAccountBindVC *vc = [[GainsAccountBindVC alloc] initWithNibName:@"GainsAccountBindVC" bundle:nil];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
    else
    {
        GainsWithdrawVC *vc = [[GainsWithdrawVC alloc] initWithNibName:@"GainsWithdrawVC" bundle:nil];
        
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
}

- (void)delayMethod
{
    [FanweMessage alert:[NSString stringWithFormat:@"微信搜索关注“%@”公众号领取红包", subscription]];
}

#pragma marlk 微信提现
- (void)WXDrawrequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"submitrefundwx" forKey:@"act"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ((NSNull *)responseJson != [NSNull null])
         {
             if ([responseJson toInt:@"status"] ==1)
             {
                 [self judgereDraw];
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
     }];
}

#pragma mark 绑定微信
- (void)loginByWechat
{
    FWWeakify(self)
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        FWStrongify(self)
        
        UMSocialUserInfoResponse *resp = result;
        
        if (resp)
        {
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"user_center" forKey:@"ctl"];
            [parmDict setObject:@"update_wxopenid" forKey:@"act"];
            [parmDict setObject:resp.openid forKey:@"openid"];
            [parmDict setObject:resp.accessToken forKey:@"access_token"];
            
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
             {
                 if ([responseJson toInt:@"status"] == 1)
                 {
                     NSString * binding_wx1 =[responseJson objectForKey:@"binding_wx"];
                     
                     if ([binding_wx1 intValue] ==1)
                     {
                         [FanweMessage alert:@"绑定成功"];
                         [self myProfitRequest];
                     }
                     else
                     {
                         [FanweMessage alert:@"绑定失败"];
                     }
                 }
                 
             }FailureBlock:^(NSError *error){
                 
             }];
        }
    }];
}


@end
