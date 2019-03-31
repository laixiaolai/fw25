//
//  AccountRechargeVC.m
//  FanweApp
//  账号充值
//  Created by hym on 2016/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AccountRechargeVC.h"
#import "AccountRechargeModel.h"
#import "AccountRechargeModel.h"
#import "DisplayTableViewCell.h"
#import "AccountRechargeOthermoneyTBCell.h"
#import "Pay_Model.h"
#import "Mwxpay.h"
#import "FWInterface.h"
#import "JuBaoModel.h"
#import <StoreKit/StoreKit.h>

#define Label_Balances_Tag          10000           //余额
#define Label_Titles_Tag            10001
#define Cell_PayType_Default_Tag    20000

@interface AccountRechargeVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate,FWInterfaceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AccountRechargeModel *model;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *pro_id;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) BOOL hsClick;
@property (nonatomic, strong) NSMutableArray * ruleListArr;

@property (nonatomic, strong) SKProductsRequest * request;
@property (nonatomic, strong) JuBaoModel * juBaoModel;

@end

@implementation AccountRechargeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doInit];
    [self dataStructrue];
    [self keyboardConfig];
    _ruleListArr = [NSMutableArray array];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.HUD hideAnimated:YES];
    [SVProgressHUD dismiss];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)doInit
{
    self.view.backgroundColor =kBackGroundColor;
    if (_is_vip)
    {
        self.title = @"VIP充值";
    }
    else
    {
        self.title = @"充值";
    }
    
    self.navigationController.navigationBarHidden =NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.money = @"0";
    [self.tableView registerNib:[UINib nibWithNibName:@"DisplayTableViewCell" bundle:nil] forCellReuseIdentifier:@"payMoneycellIdentifier"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:@"PaySuccess" object:nil];
    
    self.row = 0;
    self.hsClick = YES;
    
    [self setupBackBtnWithBlock:nil];
}

//数据构造
- (void)dataStructrue
{
    self.model = [AccountRechargeModel new];
    [self loadNet];
}

- (void)loadNet
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    if (_is_vip)
    {
        [parmDict setObject:@"vip_pay" forKey:@"ctl"];
        [parmDict setObject:@"purchase" forKey:@"act"];
    }
    else
    {
        [parmDict setObject:@"pay" forKey:@"ctl"];
        [parmDict setObject:@"recharge" forKey:@"act"];
    }
    
    __weak AccountRechargeVC *weakSelf = self;
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
         weakSelf.model = [AccountRechargeModel mj_objectWithKeyValues:responseJson];
         if (weakSelf.model.pay_list.count)
         {
             PayTypeModel *model = [weakSelf.model.pay_list firstObject];
             if (model)
             {
                 model.isSelect = YES;
             }
             weakSelf.row = 1;
             self.ruleListArr = model.rule_list.count>0 ? model.rule_list : weakSelf.model.rule_list;
         }
         [weakSelf.tableView reloadData];
         
     } FailureBlock:^(NSError *error) {
         
     }];
}

//支付成功刷新账户
- (void)paySuccess
{
    [self reloadAcount];
}

#pragma marlk 刷新账户
- (void)reloadAcount
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    if (_is_vip)
    {
        [parmDict setObject:@"vip_pay" forKey:@"ctl"];
        [parmDict setObject:@"purchase" forKey:@"act"];
    }
    else
    {
        [parmDict setObject:@"pay" forKey:@"ctl"];
        [parmDict setObject:@"recharge" forKey:@"act"];
    }
    __weak AccountRechargeVC *weakSelf = self;
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ((NSNull *)responseJson != [NSNull null])
         {
             if (_is_vip)
             {
                 weakSelf.model.vip_expire_time = [responseJson objectForKey:@"vip_expire_time"];
                 weakSelf.model.is_vip = [responseJson integerForKey:@"is_vip"];
             }
             else
             {
                 weakSelf.model.diamonds = [[responseJson objectForKey:@"diamonds"] doubleValue];
             }
             
             [weakSelf.tableView reloadData];
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1)
    {
        return 44.0f;
    }
    else if (indexPath.section == 2)
    {
        
        if ([self hsOnlyIappay])
        {
            return 60.0f;
        }
        else
        {
            return indexPath.row == 0 ? 44.0f : 60.0f;
        }
    }
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return [self hsOnlyIappay] ? 0.001f : 10.0f;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    NSInteger Sections = [self hsOtherPayMoney] ? 3 : 2;
    if (section == Sections) {
        return 30.0f;
    }
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return;
        }
        
        PayTypeModel *model = self.model.pay_list[indexPath.row - 1];
        if (model.isSelect)
        {
            return;
        }
        
        for (PayTypeModel *model in self.model.pay_list)
        {
            model.isSelect = NO;
        }
        model.isSelect = YES;
        self.ruleListArr = model.rule_list.count > 0 ? model.rule_list : self.model.rule_list;
        [self.tableView reloadData];
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0 && ![self hsOnlyIappay])
        {
            return;
        }
        if (self.hsClick)
        {
            self.hsClick = NO;
            [self payRequestNet:(int)indexPath.row - (int)self.row wxPayNet:1];
            __weak AccountRechargeVC *weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.hsClick = YES;
            });
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_is_vip)
    {
        return 3;
    }
    else
    {
        return [self hsOtherPayMoney] ? 4 : 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return [self hsOnlyIappay] ? 0 : self.model.pay_list.count + self.row;
    }
    else if (section == 2)
    {
        return [self hsOnlyIappay] ? self.ruleListArr.count : self.ruleListArr.count + self.row;
    }
    return self.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [self balancesCellWithTbaleview:tableView cellForRowAtIndexPath:indexPath];
        _lbBalance = [cell.contentView viewWithTag:Label_Balances_Tag];
        if (!_is_vip)
        {
            _lbBalance.text = [NSString stringWithFormat:@"%ld",(long)self.model.diamonds];
            
            [_lbBalance mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(_diamImageView.mas_right).with.offset(10);
            }];
        }
        else
        {
            [_lbBalance mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(_diamImageView.mas_right).with.offset(-20);
            }];
            
            if (self.model.is_vip == 0)
            {
                _lbBalance.textColor = kGrayColor;
                _lbBalance.text = self.model.vip_expire_time;
            }
            else if (self.model.is_vip == 1 && self.model.vip_expire_time.length == 0)
            {
                _lbBalance.textColor = kAppGrayColor1;
                _lbBalance.text = @"永久会员";
            }
            else
            {
                _lbBalance.textColor = kAppGrayColor1;
                _lbBalance.text = self.model.vip_expire_time;
            }
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *cell = nil;
        if (indexPath.row == 0)
        {
            cell = [self titlesCellWithTbaleview:tableView cellForRowAtIndexPath:indexPath];
            UILabel *lbTitles = [cell.contentView viewWithTag:Label_Titles_Tag];
            lbTitles.text = @"请选择支付方式";
        }
        else
        {
            cell = [self payTypeCellWithTbaleview:tableView cellForRowAtIndexPath:indexPath];
            
            PayTypeModel *model = self.model.pay_list[indexPath.row - self.row];
            UIImageView *imageIcon = [cell viewWithTag:Cell_PayType_Default_Tag];
            [imageIcon sd_setImageWithURL:[NSURL URLWithString:model.logo]];
            UILabel *lbTitles = [cell.contentView viewWithTag:Cell_PayType_Default_Tag + 1];
            lbTitles.text = model.name;
            UIImageView *imageSelect = [cell.contentView viewWithTag:Cell_PayType_Default_Tag + 2];
            model.isSelect ? [imageSelect setImage:[UIImage imageNamed:@"com_radio_selected_2"]] : [imageSelect setImage:[UIImage imageNamed:@"com_radio_normal_2"]];
            if (indexPath.row == self.model.pay_list.count)
            {
                UIView *line = [cell.contentView viewWithTag:Cell_PayType_Default_Tag + 3];
                line.hidden = YES;
            }
        }
        return cell;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0 && ![self hsOnlyIappay])
        {
            UITableViewCell *cell = [self titlesCellWithTbaleview:tableView cellForRowAtIndexPath:indexPath];
            UILabel *lbTitles = [cell.contentView viewWithTag:Label_Titles_Tag];
            if (_is_vip) {
                lbTitles.text = @"请选择会员套餐";
            }
            else
            {
                lbTitles.text = @"请选择支付金额";
            }
            
            return cell;
            
        }
        else
        {
            static NSString * payMoneycellIdentifier = @"payMoneycellIdentifier";
            DisplayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payMoneycellIdentifier];
            
            if (cell == nil)
            {
                cell = [[DisplayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payMoneycellIdentifier];
                
            }
            PayMoneyModel *model = self.ruleListArr[indexPath.row - self.row];
            if (_is_vip)
            {
                cell.topLabel.text = model.day_num;
                cell.bottomLabel.text = model.name;
                cell.diamondImageView.hidden = YES;
                cell.diamondImgWidth.constant = 0;
                cell.diamondImgRight.constant = 0;
            }
            else
            {
                cell.diamondImageView.hidden = NO;
                cell.topLabel.text = [NSString stringWithFormat:@"%ld",(long)model.diamonds];
                cell.bottomLabel.text = model.name;
            }
            
            cell.rightLabel.text = model.money_name;
            NSInteger row = self.row == 1 ? 0 : 1;
            if (indexPath.row == self.model.rule_list.count - row){
                cell.lineView.hidden = YES;
            }
            return cell;
        }
    }
    
    AccountRechargeOthermoneyTBCell *cell = [AccountRechargeOthermoneyTBCell cellWithTbaleview:tableView];
    cell.rate = self.model.rate;
    __weak AccountRechargeVC *weakSelf = self;
    cell.block = ^(id object) {
        weakSelf.money = object;
        [weakSelf payRequestNet:0 wxPayNet:0];
    };
    
    return cell;
}

#pragma mark UIHelper
- (UITableViewCell *)balancesCellWithTbaleview:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * BalancescellIdentifier = @"BalancescellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BalancescellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BalancescellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _lbTitles =[UILabel new];
        if (_is_vip)
        {
            _lbTitles.text =@"会员到期日期:";
        }
        else
        {
            _lbTitles.text =@"账户余额：";
        }
        
        _lbTitles.font = [UIFont systemFontOfSize:14];
        _lbTitles.textColor = kAppGrayColor1;
        [cell.contentView addSubview:_lbTitles];
        
        [_lbTitles mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView.mas_left).with.offset(14);
        }];
        
        _diamImageView =[UIImageView new];
        if (_is_vip)
        {
            _diamImageView.hidden = YES;
        }
        else
        {
            _diamImageView.hidden = NO;
            _diamImageView.image =[UIImage imageNamed:@"com_diamond_1"];
        }
        [cell.contentView addSubview:_diamImageView];
        [_diamImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(_lbTitles.mas_right).with.offset(10);
            if (_is_vip)
            {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }
            else
            {
                make.size.mas_equalTo(CGSizeMake(18, 14));
            }
            
        }];
        
        _lbBalance = [UILabel new];
        _lbBalance.tag = Label_Balances_Tag;
        _lbBalance.textAlignment =NSTextAlignmentLeft;
        _lbBalance.textColor = kAppGrayColor1;
        _lbBalance.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:_lbBalance];
        
        [_lbBalance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(_diamImageView.mas_right).with.offset(10);
        }];
    }
    return cell;
}

- (UITableViewCell *)titlesCellWithTbaleview:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * titlescellIdentifier = @"titlescellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titlescellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titlescellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbTitles = [UILabel new];
        lbTitles.font = [UIFont systemFontOfSize:14];
        lbTitles.textColor = kAppGrayColor1;
        lbTitles.tag = Label_Titles_Tag;
        
        [cell.contentView addSubview:lbTitles];
        [lbTitles mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView.mas_left).with.offset(14);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = kBackGroundColor;
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(cell.contentView);
             make.right.equalTo(cell.contentView);
             make.bottom.equalTo(cell.contentView);
             make.height.offset(1);
         }];
    }
    
    return cell;
}

- (UITableViewCell *)payTypeCellWithTbaleview:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * payTypecellIdentifier = @"payTypecellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payTypecellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payTypecellIdentifier];
        
        UIImageView *imageView = [UIImageView new];
        imageView.tag = Cell_PayType_Default_Tag;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(cell.contentView.mas_left).with.offset(14);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UILabel *lbTitles =[UILabel new];
        lbTitles.font = [UIFont systemFontOfSize:14];
        lbTitles.textColor = kAppGrayColor1;
        lbTitles.tag = Cell_PayType_Default_Tag + 1;
        [cell.contentView addSubview:lbTitles];
        [lbTitles mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(imageView.mas_right).with.offset(20);
        }];
        
        UIImageView *imageSelect = [UIImageView new];
        imageSelect.tag = Cell_PayType_Default_Tag + 2;
        [cell.contentView addSubview:imageSelect];
        [imageSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.equalTo(cell.contentView.mas_right).with.offset( - 14);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = kBackGroundColor;
        line.tag = Cell_PayType_Default_Tag + 3;
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView);
            make.height.offset(1);
        }];
        
    }
    return cell;
}

#pragma mark 只有苹果支付
- (BOOL)hsOnlyIappay
{
    PayTypeModel *model = [self.model.pay_list firstObject];
    if (self.model.pay_list.count == 1 && [model.class_name  isEqualToString:@"Iappay"])
    {
        self.row = 0;
        return YES;
    }
    return NO;
}

- (BOOL)hsOtherPayMoney
{
    return [self.model.show_other integerValue] == 1 ? YES : NO;
}

- (void)keyboardConfig
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

#pragma mark 支付请求
- (void)payRequestNet:(int)indicate wxPayNet:(int)wxIndicate
{
    NSString *payID = @"";
    for (PayTypeModel *model in self.model.pay_list)
    {
        if (model.isSelect)
        {
            payID = [NSString stringWithFormat:@"%ld",(long)model.payWayID];
        }
    }
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    if (_is_vip)
    {
        [parmDict setObject:@"vip_pay" forKey:@"ctl"];
    }
    else
    {
        [parmDict setObject:@"pay" forKey:@"ctl"];
    }
    
    [parmDict setObject:@"pay" forKey:@"act"];
    [parmDict setObject:payID forKey:@"pay_id"];
    if (wxIndicate == 1)
    {
        PayMoneyModel *model = self.ruleListArr[indicate];
        [parmDict setObject:[NSString stringWithFormat:@"%ld",(long)model.payID] forKey:@"rule_id"];
        
        [parmDict setObject:[NSString stringWithFormat:@"%@",model.money] forKey:@"money"];
    }
    else
    {
        [parmDict setObject:self.money forKey:@"money"];
    }
    
    [SVProgressHUD show];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson){
        
        [SVProgressHUD dismiss];
        
        if ([responseJson toInt:@"status"]==1)
        {
            NSDictionary *payDic =[responseJson objectForKey:@"pay"];
            NSDictionary *sdkDic =[payDic objectForKey:@"sdk_code"];
            NSString *sdkType =[sdkDic objectForKey:@"pay_sdk_type"];
            if ([sdkType isEqualToString:@"alipay"])
            {
                //支付宝支付
                NSDictionary *configDic =[sdkDic objectForKey:@"config"];
                Pay_Model * model2 =[Pay_Model mj_objectWithKeyValues: configDic];
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",model2.order_spec, model2.sign, model2.sign_type];
                [self alipay:orderString block:nil];
            }
            else if ([sdkType isEqualToString:@"wxpay"])
            {
                //微信支付
                NSDictionary *configDic =[payDic objectForKey:@"config"];
                NSDictionary *iosDic =[configDic objectForKey:@"ios"];
                Mwxpay * wxmodel =[Mwxpay mj_objectWithKeyValues: iosDic];
                PayReq* req = [[PayReq alloc] init];
                req.openID = wxmodel.appid;
                req.partnerId = wxmodel.partnerid;
                req.prepayId = wxmodel.prepayid;
                req.nonceStr = wxmodel.noncestr;
                req.timeStamp = [wxmodel.timestamp intValue];
                req.package = wxmodel.package;
                req.sign = wxmodel.sign;
                [WXApi sendReq:req];
            }
            else if ([sdkType isEqualToString:@"JubaoWxsdk"] || [sdkType isEqualToString:@"JubaoAlisdk"])
            {
                NSDictionary *configDic =[sdkDic objectForKey:@"config"];
                _juBaoModel = [JuBaoModel mj_objectWithKeyValues: configDic];
                FWParam *param = [[FWParam alloc] init];
                // playerid：用户在第三方平台上的用户名
                param.playerid  = _juBaoModel.playerid;
                // goodsname：购买商品名称
                param.goodsname = _juBaoModel.goodsname;
                // amount：购买商品价格，单位是元
                param.amount    = _juBaoModel.amount;
                // payid：第三方平台上的订单号，请传真实订单号，方便后续对账，例子里采用随机数，
                param.payid     = _juBaoModel.payid;
                
                [FWInterface start:self withParams:param  withDelegate:self];
                //[FWInterface start:self withParams:param withType:model.withType withDelegate:self];
                // 凡伟支付 end
                
            }
            else if ([sdkType isEqualToString:@"iappay"])
            {
                [SVProgressHUD showWithStatus:@"正在提交iTunes Store,请等待..."];
                // 监听购买结果
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                NSMutableDictionary *configDic = [NSMutableDictionary new];
                configDic = sdkDic[@"config"];
                self.pro_id = configDic[@"product_id"];
                //查询是否允许内付费
                if ([SKPaymentQueue canMakePayments])
                {
                    // 执行下面提到的第5步：
                    [self getProductInfowithprotectId:self.pro_id];
                }
                else
                {
                    [FanweMessage alert:@"您已禁止应用内付费购买商品"];
                }
            }
            else if ([payDic toInt:@"is_wap"] == 1)
            {
                if ([payDic toInt:@"is_without"] == 1) // 跳转外部浏览器
                {
                    NSURL *url=[NSURL URLWithString:[payDic stringForKey:@"url"]];
                    [[UIApplication sharedApplication] openURL:url];
                }
                else
                {
                    FWMainWebViewController *vc = [FWMainWebViewController webControlerWithUrlStr:[payDic stringForKey:@"url"] isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
                    [[AppDelegate sharedAppDelegate] pushViewController:vc];
                }
            }
            else
            {
                NSLog(@"错误");
            }
        }
        else
        {
            NSLog(@"请求失败");
        }
        
    }FailureBlock:^(NSError *error){
        
        [SVProgressHUD dismiss];
        
    }];
}

- (void)returnCenterVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma marlk  支付宝支付
- (void)alipay:(NSString*)payinfo  block:(void(^)(SResBase* resb))block
{
    NSString *appScheme = AlipayScheme;
    
    [[AlipaySDK defaultService] payOrder:payinfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        SResBase* retobj = nil;
        
        if ( resultDic )
        {
            if ( [[resultDic objectForKey:@"resultStatus"] intValue] == 9000 )
            {
                retobj = [[SResBase alloc]init];
                retobj.msuccess = YES;
                retobj.mmsg = @"支付成功";
                retobj.mcode = 1;
                //                block(retobj);
                [FanweMessage alert:[NSString stringWithFormat:@"%@",retobj.mmsg]];
                
                [self reloadAcount];
            }
            else
            {
                retobj = [SResBase infoWithString: [resultDic objectForKey:@"memo" ]];
                [FanweMessage alert:@"支付失败"];
            }
        }
        else
        {
            retobj = [SResBase infoWithString: @"支付出现异常"];
            [FanweMessage alert:@"支付异常"];
        }
        
    }];
}

#pragma mark -- 苹果内购服务，下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfowithprotectId:(NSString *)proId
{
    //这里填你的产品id，根据创建的名字
    //ProductIdofvip
    //ProductId
    NSMutableArray *proArr = [NSMutableArray new];
    [proArr addObject:proId];
    NSSet * set = [NSSet setWithArray:proArr];
    
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    self.request.delegate = self;
    [self.request start];
    
    NSLog(@"%@",set);
    NSLog(@"请求开始请等待...");
}

#pragma mark - 以上查询的回调函数，以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProduct = response.products;
    if (myProduct.count == 0)
    {
        [FanweMessage alert:@"无法获取产品信息，购买失败。"];
        [SVProgressHUD dismiss];
        return;
    }
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[myProduct count]);
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - others SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [SVProgressHUD dismiss];
                [self completeTransaction:transaction];
                //[queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                NSLog(@"交易失败");
                [self failedTransaction:transaction];
                //[queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://恢复已购买商品
                NSLog(@"恢复已购买商品");
                [self restoreTransaction:transaction];
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing://商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    NSLog(@"---------进入了这里");
    //    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSData *data = [productIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        [self shoppingValidation:base64String];
    }
    // Remove the transaction from the payment queue.
    [SVProgressHUD dismiss];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark -- 向自己的服务器验证购买凭证
- (void)shoppingValidation : (NSString *)base64Str
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_is_vip)
    {
        [dict setObject:@"vip_pay" forKey:@"ctl"];
    }
    else
    {
        [dict setObject:@"pay" forKey:@"ctl"];
    }
    [dict setObject:@"iappay" forKey:@"act"];
    NSString *userid = [IMAPlatform sharedInstance].host.imUserId;
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:base64Str forKey:@"receipt-data"];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        [self reloadAcount];
        // [FanweMessage alert:@"充值成功"];
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    [SVProgressHUD dismiss];
    if(transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"购买失败");
    }
    else
    {
        NSLog(@"用户取消交易");
        //[FanweMessage alert:@"您已经取消交易"];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    // 对于已购商品，处理恢复购买的逻辑
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

// 支付结果的通知：
- (void)receiveResult:(NSString*)payid result:(BOOL)success message:(NSString*)message
{
    if ( success == YES )
    {
        [self reloadAcount];
        [FanweMessage alert:@"支付成功"];
    }
    else
    {
        [FanweMessage alert:@"支付失败"];
    }
}

- (void)receiveChannelTypes:(NSArray<NSNumber *>*)types
{
    [FWInterface selectChannel:_juBaoModel.withType];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"释放充值");
    if (self.request)
    {
        [self.request cancel];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
