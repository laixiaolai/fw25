//
//  AuctionTool.m
//  FanweApp
//
//  Created by 王珂 on 16/12/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionTool.h"
#import "AuctionItemdetailsViewController.h"
#import "JSBadgeView.h"
#import "ShopGoodsUIView.h"
#import "ShopGoodsModel.h"
#import "GoodsModel.h"
#import "DepositViewController.h"
#import "AuctionGoodsView.h"
#import "CreateAuctionView.h"
#import "AuctionResultView.h"
#import "AuctionPayView.h"
#import "ShopGoodsView.h"
#import "shareModel.h"
#import "GoodsModel.h"
#import "ReleaseViewController.h"

@interface AuctionTool()<ReleaseViewControllerDelegate,CreateAuctionViewDelegate,AuctionPayViewDelegate,AuctionResultViewDelegate,AuctionGoodsViewDelegate,ShopGoodsViewDelegate,ShopGoodsDelegate>
{
    //    NetHttpsManager *_httpsManager;
    NSInteger  _paiId;//竞拍商品id
    NSInteger _lastPrice;//最新价格
    //    int _paiTime;//竞拍倒计时长
    int _paiHour;//竞拍倒计时小时
    int _paiMinute;//竞拍倒计时分
    int _paiSecond;//竞拍倒计时秒
    NSInteger _addPrice;//加价幅度
    NSTimer * _paiTimer;//竞拍倒计时计时器
    int _payMinute;//付款倒计时的分钟数
    int _paySecond;//付款倒计时的秒数
    //    int _payTime;//付款倒计时时长
    int _missPayCount;//超时未付款的个数
    NSInteger _count; //总数
    NSTimer * _payTimer;//付款倒计时计时器
    JSBadgeView                     *_jsNumber;
    UserModel                       *_payModel;
    GlobalVariables * _fanweApp;
}
@property(nonatomic, strong) NetHttpsManager * httpsManager;
@property (nonatomic, assign) NSInteger currentDiamonds; //当前账户钻石数量
@property (nonatomic, strong) UIButton * hadClick;
@property (nonatomic, strong) NSTimer * clickTimer;
@property (nonatomic, copy) NSString * order_sn;
@property (nonatomic, assign) NSInteger  price; //付款价格
@property (nonatomic, copy) NSString * payUserId;//最终付款人ID
@property (nonatomic, strong) UILabel * leftTimeTitleLabel;
@property (nonatomic, strong) UILabel * leftTimeLabel;
@property (nonatomic, strong) NSTimer * desTimer;
@property (nonatomic, strong) UIButton * addPriceBtn;
@property (nonatomic, strong) AuctionPayView * topayView;
@property (nonatomic, assign) int disBtnTime;//加价按钮不能点击时的时间设置
@property (nonatomic, strong) UILabel * disBtnTimeLabel;//加价按钮点击倒计时的时间提示
@property (nonatomic, strong) ShopGoodsUIView * shopGoodsView;//星店视图
@property (nonatomic, copy) NSString * goodsUrl;//商品链接
@property (nonatomic, copy) NSString * bz_diamonds;//保证金
@property (nonatomic, strong) AuctionGoodsView * auctionGoodsView;//实物竞拍视图
@property (nonatomic, strong) CreateAuctionView * auctionView;//创建竞拍视图弹窗
@property (nonatomic, strong) AuctionResultView * auctionResultView;//竞拍结果图
@property (nonatomic, assign) NSInteger game_log_id; //游戏id(游戏轮数id)
@property (nonatomic, strong) NSMutableArray * stateArray;//中标前三名状态
@property (nonatomic, strong) NSMutableArray * displayArray; //显示具体状态
@property (nonatomic, strong) NSMutableArray * imageArray; //用户头信息
@property (nonatomic, strong) NSMutableArray * priceArray; //用户出价
@property (nonatomic, strong) NSMutableArray * nameArray;  //用户名
@property (nonatomic, strong) NSMutableArray * timeArray; //用户支付剩余时间
@property (nonatomic, strong) NSMutableArray * bigArray; //用户数据相关数组
@property (nonatomic, strong) NSMutableArray * pastArray; //记录中标者之前的状态
@property (nonatomic, copy) NSString * goodsId;//商品ID；
@property (nonatomic, strong) UIButton * clearButton;
@property (nonatomic, strong) ShopGoodsUIView * OTOShopGoodsView;//OTO星店视图
@property (nonatomic, assign) CGFloat  taskViewY;
@end

@implementation AuctionTool

- (id)initWithLiveView:(TCShowLiveView *)liveView andView:(UIView *)view andTCController:(UIViewController *)tcController andLiveItem:(id<FWShowLiveRoomAble>)liveItem
{
    if (self = [super init])
    {
        _liveView = liveView;
        _view = view;
        _httpsManager = [NetHttpsManager manager];
        _hadEnd = NO;
        _liveItem = liveItem;
        _fanweApp = [GlobalVariables sharedInstance];
        if (_liveView.isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            _taskViewY = 90;
        }
        else
        {
            _taskViewY = CGRectGetMaxY(liveView.closeLiveBtn.frame)+10;
        }
    }
    return self;
}

- (NSMutableArray *)stateArray
{
    if (_stateArray == nil)
    {
        _stateArray = [NSMutableArray array];
    }
    return _stateArray;
}

- (NSMutableArray *)displayArray
{
    if (_displayArray == nil) {
        _displayArray = [NSMutableArray array];
    }
    return _displayArray;
}

- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)priceArray
{
    if (_priceArray == nil) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}
- (NSMutableArray *)nameArray
{
    if (_nameArray == nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
- (NSMutableArray *)timeArray
{
    if (_timeArray == nil) {
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}

- (NSMutableArray *)bigArray
{
    if (_bigArray == nil) {
        _bigArray = [NSMutableArray array];
    }
    return _bigArray;
}

- (NSMutableArray *)pastArray
{
    if (_pastArray == nil) {
        _pastArray = [NSMutableArray array];
    }
    return _pastArray;
}

-(NetHttpsManager *)httpsManager
{
    if (_httpsManager == nil) {
        _httpsManager = [NetHttpsManager manager];
    }
    return _httpsManager;
}

-(AuctionGoodsView *)auctionGoodsView
{
    if (_auctionGoodsView==nil) {
        _auctionGoodsView = [[AuctionGoodsView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 300)];
        _auctionGoodsView.backgroundColor = [UIColor whiteColor];
        _auctionGoodsView.hidden = YES;
        _auctionGoodsView.delegate = self;
    }
    return _auctionGoodsView;
}

#pragma mark 竞拍弹窗视图
-(CreateAuctionView *)auctionView
{
    if (_auctionView==nil) {
        _auctionView = [[CreateAuctionView alloc] init];
        _auctionView.backgroundColor = [UIColor whiteColor];
        _auctionView.hidden = YES;
    }
    return _auctionView;
}

-(UIButton *)clearButton
{
    if (_clearButton == nil) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _clearButton;
}

- (void)bringArray:(NSMutableArray *)dataArray
{
    [self.stateArray removeAllObjects];
    [self.imageArray removeAllObjects];
    [self.priceArray removeAllObjects];
    [self.nameArray removeAllObjects];
    [self.bigArray removeAllObjects];
    [self.timeArray removeAllObjects];
    [self.displayArray removeAllObjects];
    _missPayCount = 0;
    for (int i=0; i<dataArray.count; ++i) {
        [_stateArray addObject:[dataArray[i] objectForKey:@"type"]];
        [_nameArray addObject:[dataArray[i] objectForKey:@"nick_name"]];
        [_imageArray addObject:[dataArray[i] objectForKey:@"head_image"]];
        [_priceArray addObject:[dataArray[i] objectForKey:@"pai_diamonds"]];
        [_timeArray addObject:[dataArray[i] objectForKey:@"left_time"]];
        UserModel * userModel = [UserModel mj_objectWithKeyValues:dataArray[i]];
        [_bigArray addObject:userModel];
    }
    for (int i=0; i<_stateArray.count; ++i) {
        if ([_stateArray[i] isEqual:@1]) {
            _payTime =[_timeArray[i] intValue];
            _payMinute = _payTime/60;
            _paySecond = _payTime%60;
            NSString * labelStr = [NSString stringWithFormat:@"%02d分%02d秒前需付款",_payMinute,_paySecond];
            [_displayArray addObject:labelStr];
        }
        else if ([_stateArray[i] isEqual:@2])
        {
            [_displayArray addObject:@"排队中"];
        }
        else if ([_stateArray[i] isEqual:@3])
        {
            [_displayArray addObject:@"超时未付款"];
            _missPayCount++;
        }
        else if ([_stateArray[i] isEqual:@4])
        {
            [_displayArray addObject:@"付款成功"];
        }
        else if ([_stateArray[i] isEqual:@0])
        {
            [_displayArray addObject:@"出局"];
        }
    }
}


- (void)loadTimeData
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"pai_user" forKey:@"ctl"];
    [mDict setObject:@"get_video" forKey:@"act"];
    [mDict setObject:@(_paiId) forKey:@"pai_id"];
    [mDict setObject:@"shop" forKey:@"itype"];
    
    FWWeakify(self)
    [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            NSDictionary * dic = [responseJson objectForKey:@"data"];
            if (dic && [dic isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * dataDic = [dic objectForKey:@"info"];
                if (dataDic && [dataDic isKindOfClass:[NSDictionary class]])
                {
                    _paiTime = [dataDic toInt:@"pai_left_time"];
                    _addPrice = [dataDic toInt:@"jj_diamonds"];
                    _lastPrice = [dataDic toInt:@"last_pai_diamonds"];
                    _bz_diamonds = [dataDic toString:@"bz_diamonds"];
                    _paiHour = _paiTime/3600;
                    _paiMinute = _paiTime%3600/60;
                    _paiSecond = _paiTime%3600%60;
                    if (_paiTime>0) {
                        [self creatAuctionView];
                        _liveView.topView.priceView.userInteractionEnabled = YES;
                        _liveView.topView.titleNameLabel.text = @"最高价";
                        _liveView.topView.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)_lastPrice];
                        [_liveView.topView relayoutOtherContainerViewFrame];                    }
                    else
                    {
                        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"buyer"]];
                        if (dataArray && [dataArray isKindOfClass:[NSArray class]]&& dataArray.count>0) {
                            [self bringArray:dataArray];
                            _pastArray =[NSMutableArray arrayWithArray:_stateArray];
                            [self auctionResultWithDataFromPost:YES];
                            //                            _liveView.topView.priceView.userInteractionEnabled = NO;
                            //                            _liveView.topView.titleNameLabel.text = @"钻石";
                            _liveView.topView.priceView.userInteractionEnabled = YES;
                            _liveView.topView.titleNameLabel.text = @"最高价";
                            //_liveView.topView.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)_lastPrice];
                            _liveView.topView.priceLabel.text = [NSString stringWithFormat:@"%d",[dataDic toInt:@"last_pai_diamonds"]];
                            [_liveView.topView relayoutOtherContainerViewFrame];
                        }
                    }
                    [_liveView bringSubviewToFront:_liveView.topView.priceView];
                }
                
            }
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 重新加载时间数据
- (void)reloadTimeData
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"pai_user" forKey:@"ctl"];
    [mDict setObject:@"get_video" forKey:@"act"];
    [mDict setObject:@(_paiId) forKey:@"pai_id"];
    [mDict setObject:@"shop" forKey:@"itype"];
    
    [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            NSDictionary * dic = [responseJson objectForKey:@"data"];
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dataDic = [dic objectForKey:@"info"];
                if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
                    _paiTime = [dataDic toInt:@"pai_left_time"];
                    _addPrice = [dataDic toInt:@"jj_diamonds"];
                    _lastPrice = [dataDic toInt:@"last_pai_diamonds"];
                    if (_paiTime>0) {
                        _paiHour = _paiTime/3600;
                        _paiMinute = _paiTime%3600/60;
                        _paiSecond = _paiTime%3600%60;
                    }
                    else
                    {
                        NSMutableArray * dataArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"buyer"]];
                        if (dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count>0) {
                            [self bringArray:dataArray];
                            if (![_stateArray isEqualToArray:_pastArray]) {
                                if (_stateArray.count>0) {
                                    [self resultWithDataFromPost:YES];
                                }
                                if (_payTimer == nil) {
                                    for (int i=0; i<_stateArray.count; ++i) {
                                        //UILabel * label = (id)[self.view viewWithTag:800+i];
                                        UILabel * label = _stateLabelArr[i];
                                        label.text = _displayArray[i];
                                        label.textColor = [ _stateArray[i] isEqual:@1]?[UIColor yellowColor]:kAppGrayColor1;
                                    }
                                    _payTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(payTimeView) userInfo:nil repeats:YES];
                                }
                                //记录上一个次的stateArray
                                _pastArray = [NSMutableArray arrayWithArray:_stateArray];
                            }
                            
                        }
                    }
                }
                
            }
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

//竞拍首页
-(UILabel *)leftTimeTitleLabel
{
    if (_leftTimeTitleLabel == nil) {
        _leftTimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-110, _taskViewY, 95, 15)];
        _leftTimeTitleLabel.font = [UIFont systemFontOfSize:15.0];
        _leftTimeTitleLabel.textColor = [UIColor whiteColor];
        _leftTimeTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftTimeTitleLabel;
}

-(UILabel *)leftTimeLabel
{
    if (_leftTimeLabel== nil) {
        _leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-125, _taskViewY+20, 115, 15)];
        _leftTimeLabel.font = [UIFont systemFontOfSize:15.0];
        _leftTimeLabel.textColor = [UIColor whiteColor];
        _leftTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftTimeLabel;
}

-(UILabel *)disBtnTimeLabel
{
    if (_disBtnTimeLabel == nil) {
        _disBtnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-45,kScreenH/2-20, 15, 15)];
        _disBtnTimeLabel.font = [UIFont systemFontOfSize:15.0];
        _disBtnTimeLabel.textColor = kAppGrayColor1;
        _disBtnTimeLabel.textAlignment = NSTextAlignmentCenter;
        _disBtnTimeLabel.backgroundColor = kAppGrayColor3;
        _disBtnTimeLabel.hidden = YES;
        [_liveView addSubview:_disBtnTimeLabel];
    }
    return _disBtnTimeLabel;
}


- (void)creatAuctionView
{
    __weak typeof (self) weakSelf = self;
    weakSelf.leftTimeTitleLabel.text = @"竞拍剩余时间";
    weakSelf.leftTimeLabel.text = [NSString stringWithFormat:@"%02d时%02d分%02d秒",_paiHour,_paiMinute,_paiSecond];
    [_liveView addSubview:_leftTimeTitleLabel];
    [_liveView addSubview:_leftTimeLabel];
    
    if([_liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
    {
        [self addHammerView];
    }
    if (!_paiTimer)
    {
        _paiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    }
}

- (void)addHammerView
{
    if (_addPriceBtn==nil)
    {
        _addPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPriceBtn.frame = CGRectMake(kScreenW-80, kScreenH/2, 50, 55);
        [_addPriceBtn setBackgroundImage:[UIImage imageNamed:@"ac_hammer"] forState:UIControlStateNormal];
        [_addPriceBtn setBackgroundImage:[UIImage imageNamed:@"ac_disable_hammer"] forState:UIControlStateDisabled];
        [_addPriceBtn addTarget:self action:@selector(addPrice:) forControlEvents:UIControlEventTouchUpInside];
        [_liveView addSubview:_addPriceBtn];
        
        _addPriceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ac_add_price"]];
        _addPriceView.frame = CGRectMake(kScreenW-82, CGRectGetMaxY(_addPriceBtn.frame)+5, 62, 19);
        [_liveView addSubview:_addPriceView];
        UILabel * addPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 19)];
        addPriceLabel.text =  [NSString stringWithFormat:@"%ld",(long)_addPrice];
        addPriceLabel.textColor = [UIColor whiteColor];
        addPriceLabel.font = [UIFont systemFontOfSize:13];
        [_addPriceView addSubview:addPriceLabel];
    }
}

//竞拍剩余时间倒计时
- (void)countTime
{
    if (_paiTime == 10) {
        [self reloadTimeData];
    }
    if (_paiTime==0) {
        [_paiTimer invalidate];
        _paiTimer = nil;
        return;
    }
    _paiTime--;
    _paiHour = _paiTime/3600;
    _paiMinute = _paiTime%3600/60;
    _paiSecond = _paiTime%3600%60;
    if (_paiTime==0) {
        [_paiTimer invalidate];
        _paiTimer = nil;
        [_leftTimeLabel removeFromSuperview];
        [_leftTimeTitleLabel removeFromSuperview];
        if (_addPriceBtn) {
            [_addPriceBtn removeFromSuperview];
            _addPriceBtn=nil;
            [_addPriceView removeFromSuperview];
            _addPriceView = nil;
        }
        [_disBtnTimeLabel removeFromSuperview];
        _disBtnTimeLabel = nil;
    }
    else
    {
        self.leftTimeLabel.text = [NSString stringWithFormat:@"%02d时%02d分%02d秒",_paiHour,_paiMinute,_paiSecond];
    }
}

- (void)addPrice:(UIButton *)button
{
    
    _addPriceBtn.userInteractionEnabled = NO;
    if (_hadClick==nil) {
        _hadClick = _addPriceBtn;
        //        _disBtnTime = 5;//设置加价按钮不能点击的时间
        _disBtnTime = 3;
        _clickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendBtnEnble) userInfo:nil repeats:YES];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:@"pai_user" forKey:@"ctl"];
        [dict setObject:@"goods_detail" forKey:@"act"];
        [dict setObject:@(_paiId) forKey:@"id"];
        [dict setObject:@"1" forKey:@"p"];
        [dict setObject:@"1" forKey:@"get_joindata"];
        [dict setObject:@"0" forKey:@"get_pailogs"];
        [dict setObject:@"shop" forKey:@"itype"];
        
        [_httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"] == 1) {
                NSDictionary * data = [responseJson objectForKey:@"data"];
                if (data && [data isKindOfClass:[NSDictionary class]]) {
                    int i = [data toInt:@"has_join"];
                    if (i==1) {
                        _liveView.topView.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)_lastPrice];
                        [_liveView.topView relayoutOtherContainerViewFrame];
                        
                        [_addPriceBtn setBackgroundImage:[UIImage imageNamed:@"ac_disable_hammer"] forState:UIControlStateNormal];
                        _disBtnTime = 3;//设置加价按钮不能点击的时间
                        if(!_clickTimer)
                        {
                            _clickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendBtnEnble) userInfo:nil repeats:YES];
                        }
                        self.disBtnTimeLabel.text = [NSString stringWithFormat:@"%d",_disBtnTime];
                        self.disBtnTimeLabel.hidden = NO;
                        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                        [mDict setObject:@"pai_user" forKey:@"ctl"];
                        [mDict setObject:@"dopai" forKey:@"act"];
                        [mDict setObject:@(_paiId) forKey:@"id"];
                        [mDict setObject:@(_lastPrice) forKey:@"pai_diamonds"];
                        [mDict setObject:@"shop" forKey:@"itype"];
                        
                        [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
                            
                            if ([responseJson toInt:@"status"] == 1) {
                                // [_liveView.topView.collectionView reloadData];
                            }
                            
                        } FailureBlock:^(NSError *error) {
                            
                        }];
                    }
                    else
                    {
                        AuctionItemdetailsViewController *AutionVc = [[AuctionItemdetailsViewController alloc]init];
                        //AutionVc.isPop = NO;
                        AutionVc.productId=[NSString stringWithFormat:@"%ld",(long)_paiId];
                        if ([_liveItem liveType] == FW_LIVE_TYPE_HOST)
                        {
                            AutionVc.type = 1;
                        }
                        else if ([_liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
                        {
                            AutionVc.type = 0;
                        }
                        
                        //                        [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:YES nextViewController:AutionVc delegateWindowRCNameStr:nil complete:^(BOOL finished) {
                        //
                        //                        }];
                        if (_delegate && [_delegate respondsToSelector:@selector(pushAuctionDetailVC:)])
                        {
                            [_delegate pushAuctionDetailVC:AutionVc];
                        }
                        
                        _addPriceBtn.userInteractionEnabled = YES;
                    }
                }
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}

//设置加价按钮5秒可点击一次
- (void)sendBtnEnble
{
    _disBtnTime--;
    self.disBtnTimeLabel.text = [NSString stringWithFormat:@"%d",_disBtnTime];
    if (_disBtnTime==0) {
        _addPriceBtn.userInteractionEnabled = YES;
        [_addPriceBtn setBackgroundImage:[UIImage imageNamed:@"ac_hammer"] forState:UIControlStateNormal];
        _hadClick = nil;
        [_clickTimer invalidate];
        _clickTimer = nil;
        self.disBtnTimeLabel.hidden = YES;
    }
}

- (void)auctionResultWithDataFromPost:(BOOL )dataFromPost
{
    //    //0为排队中 1为付款倒计时  2为超时未付款 3付款成功
    //    //进入付款界面显示的观众个数
    //    //根据后台返回的状态值显示不同的内容
    _count = _stateArray.count;
    NSInteger number;
    //判断参与竞拍的人数，如果大于或等于三个时显示三个，如果小于三个则显示实际个数
    
    number = _stateArray.count>3 ? 3 : _stateArray.count;
    if (self.bigImageArr.count>0) {
        for (UIView * view in self.bigImageArr) {
            [view removeFromSuperview];
        }
    }
    if (self.stateLabelArr.count>0) {
        for (UILabel * label in self.stateLabelArr) {
            [label removeFromSuperview];
        }
    }
    [self.bigImageArr removeAllObjects];
    [self.stateLabelArr removeAllObjects];
    for (int i=0; i<number; ++i) {
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(kScreenW-180,  _taskViewY+45*i, 180, 40)];
        //view1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //view1.backgroundColor = [UIColor  redColor];
        view1.userInteractionEnabled = YES;
        [self.bigImageArr addObject:view1];
        //[self.view addSubview:view1];
        [_liveView addSubview:view1];
        //        [self.view bringSubviewToFront:view1];
        //设置灰色背景
        UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(24.5, 0, 180, 40)];
        view2.backgroundColor = kGrayTransparentColor2;
        [view1 addSubview:view2];
       UIImageView * smallImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 37, 37)];
        //[smallImage sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]]];
        [smallImage sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:kDefaultPreloadHeadImg];
        smallImage.layer.cornerRadius = 18.5;
        smallImage.layer.masksToBounds = YES;
        [view1 addSubview:smallImage];
        UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, 45, 40)];
        //headView.backgroundColor = [UIColor redColor];
        [headView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ac_pai_num%d",i+1]]];
        [view1 addSubview:headView];
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 60, 18)];
        nameLabel.text = _nameArray[i];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        [view1 addSubview:nameLabel];
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_diamond_1"]];
        image.frame = CGRectMake(110, 6, 18, 12);
        [view1 addSubview:image];
        UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 2, 50, 18)];
        if ([_priceArray[i] intValue]>10000) {
            float m = [_priceArray[i] intValue]/10000.0;
            numberLabel.text = [NSString stringWithFormat:@"%.2f万",m];
        }
        else
            numberLabel.text = [NSString stringWithFormat:@"%@",_priceArray[i]];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = [UIFont systemFontOfSize:14.0];
        [view1 addSubview:numberLabel];
        UILabel * stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 130, 18)];
        stateLabel.text = _displayArray[i];
        stateLabel.textColor =[ _stateArray[i] isEqual:@1]?[UIColor yellowColor]:kAppGrayColor1;
        stateLabel.font = [UIFont systemFontOfSize:14.0];
        //stateLabel.tag = 800+i;
        [view1 addSubview:stateLabel];
        [self.stateLabelArr addObject:stateLabel];
        //点击事件
        //        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        //        button.frame = CGRectMake(0, 0, 180, 40);
        //        button.tag = 200+i;
        //        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        //        [view1 addSubview:button];
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBigView:)];
        [view1 addGestureRecognizer:tapGes];
    }
    if(_payTimer == nil)
    {
        _payTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(payTimeView) userInfo:nil repeats:YES];
    }
    [self firstResultWithDataFromPost:dataFromPost];
}

//查看竞拍前三名的观众的相关信息
//- (void)clickButton:(UIButton *)button
//{
//    UserModel * userModel = _bigArray[button.tag-200];
//    if (_delegate && [_delegate respondsToSelector:@selector(getUserInfo:)]) {
//        [_delegate getUserInfo:userModel];
//    }
//}

//查看竞拍前三名的观众的相关信息
- (void)tapBigView:(UIGestureRecognizer *)gesture
{
    for (int i=0; i<_bigImageArr.count; ++i) {
        if ([_bigImageArr[i] isEqual:gesture.view]) {
            UserModel * userModel = _bigArray[i];
            if (_delegate && [_delegate respondsToSelector:@selector(getUserInfo:)]) {
                [_delegate getUserInfo:userModel];
            }
        }
    }
}

-(AuctionResultView *)auctionResultView
{
    if (_auctionResultView==nil) {
        CGFloat scaleW = [[UIScreen mainScreen] bounds].size.width/375.0;
        _auctionResultView = [[AuctionResultView alloc] initWithFrame:CGRectMake((kScreenW-250*scaleW)/2, 230, 250*scaleW, 250*scaleW)];
    }
    return _auctionResultView;
}


- (void)firstResultWithDataFromPost:(BOOL )dataFromPost
{
    [_liveView addSubview:self.auctionResultView];
    [_liveView bringSubviewToFront:self.auctionResultView];
    _auctionResultView.delegate = self;
    if (_stateArray.count>0) {
        
        if ([_stateArray[0] isEqual:@1]) {
            //如果是竞拍人
            if ([self isShouldPayer:[_bigArray[0] user_id]]) {
                if (dataFromPost == NO) {
                    [_auctionResultView createWithType:1 andResult:@"ac_auction_success" andName:nil andPrice:nil];
                }
                [self addPayButton];
                _desTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(desPict) userInfo:nil repeats:YES];
                
            }
            //如果不是竞拍人
            else if(dataFromPost == NO)
            {
                [_auctionResultView createWithType:0 andResult:@"ac_auction_success" andName: _nameArray[0] andPrice:[NSString stringWithFormat:@"%@",_priceArray[0]]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_auctionResultView removeFromSuperview];
                    _auctionResultView = nil;
                });
            }
        }
        else
        {
            //如果第一中拍者不在付款状态
            [self resultWithDataFromPost:dataFromPost];
        }
    }
    else if(dataFromPost == NO)
    {
        //没有观众参与拍卖，流拍
        [_auctionResultView createWithType:0 andResult:@"ac_auction_fail" andName:nil andPrice:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_auctionResultView removeFromSuperview];
            _auctionResultView = nil;
        });
    }
}


//竞拍结束后显示的竞拍成功，失败的画面，这部分要根据数据和对象进行不同的显示
- (void)resultWithDataFromPost:(BOOL )dataFromPost{
    [_liveView addSubview:self.auctionResultView];
    _auctionResultView.delegate = self;
    if ([_stateArray[0] isEqual:@4]) {
        if (dataFromPost) {
            return;
        }
        if ([self isShouldPayer:[_bigArray[0] user_id]]) {
            //中标者一付款成功
            //完成付款
            [_auctionResultView createWithType:1 andResult:@"ac_pay_success" andName:nil andPrice:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_auctionResultView removeFromSuperview];
                _auctionResultView = nil;
            });
        }
        else
        {
            //其余观众显示的内容
            [_auctionResultView createWithType:0 andResult:@"ac_pay_success" andName:_nameArray[0] andPrice:[NSString stringWithFormat:@"%@",_priceArray[0]]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_auctionResultView removeFromSuperview];
                _auctionResultView = nil;
            });
        }
    }
    else
    {
        if (_missPayCount>0) {
            if (_missPayCount==_count) {
                //中标前三者全部超时未付款
                //如果竞拍不成功
                //                UIImageView * failView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250*scaleW, 165*scaleW)];
                //                [failView setImage:[UIImage imageNamed:@"ac_auction_fail"]];
                //                [self.payBackgroudView addSubview:failView];
                //                UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 165*scaleW, 250*scaleW, 40*scaleW)];
                //                backView.backgroundColor = kGrayTransparentColor2;
                //                [self.payBackgroudView addSubview:backView];
                //                UILabel  * failLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250*scaleW, 40*scaleW)];
                //                failLabel.textColor = [UIColor whiteColor];
                //                failLabel.font = [UIFont systemFontOfSize:18.0];
                //                failLabel.textAlignment = NSTextAlignmentCenter;
                //                [backView addSubview:failLabel];
                //                if ([self isShouldPayer:[_bigArray[_missPayCount-1] user_id]]) {
                //                    //超时未付款的人
                //                    failLabel.text = @"您参与的竞拍超时未付款";
                //                }
                //                else
                //                {
                //                    NSArray * array = @[@"一",@"二",@"三"];
                //                    failLabel.text = [NSString stringWithFormat:@"前%@名领先者超时未付款", array[_missPayCount-1]];
                //                }
                //
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                    [failLabel removeFromSuperview];
                //                    [failView removeFromSuperview];
                //                    [self.payBackgroudView removeFromSuperview];
                //                });
            }
            else
            {
                //超时未支付者后有顺位中标者
                
                _payModel = _bigArray[_missPayCount];
                UserModel * missModel = _bigArray[_missPayCount-1];
                //顺位中标者在付款中
                if ([_stateArray[_missPayCount] isEqual:@1]) {
                    
                    if ([self isShouldPayer:_payModel.user_id]) {
                        //顺位中标者显示
                        if (dataFromPost == NO) {
                            [_auctionResultView createWithType:1 andResult:@"ac_auction_success" andName:nil andPrice:nil];
                        }
                        [self addPayButton];
                        _desTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(desPict) userInfo:nil repeats:YES];
                    }
                    else if([self isShouldPayer:missModel.user_id])
                    {
                        //超时未支付者显示
                        if (dataFromPost) {
                            return;
                        }
                        [_auctionResultView createWithType:2 andResult:@"ac_auction_fail" andName:nil andPrice:nil];
                        _payView.hidden = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [_auctionResultView removeFromSuperview];
                            _auctionResultView = nil;
                        });
                    }
                }
                else if([_stateArray[_missPayCount] isEqual:@4] && dataFromPost == NO)
                {
                    if ([self isShouldPayer:_payModel.user_id]) {
                        [_auctionResultView createWithType:1 andResult:@"ac_pay_success" andName:nil andPrice:nil];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [_auctionResultView removeFromSuperview];
                            _auctionResultView = nil;
                        });
                    }
                    else
                    {
                        [_auctionResultView createWithType:0 andResult:@"ac_pay_success" andName:_nameArray[_missPayCount] andPrice:[NSString stringWithFormat:@"%@",_priceArray[_missPayCount]]];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [_auctionResultView removeFromSuperview];
                            _auctionResultView = nil;
                        });
                    }
                }
            }
        }
    }
}


- (void)desPict
{
    if (_payTime==0) {
        [_desTimer invalidate];
        _desTimer = nil;
        _payView.hidden = YES;
        [_auctionResultView removeFromSuperview];
        _auctionResultView = nil;
    }
}

- (void)payTimeView
{
    if (_payTime==10) {
        [self reloadTimeData];
    }
    if (_payTime==0) {
        [_payTimer invalidate];
        _payTimer = nil;
        [_topayView removeFromSuperview];
        _topayView = nil;
        return;
    }
    _payTime--;
    _payMinute=_payTime/60;
    _paySecond = _payTime%60;
    if (_stateLabelArr.count == _stateArray.count) {
        for (int i=0; i<_stateArray.count; ++i) {
            if ([_stateArray[i] isEqual:@1]) {
                UILabel * label = _stateLabelArr[i];
                label.text = [NSString stringWithFormat:@"%02d分%02d秒 内需付款",_payMinute,_paySecond];
            }
        }
    }
    _topayView.timeLabel.text = [NSString stringWithFormat:@"剩%02d分%02d秒  自动关闭",_payMinute,_paySecond];
    if (_payTime==0) {//每次倒计时结束就会进入此函数
        [_topayView removeFromSuperview];
        _topayView = nil;
        [_payTimer invalidate];
        _payTimer = nil;
        
        if (_missPayCount==_count) {
            [_payTimer invalidate];
            _payTimer = nil;
        }
    }
}


-(AuctionPayView *)topayView
{
    if (_topayView==nil) {
        _topayView = [[AuctionPayView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 140)];
        _topayView.backgroundColor = [UIColor whiteColor];
    }
    return _topayView;
}


- (void)toPay
{
    if (_topayView == nil) {
        [self.view addSubview:self.topayView];
        _topayView.delegate = self;
        _topayView.timeLabel.text = [NSString stringWithFormat:@"剩%02d分%02d秒  自动关闭",_payMinute,_paySecond];
        _currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        for (int i=0; i<_stateArray.count; ++i) {
            if ([_stateArray[i] isEqual:@1]) {
                UserModel  * model = _bigArray[i];
                [_topayView creatWith:model withCurrentDiamonds:_currentDiamonds withPrice:[NSString stringWithFormat:@"%@",_priceArray[i]]];
                _price = [_priceArray[i] integerValue];
                _order_sn = model.order_sn;
            }
        }
        [UIView animateWithDuration:0.2 animations:^{
            _topayView.frame = CGRectMake(0, kScreenH-140, kScreenW, 140);
        }];
    }
}

#pragma mark -去充值
- (void)clickRechargeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(rechargeView:)])
    {
        [_delegate rechargeView:self.liveView];
    }
}

#pragma mark -去付款
- (void)clickToPay
{
    if (_currentDiamonds < _price)
    {
        FWWeakify(self)
        [FanweMessage alert:@"余额不足" message:@"当前余额不足，充值才能完成付款，是否去充值？" destructiveAction:^{
            
            FWStrongify(self)
            [self clickRechargeAction];
            
        } cancelAction:^{
            
        }];
        
        return;
    }
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"pai_user" forKey:@"ctl"];
    [mDict setObject:@"pay_diamonds" forKey:@"act"];
    [mDict setObject:_order_sn forKey:@"order_sn"];
    [mDict setObject:@"shop" forKey:@"itype"];
    
    [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
        {
            _currentDiamonds -= _price;
            if (_currentDiamonds>0)
            {
                [_liveView.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)_currentDiamonds]];
                [_topayView setDiamondsText:[NSString stringWithFormat:@"%ld",(long)_currentDiamonds]];
                [[IMAPlatform sharedInstance].host setDiamonds:[NSString stringWithFormat:@"%ld",(long)_currentDiamonds]];
                [_topayView removeFromSuperview];
                _topayView = nil;
                [_desTimer invalidate];
                _desTimer = nil;
                _payView.hidden = YES;
                if (_auctionResultView)
                {
                    [_auctionResultView removeFromSuperview];
                    _auctionResultView = nil;
                }
            }
        }
        else
        {
            [_topayView removeFromSuperview];
            _topayView = nil;
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)cancelPay
{
    [UIView animateWithDuration:0.2 animations:^{
        _topayView.frame = CGRectMake(0, kScreenH, kScreenW, 140);
    } completion:^(BOOL finished) {
        [_topayView removeFromSuperview];
        _topayView = nil;
    }];
}

#pragma mark -创建竞拍成功后的支付按钮
- (void)addPayButton
{
    if (_payView == nil) {
        _payView = [[UIView alloc] init];
        _payView.frame = CGRectMake(_liveView.bottomView.menusBottomView.frame.origin.x-kDefaultMargin-kMyBtnWidth1, 0, kMyBtnWidth1, kMyBtnWidth1);
        [_liveView.bottomView addSubview:_payView];
        //        [_liveView bringSubviewToFront:_payView];
        UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(0, 0, kMyBtnWidth1, kMyBtnWidth1);
        payButton.backgroundColor = [UIColor clearColor];
        [payButton setBackgroundImage:[UIImage imageNamed:@"ac_create_auction"] forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
        [_payView addSubview:payButton];
        _jsNumber = [[JSBadgeView alloc]initWithParentView:payButton alignment:JSBadgeViewAlignmentTopRight];
        _jsNumber.badgeText = [NSString stringWithFormat:@"1"];
        [_payView addSubview:_jsNumber];
    }
    else
    {
        _payView.hidden = NO;
    }
}

#pragma mark 判断当前用户是否是当前中拍者付款者
- (BOOL) isShouldPayer:(id) user
{
    return [[IMAPlatform sharedInstance].host isCurrentHost:user];
}

//#pragma mark 判断当前用户是否主播
//- (BOOL)isHost
//{
//    id<AVRoomAble> room = [_liveController roomInfo];
//    return [[IMAPlatform sharedInstance].host isCurrentLiveHost:room];
//}

- (void)closeTimer
{
    if (_paiTimer)
    {
        [_paiTimer invalidate];
        _paiTimer = nil;
    }
    if(_payTimer)
    {
        [_payTimer invalidate];
        _payTimer = nil;
    }
    if (_desTimer)
    {
        [_desTimer invalidate];
        _desTimer = nil;
    }
    if (_clickTimer)
    {
        [_clickTimer invalidate];
        _clickTimer = nil;
        
    }
    if (_goodsTimer)
    {
        [_goodsTimer invalidate];
        _goodsTimer = nil;
    }
    
    _view = nil;
}

- (void)paiSuccessWithCustomModel:(CustomMessageModel *)customMessageModel
{
    NSMutableArray * dataArray = [NSMutableArray arrayWithArray:customMessageModel.buyer];
    [self bringArray:dataArray];
    _pastArray =[NSMutableArray arrayWithArray:_stateArray];
    [self auctionResultWithDataFromPost:NO];
    _paiTime = 0;
    if (_paiTimer)
    {
        [_paiTimer invalidate];
        _paiTimer = nil;
    }
    if (_leftTimeTitleLabel)
    {
        [_leftTimeTitleLabel removeFromSuperview];
        _leftTimeTitleLabel = nil;
    }
    if (_leftTimeLabel)
    {
        [_leftTimeLabel removeFromSuperview];
        _leftTimeLabel = nil;
    }
    if (_addPriceBtn)
    {
        [_addPriceBtn removeFromSuperview];
        _addPriceBtn = nil;
        [_addPriceView removeFromSuperview];
        _addPriceView = nil;
    }
    if (_clickTimer) {
        [_clickTimer invalidate];
        _clickTimer = nil;
        [_disBtnTimeLabel removeFromSuperview];
        _disBtnTimeLabel = nil;
        _hadClick = nil;
    }
    _liveView.topView.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)_lastPrice];
}

- (void)paiTipWithCustomModel:(CustomMessageModel *)customMessageModel
{
    NSMutableArray * dataArray = [NSMutableArray arrayWithArray:customMessageModel.buyer];
    [self bringArray:dataArray];
    if (![_stateArray isEqualToArray:_pastArray]) {
        if (_stateArray.count>0) {
            [self resultWithDataFromPost:NO];
        }
        if (_payTimer) {
            [_payTimer invalidate];
            _payTimer = nil;
        }
        for (int i=0; i<_stateLabelArr.count; ++i) {
            //UILabel * label = (id)[self.view viewWithTag:800+i];
            UILabel * label = _stateLabelArr[i];
            label.text = _displayArray[i];
            label.textColor = [ _stateArray[i] isEqual:@1]?[UIColor yellowColor]:kAppGrayColor1;
        }
        _payTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(payTimeView) userInfo:nil repeats:YES];
        //记录上一个次的stateArray
        _pastArray = [NSMutableArray arrayWithArray:_stateArray];
    }
}

- (void)paiFaultWithCustomModel:(CustomMessageModel *)customMessageModel
{
    _paiTime = 0;
    if (_paiTimer)
    {
        [_paiTimer invalidate];
        _paiTimer = nil;
    }
    
    if (_leftTimeTitleLabel )
    {
        [_leftTimeTitleLabel removeFromSuperview];
        _leftTimeTitleLabel = nil;
    }
    if (_leftTimeLabel)
    {
        [_leftTimeLabel removeFromSuperview];
        _leftTimeLabel = nil;
    }
    if (_addPriceBtn)
    {
        [_addPriceBtn removeFromSuperview];
        _addPriceBtn = nil;
        [_addPriceView removeFromSuperview];
        _addPriceView = nil;
    }
    if (_payTime) {
        [_payTimer invalidate];
        _payTimer = nil;
    }
    if (_clickTimer) {
        [_clickTimer invalidate];
        _clickTimer = nil;
        [_disBtnTimeLabel removeFromSuperview];
        _disBtnTimeLabel = nil;
        _hadClick = nil;
    }
    if (_desTimer) {
        [_desTimer invalidate];
        _desTimer = nil;
    }
    for (int i=0; i<_stateLabelArr.count; ++i) {
        //UILabel * label = (id)[self.view viewWithTag:800+i];
        UILabel * label = _stateLabelArr[i];
        label.text = @"超时未付款";
        label.textColor = kAppGrayColor1;
    }
    [_liveView addSubview:self.auctionResultView];
    [_auctionResultView createWithType:[customMessageModel.out_type integerValue] andResult:@"ac_auction_fail" andName:nil andPrice:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_auctionResultView removeFromSuperview];
        _auctionResultView = nil;
        for (int i=0; i<_bigImageArr.count; ++i) {
            UIView * bigView = self.bigImageArr[i];
            [bigView removeFromSuperview];
        }
        [self.bigImageArr removeAllObjects];
        [self.stateLabelArr removeAllObjects];
        _liveView.topView.priceView.hidden = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(changePayView:)]) {
            [_delegate changePayView:_liveView];
        }
        //如果是主播
        if (_liveView.isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST) {
            UIView * auctionBtn = [self.view viewWithTag:EFunc_AUCTION ];
            auctionBtn.hidden = NO;
            //            _liveView.bottomView.auctionBtn.hidden = NO;
        }
    });
    
}

- (void)paiAddPriceWithCustomModel:(CustomMessageModel *)customMessageModel
{
    
    NSString * pai_diamonds = customMessageModel.pai_diamonds; //出价金额
    _lastPrice = [pai_diamonds integerValue];
    
    if ([customMessageModel.yanshi isEqualToString:@"1"]) {
        NSString * pai_leftTime = customMessageModel.pai_left_time; //竞拍剩余时间
        _paiTime = [pai_leftTime intValue];
    }
    _liveView.topView.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)_lastPrice];
    
    [_liveView.topView relayoutOtherContainerViewFrame];
    //接收到加价消息后，刷新竞拍观众列表
    [_liveView.topView.collectionView reloadData];
}

- (void)paySuccessWithCustomModel:(CustomMessageModel *)customMessageModel
{
    NSMutableArray * dataArray = [NSMutableArray arrayWithArray:customMessageModel.buyer];
    [self bringArray:dataArray];
    if (![_stateArray isEqualToArray:_pastArray]) {
        if (_stateArray.count>0) {
            [self resultWithDataFromPost:NO];
        }
        //记录上一个次的stateArray
        _pastArray = [NSMutableArray arrayWithArray:_stateArray];
    }
    for (int i=0; i<_stateLabelArr.count; ++i) {
        //UILabel * label = (id)[self.view viewWithTag:800+i];
        UILabel * label = _stateLabelArr[i];
        label.text = _displayArray[i];
        label.textColor = [ _stateArray[i] isEqual:@1]?[UIColor yellowColor]:kAppGrayColor1;
    }
    if (_payTimer) {
        [_payTimer invalidate];
        _payTimer = nil;
    }
    if (_desTimer) {
        [_desTimer invalidate];
        _desTimer = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<_bigImageArr.count; ++i) {
            UIView * bigView = self.bigImageArr[i];
            [bigView removeFromSuperview];
        }
        [self.bigImageArr removeAllObjects];
        [self.stateLabelArr removeAllObjects];
        _liveView.topView.priceView.hidden = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(changePayView:)]) {
            [_delegate changePayView:_liveView];
        }
        //如果是主播
        if (_liveView.isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST) {
            UIView * auctionBtn = [self.view viewWithTag:EFunc_AUCTION ];
            auctionBtn.hidden = NO;
            //             _liveView.bottomView.auctionBtn.hidden = NO;
            //             NSLog(@"竞拍按钮*********%@", _liveView.bottomView.auctionBtn);
        }
        
    });
}

- (void)paiReleaseSuccessWithCustomModel:(CustomMessageModel *)customMessageModel
{
    _paiId = [customMessageModel.pai_id integerValue];
    //如果是主播
    if (_liveView.isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST) {
        UIView * auctionBtn = [self.view viewWithTag:EFunc_AUCTION ];
        auctionBtn.hidden = YES;
        //_liveView.bottomView.auctionBtn.hidden = YES;
    }
    else if([_liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)//如果是观众
    {
        [self loadTimeData];
        _liveView.topView.priceView.hidden = NO;
        _liveView.topView.priceView.userInteractionEnabled = YES;
        _liveView.topView.titleNameLabel.text = @"最高价";
        _liveView.topView.priceLabel.text = customMessageModel.qp_diamonds;
        [_liveView bringSubviewToFront:_liveView.topView];
        [_liveView.topView relayoutOtherContainerViewFrame];
        _lastPrice = [customMessageModel.pai_id integerValue];
        if (_delegate && [_delegate respondsToSelector:@selector(changePayView:)]) {
            [_delegate changePayView:_liveView];
        }
    }
}

- (void)closeView
{
    if (_auctionGoodsView.hidden== NO) {
        [UIView animateWithDuration:kGoodsViewDescTime  animations:^{
            _auctionGoodsView.frame = CGRectMake(0, kScreenH, kScreenW, 300);
        } completion:^(BOOL finished) {
            _auctionGoodsView.hidden = YES;
        }];
    }
    if (_auctionView.hidden== NO) {
        CGRect frame = _auctionView.frame;
        frame.origin.y = kScreenH;
        [UIView animateWithDuration:kGoodsViewDescTime  animations:^{
            _auctionView.frame = frame;
        } completion:^(BOOL finished) {
            _auctionView.hidden = YES;
        }];
    }
    
    if (_bigArray && [_bigArray isKindOfClass:[NSArray class]])//中拍着竞拍成功到付款时候点击界面可以去掉竞拍付款的动画的页面
    {
        if (_bigArray.count)
        {
            if ([self isShouldPayer:[_bigArray[0] user_id]])
            {
                if (self.auctionResultView) {
                    [self.auctionResultView removeFromSuperview];
                    _auctionResultView = nil;
                }
            }else if (_payModel)
            {
                if ([self isShouldPayer:_payModel.user_id])
                {
                    if (self.auctionResultView) {
                        [self.auctionResultView removeFromSuperview];
                        _auctionResultView = nil;
                    }
                }
            }
        }
    }
    
    if (_topayView) {
        [UIView animateWithDuration:0.2 animations:^{
            _topayView.frame = CGRectMake(0, kScreenH, kScreenW, 140);
        } completion:^(BOOL finished) {
            [_topayView removeFromSuperview];
            _topayView = nil;
        }];
    }
}

- (void)addView
{
    NSInteger i= [_fanweApp.appModel.pai_virtual_btn integerValue];
    NSInteger j = [_fanweApp.appModel.pai_real_btn integerValue];
    
    //    NSInteger i = 1;//虚拟
    //    NSInteger j = 1;//实物
    
    if (i==1 && j==1) {
        self.auctionView.frame = CGRectMake(0, kScreenH, kScreenW, 200);
    }
    else if (i==1 && j==0 )
    {
        self.auctionView.frame = CGRectMake(0, kScreenH, kScreenW, 124);
    }
    else if (i==0 && j==1)
    {
        self.auctionView.frame = CGRectMake(0, kScreenH, kScreenW, 124);
    }
    self.auctionView.hidden = NO;
    _auctionView.delegate = self;
    [self.view addSubview:_auctionView];
    [_auctionView createVieWith:i andNumber:j];
    [UIView animateWithDuration:0.2 animations:^{
        if (i==1 && j==1) {
            _auctionView.frame = CGRectMake(0, kScreenH-200, kScreenW, 200);
        }
        else if (i==0 && j==1)
        {
            _auctionView.frame = CGRectMake(0, kScreenH-124, kScreenW, 124);
        }
        else if (i==1 && j==0)
        {
            _auctionView.frame = CGRectMake(0, kScreenH-124, kScreenW, 124);
        }
    }];
    self.clearButton.frame = CGRectMake(0, 0, kScreenW, kScreenH-_auctionView.frame.size.height);
    [self.clearButton addTarget:self action:@selector(closeActionView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
}

#pragma mark 发起实物竞拍，虚拟竞拍时的处理
- (void)chooseButton:(UIButton *)button
{
    CGRect frame = _auctionView.frame;
    frame.origin.y = kScreenH;
    //虚拟竞拍
    if (button.tag==301) {
        //获取数据，判断主播是否能创建竞拍
        if (![FWUtils isNetConnected])
        {
            [FWHUDHelper alert:@"当前无网络"];
            return;
        }
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"pai_podcast" forKey:@"ctl"];
        [mDict setObject:@"check" forKey:@"act"];
        [mDict setObject:@"shop" forKey:@"itype"];
        
        [[FWHUDHelper sharedInstance] syncLoading:@"正在跳转请等待" inView:_view];
        [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"] == 1)
            {
                [[FWHUDHelper sharedInstance] syncStopLoading];
                
                ReleaseViewController *releaseVC = [[ReleaseViewController alloc]init];
                releaseVC.delegate = self;
                releaseVC.hidesBottomBarWhenPushed = YES;
                releaseVC.shopType = @"VirtualShopping";
                _auctionView.frame =frame;
                _auctionView.hidden = YES;
                [_clearButton removeFromSuperview];
                if (_delegate && [_delegate respondsToSelector:@selector(pushVC:)])
                {
                    [_delegate pushVC:releaseVC];
                }
            }
            else
            {
                [[FWHUDHelper sharedInstance] syncStopLoading];
                if (![responseJson[@"error"] isEqualToString:@""])
                {
                    _auctionView.frame =frame;
                    _auctionView.hidden = YES;
                    [_clearButton removeFromSuperview];
                }
            }
            
        } FailureBlock:^(NSError *error) {
            
            [[FWHUDHelper sharedInstance] syncStopLoading];
        }];
    }
    else if (button.tag==302) //实物竞拍
    {
        _auctionView.frame =frame;
        _auctionView.hidden = YES;
        [_clearButton removeFromSuperview];
        //        id<AVRoomAble> room = [_liveController roomInfo];
        //        //主播id
        NSString * hostId = [[_liveItem liveHost] imUserId];
        self.auctionGoodsView.hostID = hostId;
        [_auctionGoodsView loadDataWithPage:1];
        [self.view addSubview:self.auctionGoodsView];
        _auctionGoodsView.hidden = NO;
        [UIView animateWithDuration:kGoodsViewDescTime animations:^{
            _auctionGoodsView.frame = CGRectMake(0, kScreenH-300, kScreenW,300);
        } completion:^(BOOL finished) {
            self.clearButton.frame = CGRectMake(0, 0, kScreenW, kScreenH-300);
            [self.clearButton addTarget:self action:@selector(closeActionView) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.clearButton];
        }];
    }
    else if (button.tag==303) //取消按钮
    {
        [_clearButton removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            _auctionView.frame = frame;
        } completion:^(BOOL finished) {
            _auctionView.hidden = YES;
        }];
    }
}

//点击实物竞拍推送，跳转到实物竞拍发布页
- (void)closeAuctionGoodsView
{
    //    [UIView animateWithDuration:kGoodsViewDescTime  animations:^{
    //        _auctionGoodsView.frame = CGRectMake(0, kScreenH, kScreenW, 300);
    //    } completion:^(BOOL finished) {
    //        _auctionGoodsView.hidden = YES;
    //    }];
    [_clearButton removeFromSuperview];
    _auctionGoodsView.frame = CGRectMake(0, kScreenH, kScreenW, 300);
    _auctionGoodsView.hidden = YES;
    //实物商品按钮
    ReleaseViewController *releaseVC = [[ReleaseViewController alloc]init];
    releaseVC.delegate = self;
    releaseVC.hidesBottomBarWhenPushed = YES;
    releaseVC.shopType = @"EntityAuctionShopping";
    releaseVC.auctionGoodsModel = _auctionGoodsView.model;
    if (_delegate && [_delegate respondsToSelector:@selector(pushVC:)]) {
        [_delegate pushVC:releaseVC];
    }
}

#pragma mark 关闭操作
- (void)onClickClose
{
    //如果是互动直播的主播
    if (_paiTime > 0 && _liveView.isHost)
    {
        // [[FWHUDHelper sharedInstance] tipMessage:@"你发起的竞拍直播还未结束"];
        [FanweMessage alert:@"你发起的竞拍暂未结束，不能关闭直播！"];
    }
    //如果是腾讯云直播的主播
    else if (_paiTime >0 && [_liveItem liveType] == FW_LIVE_TYPE_HOST)
    {
        [FanweMessage alert:@"你发起的竞拍暂未结束，不能关闭直播！"];
    }
    //如果观看直播的观众
    else if(_paiTime > 0)
    {
        FWWeakify(self)
        [FanweMessage alert:nil message:@"您参与的竞拍暂未结束，确定要离开直播间么？" destructiveAction:^{
            
            FWStrongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(closeRoom)])
            {
                [self.delegate closeRoom];
            }
            
        } cancelAction:^{
            
        }];
    }
}

#pragma mark ReleaseViewController代理（ReleaseViewControllerDelegate）
- (void)onReleaseVCAuctionId:(NSInteger )auctionId
{
    _paiId = auctionId;
    if (_hadEnd) {
        //        [[FWHUDHelper sharedInstance] tipMessage:@"发布失败，直播已关闭"];
        [FanweMessage alert:@"发布失败，直播已关闭"];
    }
    else
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"发布成功"];
        [self loadTimeData];
        // _liveView.topView.accountLabel.hidden = YES;
        _liveView.topView.priceView.hidden = NO;
        _liveView.topView.priceView.userInteractionEnabled = YES;
        _liveView.topView.titleNameLabel.text = @"最高价";
        _liveView.topView.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)_lastPrice];
        _liveView.bottomView.auctionBtn.hidden = YES;
        [_liveView bringSubviewToFront:_liveView.topView];
        [_liveView.topView relayoutOtherContainerViewFrame];
        if (_delegate && [_delegate respondsToSelector:@selector(changePayView:)]) {
            [_delegate changePayView:_liveView];
        }
    }
}

- (void)closeActionView
{
    [_clearButton removeFromSuperview];
    if (_auctionView.hidden== NO) {
        CGRect frame = _auctionView.frame;
        frame.origin.y = kScreenH;
        [UIView animateWithDuration:kGoodsViewDescTime  animations:^{
            _auctionView.frame = frame;
        } completion:^(BOOL finished) {
            _auctionView.hidden = YES;
        }];
    }
    if (_auctionGoodsView.hidden== NO) {
        [UIView animateWithDuration:kGoodsViewDescTime  animations:^{
            _auctionGoodsView.frame = CGRectMake(0, kScreenH, kScreenW, 300);
        } completion:^(BOOL finished) {
            _auctionGoodsView.hidden = YES;
        }];
    }
    if (_shopGoodsView.hidden== NO) {
        [UIView animateWithDuration:kGoodsViewDescTime  animations:^{
            _shopGoodsView.frame = CGRectMake(0, kScreenH, kScreenW, kShoppingHeight);
        } completion:^(BOOL finished) {
            _shopGoodsView.hidden = YES;
        }];
    }
    if (_OTOShopGoodsView.hidden== NO) {
        [UIView animateWithDuration:kGoodsViewDescTime  animations:^{
            _OTOShopGoodsView.frame = CGRectMake(0, kScreenH, kScreenW, kShoppingHeight);
        } completion:^(BOOL finished) {
            _OTOShopGoodsView.hidden = YES;
        }];
    }
}

- (void)closeAuctionAboutView
{
    if (_bigArray && [_bigArray isKindOfClass:[NSArray class]])//中拍着竞拍成功到付款时候点击界面可以去掉竞拍付款的动画的页面
    {
        if (_bigArray.count)
        {
            if ([self isShouldPayer:[_bigArray[0] user_id]])
            {
                if (self.auctionResultView) {
                    [self.auctionResultView removeFromSuperview];
                    _auctionResultView = nil;
                }
            }else if (_payModel)
            {
                if ([self isShouldPayer:_payModel.user_id])
                {
                    if (self.auctionResultView) {
                        [self.auctionResultView removeFromSuperview];
                        _auctionResultView = nil;
                    }
                }
            }
        }
    }
    
    if (_topayView) {
        [UIView animateWithDuration:0.2 animations:^{
            _topayView.frame = CGRectMake(0, kScreenH, kScreenW, 140);
        } completion:^(BOOL finished) {
            [_topayView removeFromSuperview];
            _topayView = nil;
        }];
    }
    
    [self removeAboutGoods];
}

#pragma mark ————————————————————————————————购物相关——————————————————————————————————————————————————————————
//主播发起商品推送成功
- (void)starGoodsSuccessWithCustomModel:(CustomMessageModel *)customMessageModel
{
    if (_shopGoodsView==nil) {
        [self.view addSubview:self.shopGoodsView];
        _shopGoodsView.hidden = YES;
    }
    if (_shopGoodsView.hidden== YES) {
        ShopGoodsView * goodsView = [[ShopGoodsView alloc] initWithFrame:CGRectMake(0, kScreenH/2-50, 300,100 )];
        if ([_liveItem liveType] == FW_LIVE_TYPE_HOST) {
            goodsView.type = 0;
        }
        else if ([_liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            goodsView.type = 1;
        }
        goodsView.backgroundColor = [UIColor whiteColor];
        goodsView.model = customMessageModel.goods;
        goodsView.delegate = self;
        _goodsUrl = nil;
        if (kSupportH5Shopping && customMessageModel.goods.url.length>0) {
            _goodsUrl = customMessageModel.goods.url;
        }
        else if(customMessageModel.goods.url.length>0 && customMessageModel.goods.type == 1)
        {
            _goodsUrl = customMessageModel.goods.url;
        }
        _goodsId = customMessageModel.goods.goods_id;
        [_liveView addSubview:goodsView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [goodsView removeFromSuperview];
        });
    }
}

//购物成功推送
- (void)buyGoodsSuccessWithCustomModel:(CustomMessageModel *)customMessageModel
{
    [self removeAboutGoods];
    if ([customMessageModel.is_self intValue] == 0) {
        _buyGoodsView = [[BuyGoodsView alloc] initWithFrame:CGRectMake((kScreenW-170)/2, (kScreenH-230)/2, 170, 230)];
    }
    else if ([customMessageModel.is_self intValue] == 1)
    {
        _buyGoodsView = [[BuyGoodsView alloc] initWithFrame:CGRectMake((kScreenW-170)/2, (kScreenH-170)/2, 170, 170)];
    }
    [_liveView addSubview:_buyGoodsView];
    [_buyGoodsView addDataWithDesMoel:customMessageModel andIsHost:_liveView.isHost];
    _goodsTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(removeAboutGoods) userInfo:nil repeats:NO];
}

- (void)removeAboutGoods
{
    if (_buyGoodsView) {
        [_buyGoodsView removeFromSuperview];
        _buyGoodsView = nil;
    }
    if (_goodsTimer) {
        [_goodsTimer invalidate];
        _goodsTimer = nil;
    }
}

#pragma mark 跳转购物链接
- (void)toGoods
{
    if (_goodsUrl.length>0)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:_goodsUrl isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
        [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:@"直播"];
        
        //        if (kSupportH5Shopping || _fanweApp.appModel.open_podcast_goods == 1)
        //        {
        //            tmpController.isSmallScreen = NO;
        //        }
        //        else
        //        {
        //            tmpController.isSmallScreen = YES;
        //        }
        tmpController.isSmallScreen = NO;
        tmpController.httpMethodStr = @"GET";
        if (_delegate && [_delegate respondsToSelector:@selector(toGoH5With:andShowSmallWindow:)])
        {
            [_delegate toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
        }
    }
    else
    {
        NSString * hostId = [[_liveItem liveHost] imUserId];
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"pai_user" forKey:@"ctl"];
        [mDict setObject:@"open_goods_detail" forKey:@"act"];
        [mDict setObject:hostId forKey:@"podcast_id"];
        if(_goodsId.length>0)
        {
            [mDict setObject:_goodsId forKey:@"goods_id"];
        }
        [mDict setObject:@"shop" forKey:@"itype"];
        [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"] == 1)
            {
                FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:[responseJson toString:@"url"] isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
                [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:@"直播"];
                
                //                if (kSupportH5Shopping || _fanweApp.appModel.open_podcast_goods == 1)
                //                {
                //                    tmpController.isSmallScreen = NO;
                //                }
                //                else
                //                {
                //                    tmpController.isSmallScreen = YES;
                //                }
                tmpController.isSmallScreen = NO;
                tmpController.httpMethodStr = @"GET";
                if (_delegate && [_delegate respondsToSelector:@selector(toGoH5With:andShowSmallWindow:)])
                {
                    [_delegate toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
                }
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}


-(ShopGoodsUIView *)shopGoodsView
{
    if (_shopGoodsView==nil) {
        _shopGoodsView = [[ShopGoodsUIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kShoppingHeight)];
        _shopGoodsView.backgroundColor = [UIColor whiteColor];
        _shopGoodsView.hidden = YES;
        _shopGoodsView.delegate = self;
    }
    return _shopGoodsView;
}

-(ShopGoodsUIView *)OTOShopGoodsView
{
    if (_OTOShopGoodsView==nil) {
        _OTOShopGoodsView = [[ShopGoodsUIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kShoppingHeight)];
        _OTOShopGoodsView.backgroundColor = [UIColor whiteColor];
        _OTOShopGoodsView.hidden = YES;
        _OTOShopGoodsView.delegate = self;
    }
    return _OTOShopGoodsView;
}

#pragma mark 星店
- (void)clickStarShopWithIsOTOShop:(BOOL)isOTOShop
{
    NSString * hostId = [[_liveItem liveHost] imUserId];
    if (_liveView.isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST) {
        if (isOTOShop) {
            self.OTOShopGoodsView.type = 0;
            self.OTOShopGoodsView.hostID = hostId;
            //[_shopGoodsView loadData];
            self.OTOShopGoodsView.isOTOShop = YES;
            [_OTOShopGoodsView loadDataWithPage:1];
            [self.view addSubview:self.OTOShopGoodsView];
            _OTOShopGoodsView.hidden = NO;
            [UIView animateWithDuration:kGoodsViewDescTime animations:^{
                _OTOShopGoodsView.frame = CGRectMake(0, 0.6*kScreenW, kScreenW, kShoppingHeight);
            } completion:^(BOOL finished) {
                self.clearButton.frame = CGRectMake(0, 0, kScreenW, 0.6*kScreenW);
                [self.clearButton addTarget:self action:@selector(closeActionView) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.clearButton];
            }];
        }
        else
        {
            self.shopGoodsView.type = 0;
            self.shopGoodsView.hostID = hostId;
            //[_shopGoodsView loadData];
            self.shopGoodsView.isOTOShop = NO;
            [_shopGoodsView loadDataWithPage:1];
            [self.view addSubview:self.shopGoodsView];
            _shopGoodsView.hidden = NO;
            [UIView animateWithDuration:kGoodsViewDescTime animations:^{
                _shopGoodsView.frame = CGRectMake(0, 0.6*kScreenW, kScreenW, kShoppingHeight);
            } completion:^(BOOL finished) {
                self.clearButton.frame = CGRectMake(0, 0, kScreenW, 0.6*kScreenW);
                [self.clearButton addTarget:self action:@selector(closeActionView) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.clearButton];
            }];
        }
        
    }
    else if(kSupportH5Shopping || isOTOShop)
    {
        if (kSupportH5Shopping) {
            self.shopGoodsView.type = 1;
            self.shopGoodsView.hostID = hostId;
            [_shopGoodsView loadDataWithPage:1];
            [self.view addSubview:self.shopGoodsView];
            _shopGoodsView.hidden = NO;
            [UIView animateWithDuration:kGoodsViewDescTime animations:^{
                _shopGoodsView.frame = CGRectMake(0, 0.6*kScreenW, kScreenW, kShoppingHeight);
            } completion:^(BOOL finished) {
                self.clearButton.frame = CGRectMake(0, 0, kScreenW, 0.6*kScreenW);
                [self.clearButton addTarget:self action:@selector(closeActionView) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.clearButton];
            }];
        }
        else if (isOTOShop)
        {
            self.OTOShopGoodsView.type = 1;
            self.OTOShopGoodsView.hostID = hostId;
            //[_shopGoodsView loadData];
            self.OTOShopGoodsView.isOTOShop = YES;
            [_OTOShopGoodsView loadDataWithPage:1];
            [self.view addSubview:self.OTOShopGoodsView];
            _OTOShopGoodsView.hidden = NO;
            [UIView animateWithDuration:kGoodsViewDescTime animations:^{
                _OTOShopGoodsView.frame = CGRectMake(0, 0.6*kScreenW, kScreenW, kShoppingHeight);
            } completion:^(BOOL finished) {
                self.clearButton.frame = CGRectMake(0, 0, kScreenW, 0.6*kScreenW);
                [self.clearButton addTarget:self action:@selector(closeActionView) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.clearButton];
            }];
        }
    }
    else
    {
        if (hostId.length == 0) {
            return;
        }
        self.shopGoodsView.type = 1;
        self.shopGoodsView.hostID = hostId;
        //获取h5的url
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"pai_user" forKey:@"ctl"];
        [mDict setObject:@"open_goods" forKey:@"act"];
        [mDict setObject:hostId forKey:@"podcast_id"];
        [mDict setObject:@"shop" forKey:@"itype"];
        
        [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"] == 1)
            {
                FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:[responseJson toString:@"url"] isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
                [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:@"直播"];
                
                //                if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE  || kSupportH5Shopping || _fanweApp.appModel.open_podcast_goods == 1)
                //                {
                //                    tmpController.isSmallScreen = NO;
                //                }
                //                else
                //                {
                //                    tmpController.isSmallScreen = YES;
                //                }
                tmpController.isSmallScreen = NO;
                tmpController.httpMethodStr = @"GET";
                if (_delegate && [_delegate respondsToSelector:@selector(toGoH5With:andShowSmallWindow:)])
                {
                    [_delegate toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
                }
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)closeShopGoodsViewWithDic:(NSDictionary *)dic andIsOTOShop:(BOOL)isOTOShop
{
    [_clearButton removeFromSuperview];
    [UIView animateWithDuration:kGoodsViewDescTime  animations:^{
        if (isOTOShop) {
            _OTOShopGoodsView.frame = CGRectMake(0, kScreenH, kScreenW, kShoppingHeight);
        }
        else
        {
            _shopGoodsView.frame = CGRectMake(0, kScreenH, kScreenW, kShoppingHeight);
        }
    } completion:^(BOOL finished) {
        if (isOTOShop) {
            _OTOShopGoodsView.hidden = YES;
        }
        else
        {
            _shopGoodsView.hidden = YES;
        }
        //如果传过来的字典不为空，更据字典的键的个数跳转不同的网页
        if (_liveView.isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST || kSupportH5Shopping || isOTOShop) {
            if (dic != nil) {
                if (dic.allKeys.count == 1)
                {
                    //跳转到商品管理页面
                    NSString * url = kSupportH5Shopping ? dic[@"url"] : _fanweApp.appModel.h5_url.url_podcast_goods;
                    
                    FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:url isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
                    [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:@"直播"];
                    
                    //                    if (kSupportH5Shopping || _fanweApp.appModel.open_podcast_goods == 1)
                    //                    {
                    //                        tmpController.isSmallScreen = NO;
                    //                    }
                    //                    else
                    //                    {
                    //                        tmpController.isSmallScreen = YES;
                    //                    }
                    tmpController.isSmallScreen = NO;
                    tmpController.httpMethodStr = @"GET";
                    if (_delegate && [_delegate respondsToSelector:@selector(toGoH5With:andShowSmallWindow:)]) {
                        [_delegate toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
                    }
                }
                else if (dic.allKeys.count == 2)
                {
                    //跳转到商品详情页面
                    if (isOTOShop)
                    {
                        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:[dic toString:@"url"] isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
                        [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:@"直播"];
                        
                        //                        if (kSupportH5Shopping || _fanweApp.appModel.open_podcast_goods == 1)
                        //                        {
                        //                            tmpController.isSmallScreen = NO;
                        //                        }
                        //                        else
                        //                        {
                        //                            tmpController.isSmallScreen = YES;
                        //                        }
                        tmpController.isSmallScreen = NO;
                        tmpController.httpMethodStr = @"GET";
                        if (_delegate && [_delegate respondsToSelector:@selector(toGoH5With:andShowSmallWindow:)])
                        {
                            [_delegate toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
                        }
                    }
                    else
                    {
                        //主播id
                        NSString * hostId = [[_liveItem liveHost] imUserId];
                        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                        [mDict setObject:@"pai_user" forKey:@"ctl"];
                        [mDict setObject:@"open_goods_detail" forKey:@"act"];
                        [mDict setObject:hostId forKey:@"podcast_id"];
                        [mDict setObject:dic[@"goodsId"] forKey:@"goods_id"];
                        [mDict setObject:@"shop" forKey:@"itype"];
                        [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
                            
                            if ([responseJson toInt:@"status"] == 1)
                            {
                                FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:[responseJson toString:@"url"] isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
                                [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:@"直播"];
                                
                                //                                if (kSupportH5Shopping || _fanweApp.appModel.open_podcast_goods == 1)
                                //                                {
                                //                                    tmpController.isSmallScreen = NO;
                                //                                }
                                //                                else
                                //                                {
                                //                                    tmpController.isSmallScreen = YES;
                                //                                }
                                tmpController.isSmallScreen = NO;
                                tmpController.httpMethodStr = @"GET";
                                if (_delegate && [_delegate respondsToSelector:@selector(toGoH5With:andShowSmallWindow:)])
                                {
                                    [_delegate toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
                                }
                            }
                            
                        } FailureBlock:^(NSError *error) {
                            
                        }];
                    }
                }
            }
        }
    }];
}

- (NSMutableArray *)bigImageArr
{
    if (_bigImageArr == nil) {
        _bigImageArr = [NSMutableArray array];
    }
    return _bigImageArr;
}

- (NSMutableArray *)stateLabelArr
{
    if (_stateLabelArr == nil) {
        _stateLabelArr = [NSMutableArray array];
    }
    return _stateLabelArr;
}

@end
