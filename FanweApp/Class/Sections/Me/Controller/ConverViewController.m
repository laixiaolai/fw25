//
//  ConverViewController.m
//  FanweApp
//
//  Created by yy on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ConverViewController.h"
#import "payWayTableViewCell.h"
#import "myProfitModel.h"
#import "ConverTableViewCell.h"
#import "ConverDiamondsViewController.h"
#import "MBProgressHUD.h"
#import "FreshAcountModel.h"
#import "ExchangeCoinView.h"

@interface ConverViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MBProgressHUDDelegate,ExchangeCoinViewDelegate>
{
    ExchangeCoinView            *_exchangeView;      //兑换
    UILabel                     *numberLable;
    NSMutableArray              *dataArray;
    UIScrollView                *mainScrollView;
    UIView                      *acountView;
    UITableView                 *converTabelView;
    MBProgressHUD               *hud;
    
    UIWindow                    *_bgWindow;
    UIView                      *_exchangeBgView;
}
@end

@implementation ConverViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requetAcountMoney];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title =@"兑换";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAcount) name:@"refreshAcount" object:nil];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    [self creatDisplayView];
    [self requetAcountMoney];
    [self myProfitRequest];
    [self createExchangeCoinView];
    
    [self setupBackBtnWithBlock:nil];
}

- (void)refreshAcount
{
    [self requetAcountMoney];
}

- (void)creatDisplayView
{
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    mainScrollView.backgroundColor = kBackGroundColor;
    mainScrollView.delegate =self;
    mainScrollView.scrollsToTop =YES;
    mainScrollView.scrollEnabled =YES;
    mainScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:mainScrollView];
    
    acountView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH *0.0176, kScreenW,kScreenH *0.088)];
    acountView.backgroundColor =[UIColor whiteColor];
    [mainScrollView addSubview:acountView];
    
    UILabel *acountBalanceLabel =[[UILabel alloc]initWithFrame:CGRectMake(kScreenW *0.031, 0, 80, kScreenH *0.088)];
    acountBalanceLabel.text =@"账户余额：";
    acountBalanceLabel.font =[UIFont systemFontOfSize:14];
    acountBalanceLabel.textColor =kAppGrayColor1;
    [acountView addSubview:acountBalanceLabel];
    numberLable =[[UILabel alloc]initWithFrame:CGRectMake(90, kScreenH *0.008, kScreenW-kScreenW *0.32, kScreenH *0.07)];
    numberLable.textAlignment =NSTextAlignmentLeft;
    numberLable.textColor = kAppGrayColor1;
    [acountView addSubview:numberLable];
}

- (void)creatTabelView
{
    converTabelView =[[UITableView alloc]initWithFrame:CGRectMake(0, acountView.frame.size.height+kScreenH *0.0176, kScreenW, dataArray.count *60 +20)];
    converTabelView.delegate =self;
    converTabelView.dataSource =self;
    [converTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    converTabelView.backgroundColor =[UIColor whiteColor];
    converTabelView.scrollEnabled = NO;
    [mainScrollView addSubview:converTabelView];
    
    [converTabelView registerNib:[UINib nibWithNibName:@"ConverTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    UIButton *writeMoneyButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW *0.093, dataArray.count *60+20+kScreenH *0.0176+acountView.height+30, kScreenW *0.812, 46)];
    [writeMoneyButton setTitle:@"自定义金额" forState:UIControlStateNormal];
    [writeMoneyButton setTitleColor:kAppMainColor forState:UIControlStateNormal];
    writeMoneyButton.layer.borderColor =[kAppMainColor CGColor];
    writeMoneyButton.layer.borderWidth =1;
    writeMoneyButton.layer.masksToBounds =YES;
    writeMoneyButton.layer.cornerRadius = 23;
    [writeMoneyButton addTarget:self action:@selector(writeMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:writeMoneyButton];
    
    mainScrollView.contentSize =CGSizeMake(kScreenW, kScreenH *0.25 + writeMoneyButton.height + writeMoneyButton.frame.origin.y);
}

#pragma mark    创建兑换视图
- (void)createExchangeCoinView
{
    _bgWindow = [[UIApplication sharedApplication].delegate window];
    
    if (!_exchangeView)
    {
        _exchangeBgView                    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _exchangeBgView.backgroundColor    = kGrayTransparentColor4;
        _exchangeBgView.hidden             = YES;
        [_bgWindow addSubview:_exchangeBgView];
        
        UITapGestureRecognizer  *bgViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeBgViewTap)];
        [_exchangeBgView addGestureRecognizer:bgViewTap];
        
        _exchangeView                      = [ExchangeCoinView EditNibFromXib];
        _exchangeView.exchangeType         = 2;
        _exchangeView.delegate             = self;
        _exchangeView.frame                = CGRectMake((kScreenW - 300)/2, kScreenH, 300, 230);
        [_exchangeView createSomething];
        [_bgWindow addSubview:_exchangeView];
    }
}

#pragma mark-----tabelview代理方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerSectionID = @"headerSectionID";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
    UILabel *label;
    
    if (headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        label.text = @"兑换:";
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment =NSTextAlignmentLeft;
        label.textColor =kAppGrayColor3;
        [headerView addSubview:label];
    }
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count>0) {
        return dataArray.count ;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"Cell";
    ConverTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[ConverTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.lineLabel.backgroundColor =kBackGroundColor;
    myProfitModel *proFitModel = [dataArray objectAtIndex:indexPath.row];
    
    cell.label.text = proFitModel.diamonds;
    cell.lettLabel.text = [NSString stringWithFormat:@"%@%@",proFitModel.ticket,self.fanweApp.appModel.ticket_name];
    cell.lettLabel.textColor = kAppMainColor;
    cell.lettLabel.layer.borderWidth =1;
    cell.lettLabel.layer.borderColor =[kAppMainColor CGColor];
    cell.lettLabel.layer.masksToBounds =YES;
    cell.lettLabel.layer.cornerRadius =15;
    return cell;
}

#pragma mark 点击兑换项目
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    myProfitModel *proFitModel = [dataArray objectAtIndex:indexPath.row];
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",proFitModel.ID ]forKey:@"converID"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",proFitModel.ticket ]forKey:@"Ticket"];
    [userDefaults synchronize];
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    [self converDiamondsRequest];
}

#pragma section头部跟着视图一起移动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark 自定义金额
- (void)writeMoneyAction:(UIButton *)sender
{
    [_exchangeView requetRatio];
    [UIView animateWithDuration:0.3 animations:^{
        _exchangeBgView.hidden = NO;
        [_exchangeView.diamondLeftTextfield becomeFirstResponder];
        _exchangeView.ticket = numberLable.text;
        _exchangeView.diamondLabel.text =[NSString stringWithFormat:@"账户余额:%@",_exchangeView.ticket];
        _exchangeView.frame = CGRectMake((kScreenW - 300)/2, (kScreenH - 350)/2, 300, 230);
    }];
}

#pragma marlk 我的收益兑换初始化
- (void)myProfitRequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"exchange" forKey:@"act"];
    
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ((NSNull *)responseJson != [NSNull null])
        {
            if ([responseJson toInt:@"status"] ==1)
            {
                NSMutableArray *exchageArray =[responseJson objectForKey:@"exchange_rules"];
                if (exchageArray !=nil)
                {
                    for (int i =0; i<exchageArray.count; i++)
                    {
                        NSDictionary *ruleDic =[exchageArray objectAtIndex:i];
                        myProfitModel *proFitModel =[myProfitModel mj_objectWithKeyValues:ruleDic];
                        [dataArray addObject:proFitModel];
                        
                    };
                    [self creatTabelView];
                }
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma marlk 请求账户余额
- (void)requetAcountMoney
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"exchange" forKey:@"act"];
    
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ((NSNull *)responseJson != [NSNull null])
        {
            if ([responseJson toInt:@"status"] ==1)
            {
                FreshAcountModel *model =[[FreshAcountModel alloc]init];
                model =[FreshAcountModel mj_objectWithKeyValues:responseJson];
                
                numberLable.text = [NSString stringWithFormat:@"%@%@",model.useable_ticket,self.fanweApp.appModel.ticket_name];
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma marlk 砖石兑换
- (void)converDiamondsRequest
{
    NSString *charge = [[NSUserDefaults standardUserDefaults]objectForKey:@"converID"];
    NSString *Ticket =[[NSUserDefaults standardUserDefaults ]objectForKey:@"Ticket"];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"do_exchange" forKey:@"act"];
    [parmDict setObject:charge forKey:@"rule_id"];
    [parmDict setObject:Ticket forKey:@"ticket"];
    
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if (hud)
        {
            [hud hideAnimated:YES];
        }
        if ([responseJson toInt:@"status"] == 1)
        {
            [self requetAcountMoney];
        }
        
    } FailureBlock:^(NSError *error) {
        
        if (hud)
        {
            [hud hideAnimated:YES];
        }
        
    }];
}

- (void)exchangeViewDownWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView
{
    if (_exchangeView == exchangeCoinView)
    {
        [_exchangeView.diamondLeftTextfield resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            [_exchangeView.diamondLeftTextfield resignFirstResponder];
            _exchangeView.diamondLeftTextfield.text = nil;
            _exchangeView.coinLabel.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
            _exchangeView.frame = CGRectMake((kScreenW - 300)/2, kScreenH, 300, 230);
        } completion:^(BOOL finished) {
            _exchangeBgView.hidden = YES;
            _exchangeView.diamondLeftTextfield.text = nil;
            _exchangeView.coinLabel.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
        }];
    }
}

- (void)exchangeBgViewTap
{
    [self exchangeViewDownWithExchangeCoinView:_exchangeView];
}

@end
