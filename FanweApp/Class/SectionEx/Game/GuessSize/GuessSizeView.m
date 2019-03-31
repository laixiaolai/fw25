//
//  GuessSizeView.m
//  FanweApp
//
//  Created by 方维 on 2017/5/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GuessSizeView.h"
#import <ImageIO/ImageIO.h>

@implementation GuessSizeView
- (void)awakeFromNib
{
    [super awakeFromNib];
    _httpManager =[NetHttpsManager manager];
    _fanweApp = [GlobalVariables sharedInstance];
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = kColorWithStr(@"fff3e1");
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font =  kAppMiddleTextFont_1;
    [self.clockImageView addSubview:self.timeLabel];
    self.betImageArray = @[self.bigSizeImageView,self.middleSizeImageView,self.smallSizeImageView];
    if (!_coinMoveArray) {
        _coinMoveArray      = [[NSMutableArray alloc]init];
        _coinBtnArray       = [[NSMutableArray alloc]init];
        _coinBeignArray     = [[NSMutableArray alloc]init];
        _betViewArray       = [[NSMutableArray alloc]init];
        _breathImgArray     = [[NSMutableArray alloc]init];
    }
    self.diceImageViewOne = [[FLAnimatedImageView alloc] init];
    self.diceImageViewOne.frame = CGRectMake((kScreenW-170)/2, 0, 150, 150);
    self.diceImageViewOne.backgroundColor = [UIColor clearColor];
    [self addSubview:self.diceImageViewOne];
    
    self.diceImageViewTwo = [[FLAnimatedImageView alloc] init];
    self.diceImageViewTwo.frame = CGRectMake((kScreenW-170)/2+30, 40, 100, 100);
    self.diceImageViewTwo.backgroundColor = [UIColor clearColor];
    [self addSubview:self.diceImageViewTwo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCoin) name:@"updateCoin" object:nil];
    _canCloseGame = YES;
    _maskViewNameArr = @[@"gm_bigMaskView",@"gm_middleMaskView",@"gm_smallMaskView"];
}

- (void)creatLabel
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.timeLabel.frame = CGRectMake(0, 0, self.clockImageView.width, self.clockImageView.height);
    CGFloat betLabelOrigin = 0;
    CGFloat userBetLabelOrigin = 0;
    for (int i=0; i<3; i++) {
        UIImageView * betImageView = self.betImageArray[i];
        if (i == 0) {
            betLabelOrigin = (betImageView.width-60)/2+10;
            userBetLabelOrigin = (betImageView.width-60)/2+5;
        }
        else if (i == 1)
        {
            betLabelOrigin = (betImageView.width-60)/2;
            userBetLabelOrigin = (betImageView.width-60)/2;
        }
        else if (i == 2)
        {
           betLabelOrigin = (betImageView.width-60)/2-10;
           userBetLabelOrigin = (betImageView.width-60)/2-5;
        }
        UILabel * betLabel = [[UILabel alloc] initWithFrame:CGRectMake(betLabelOrigin, 10, 60,20)];
        betLabel.textAlignment = NSTextAlignmentCenter;
        betLabel.font = kAppSmallerTextFont_1;
        betLabel.backgroundColor = kGrayTransparentColor3;
        betLabel.layer.cornerRadius = 10;
        betLabel.layer.masksToBounds = YES;
        betLabel.hidden = YES;
        betLabel.textColor = kWhiteColor;
        [betImageView addSubview:betLabel];
        [self.betLabelArr addObject:betLabel];
        
        UILabel * userBetLabel = [[UILabel alloc] initWithFrame:CGRectMake(userBetLabelOrigin, betImageView.height-50, 60, 20)];
        userBetLabel.textAlignment = NSTextAlignmentCenter;
        userBetLabel.font = kAppSmallerTextFont_1;
        userBetLabel.backgroundColor = kRedColor;
        userBetLabel.layer.cornerRadius = 10;
        userBetLabel.layer.masksToBounds = YES;
        userBetLabel.hidden = YES;
        userBetLabel.textColor = kWhiteColor;
        [betImageView addSubview:userBetLabel];
        [self.userBetLabelArr addObject:userBetLabel];
        
        UILabel * betMultipleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, betImageView.height-30, betImageView.width, 20)];
        betMultipleLabel.textAlignment = NSTextAlignmentCenter;
        betMultipleLabel.textColor = kColorWithStr(@"832f0d");
        betMultipleLabel.font = kAppMiddleTextFont_1;
        [betImageView addSubview:betMultipleLabel];
        [self.betMultipleLabelArr addObject:betMultipleLabel];
        [_coinMoveArray addObject:[NSValue valueWithCGPoint:betImageView.center]];
        
        
        UIImageView * maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, betImageView.width, betImageView.height)];
        maskView.image =[UIImage imageNamed:self.maskViewNameArr[i]];
        maskView.hidden = YES;
        [betImageView addSubview:maskView];
        [self.maskViewArr addObject:maskView];
        
        betImageView.userInteractionEnabled = YES;
        betImageView.tag = i+1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coinMove:)];
        [betImageView addGestureRecognizer:tap];
    }
}

- (void)setBetOptionArray:(NSArray *)betOptionArray
{
    _betOptionArray = betOptionArray;
    //[self createCoinView];
}

- (void)loadDiceWithDicesArr:(NSArray *)dicesArr andResultWinPostion:(NSInteger )winPostion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (winPostion>0)
        {
            for (UIImageView * view in self.maskViewArr)
            {
                if (![view isEqual:self.maskViewArr[winPostion-1]] && winPostion>0)
                {
                    view.hidden = NO;
                }
            }
            [self.betArr removeAllObjects];
            [self.userBetArr removeAllObjects];
        }
    });
    self.clockImageView.hidden = YES;
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@-%@",dicesArr.firstObject,dicesArr.lastObject] withExtension:@"gif"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    FLAnimatedImage * animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    animatedImage1.loopCount = 1;
    self.diceImageViewOne.animatedImage = animatedImage1;
    self.diceImageViewOne.hidden = NO;
}

- (void)showTime:(int)time
{
    _countTime = time;
    _timeLabel.text = [NSString stringWithFormat:@"%d",time];
    _clockImageView.hidden = NO;
    _timeLabel.hidden = NO;
    for (UIImageView * view in self.maskViewArr) {
        view.hidden = YES;
    }
    [self hiddenLabelWithLabelArr:self.betLabelArr];
    [self hiddenLabelWithLabelArr:self.userBetLabelArr];
    //[self hiddenLabelWithLabelArr:self.betMultipleLabelArr];
    self.diceImageViewOne.hidden = YES;
    self.diceImageViewTwo.hidden = YES;
    if (_showDiceTimer) {
        [_showDiceTimer invalidate];
        _showDiceTimer = nil;
    }
    _showDiceTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)hiddenLabelWithLabelArr:(NSArray *)labelArr
{
    for (UILabel * label in labelArr) {
        label.hidden = YES;
    }
}


- (void)countDown
{
    if (_countTime == 0) {
        [_showDiceTimer invalidate];
        _showDiceTimer = nil;
        return;
    }
    _countTime--;
    _timeLabel.text = [NSString stringWithFormat:@"%d",_countTime];
    if (_countTime == 0) {
        [self addTimer];
    }
}


-(void)addTimer
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(reloadGameData)]) {
            [_delegate reloadGameData];
        }
    });
}

- (void)disClockTime
{
    if (_showDiceTimer) {
        [_showDiceTimer invalidate];
        _showDiceTimer = nil;
    }
    _clockImageView.hidden = YES;
}

-(void)setIsArc:(BOOL)isArc
{
    _isArc = isArc;
    NSString * imageStr = isArc ? @"gm_game_arcBtn" : @"gm_game_mrcBtn";
    [_arcOrMrcGameView.betBtn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}

#pragma mark    ---------------------------------加载押注数据等------------------------------------
#pragma mark 加载更新押注数据
-(void)loadBetDataWithBetArray:(NSArray *)betArray andUserBetArray:(NSArray *)userBetArray
{
    if (betArray.count == self.betImageArray.count ) {
        if (self.betArr.count == 0 ) {
            NSMutableArray * arr = [NSMutableArray arrayWithArray:betArray];
            //每局游戏第一次加载下注情况时对总下注情况用数组进行记录
            self.betArr = arr;
            for (int i=0; i<betArray.count; ++i) {
                //总投注数,第一次加载下注情况时进循环，如果为0则不显示出来
                if ([betArray[i] integerValue]>0) {
                    [self loadBetDesDataWithBetLabel:_betLabelArr[i] andBetNumber:betArray[i]];
                }
            }
        }
        else
        {
            for (int i=0; i<betArray.count; ++i) {
                //如果不是第一次加载下注情况，则通过之前存的下注情况与现在的下注情况进行对比
                if ([betArray[i] integerValue]>[self.betArr[i] integerValue]) {
                    self.betArr[i] = betArray[i];
                    [self loadBetDesDataWithBetLabel:_betLabelArr[i] andBetNumber:betArray[i]];
                }
            }
        }
    }
    if (userBetArray != nil) {
        if (userBetArray.count == self.betImageArray.count) {
            //每局游戏第一次加载下注情况时对玩家下注情况用数组进行记录
            if (self.userBetArr.count == 0 ) {
                NSMutableArray * arr = [NSMutableArray arrayWithArray:userBetArray];
                self.userBetArr = arr;
                for (int i=0; i<userBetArray.count; ++i) {
                    //玩家投注数,第一次加载下注情况时进循环，如果为0则不显示出来
                    if ([userBetArray[i] integerValue] >0) {
                        [self loadUserBetDesDataWithLabel:_userBetLabelArr[i] andUserBetNumber:userBetArray[i]];
                    }
                }
            }
            else
            {
                //玩家投注数
                for (int i=0; i<userBetArray.count; ++i) {
                    //如果不是第一次加载下注情况，则通过之前存的下注情况与现在的下注情况进行对比
                    if ([userBetArray[i] integerValue]>[self.userBetArr[i] integerValue]) {
                        self.userBetArr[i] = userBetArray[i];
                        [self loadUserBetDesDataWithLabel:_userBetLabelArr[i] andUserBetNumber:userBetArray[i]];
                    }
                }
            }
        }
    }
}

#pragma mark 加载总下注数据的实现
-(void)loadBetDesDataWithBetLabel:(UILabel *)betLabel andBetNumber:(id)betNumber
{
    betLabel.hidden = NO;
    if ([betNumber integerValue]>=10000) {
        float bet = [betNumber integerValue]/10000.0;
        betLabel.text = [NSString stringWithFormat:@"%.1f万",bet];
    }
    else
    {
        betLabel.text = [NSString stringWithFormat:@"%@",betNumber];
    }
}

#pragma mark 加载玩家下注数据的实现
-(void)loadUserBetDesDataWithLabel:(UILabel *)userBetLabel andUserBetNumber:(id)userBetNumber
{
    userBetLabel.hidden = NO;
    if ([userBetNumber integerValue]>=10000) {
        float userBet = [userBetNumber integerValue]/10000.0;
        userBetLabel.text = [NSString stringWithFormat:@"%.1f万",userBet];
    }
    else
    {
        userBetLabel.text = [NSString stringWithFormat:@"%@",userBetNumber];
    }
}

- (void)createButtomView
{
    if (!_buttomView) {
        _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kGuessSizeViewHeight-kGuessSizeButtomHeight, kScreenW, kGuessSizeButtomHeight)];
        [self addSubview:_buttomView];
        _gameRechargeView = [[NSBundle mainBundle] loadNibNamed:@"GameRechargeView" owner:nil options:nil].lastObject;
        _gameRechargeView.userInteractionEnabled = YES;
        _gameRechargeView.frame = CGRectMake(10, (kGuessSizeButtomHeight-26)/2,kScreenW-200, 26);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recharge)];
        [_gameRechargeView.backGroundView addGestureRecognizer:tap];
        [_buttomView addSubview:_gameRechargeView];
        //金币余额的中心位置
        _coinPoint = CGPointMake(17.5, kGuessSizeViewHeight-kGuessSizeButtomHeight);
        [self updateCoinWithID:nil];
    }
    
    [self createBetView];
}

- (void)recharge
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickRecharge)]) {
        [_delegate clickRecharge];
    }
}

#pragma mark    创建押注金额视图
- (void)createBetView
{
    //押注的金额视图
    if (!_isHost) {
        if (!_betView) {
            
            for (int i = 0; i < self.betOptionArray.count; i++) {
                _betView = [BetView EditNibFromXib];
                _betView.delegate = self;
                _betView.backgroundColor = [UIColor clearColor];
                _betView.frame = CGRectMake((kScreenW -180) + i*(betButtonInterval +betButtonWidth), (kGuessSizeButtomHeight-30)/2, 30, 30);
                _betView.betBtn.tag = i+200;
                
                if (_betOptionArray.count > 0)
                {
                    [_betView.betBtn setTitle:[NSString stringWithFormat:@"%@",[self.betOptionArray objectAtIndex:i]] forState:UIControlStateNormal];
                }
                [_betView.betBtn setBackgroundImage:[UIImage imageNamed:@"gm_selectedBet"] forState:UIControlStateNormal];
                [_betView.betBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
                if (i == 0) {
                    //获取betView在当前视图的位置
                    _amountPoint = [_buttomView convertPoint:_betView.center toView:self];
                    _betMoney = [NSString stringWithFormat:@"%@",[self.betOptionArray objectAtIndex:0]];
                    [_betView.betBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
//                    //加上呼吸灯动画
//                    _betView.breathImg.image = [UIImage imageNamed:@"gm_coin_breath"];
//                    [_betView.breathImg.layer addAnimation:[CAAnimation AlphaLight:1.0f fromValue:1.0f toValue:0.4f] forKey:@"alpha"];
                    
                }
                else if (i == 1)
                {
                    [_betView.betBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
                }
                else if (i == 2)
                {
                    [_betView.betBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:9]];
                }
                else
                {
                    [_betView.betBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8]];
                }
//                _betView.betBtn.userInteractionEnabled = NO;
//                _betView.betBtn.alpha = 0.3;
                BOOL isSelected = i == _betCount ? YES : NO;
                [self setBetBtnWithIsSelected:isSelected andBtn:_betView.betBtn];
                //将控件存入数组中
                [_coinBtnArray addObject:_betView.betBtn];
                [_breathImgArray addObject:_betView.breathImg];
                [_betViewArray addObject:_betView];
                //将押注的开始位置保存起来
                [_coinBeignArray addObject:[NSValue valueWithCGPoint:_betView.center]];
                
                [_buttomView addSubview:_betView];
            }
        }
    }
    
    //历史记录
    if (!_historyView) {
        _historyView = [BetView EditNibFromXib];
        _historyView.delegate = self;
        if (_isHost) {
            _historyView.frame = CGRectMake((kScreenW - 180)+3*(betButtonInterval +betButtonWidth),( kGuessSizeButtomHeight-30)/2, 30, 30);
        }
        else
        {
            _historyView.frame = CGRectMake((kScreenW - 180)+4*(betButtonInterval +betButtonWidth), ( kGuessSizeButtomHeight-30)/2, 30, 30);
        }
        _historyView.betBtn.tag = 204;
        [_historyView.betBtn setBackgroundImage:[UIImage imageNamed:@"gm_history"] forState:UIControlStateNormal];
        [_buttomView addSubview:_historyView];
        
        //将控件存入入数组中
        [_coinBtnArray addObject:_historyView.betBtn];
        [_breathImgArray addObject:_historyView.breathImg];
        [_betViewArray addObject:_historyView];
    }
    
    if (_isHost) {
        //游戏结束
        if (!_gameOverView) {
            _gameOverView = [BetView EditNibFromXib];
            _gameOverView.delegate = self;
            _gameOverView.frame = CGRectMake((kScreenW -180)+4*(betButtonInterval +betButtonWidth), ( kGuessSizeButtomHeight-30)/2, 30, 30);
            _gameOverView.betBtn.tag = 205;
            [_gameOverView.betBtn setBackgroundImage:[UIImage imageNamed:@"gm_game_closeBtn"] forState:UIControlStateNormal];
            [_buttomView addSubview:_gameOverView];
            
            //将控件存入入数组中
            [_coinBtnArray addObject:_gameOverView.betBtn];
            [_breathImgArray addObject:_gameOverView.breathImg];
            [_betViewArray addObject:_gameOverView];
        }
        //手动发牌与自动发牌
        if (!_arcOrMrcGameView && kSupportArcGame) {
            _arcOrMrcGameView = [BetView EditNibFromXib];
            _arcOrMrcGameView.delegate = self;
            _arcOrMrcGameView.frame = CGRectMake((kScreenW -180)+2*(betButtonInterval +betButtonWidth), ( kGuessSizeButtomHeight-30)/2, 30, 30);
            _arcOrMrcGameView.betBtn.tag = 206;
            [_arcOrMrcGameView.betBtn setBackgroundImage:[UIImage imageNamed:@"gm_game_mrcBtn"] forState:UIControlStateNormal];
            [_buttomView addSubview:_arcOrMrcGameView];
            
            //将控件存入入数组中
            [_coinBtnArray addObject:_arcOrMrcGameView.betBtn];
            [_breathImgArray addObject:_arcOrMrcGameView.breathImg];
            [_betViewArray addObject:_arcOrMrcGameView];
        }
        
    }
}

- (void)setBetBtnWithIsSelected:(BOOL )isSelected andBtn:(UIButton *)button
{
    if (isSelected) {
        [button setBackgroundImage:[UIImage imageNamed:@"gm_selectedBet"] forState:UIControlStateNormal];
        [button setTitleColor:kColorWithStr(@"fbeda5") forState:UIControlStateNormal];
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"gm_normalBet"] forState:UIControlStateNormal];
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }
}

#pragma mark    ------------------------------------网络请求--------------------------------------
#pragma mark  --  押注发送请求
- (void)postBetMoneyStr:(NSString *)str withTag:(NSInteger)tag
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"bet" forKey:@"act"];
    [parmDict setObject:str  forKey:@"id"];
    [parmDict setObject:_betMoney forKey:@"money"];
    [parmDict setObject:[NSString stringWithFormat:@"%ld",(long)_bet] forKey:@"bet"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"----%@",responseJson);
        if ([responseJson toInt:@"status"] == 1)
        {
            NSDictionary *dataDic = [responseJson objectForKey:@"data"];
            NSDictionary *dic = [dataDic objectForKey:@"game_data"];
            
            if (_fanweApp.appModel.open_diamond_game_module == 1)
            {
                _currentMoney = [[IMAPlatform sharedInstance].host getDiamonds];
            }
            else
            {
                _currentMoney = [[IMAPlatform sharedInstance].host getUserCoin];
            }
            
            //更新押注信息
            if ([dic[@"bet"] isKindOfClass:[NSArray class]]&& [dic[@"user_bet"] isKindOfClass:[NSArray class]]) {
                [self loadBetDataWithBetArray:dic[@"bet"] andUserBetArray:dic[@"user_bet"]];
            }
            //更新金币
            if (_currentMoney >= 0 && _currentMoney >= [_betMoney integerValue])
            {
                _currentMoney -= [_betMoney integerValue];
                _gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",(long)_currentMoney];
                
                if (_fanweApp.appModel.open_diamond_game_module == 1)
                {
                    //存入本地
                    [[IMAPlatform sharedInstance].host setDiamonds:[NSString stringWithFormat:@"%ld",(long)_currentMoney]];
                }
                else
                {
                    //存入本地
                    [[IMAPlatform sharedInstance].host setUserCoin:[NSString stringWithFormat:@"%ld",(long)_currentMoney]];
                }
                
            }
            [self coinBreathMove:_currentMoney];
            [self judgmentBetView:[_gameRechargeView.accountLabel.text integerValue]];
        }
        else
        {
            [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
        }
    } FailureBlock:^(NSError *error) {
        [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}

#pragma mark  --  更新余额
- (void)updateCoinWithID:(NSString *)ID
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"userDiamonds" forKey:@"act"];
    if (ID != nil) {
        [parmDict setObject:ID forKey:@"id"];
    }
    
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            GameGainModel * gainModel = [GameGainModel mj_objectWithKeyValues:responseJson];
            NSInteger gainInt = [responseJson toInt:@"gain"];
            
            if (_fanweApp.appModel.open_diamond_game_module == 1)
            {
                _currentMoney = [[responseJson toString:@"user_diamonds"] integerValue];
                //存入钻石
                [[IMAPlatform sharedInstance].host setDiamonds:[responseJson toString:@"user_diamonds"]];
            }
            else
            {
                _currentMoney = [[responseJson toString:@"coin"] integerValue];
                //存入游戏币
                [[IMAPlatform sharedInstance].host setUserCoin:[responseJson toString:@"coin"]];
            }
            
            if (ID != nil) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _gameRechargeView.accountLabel.text =  [NSString stringWithFormat:@"%ld",(long)_currentMoney];
                    //押注按钮颜色变化
                    if (!_isHost) {
                        [self judgmentBetView:[_gameRechargeView.accountLabel.text integerValue]];
                    }
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (gainInt > 0) {
                        if (_delegate && [_delegate respondsToSelector:@selector(displayGameWinWithGainModel:)]) {
                            [_delegate displayGameWinWithGainModel:gainModel];
                        }
                    }
                });
            }else{
                _gameRechargeView.accountLabel.text =  [NSString stringWithFormat:@"%ld",(long)_currentMoney];
                //押注按钮颜色变化
                if (!_isHost) {
                    [self judgmentBetView:[_gameRechargeView.accountLabel.text integerValue]];
                }
            }
        }
    } FailureBlock:^(NSError *error) {
        NSLog(@"---%@",error);
    }];
}

#pragma mark    主播结束游戏
- (void)gameOver
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"stop" forKey:@"act"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        _canCloseGame = YES;
        if ([responseJson toInt:@"status"] == 1)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"closeGame" object:nil];
        }
    } FailureBlock:^(NSError *error) {
        _canCloseGame = YES;
        [[FWHUDHelper sharedInstance] tipMessage:@"关闭游戏失败"];
        NSLog(@"---%@",error);
    }];
}

#pragma mark    更新余额
- (void)updateCoin
{
    [self updateCoinWithID:nil];
}

#pragma mark    -----------------------------------押注相关--------------------------------
#pragma mark    点击押注
- (void)coinMove:(UITapGestureRecognizer *)tap
{
    if (!_isHost && _canBet)
    {
        if ([_gameRechargeView.accountLabel.text integerValue] >= [[self.betOptionArray objectAtIndex:0] integerValue])
        {
            [self betProcessing:tap.view.tag];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"金额不足，请充值"];
        }
    }
}

#pragma mark    押注进行中
- (void)betProcessing:(NSInteger)tag
{
    _bet = tag;
    //发送请求
    [self postBetMoneyStr:_game_log_id withTag:tag-1];
    //  //余额减少
    //  NSInteger coinInt = [_coinView.personCoinLab.text integerValue] - [_betMoney integerValue];
    //  _coinView.personCoinLab.text = [NSString stringWithFormat:@"%d",coinInt];
    //金币移动
    CGPoint imagePoint = [[_coinMoveArray objectAtIndex:tag-1] CGPointValue];
    [self coinMoveWithBegin:_amountPoint WithEnd:imagePoint];
}

#pragma mark    选择押注金额或游戏记录
- (void)selectAmount:(UIButton *)sender
{
    if (_isHost) {
        //(tag==204 代表游戏记录按钮)
        if (sender.tag == 204) {
            _betView = [_betViewArray objectAtIndex:0];
            
            if (_delegate && [_delegate respondsToSelector:@selector(displayGameHistory)]) {
                [_delegate displayGameHistory];
            }
            
        }
        else if (sender.tag == 206)
        {
            if (_betViewArray.count>2) {
                _betView = [_betViewArray objectAtIndex:2];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(choseArcOrMrcGameWithView:)]) {
                [_delegate choseArcOrMrcGameWithView:self];
            }
        }
        else{
            if (_betViewArray.count>1) {
                _betView = [_betViewArray objectAtIndex:1];
            }
            if (_canCloseGame)
            {
                FWWeakify(self)
                [FanweMessage alert:nil message:@"是否确定结束游戏？" destructiveAction:^{
                    
                    FWStrongify(self)
                    self.canCloseGame = NO;
                    //主播结束游戏
                    [self gameOver];
                    
                } cancelAction:^{
                    
                }];
            }
            else
            {
                [[FWHUDHelper sharedInstance] tipMessage:@"关闭游戏中，请稍后！"];
            }
        }
    }
    else
    {
        _betView = [_betViewArray objectAtIndex:sender.tag-200];
        
        if (sender.tag != 204) {
            if ([_gameRechargeView.accountLabel.text integerValue] < [[self.betOptionArray objectAtIndex:sender.tag-200] integerValue])
            {
                [[FWHUDHelper sharedInstance] tipMessage:@"余额不足"];
                return;
            }
            else
            {
                _isClick = !_isClick;
                _betCount = sender.tag-200;
                //为什么不行～_～!!!!!
                //[_coinBtnArray makeObjectsPerformSelector:@selector(removeBreathAnimation:) withObject:sender];
                for (BetView * betView in _betViewArray) {
                    if (![betView isEqual:_historyView]) {
                        [self setBetBtnWithIsSelected:[betView isEqual:_betView] andBtn:betView.betBtn];
                    }
                }
                [self getCoinBreathAndPoint:sender.tag-200];
            }

        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(displayGameHistory)]) {
                [_delegate displayGameHistory];
            }
        }
    }
    //加入抖动动画
    [_betView.layer addAnimation:[CAAnimation jitterAnimation] forKey:@"jitter"];
}

#pragma mark    押注按钮颜色变暗（金额不足时）
- (void)judgmentBetView:(NSInteger)coin
{
    if (self.betOptionArray.count > 0 && self.betOptionArray.count < self.coinBtnArray.count) {
        
        [self.betOptionArray enumerateObjectsUsingBlock:^(NSString *betOptionStr, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger betOptionInt = [betOptionStr integerValue];
            UIButton *btn= (UIButton *)_coinBtnArray[idx];
            if (coin >= betOptionInt) {
                btn.userInteractionEnabled = YES;
                btn.alpha = 1;
            }
            else
            {
                btn.userInteractionEnabled = NO;
                btn.alpha = 0.3;
            }
            
        }];
        
    }
    
}

#pragma mark    判断呼吸灯位置（金额减少时）
- (void)coinBreathMove:(NSInteger)currentGold
{
    if (currentGold >= 0 && currentGold < [_betMoney integerValue])
    {
        if (currentGold >=[[self.betOptionArray objectAtIndex:2]integerValue])
        {
            _betCount = 2;
        }
        else if (currentGold >= [[self.betOptionArray objectAtIndex:1]integerValue])
        {
            _betCount = 1;
        }
        else
        {
            _betCount = 0;
        }
        [self getCoinBreathAndPoint:_betCount];
    }
}

#pragma mark    加入呼吸灯和获取金币移动的起始位置
- (void)getCoinBreathAndPoint:(NSInteger)tag
{
    //获取押注金额
    if (_betOptionArray.count > 0) {
        _betMoney = [_betOptionArray objectAtIndex:tag];
    }
//    //移除呼吸灯动画
//    for (UIImageView *imageView in _breathImgArray) {
//        imageView.image = [UIImage imageNamed:@""];
//        [imageView.layer removeAnimationForKey:@"alpha"];
//    }
//    //加入呼吸灯动画
//    UIImageView *img = [_breathImgArray objectAtIndex:tag];
//    img.image = [UIImage imageNamed:@"gm_coin_breath"];
//    [img.layer addAnimation:[CAAnimation AlphaLight:1.0f
//                                          fromValue:1.0f
//                                            toValue:0.4f]
//                     forKey:@"alpha"];
    //获取金币开始动画的位置
    CGPoint point = [[_coinBeignArray objectAtIndex:tag] CGPointValue];
    _amountPoint = [_buttomView convertPoint:point toView:self];
}

#pragma mark    -----------------------------------金币相关动画-----------------------------------
#pragma mark    金币移动动画(传入起始位置和终点位置)
- (void)coinMoveWithBegin:(CGPoint)begin WithEnd:(CGPoint)end
{
    UIImageView *breathImg = [[UIImageView alloc]init];
    breathImg.width = 25;
    breathImg.height = 25;
    if (!_isClick && NSStringFromCGPoint(_winCoinPoint).length == 0) {
        breathImg.center = _amountPoint;
    }
    else
    {
        breathImg.center = begin;
    }
    
    breathImg.image = [UIImage imageNamed:@"gm_selectedBet"];
    [self addSubview:breathImg];
    
    if (!_isClick) {
        [breathImg.layer addAnimation:[CAAnimation coinMoveAntimationWithBegin:breathImg.center
                                                                       WithEnd:end
                                                                   andMoveTime:kMoveAnimationDuration
                                                                 andNarrowTime:kNarrowAnimationDuration
                                                            andNarrowFromValue:1.0f
                                                              andNarrowToValue:0.0f]
                               forKey:@"moveWithNarrow"];
    }
    else
    {
        [breathImg.layer addAnimation:[CAAnimation coinMoveAntimationWithBegin:begin
                                                                       WithEnd:end
                                                                   andMoveTime:kMoveAnimationDuration
                                                                 andNarrowTime:kNarrowAnimationDuration
                                                            andNarrowFromValue:1.0f
                                                              andNarrowToValue:0.0f]
                               forKey:@"moveWithNarrow"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kCoinMoveAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (breathImg) {
            [breathImg removeFromSuperview];
        }
    });
    
}

#pragma mark 加载押注倍率
-(void)loadOptionArray:(NSArray *)optionArray
{
    if (optionArray.count == self.betMultipleLabelArr.count ) {
        for (int i=0; i<optionArray.count; ++i) {
            UILabel * optionLabel = self.betMultipleLabelArr[i];
            if ([optionArray[i] floatValue]>0) {
                optionLabel.text = [NSString stringWithFormat:@"X%@",optionArray[i]];
                optionLabel.hidden = NO;
            }
            else
            {
                optionLabel.hidden = YES;
            }
        }
    }
}

//总押注数据
-(NSMutableArray *)betArr
{
    if (_betArr == nil) {
        _betArr = [NSMutableArray array];
    }
    return _betArr;
}

//用户本人押注数据
-(NSMutableArray *)userBetArr
{
    if (_userBetArr == nil) {
        _userBetArr = [NSMutableArray array];
    }
    return _userBetArr;
}

//总押注数据label
-(NSMutableArray *)betLabelArr
{
    if (_betLabelArr == nil) {
        _betLabelArr = [NSMutableArray array];
    }
    return _betLabelArr;
}

//用户押注数据label
-(NSMutableArray *)userBetLabelArr
{
    if (_userBetLabelArr == nil) {
        _userBetLabelArr = [NSMutableArray array];
    }
    return _userBetLabelArr;
}

/**
 下注倍率label
 */
- (NSMutableArray *)betMultipleLabelArr
{
    if (!_betMultipleLabelArr) {
        _betMultipleLabelArr = [NSMutableArray array];
    }
    return _betMultipleLabelArr;
}

/**
遮罩视图
*/
- (NSMutableArray *)maskViewArr
{
    if (!_maskViewArr) {
        _maskViewArr = [NSMutableArray array];
    }
    return _maskViewArr;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_showDiceTimer) {
        [_showDiceTimer invalidate];
        _showDiceTimer = nil;
    }
}
@end
