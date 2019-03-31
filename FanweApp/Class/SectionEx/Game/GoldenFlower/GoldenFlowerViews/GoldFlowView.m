//
//  GoldFlowView.m
//  GoldenFlowerDemo
//
//  Created by GuoMs on 16/11/17.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import "GoldFlowView.h"
#import "PokerStr.h"
#import "THLabel.h"
#define space 10
#define pokerY 5
#define pokerH 93

NS_ENUM(NSInteger, LicensingPosition)
{
    LicensingPosition_Left = 4,   // 发牌到最左边第一张位置
    LicensingPosition_Between,    // 发牌到中间第二张位置
    LicensingPosition_Right,   // 发牌到最右边第三张位置
};
NS_ENUM(NSInteger, LotPokerPosition)
{
    LotPokerPosition_Left = 1,   // 发牌到最左边
    LotPokerPosition_Between,    // 发牌到中间
    LotPokerPosition_Right,   // 发牌到最右边
};
@interface GoldFlowView()
@end

@implementation GoldFlowView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self closeGameAboutTimer];
    if (_showPokerTimer) {
        [_showPokerTimer invalidate];
        _showPokerTimer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame withBetArray:(NSArray *)betArray withIsHost:(BOOL ) isHost
{
    if (self = [super initWithFrame:frame]) {
        _httpManager = [NetHttpsManager manager];
        _fanweApp = [GlobalVariables sharedInstance];
        [self updateCoinWithID:nil];
        //        self.backgroundColor = kGrayTransparentColor4_1;
        self.backgroundColor = [UIColor clearColor];
        _isHost = isHost;
        
        if (!_coinMoveArray) {
            _coinMoveArray      = [[NSMutableArray alloc]init];
            _coinBtnArray       = [[NSMutableArray alloc]init];
            _coinBeignArray     = [[NSMutableArray alloc]init];
            _betViewArray       = [[NSMutableArray alloc]init];
            _breathImgArray     = [[NSMutableArray alloc]init];
            _betMoneyLabArray   = [[NSMutableArray alloc]init];
            self.betOptionArray = betArray;
        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCoin) name:@"updateCoin" object:nil];
        _animationIMG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20+2*kPokerH+15)];
        //        _animationIMG.image = [UIImage imageNamed:@"gm_bet_tables"];
        _animationIMG.backgroundColor = kGrayTransparentColor4_1;
        
        if (_isHost)
        {
            _animationIMG.userInteractionEnabled = NO;
        }
        [self addSubview:_animationIMG];
        [self createCoinView];
        _isStartOpenCard = NO;//是否开牌赋初始值
        _isStopAnimation = NO;
        _canCloseGame    = YES;
    }
    return self;
}

- (void)setIsArc:(BOOL)isArc
{
    _isArc = isArc;
    NSString * imageStr = isArc ? @"gm_game_arcBtn" : @"gm_game_mrcBtn";
    [_arcOrMrcGameView.betBtn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}

#pragma mark -- 游戏准备
- (void)gameToPrepareTypeGoldenFlowerOrBull:(NSString *)type card:(NSArray *)card{
    NSLog(@"%@",type);
    [self creatPokerhiden:YES gameType:type card:card];//炸金花or斗牛,德州扑克
    [self creatBetAmount:YES type:type];
    [self beAbleToLicensingType:type];
}
#pragma mark -- 即将发牌等待中
- (void)beAbleToLicensingType:(NSString *)type{
    //隐藏遮罩
    self.firstView.hidden = YES;
    self.secondView.hidden = YES;
    self.thirdView.hidden = YES;
    if (!_willStartIMG) {
        _willStartIMG = [UIImageView new];
    }
    _willStartIMG.frame = CGRectMake(80, 40, [UIScreen mainScreen].bounds.size.width - 160, 26);
    [self.animationIMG addSubview:_willStartIMG];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self licensingGameTypeGoldenFlowerOrBull:type];
    });
}

- (void)createCoinView
{
    if (!_coinView)
    {
        _coinView = [CoinView EditNibFromXib];
        //_coinView.gameRechargeView.userInteractionEnabled = YES;
        _coinView.frame = CGRectMake(0, 20+2*kPokerH+15, kScreenW, 40);
        _coinView.backgroundColor = kGrayTransparentColor5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recharge)];
        [_coinView.gameRechargeView.backGroundView addGestureRecognizer:tap];
        [self addSubview:_coinView];
        // 金币余额的中心位置
        _coinPoint = CGPointMake(17.5, 40+2*kPokerH);
    }
    [self createBetView];
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
                _betView.frame = CGRectMake((kScreenW -180) + i*(betButtonInterval +betButtonWidth), 0, 40, 40);
                _betView.betBtn.tag = i+200;
                
                if (_betOptionArray.count > 0)
                {
                    [_betView.betBtn setTitle:[NSString stringWithFormat:@"%@",[self.betOptionArray objectAtIndex:i]] forState:UIControlStateNormal];
                }
                [_betView.betBtn setBackgroundImage:[UIImage imageNamed:@"gm_selectedBet"] forState:UIControlStateNormal];
                [_betView.betBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
                if (i == 0) {
                    //获取betView在当前视图的位置
                    _amountPoint = [_coinView convertPoint:_betView.center toView:self];
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
                
                [_coinView addSubview:_betView];
            }
        }
    }
    
    //历史记录
    if (!_historyView) {
        _historyView = [BetView EditNibFromXib];
        _historyView.delegate = self;
        if (_isHost) {
            _historyView.frame = CGRectMake((kScreenW - 180)+3*(betButtonInterval +betButtonWidth), 0, 40, 40);
        }
        else
        {
            _historyView.frame = CGRectMake((kScreenW - 180)+4*(betButtonInterval +betButtonWidth), 0, 40, 40);
        }
        _historyView.betBtn.tag = 204;
        [_historyView.betBtn setBackgroundImage:[UIImage imageNamed:@"gm_history"] forState:UIControlStateNormal];
        [_coinView addSubview:_historyView];
        
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
            _gameOverView.frame = CGRectMake((kScreenW -180)+4*(betButtonInterval +betButtonWidth), 0, 40, 40);
            _gameOverView.betBtn.tag = 205;
            [_gameOverView.betBtn setBackgroundImage:[UIImage imageNamed:@"gm_game_closeBtn"] forState:UIControlStateNormal];
            [_coinView addSubview:_gameOverView];
            
            //将控件存入入数组中
            [_coinBtnArray addObject:_gameOverView.betBtn];
            [_breathImgArray addObject:_gameOverView.breathImg];
            [_betViewArray addObject:_gameOverView];
        }
        //手动发牌与自动发牌
        if (!_arcOrMrcGameView && kSupportArcGame) {
            _arcOrMrcGameView = [BetView EditNibFromXib];
            _arcOrMrcGameView.delegate = self;
            _arcOrMrcGameView.frame = CGRectMake((kScreenW -180)+2*(betButtonInterval +betButtonWidth), 0, 40, 40);
            _arcOrMrcGameView.betBtn.tag = 206;
            [_arcOrMrcGameView.betBtn setBackgroundImage:[UIImage imageNamed:@"gm_game_mrcBtn"] forState:UIControlStateNormal];
            [_coinView addSubview:_arcOrMrcGameView];
            
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

#pragma mark -------------------------发牌动画----------------------------
#pragma mark -- 正在发牌中
- (void)licensingGameTypeGoldenFlowerOrBull:(NSString *)type{
    _movingIMG.hidden = NO;//显示下面发牌的位置
    [self.pokerArray removeAllObjects];
    [self.animationArray removeAllObjects];
    _count = 0;
    if (_isHost == NO) {
        _canBet = NO;
        _animationIMG.userInteractionEnabled = _canBet;
    }
    //发牌方法一
    // 将九扑克加到数组中(咋金花)
    if ([type isEqualToString:@"1"]) {
        for (int i=0; i<3; ++i){
            [self.pokerArray addObject:[self.smallArray[i] pokerOne]];
            [self.pokerArray addObject:[self.smallArray[i] pokerTwo]];
            [self.pokerArray addObject:[self.smallArray[i] pokerThree]];
        }
        for (int i=0; i<self.pokerArray.count; ++i) {
            [self playVoiceWithNumber:1.5];
            [self.animationArray addObject:[self drawTrajectoryWithPokerView:self.smallArray[i/3] imageView:self.pokerArray[i] andBeginTime:i*0.2]];
        }
        
    }else if ([type isEqualToString:@"2"]){// 将15扑克加到数组中(斗牛)
        for (int i=0; i<3; i++) {
            [self.pokerArray addObject:[self.smallArray[i] BullPokerOne]];
            [self.pokerArray addObject:[self.smallArray[i] BullPokerTwo]];
            [self.pokerArray addObject:[self.smallArray[i] BullPokerThree]];
            [self.pokerArray addObject:[self.smallArray[i] BullPokerFour]];
            [self.pokerArray addObject:[self.smallArray[i] BullPokerFive]];
        }
        
        for (int i=0; i<self.pokerArray.count; ++i) {
            [self playVoiceWithNumber:2.5];
            [self.animationArray addObject:[self drawTrajectoryWithPokerView:self.smallArray[i/5] imageView:self.pokerArray[i] andBeginTime:i*0.2]];
        }
    }else if ([type isEqualToString:@"3"]){//德州扑克
        for (int i=0; i<3; i++) {
            if (i==0) {
                [self.pokerArray addObject:[self.smallArray[i] texasLeftAndRightOne]];
                [self.pokerArray addObject:[self.smallArray[i] texasLeftAndRightTwo]];
            }else if (i==1){
                [self.pokerArray addObject:[self.smallArray[i] texasPokerOne]];
                [self.pokerArray addObject:[self.smallArray[i] texasPokerTwo]];
                [self.pokerArray addObject:[self.smallArray[i] texasPokerThree]];
                [self.pokerArray addObject:[self.smallArray[i] texasPokerFour]];
                [self.pokerArray addObject:[self.smallArray[i] texasPokerFive]];
                
            }else if (i==2){
                [self.pokerArray addObject:[self.smallArray[i] texasLeftAndRightOne]];
                [self.pokerArray addObject:[self.smallArray[i] texasLeftAndRightTwo]];
            }
        }
        for (int i=0; i<self.pokerArray.count; ++i) {
            [self playVoiceWithNumber:1.5];
            if (i<2) {//左边两张牌的动画
                [self.animationArray addObject:[self drawTrajectoryWithPokerView:self.smallArray[0] imageView:self.pokerArray[i] andBeginTime:i*0.2]];
            }else if (i >= 2 && i < 7){//中间的五张牌
                [self.animationArray addObject:[self drawTrajectoryWithPokerView:self.smallArray[1] imageView:self.pokerArray[i] andBeginTime:i*0.2]];
            }else if (i >= 7){//右边的两张牌
                [self.animationArray addObject:[self drawTrajectoryWithPokerView:self.smallArray[2] imageView:self.pokerArray[i] andBeginTime:i*0.2]];
            }
            
        }
        
        
    }
    
    //发牌方法二
    //    for (int i=0; i<3; ++i) {
    //        if (i== 0) {
    //            for (int j=0; j<3; ++j) {
    //                [self.pokerArray addObject:[self.smallArray[j] pokerOne]];
    //            }
    //        }
    //        else if (i== 1) {
    //            for (int j=0; j<3; ++j) {
    //                [self.pokerArray addObject:[self.smallArray[j] pokerTwo]];
    //            }
    //        }
    //        else if (i== 2)
    //        {
    //            for (int j=0; j<3; ++j) {
    //                [self.pokerArray addObject:[self.smallArray[j] pokerThree]];
    //            }
    //        }
    //    }
    //    for (int i=0; i<self.pokerArray.count; ++i) {
    //        //添加发牌音效
    //        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"dealsound" ofType:@"mp3"];
    //        NSURL *url= [NSURL URLWithString:filePath];
    //        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    //        _audioPlayer.numberOfLoops = 4;
    //        [_audioPlayer play];
    //        [self.animationArray addObject:[self drawTrajectoryWithPokerView:self.smallArray[i%3] imageView:self.pokerArray[i] andBeginTime:i*0.2]];
    //    }
    _groupAntimation = [CAAnimationGroup animation];
    _groupAntimation.animations = self.animationArray;
    _groupAntimation.duration = 0.2*self.animationArray.count;
    _groupAntimation.delegate = self;
    [_groupAntimation setValue:@"groupAnimation" forKey:@"animationName"];
    [_movingIMG.layer addAnimation:_groupAntimation forKey:nil];
    
    if (_prokerTimer == nil) {
        _prokerTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(closeHide) userInfo:nil repeats:YES];
    }
    
}
#pragma mark -- 发牌音效
- (void)playVoiceWithNumber:(float) number{
    //添加发牌音效
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"dealsound" ofType:@"mp3"];
    NSURL *url= [NSURL URLWithString:filePath];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _audioPlayer.numberOfLoops = number;
    [_audioPlayer play];
}
#pragma mark -- 关闭发牌音效
- (void)closeVideo{
    [_audioPlayer pause];
}
- (void)closeHide
{
    if (_count>self.pokerArray.count-1) {
        [_prokerTimer invalidate];
        _prokerTimer = nil;
        _groupAntimation = nil;
        return;
    }
    UIImageView * proker = self.pokerArray[_count];
    proker.hidden = NO;
    _count++;
    
}

- (void)endAnmination
{
    [_animationIMG.layer removeAllAnimations];
    if (_groupAntimation) {
        _groupAntimation = nil;
    }
    [self closeVideo];
    if (_prokerTimer) {
        [_prokerTimer invalidate];
        _prokerTimer = nil;
    }
    for (UIImageView * poker in _pokerArray) {
        poker.hidden = NO;
    }
}

#pragma mark -- 画发牌的运动轨迹
-(CAAnimationGroup *)drawTrajectoryWithPokerView:(PokerView *)pokerView imageView:(UIImageView *)imageView andBeginTime:(float) antionBegintime{
    //获取发牌的起始位置
    PokerDownView *pokerDownView = [self.animationIMG viewWithTag:LotPokerPosition_Between];
    //动态计算开始位置与起始位置
    CGRect pokerOneFrame = CGRectMake(imageView.frame.origin.x + pokerView.frame.origin.x, imageView.frame.origin.y + pokerView.frame.origin.y,imageView.frame.size.width, imageView.frame.size.height) ;
    CGRect movingIMGFrame = CGRectMake(_movingIMG.frame.origin.x + pokerDownView.frame.origin.x, _movingIMG.frame.origin.y +  pokerDownView.frame.origin.y, _movingIMG.frame.size.height, _movingIMG.frame.size.width);
    
    //移动横向位置
    CABasicAnimation *basicAnimationx = [CABasicAnimation animationWithKeyPath: @"position.x"];
    basicAnimationx.fromValue = @(_movingIMG.frame.origin.x);
    basicAnimationx.toValue = @(pokerOneFrame.origin.x - movingIMGFrame.origin.x);
    
    //移动纵向位置
    CABasicAnimation *basicAnimationy = [CABasicAnimation animationWithKeyPath: @"position.y"];
    basicAnimationy.fromValue = @(_movingIMG.frame.origin.y);
    basicAnimationy.toValue = @(pokerOneFrame.origin.y - movingIMGFrame.origin.y + 45);
    
    //移动中的放大过程
    CAKeyframeAnimation *scaleFrom = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleFrom.values = @[@990];
    
    
    //添加组动画
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.beginTime = antionBegintime;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.duration = 0.2;
    group.animations = @[scaleFrom,basicAnimationx,basicAnimationy];
    
    return group;
}
#pragma mark -- 发牌结束操作
//主播
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag){
        NSString *animationName = [anim valueForKey:@"animationName"];
        if ([animationName isEqualToString:@"groupAnimation"])
        {
            PokerDownView *pokerDownView = self.betImageArray[1];
            pokerDownView.lotPokerIMG.hidden = YES;
            pokerDownView.amountBetLable.hidden = NO;
            _willStartIMG.hidden = _isHost ? YES : NO;
            _willStartIMG.image = [UIImage imageNamed:@"gm_xzxyqy"];
            _isStopAnimation = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _timeLable.hidden = NO;//显示倒计时控件
                _alarmClock.hidden = NO;
                _willStartIMG.hidden = YES;
                if (!_isHost && !_banker)
                {
                    _animationIMG.userInteractionEnabled = YES;
                }
                else if (!_isHost && _banker)
                {
                    _animationIMG.userInteractionEnabled = NO;
                }
                
            });
        }
    }
}
#pragma mark -------------------------开牌倒计时----------------------------
#pragma mark -- 倒计时(观众与主播通过getVideo接口获取游戏信息时调用)
- (void)timeCountDown:(int)time{
    PokerDownView *pokerDownView = [_animationIMG viewWithTag:LotPokerPosition_Between];
    pokerDownView.lotPokerIMG.hidden = YES;
    pokerDownView.amountBetLable.hidden = NO;
    _willStartIMG.hidden = _isHost ? YES : NO;
    _willStartIMG.image = [UIImage imageNamed:@"gm_xzxyqy"];
    _timeLable.hidden = NO;//显示倒计时控件
    _alarmClock.hidden = NO;
    _timeLable.text = [NSString stringWithFormat:@"%02d",time];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _willStartIMG.hidden = YES;
        [self overPokerKJTime:time];
    });
    
}
#pragma mark -- 发牌结束进入倒计时操作(主播端)
- (void)overPokerKJTime:(int)time{
    _timeLable.text =  [NSString stringWithFormat:@"%02d",time];
    __block int timeout = time; //倒计时时间的设定秒数
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _gameTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_gameTimer,dispatch_walltime(NULL, 0),1.0 *NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_gameTimer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            [self cancelTimer];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                timeout--;
                if (timeout == 1) {
                    _compareImg = [[UIImageView alloc]initWithFrame:CGRectMake(_animationIMG.frame.size.width / 2 - 60, _animationIMG.frame.size.height / 3, 120, 20)];//比牌开始控件
                    _compareImg.hidden = YES;
                    [_animationIMG addSubview:_compareImg];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _compareImg.hidden = NO;
                        self.compareImg.image = [UIImage imageNamed:@"gm_bpks"];
                        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:10 options: UIViewAnimationOptionCurveLinear  animations:^{
                            self.compareImg.center = CGPointMake(self.compareImg.center.x, self.compareImg.center.y + 20);
                        } completion:^(BOOL finished) {
                            self.compareImg.center = CGPointMake(self.compareImg.center.x, self.compareImg.center.y - 20);
                            self.compareImg.hidden = YES;
                        }];
                        
                    });
                }
                //小于1秒的时候
                if (timeout < 1) {
                    
                    if (!_isHost) {
                        _animationIMG.userInteractionEnabled = NO;
                    }
                    _isStartOpenCard = YES;//开牌比较大小
                    _timeLable .hidden = YES;//当倒计时为1时候隐藏倒计时的控件,否则显示该控件
                    _alarmClock.hidden = YES;;
                    [self addTimer];
                }else{
                    _timeLable.text =  [NSString stringWithFormat:@"%02d",timeout];
                }
            });
        }
    });
    dispatch_resume(_gameTimer);
}

- (void)cancelTimer
{
    dispatch_source_cancel(_gameTimer);
    _gameTimer = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

- (void)closeGameAboutTimer
{
    if (_prokerTimer) {
        [_prokerTimer invalidate];
        _prokerTimer = nil;
    }
    if (_gameTimer) {
        dispatch_source_cancel(_gameTimer);
        _gameTimer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }
}

- (void)addTimer
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(reloadGameData)]) {
            [_delegate reloadGameData];
        }
    });
}


#pragma mark -------------------------比较大小----------------------------
#pragma mark -- 开牌比较大小(进入直播间,已经开牌的情况)
- (void)startOpenCard2:(NSDictionary *)leftdic between2:(NSDictionary *)betweendic rigth2:(NSDictionary *)rigthdic andResult:(NSInteger )result{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOpenCard:leftdic andPokerView:self.smallArray[0]];
        [self startOpenCard:betweendic andPokerView:self.smallArray[1]];
        [self startOpenCard:rigthdic andPokerView:self.smallArray[2]];
        if (![self.game_id isEqualToString:@"3"]) {
            [self winOrLoseWithReultInt:result];//显示输赢的遮罩
        }
        //每次比牌结束清空下注数据
        [self.betArr removeAllObjects];
        [self.userBetArr removeAllObjects];
    });
}

- (void)showPokerWithData:(NSArray *)dataPoker andResult:(NSString * )result
{
    _dic = @{@"dataPoker":dataPoker,@"pokerResult":result};
    if (_showPokerTimer) {
        [_showPokerTimer invalidate];
        _showPokerTimer = nil;
    }
    _showPokerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showPokerQuicklyWithPokerData) userInfo:nil repeats:NO];
}

- (void)showPokerQuicklyWithPokerData
{
    _showPokerTimer = nil;
    if (self.gameAction == 4)
    {
        [self startOpenCard:_dic[@"dataPoker"][0] andPokerView:self.smallArray[0]];
        [self startOpenCard:_dic[@"dataPoker"][1] andPokerView:self.smallArray[1]];
        [self startOpenCard:_dic[@"dataPoker"][2] andPokerView:self.smallArray[2]];
    }
    if (![self.game_id isEqualToString:@"3"])
    {
        [self winOrLoseWithReultInt:[_dic toInt:@"pokerResult"]];//显示输赢的遮罩
    }
    //每次比牌结束清空下注数据
    [self.betArr removeAllObjects];
    [self.userBetArr removeAllObjects];
}

#pragma mark -- 开牌比较大小
- (void)startOpenCard:(NSDictionary *)leftdic between:(NSDictionary *)betweendic rigth:(NSDictionary *)rigthdic andResult:(NSInteger )result gameId:(id)gameid{
    //    if ([gameid isEqualToString:@"3"]) {
    //
    //    }
    
    //第一副牌的显示
    if (self.gameAction == 4)
    {
        [self startOpenCard:leftdic andPokerView:self.smallArray[0]];
    }
    //第二副牌的显示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.gameAction == 4)
        {
            [self startOpenCard:betweendic andPokerView:self.smallArray[1]];
        }
    });
    //第三副牌显示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.gameAction == 4)
        {
            [self startOpenCard:rigthdic andPokerView:self.smallArray[2]];
        }
    });
    //显示三副牌的遮罩效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![gameid isEqualToString:@"3"])
        {
            [self winOrLoseWithReultInt:result];//显示输赢的遮罩
        }
        //每次比牌结束清空下注数据
        [self.betArr removeAllObjects];
        [self.userBetArr removeAllObjects];
    });
}
#pragma mark -- 比较大小,输赢牌的遮罩

- (void)winOrLoseWithReultInt:(NSInteger )result
{
    if (self.gameAction == 4) {
        if (result == 1) {
            self.firstView.hidden = YES;
        }else{
            self.firstView.hidden = NO;
        }
        if (result == 2) {
            self.secondView.hidden = YES;
        }else{
            self.secondView.hidden = NO;
        }
        if (result == 3) {
            self.thirdView.hidden = YES;
        }else{
            self.thirdView.hidden = NO;
        }
    }
    else
    {
        self.firstView.hidden = YES;
        self.secondView.hidden = YES;
        self.thirdView.hidden = YES;
    }
}

#pragma mark -- 直接展示全部牌
- (void)openCardWith:(NSArray *)gameDataArray
{
    if (gameDataArray.count == self.smallArray.count ) {
        for (int i=0; i<gameDataArray.count; ++i) {
            [self startOpenCard:gameDataArray[i] andPokerView:self.smallArray[i]];
        }
    }
}

#pragma mark -- 比较大小
- (void)startOpenCard:(NSDictionary *)dic andPokerView:(id)pokerView
{
    NSArray * arr = dic[@"cards"];
    if (arr.count>0) {
        NSString *pokerType =[PokerStr exchanegeGoldFlowerOrBullResultFromResultType:[dic[@"type"] intValue] goldFlowerOrBull:pokerView];//显示这张牌的类型
        [PokerStr aboutClassOfPokerOrBullPoker:pokerView dict:dic typeIMG:pokerType];
    }
}

#pragma mark -------------------------炸金花/斗牛/德州扑克视图创建----------------------------
#pragma mark -- 创建扑克牌视图(炸金花or斗牛type:1炸金花,2斗牛)
- (void)creatPokerhiden:(BOOL)hiden gameType:(NSString *)type card:(NSArray *)card{
    [self.smallArray removeAllObjects];
    [self.animationIMG.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < 3; i ++) {
        if ([type isEqualToString:@"1"]) {//炸金花判断
            [self creatFolwerGoldenPoker:i hiden:hiden];
        }else if ([type isEqualToString:@"2"]){//斗牛判断
            [self creatBullPoker:i hiden:hiden];
        }else if ([type isEqualToString:@"3"]){//德州扑克
            [self creatTexasPoker:i hiden:hiden card:card];
        }
    }
    //倒计时显示设置
    _alarmClock = [[UIImageView alloc]init];
    _alarmClock.image = [UIImage imageNamed:@"gm_clock"];
    _alarmClock.frame = CGRectMake((kScreenW-41)/2.0, kPokerH-20 , 41, 41);
    [self.animationIMG addSubview:_alarmClock];
    _alarmClock.hidden = YES;
    _timeLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 25,25)];
    _timeLable.textAlignment = NSTextAlignmentCenter;
    _timeLable.layer.masksToBounds = YES;
    _timeLable.layer.cornerRadius = 25.0 / 2;
    _timeLable.hidden = YES;//隐藏显示的倒计时
    _timeLable.textColor = kColorWithStr(@"fff3e1");
    //_timeLable.font = [UIFont fontWithName:@"GillSans-Bold" size:17];
    _timeLable.font = [UIFont systemFontOfSize:15];
    [_alarmClock addSubview: _timeLable];
    
}
#pragma mark -- 炸金花
- (void)creatFolwerGoldenPoker:(int)a hiden:(BOOL)hiden{
    _pokerView = [[NSBundle mainBundle]loadNibNamed:@"PokerView" owner:self options:nil].lastObject;
    _pokerView.frame = CGRectMake(10 * (a + 1) + pokerW * a, pokerY, pokerW, kPokerH);
    [_pokerView hidenPoker:hiden];//隐藏所有的牌
    [self.animationIMG addSubview:_pokerView];
    [self.smallArray addObject:_pokerView];
    
}
#pragma mark -- 斗牛
- (void)creatBullPoker:(int)a hiden:(BOOL)hiden{
    _bullPokerView = [[NSBundle mainBundle]loadNibNamed:@"BullPoker" owner:self options:nil].lastObject;
    _bullPokerView.frame = CGRectMake(10 * (a + 1) + pokerW * a, pokerY, pokerW, kPokerH);
    [_bullPokerView hidenBullPoker:hiden];//隐藏所有的牌
    [self.animationIMG addSubview:_bullPokerView];
    [self.smallArray addObject:_bullPokerView];
}
#pragma mark -- 德州扑克
- (void)creatTexasPoker:(int)a hiden:(BOOL)hiden card:(NSArray *)card{
    if (a == 0) {//德州扑克左边两张牌
        _texasLR = [[NSBundle mainBundle]loadNibNamed:@"TexasPokerLeftAndRight" owner:self options:nil].lastObject;
        _texasLR.frame = CGRectMake(10 * (a + 1) + kTexasSmallWidth * a, pokerY, kTexasSmallWidth, kPokerH);
        [_texasLR hidenTexasPoker:hiden];
        [self.animationIMG addSubview:_texasLR];
        [self.smallArray addObject:_texasLR];
    }else if (a == 1){//德州扑克中间5张牌
        _texasBetween = [[NSBundle mainBundle]loadNibNamed:@"TexasPokerBetween" owner:self options:nil].lastObject;
        _texasBetween.frame = CGRectMake(10 * (a + 1) + kTexasSmallWidth, pokerY, KtexasBigWidth, kPokerH);
        [_texasBetween hidenTexasPoker:hiden];//隐藏所有的牌
        [self.animationIMG addSubview:_texasBetween];
        [self.smallArray addObject:_texasBetween];
        if (card.count > 0) {
            //            _bullPokerView.playingCardView = [[NSBundle mainBundle]loadNibNamed:@"PlayingCardView" owner:self options:nil].lastObject;
            //            _bullPokerView.playingCardView.frame =  CGRectMake(0, 0,  _bullPokerView.pokWidth, _bullPokerView.pokHeight);
            //            [_bullPokerView.BullPokerOne addSubview:_bullPokerView.playingCardView];
            //            NSString *oneNumStr = [PokerStr exchangePokerNumberFromSuit:[card.firstObject intValue]andNumber:[card.lastObject intValue]];
            //            NSString *oneSmallSuit = [PokerStr exchangePokerSmallSuit:[card.firstObject intValue]];
            //            NSString *oneBigSuit =  [PokerStr exchangePokerBigSuitFromSuit:[card.firstObject intValue] andNumber:[card.lastObject intValue]];
            //            _bullPokerView.playingCardView.numberOfCard.image = [UIImage imageNamed:oneNumStr];
            //            _bullPokerView.playingCardView.smallSuit.image = [UIImage imageNamed:oneSmallSuit];
            //            _bullPokerView.playingCardView.bigSuit.image = [UIImage imageNamed:oneBigSuit];
            for (int i= 0; i<card.count; ++i) {
                _texasBetween.playingCardView = [[NSBundle mainBundle]loadNibNamed:@"PlayingCardView" owner:self options:nil].lastObject;
                _texasBetween.playingCardView.frame =  CGRectMake(0, 0,  _bullPokerView.pokWidth, _bullPokerView.pokHeight);
                _texasBetween.playingCardView.layer.cornerRadius = 5.0;
                _texasBetween.playingCardView.layer.masksToBounds = YES;
                _texasBetween.playingCardView.layer.borderWidth = 2.0;
                _texasBetween.playingCardView.layer.borderColor = kGoldFolwerColor.CGColor;
                NSArray * cardArray = card[i];
                NSString *oneNumStr = [PokerStr exchangePokerNumberFromSuit:[cardArray.firstObject intValue]andNumber:[cardArray.lastObject intValue]];
                NSString *oneSmallSuit = [PokerStr exchangePokerSmallSuit:[cardArray.firstObject intValue]];
                NSString *oneBigSuit =  [PokerStr exchangePokerBigSuitFromSuit:[cardArray.firstObject intValue] andNumber:[cardArray.lastObject intValue]];
                _texasBetween.playingCardView.numberOfCard.image = [UIImage imageNamed:oneNumStr];
                _texasBetween.playingCardView.smallSuit.image = [UIImage imageNamed:oneSmallSuit];
                _texasBetween.playingCardView.bigSuit.image = [UIImage imageNamed:oneBigSuit];
                //                if (i == 0) {
                //                    _texasBetween.texasPokerOne.hidden = NO;
                //                    [_texasBetween.texasPokerOne addSubview: _bullPokerView.playingCardView];
                //                }
                //                else if (i == 1)
                //                {
                //                    _texasBetween.texasPokerTwo.hidden = NO;
                //                    [_texasBetween.texasPokerTwo addSubview: _bullPokerView.playingCardView];
                //                }
                //                else if (i == 2)
                //                {
                //                     _texasBetween.texasPokerThree.hidden = NO;
                //                    [_texasBetween.texasPokerThree addSubview: _bullPokerView.playingCardView];
                //                }
                //                else if (i == 3 )
                //                {
                //                    _texasBetween.texasPokerFour.hidden = NO;
                //                    [_texasBetween.texasPokerFour addSubview: _bullPokerView.playingCardView];
                //                }
                //                else if (i == 4)
                //                {
                //                    _texasBetween.texasPokerFive.hidden = NO;
                //                    [_texasBetween.texasPokerFive addSubview: _bullPokerView.playingCardView];
                //                }
            }
        }
    }else if (a == 2){//德州扑克右边两张牌
        _texasLR = [[NSBundle mainBundle]loadNibNamed:@"TexasPokerLeftAndRight" owner:self options:nil].lastObject;
        _texasLR.frame = CGRectMake(10 * (a + 1) + kTexasSmallWidth+ KtexasBigWidth, pokerY, kTexasSmallWidth, kPokerH);
        [_texasLR hidenTexasPoker:hiden];
        [self.animationIMG addSubview:_texasLR];
        [self.smallArray addObject:_texasLR];
    }
}
#pragma mark -- 创建押注视图
- (void)creatBetAmount:(BOOL)hiden type:(NSString *)type{
    [self.betImageArray removeAllObjects];
    [self.betLabelArr removeAllObjects];
    [self.userBetLabelArr removeAllObjects];
    for (int i = 0; i < 3; i ++) {
        _pokerDownView = [[NSBundle mainBundle]loadNibNamed:@"PokerDownView" owner:self options:nil].lastObject;
        _pokerDownView.frame = CGRectMake(10 * (i + 1) + pokerW * i,23+kPokerH, pokerW, kPokerH+7);
        _pokerDownView.betPersonLable.textColor = kAppGrayColor1;
        if (i == 0) {
            //            if ([type isEqualToString:@"3"]) {
            //               _pokerDownView.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth * i, 23+kPokerH, kTexasSmallWidth, kPokerH+7);
            //            }
            _pokerDownView.tag = LotPokerPosition_Left;
        }else if (i == 1){
            //            _movingIMG = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0,( _pokerDownView.lotPokerIMG.frame.size.width / 3 + 10) / 10000,  (_pokerDownView.lotPokerIMG.frame.size.height / 3 + 20) / 10000)];
            //            if ([type isEqualToString:@"3"]) {
            //                _pokerDownView.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth , 23+kPokerH, KtexasBigWidth, kPokerH+7);
            //            }
            _movingIMG = [[UIImageView alloc]initWithFrame:CGRectMake(_pokerDownView.lotPokerIMG.frame.size.width / 2 , _pokerDownView.lotPokerIMG.frame.size.height / 2,( _pokerDownView.lotPokerIMG.frame.size.width / 3 + 10) / 990,  (_pokerDownView.lotPokerIMG.frame.size.height / 3 + 20) / 990)];
            [_pokerDownView.lotPokerIMG addSubview:_movingIMG];
            [self judgeImage:type];
            _movingIMG.hidden = hiden;
            _pokerDownView.tag = LotPokerPosition_Between;//发牌的起始位置
        }else if (i == 2){
            //            if ([type isEqualToString:@"3"]) {
            //                _pokerDownView.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth + KtexasBigWidth, 23+kPokerH, kTexasSmallWidth, kPokerH+7);
            //            }
            _pokerDownView.tag = LotPokerPosition_Right;
        }
        if (hiden) {
            if (i == 1) {
                _pokerDownView.amountBetLable.hidden = YES;
                _pokerDownView.lotPokerIMG.hidden = NO;
            }
            
        }
        //将押注的坐标保存起来（方便获取金币移动的位置）
        [_coinMoveArray addObject:[NSValue valueWithCGPoint:_pokerDownView.center]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coinMove:)];
        [_pokerDownView addGestureRecognizer:tap];
        [self.animationIMG addSubview:_pokerDownView];
        [self.betImageArray addObject:_pokerDownView];
        [_betMoneyLabArray addObject:_pokerDownView.betPersonLable];
    }
    for (int i= 0; i<3; ++i) {
        if ([type integerValue] == 1) {
            if (i== 0) {
                //  UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(6, 20+kPokerH, (kPokerH+10)*103.0/150.0, kPokerH+10)];
                UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(4, 17+kPokerH, (kPokerH+13)*103.0/150.0, kPokerH+13)];
                imageV.image = [UIImage imageNamed:@"gm_stake_one"];
                [self.animationIMG addSubview:imageV];
            }
            else if (i==1)
            {
                //            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(16+pokerW, 20+kPokerH, (kPokerH+10)*126.0/172.0, kPokerH+10)];
                UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(14+pokerW, 15+kPokerH, (kPokerH+15)*126.0/172.0, kPokerH+15)];
                imageV.image = [UIImage imageNamed:@"gm_stake_two"];
                [self.animationIMG addSubview:imageV];
            }
            else if (i==2)
            {
                //            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(26+2*pokerW, 20+kPokerH, (kPokerH+10)*133.0/176.0, kPokerH+10)];
                UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(24+2*pokerW, 13+kPokerH, (kPokerH+17)*133.0/176.0, kPokerH+17)];
                imageV.image = [UIImage imageNamed:@"gm_stake_three"];
                [self.animationIMG addSubview:imageV];
            }
        }
        else if ([type integerValue] == 2 || [type integerValue] == 3)
        {
            if (i== 0) {
                UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(4, 17+kPokerH, (kPokerH+13)*105.0/133.0, kPokerH+13)];
                imageV.image = [UIImage imageNamed:@"gm_bull_stake_one"];
                [self.animationIMG addSubview:imageV];
            }
            else if (i==1)
            {
                UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(14+pokerW, 17+kPokerH, (kPokerH+13)*105.0/133.0, kPokerH+13)];
                imageV.image = [UIImage imageNamed:@"gm_bull_stake_two"];
                [self.animationIMG addSubview:imageV];
            }
            else if (i==2)
            {
                UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(24+2*pokerW, 17+kPokerH, (kPokerH+13)*94.0/129.0, kPokerH+13)];
                imageV.image = [UIImage imageNamed:@"gm_bull_stake_three"];
                [self.animationIMG addSubview:imageV];
            }
        }
        CGFloat userBetLabelheight = (kPokerH+7)*40.0/143.0;
        THLabel * betLabel = [[THLabel alloc] initWithFrame:CGRectMake(10 * (i + 1) + pokerW * i, 23+kPokerH+(kPokerH+7-userBetLabelheight-30)/2.0, pokerW, 30)];
        //        if ([type integerValue] == 3) {
        //            if (i == 0) {
        //                betLabel.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth * i, 23+kPokerH+(kPokerH+7-userBetLabelheight-30)/2.0, kTexasSmallWidth, 30);
        //            }
        //            else if (i == 1) {
        //                betLabel.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth * i, 23+kPokerH+(kPokerH+7-userBetLabelheight-30)/2.0, KtexasBigWidth, 30);
        //            }
        //            else if (i == 2) {
        //                betLabel.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth + KtexasBigWidth, 23+kPokerH+(kPokerH+7-userBetLabelheight-30)/2.0, kTexasSmallWidth, 30);
        //            }
        //        }
        betLabel.textAlignment = NSTextAlignmentCenter;
        betLabel.textColor = [UIColor whiteColor];
        betLabel.font = [UIFont systemFontOfSize:23];
        betLabel.strokeColor = [UIColor blackColor];
        betLabel.strokeSize = 1.0;
        [self.betLabelArr addObject:betLabel];
        [self.animationIMG addSubview:betLabel];
        
        UILabel * userBetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * (i + 1) + pokerW * i, 30+2*kPokerH-userBetLabelheight, pokerW, userBetLabelheight)];
        //        if ([type integerValue] == 3) {
        //            if (i == 0) {
        //               userBetLabel.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth * i, 30+2*kPokerH-userBetLabelheight, kTexasSmallWidth, userBetLabelheight);
        //            }
        //            else if (i == 1) {
        //                userBetLabel.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth * i, 30+2*kPokerH-userBetLabelheight, KtexasBigWidth, userBetLabelheight);
        //            }
        //            else if (i == 2) {
        //                userBetLabel.frame = CGRectMake(10 * (i + 1) + kTexasSmallWidth + KtexasBigWidth, 30+2*kPokerH-userBetLabelheight, kTexasSmallWidth, userBetLabelheight);
        //            }
        //        }
        userBetLabel.textColor = [UIColor flatYellowColor];
        userBetLabel.font = [UIFont systemFontOfSize:15];
        userBetLabel.textAlignment = NSTextAlignmentCenter;
        [self.userBetLabelArr addObject:userBetLabel];
        [self.animationIMG addSubview:userBetLabel];
        //        [self.animationIMG bringSubviewToFront:[_betImageArray[i] amountBetLable]];
    }
    
}
#pragma mark -- 判断发牌图片及底牌图片
- (void)judgeImage:(NSString *)type{
    if ([type isEqualToString:@"1"] ||[type isEqualToString:@"3"]) {
        _movingIMG.image = [UIImage imageNamed:@"gm_poker_back_goldflower"];
        _pokerDownView.lotPokerIMG.image = [UIImage imageNamed:@"gm_img_goldflower"];
    }else if ([type isEqualToString:@"2"]){
        _movingIMG.image = [UIImage imageNamed:@"gm_poker_back_niuniu"];
        _pokerDownView.lotPokerIMG.image = [UIImage imageNamed:@"gm_img_niuniu"];
    }
    
}

- (void)recharge
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickRecharge)]) {
        [_delegate clickRecharge];
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
            if ([dic[@"bet"] isKindOfClass:[NSArray class]]&& [dic[@"user_bet"] isKindOfClass:[NSArray class]])
            {
                [self loadBetDataWithBetArray:dic[@"bet"] andUserBetArray:dic[@"user_bet"]];
            }
            //更新金币
            if (_currentMoney >= 0 && _currentMoney >= [_betMoney integerValue])
            {
                _currentMoney -= [_betMoney integerValue];
                _coinView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",(long)_currentMoney];
                
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
            [self judgmentBetView:[_coinView.gameRechargeView.accountLabel.text integerValue]];
        }
        
    } FailureBlock:^(NSError *error) {
        
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
                    _coinView.gameRechargeView.accountLabel.text =  [NSString stringWithFormat:@"%ld",(long)_currentMoney];
                    //押注按钮颜色变化
                    if (!_isHost) {
                        [self judgmentBetView:[_coinView.gameRechargeView.accountLabel.text integerValue]];
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
                _coinView.gameRechargeView.accountLabel.text =  [NSString stringWithFormat:@"%ld",(long)_currentMoney];
                //押注按钮颜色变化
                if (!_isHost) {
                    [self judgmentBetView:[_coinView.gameRechargeView.accountLabel.text integerValue]];
                }
            }
        }
    } FailureBlock:^(NSError *error) {
        
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
            //关闭游戏声音
            [self closeVideo];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"closeGame" object:nil];
        }
    } FailureBlock:^(NSError *error) {
        _canCloseGame = YES;
        [[FWHUDHelper sharedInstance] tipMessage:@"关闭游戏失败"];
        
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
    if (!_isHost)
    {
        if ([_coinView.gameRechargeView.accountLabel.text integerValue] >= [[self.betOptionArray objectAtIndex:0] integerValue])
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
    [self postBetMoneyStr:_game_log_id withTag:tag -1];
    //  //余额减少
    //  NSInteger coinInt = [_coinView.personCoinLab.text integerValue] - [_betMoney integerValue];
    //  _coinView.personCoinLab.text = [NSString stringWithFormat:@"%d",coinInt];
    //金币移动
    CGPoint imagePoint = [[_coinMoveArray objectAtIndex:tag -1] CGPointValue];
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
    _amountPoint = [_coinView convertPoint:point toView:self];
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

#pragma mark    ---------------------------------加载押注数据等------------------------------------
#pragma mark 加载更新押注数据
- (void)loadBetDataWithBetArray:(NSArray *)betArray andUserBetArray:(NSArray *)userBetArray
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
- (void)loadBetDesDataWithBetLabel:(THLabel *)betLabel andBetNumber:(id)betNumber
{
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
- (void)loadUserBetDesDataWithLabel:(UILabel *)userBetLabel andUserBetNumber:(id)userBetNumber
{
    if ([userBetNumber integerValue]>=10000) {
        float userBet = [userBetNumber integerValue]/10000.0;
        userBetLabel.text = [NSString stringWithFormat:@"%.1f万",userBet];
    }
    else
    {
        userBetLabel.text = [NSString stringWithFormat:@"%@",userBetNumber];
    }
}

#pragma mark 加载押注倍率
- (void)loadOptionArray:(NSArray *)optionArray
{
    if (optionArray.count == self.betImageArray.count ) {
        for (int i=0; i<optionArray.count; ++i) {
            PokerDownView * betView = _betImageArray[i];
            //押注倍率
            betView.betMultiple.text = [NSString stringWithFormat:@"%@倍",optionArray[i]];
        }
    }
}

#pragma mark    观众是否能够进行押注
- (void)whetherBet:(BOOL)isBet
{
    if (!_isHost) {
        _animationIMG.userInteractionEnabled = isBet;
    }
}

#pragma mark -- 懒加载
- (NSMutableArray *) betImageArray
{
    if (_betImageArray == nil) {
        _betImageArray = [NSMutableArray array];
    }
    return _betImageArray;
}

- (NSMutableArray *) pokerArray
{
    if (_pokerArray == nil) {
        _pokerArray = [NSMutableArray array];
    }
    return _pokerArray;
}

- (NSMutableArray *)animationArray
{
    if (_animationArray == nil) {
        _animationArray = [NSMutableArray array];
    }
    return _animationArray;
}

- (NSMutableArray *)smallArray
{
    if (_smallArray == nil) {
        _smallArray = [NSMutableArray array];
    }
    return _smallArray;
}

- (UIView *)firstView{
    if (!_firstView) {
        //第一副牌的遮罩
        self.firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 3, self.frame.size.height - _coinView.frame.size.height)];
        self.firstView.backgroundColor = [UIColor blackColor];
        self.firstView.alpha = 0.4;
        self.firstView.hidden = YES;
        [self addSubview:self.firstView];
    }
    return _firstView;
}

- (UIView *)secondView{
    if (!_secondView) {
        //第一副牌的遮罩
        self.secondView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW / 3, 0, kScreenW / 3, self.frame.size.height - _coinView.frame.size.height)];
        self.secondView.backgroundColor = [UIColor blackColor];
        self.secondView.hidden = YES;
        self.secondView.alpha = 0.4;
        [self addSubview:self.secondView];
    }
    return _secondView;
}

- (UIView *)thirdView{
    if (!_thirdView) {
        //第一副牌的遮罩
        self.thirdView = [[UIView alloc]initWithFrame:CGRectMake(2 * kScreenW / 3, 0, kScreenW / 3, self.frame.size.height - _coinView.frame.size.height)];
        self.thirdView.backgroundColor = [UIColor blackColor];
        self.thirdView.hidden = YES;
        self.thirdView.alpha = 0.4;
        [self addSubview:self.thirdView];
    }
    return _thirdView;
}
//总押注数据
- (NSMutableArray *)betArr
{
    if (_betArr == nil) {
        _betArr = [NSMutableArray array];
    }
    return _betArr;
}

//用户本人押注数据
- (NSMutableArray *)userBetArr
{
    if (_userBetArr == nil) {
        _userBetArr = [NSMutableArray array];
    }
    return _userBetArr;
}

//总押注数据label
- (NSMutableArray *)betLabelArr
{
    if (_betLabelArr == nil) {
        _betLabelArr = [NSMutableArray array];
    }
    return _betLabelArr;
}

//用户押注数据label
- (NSMutableArray *)userBetLabelArr
{
    if (_userBetLabelArr == nil) {
        _userBetLabelArr = [NSMutableArray array];
    }
    return _userBetLabelArr;
}

@end
