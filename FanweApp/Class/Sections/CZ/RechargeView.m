//
//  RechargeView.m
//  FanweApp
//
//  Created by 王珂 on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RechargeView.h"
#import "RechargeDesCell.h"
#import "Pay_Model.h"
#import "Mwxpay.h"
#import "FWInterface.h"
#import "JuBaoModel.h"
#import <StoreKit/StoreKit.h>

@interface RechargeView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RechargeWayViewDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,RechargeDesCellDelegate,FWInterfaceDelegate>

@property (nonatomic, strong) UIButton * rechargeBtn; //充值按钮
@property (nonatomic, strong) UIButton * exchangeBtn; //兑换按钮
@property (nonatomic, strong) UIButton * closeBtn;    //关闭按钮
@property (nonatomic, strong) UIView *lineView;       //充值与兑换之间的分割线
@property (nonatomic, strong) RechargeWayView * rechargeWayView;
@property (nonatomic, strong) UIView * separateView;
@property (nonatomic, strong) UICollectionView * listCollectionView;
@property (nonatomic, strong) UIView * balanceView;//余额视图
@property (nonatomic, strong) UILabel * balanceLabel;
@property (nonatomic, strong) UIImageView * diamondsImgView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) NetHttpsManager * httpsManager;
@property (nonatomic, strong) GlobalVariables * fanweApp;
@property (nonatomic, strong) UIButton * oldButton;
@property (nonatomic, strong) NSMutableArray * aliPayArr;//支付宝支付项目
@property (nonatomic, strong) NSMutableArray * wxPayArr;//微信支付项目
@property (nonatomic, assign) BOOL hadClick;//是否已经点击支付，限制频繁点击
@property (nonatomic, strong) NSString *pro_id;
@property (nonatomic, strong) NSMutableArray * otherPayArr;//除苹果支付外的其它第三方支付(此数组用于存有第三方支付，且show_other字段为1但支付列表只有最外面的一个统一支付列表，并没有每个不同支付方式对应不同类别时的情况)
@property (nonatomic, strong) JuBaoModel * juBaoModel;
@property (nonatomic, strong) UIView * selectLineView; //选中的分割线
@end

@implementation RechargeView

- (void)dealloc
{
    NSLog(@"释放充值");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame andUIViewController:(UIViewController *)viewController
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = kAppRechargeSelectColor;
        _fanweApp  = [GlobalVariables sharedInstance];
        CGFloat  bthOrignx = (self.width/2-80)/2;
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeBtn.titleLabel.font = kAppLargeTextFont;
        _rechargeBtn.frame = CGRectMake(bthOrignx, 30, 80, 18);
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rechargeBtn];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-0.25, 30, 0.5, 18)];
        //_lineView.backgroundColor = [FWUtils colorWithHexString:@"4dffffff"];
        _lineView.backgroundColor = kAppSpaceColor;
        [self addSubview:_lineView];
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeBtn.titleLabel.font = kAppLargeTextFont;
        _exchangeBtn.frame = CGRectMake(self.width/2+bthOrignx, 30, 80, 18);
        [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        //[_exchangeBtn setTitleColor:[FWUtils colorWithHexString:@"4dffffff"] forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
        [_exchangeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_exchangeBtn];
        
        _selectLineView= [[UIView alloc] initWithFrame:CGRectMake((self.width/2-50)/2, CGRectGetMaxY(_rechargeBtn.frame)+10, 50, 2)];
        _selectLineView.backgroundColor = kAppGrayColor1;
        [self addSubview:_selectLineView];
        
        if (_fanweApp.appModel.open_game_module == 0 || _fanweApp.appModel.open_diamond_game_module == 1)
        {
            _rechargeBtn.frame = CGRectMake(self.width/2-40, 30, 80, 18);
            _lineView.hidden = YES;
            _exchangeBtn.hidden = YES;
            _selectLineView.hidden = YES;
        }
        _oldButton = _rechargeBtn;
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(self.width-30, 10, 20, 20);
        [_closeBtn setImage:[UIImage imageNamed:@"com_close_2"] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        _rechargeWayView = [[RechargeWayView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_selectLineView.frame), self.width, 75)];
        _rechargeWayView.delegate = self;
        [self addSubview:_rechargeWayView];
        _separateView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_rechargeWayView.frame), self.width-20, 0.5)];
        _separateView.backgroundColor = kAppSpaceColor;
        [self addSubview:_separateView];
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init] ;
        CGFloat itemW = (self.width-20*3)/2 ;
        CGFloat itemH = 60;
        //设置cell的大小
        flow.itemSize = CGSizeMake(itemW, itemH);
        //设置分组距离collectionView四周的边距
        flow.minimumLineSpacing = 20;
        flow.minimumInteritemSpacing = 20;
        flow.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20) ;
        _listCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_separateView.frame), self.width, self.height-CGRectGetMaxY(_separateView.frame)-45) collectionViewLayout:flow];
        _listCollectionView.backgroundColor = kAppRechargeSelectColor;
        _listCollectionView.delegate = self;
        _listCollectionView.dataSource = self;
        [_listCollectionView registerClass:[RechargeDesCell class] forCellWithReuseIdentifier:@"rechargeCell"];
        [self addSubview:_listCollectionView];
        _balanceView = [[UIView alloc] init];
        //_balanceView.frame = CGRectMake(0, self.height-44, 100, 15);
        [self addSubview:_balanceView];
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textColor = kAppGrayColor1;
        _balanceLabel.font = kAppSmallTextFont;
        [_balanceView addSubview:_balanceLabel];
        _diamondsImgView = [[UIImageView alloc] init];
        _diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];
        [_balanceView addSubview:_diamondsImgView];
        _httpsManager = [NetHttpsManager manager];
        _listArray = [NSMutableArray array];
        _aliPayArr = [NSMutableArray array];
        _wxPayArr = [NSMutableArray array];
        _otherPayArr = [NSMutableArray array];
        [self loadRechargeData];
        _indexPayWay = 0;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        _viewController = viewController;
    }
    return self;
}

- (void)loadRechargeData
{
    NSMutableDictionary * parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"pay" forKey:@"ctl"];
    [parmDict setObject:@"recharge" forKey:@"act"];
    FWWeakify(self)
    [_httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        [self.listArray removeAllObjects];
        self.model = [AccountRechargeModel mj_objectWithKeyValues:responseJson];
        //如果有其它金额充值方式,要在除苹果支付外的其它支付方式里面的每个支付方式列表里添加一个对应的model,添加的model用于表示其它金额支付
        if ([self.model.show_other integerValue] == 1)
        {
            for (int i=0; i<self.model.pay_list.count; ++i)
            {
                PayTypeModel * model = self.model.pay_list[i];
                if (![model.class_name isEqual:@"Iappay"])
                {
                    PayMoneyModel * otherModel = [[PayMoneyModel alloc] init];
                    otherModel.hasOtherPay = YES;
                    if (model.rule_list.count>0)
                    {
                        [model.rule_list addObject:otherModel];
                        self.model.pay_list[i] = model;
                    }
                    else
                    {
                        NSMutableArray * otherArray = [NSMutableArray arrayWithArray:self.model.rule_list];
                        [otherArray addObject:otherModel];
                        self.otherPayArr = otherArray;
                        break;
                    }
                }
            }
        }
        PayTypeModel * model = self.model.pay_list.firstObject;
        if ([model.class_name isEqual:@"Iappay"] && self.model.pay_list.count == 1)
        {
            self.rechargeWayView.frame = CGRectMake(0, CGRectGetMaxY(self.rechargeBtn.frame), self.width, 0);
            self.rechargeWayView.hidden = YES;
            self.separateView.frame = CGRectMake(10, CGRectGetMaxY(self.rechargeWayView.frame)+20, self.width-20, 0.5);
        }
        else
        {
            self.rechargeWayView.frame = CGRectMake(0, CGRectGetMaxY(self.selectLineView.frame), self.width, 75);
            self.rechargeWayView.hidden = NO;
            self.separateView.frame = CGRectMake(10, CGRectGetMaxY(self.rechargeWayView.frame), self.width-20, 0.5);
        }
        self.listCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.separateView.frame), self.width, self.height-CGRectGetMaxY(_separateView.frame)-45);
        if (self.model.pay_list.count>0)
        {
            PayTypeModel *model = [self.model.pay_list firstObject];
            if ([self.model.show_other integerValue] == 1)
            {
                if (![model.class_name isEqual:@"Iappay"])
                {
                    if (model.rule_list.count>0)
                    {
                        self.listArray = model.rule_list;
                    }
                    else
                    {
                        self.listArray = self.otherPayArr;
                    }
                }
                else
                {
                    self.listArray = model.rule_list.count>0 ? model.rule_list: self.model.rule_list;
                }
            }
            else
            {
                self.listArray = model.rule_list.count>0 ? model.rule_list: self.model.rule_list;
            }
        }
        self.rechargeWayView.rechargeWayArr =self.model.pay_list;
        [self.listCollectionView reloadData];
        [self reloadView];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)setModel:(AccountRechargeModel *)model
{
    _model = model;
    [self reloadView];
}

- (void)reloadView
{
    NSString * str = [NSString stringWithFormat:@"余额：%zd",self.model.diamonds];
    CGSize priceSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, self.width) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAppSmallTextFont}  context:nil].size;
    CGFloat length = priceSize.width+17;
    //_balanceView.frame = CGRectMake(0, self.height-44, 100, 15);
    _balanceView.frame = CGRectMake((self.width-length)/2, self.height-44, length, 30);
    _balanceLabel.frame = CGRectMake(0, 5, priceSize.width, 15);
    _diamondsImgView.frame = CGRectMake(CGRectGetMaxX(_balanceLabel.frame)+2,5, 15, 15);
    _balanceLabel.text = str;
}

- (void)clickBtn:(UIButton *) button
{
    if (button == _rechargeBtn)
    {
        _oldButton = _rechargeBtn;
    }
    else if (button == _exchangeBtn)
    {
        _oldButton = _exchangeBtn;
        //点击兑换按钮
        self.hidden = YES;
        self.transform = CGAffineTransformIdentity;
        if (_delegate && [_delegate respondsToSelector:@selector(choseRecharge:orExchange:)])
        {
            [_delegate choseRecharge:NO orExchange:YES];
        }
    }
    else if (button == _closeBtn)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeDesCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rechargeCell" forIndexPath:indexPath] ;
    cell.model = self.listArray[indexPath.row];
    cell.delegate = self;
    return cell ;
}

//点击购买
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PayMoneyModel * model = self.listArray[indexPath.row];
    [self goToPayWithPayModel:model];
}

- (void)choseRechargeWayWithIndex:(NSInteger) index
{
    _indexPayWay = index;
    PayTypeModel * model = self.model.pay_list[index];
    if ([self.model.show_other integerValue] == 1)
    {
        if (![model.class_name isEqual:@"Iappay"])
        {
            if (model.rule_list.count>0)
            {
                self.listArray = model.rule_list;
            }
            else
            {
                self.listArray = _otherPayArr;
            }
        }
        else
        {
            self.listArray = model.rule_list.count>0 ? model.rule_list : self.model.rule_list;
        }
    }
    else
    {
        self.listArray = model.rule_list.count>0 ? model.rule_list : self.model.rule_list;
    }
    [self.listCollectionView reloadData];
}

- (void)goToPayWithPayModel:(PayMoneyModel *)model
{
    if (_hadClick)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"正在提交中"];
        return;
    }
    else
    {
        _hadClick = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _hadClick = NO;
        });
        //选择其它支付，弹出其它支付的窗口
        if (model.hasOtherPay)
        {
            self.hidden = YES;
            //self.frame = CGRectMake(10, kScreenH, kScreenW-20, kScreenH-180);
            self.transform = CGAffineTransformIdentity;
            if (_delegate && [_delegate respondsToSelector:@selector(choseOtherRechargeWithRechargeView:)])
            {
                [_delegate choseOtherRechargeWithRechargeView:self];
            }
        }
        else
        {
            [self payRequestWithModel:model];
        }
    }
    
}

- (void)payRequestWithModel:(PayMoneyModel *)payModel withPayWayName:(NSString *)name
{
    for (int i=0; i<self.model.pay_list.count; ++i)
    {
        PayTypeModel * model = self.model.pay_list[i];
        if ([model.class_name isEqual:name])
        {
            _indexPayWay = i;
            [self payRequestWithModel:payModel];
        }
    }
}

- (void)payRequestWithModel:(PayMoneyModel *)payModel withPayWayIndex:(NSInteger )index
{
    _indexPayWay = index;
    self.rechargeWayView.selectIndex = _indexPayWay;
    [self payRequestWithModel:payModel];
}
//支付请求
- (void)payRequestWithModel:(PayMoneyModel *)payModel
{
    PayTypeModel * model = self.model.pay_list[_indexPayWay];
    
    NSString * payID = [NSString stringWithFormat:@"%zd",model.payWayID];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"pay" forKey:@"ctl"];
    [parmDict setObject:@"pay" forKey:@"act"];
    [parmDict setObject:payID forKey:@"pay_id"];
    if (payModel.hasOtherPay == NO)
    {
        [parmDict setObject:[NSString stringWithFormat:@"%zd",payModel.payID] forKey:@"rule_id"];
        [parmDict setObject:[NSString stringWithFormat:@"%@",payModel.money] forKey:@"money"];
    }
    else
    {
        //选择其它支付
        [parmDict setObject:self.money forKey:@"money"];
    }
    [[FWHUDHelper sharedInstance] syncLoading:@"支付请求中,请稍后" inView:self];
    
    [_httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
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
            else if ([sdkType isEqualToString:@"JubaoWxsdk"] || [sdkType isEqualToString:@"JubaoAlisdk"])
            {
                NSDictionary *configDic =[sdkDic objectForKey:@"config"];
                _juBaoModel =[JuBaoModel mj_objectWithKeyValues: configDic];
                FWParam *param = [[FWParam alloc] init];
                // playerid：用户在第三方平台上的用户名
                param.playerid  = _juBaoModel.playerid;
                // goodsname：购买商品名称
                param.goodsname = _juBaoModel.goodsname;
                // amount：购买商品价格，单位是元
                param.amount    = _juBaoModel.amount;
                // payid：第三方平台上的订单号，请传真实订单号，方便后续对账，例子里采用随机数，
                param.payid     = _juBaoModel.payid;
                [FWInterface start:_viewController withParams:param  withDelegate:self];
                //[FWInterface start:_viewController withParams:param withType:model.withType withDelegate:self];
                // 凡伟支付 end
                
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
                    FWMainWebViewController *vc = [FWMainWebViewController webControlerWithUrlStr:[payDic stringForKey:@"url"] isShowIndicator:YES isShowNavBar:YES];
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
        [[FWHUDHelper sharedInstance] syncStopLoading];
        
    }FailureBlock:^(NSError *error)
     {
         [[FWHUDHelper sharedInstance] syncStopLoading];
         [SVProgressHUD dismiss];
     }];
}

#pragma marlk  支付宝支付
- (void)alipay:(NSString*)payinfo block:(void(^)(SResBase* resb))block
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
                [FanweMessage alert:[NSString stringWithFormat:@"%@",retobj.mmsg]];
                
                [self reloadAcount];
                if (_delegate && [_delegate respondsToSelector:@selector(rechargeSuccessWithRechargeView:)])
                {
                    [_delegate rechargeSuccessWithRechargeView:self];
                }
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

#pragma mark -- 苹果内购服务
// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfowithprotectId:(NSString *)proId
{
    //这里填你的产品id，根据创建的名字
    //ProductIdofvip
    //ProductId
    NSMutableArray *proArr = [NSMutableArray new];
    [proArr addObject:proId];
    NSSet * set = [NSSet setWithArray:proArr];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    NSLog(@"%@",set);
    NSLog(@"请求开始请等待...");
}

#pragma mark - 以上查询的回调函数－－－－－－－
// 以上查询的回调函数
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
            case SKPaymentTransactionStateRestored://恢复已购买的商品
                NSLog(@"已经购买过该产品");
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
    [dict setObject:@"pay" forKey:@"ctl"];
    [dict setObject:@"iappay" forKey:@"act"];
    NSString *userid = [IMAPlatform sharedInstance].host.imUserId;
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:base64Str forKey:@"receipt-data"];
    
    [_httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        
        [self reloadAcount];
        if (_delegate && [_delegate respondsToSelector:@selector(rechargeSuccessWithRechargeView:)])
        {
            [_delegate rechargeSuccessWithRechargeView:self];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    [SVProgressHUD dismiss];
    if(transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
        //[FanweMessage alert:@"您已经取消交易"];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma marlk 刷新账户
- (void)reloadAcount
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"pay" forKey:@"ctl"];
    [parmDict setObject:@"recharge" forKey:@"act"];
    __weak typeof(self) ws = self;
    [_httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
        {
            ws.model.diamonds = [[responseJson toString:@"diamonds"] doubleValue];
            [ws reloadView];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)clickWithRechargeDesCell:(RechargeDesCell *)cell
{
    NSIndexPath * indexPath = [_listCollectionView indexPathForCell:cell];
    PayMoneyModel * model = self.listArray[indexPath.row];
    [self goToPayWithPayModel:model];
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

@end
