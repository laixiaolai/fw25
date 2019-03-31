//
//  GoldFlowView.h
//  GoldenFlowerDemo
//
//  Created by GuoMs on 16/11/17.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PokerView.h"
#import "PokerDownView.h"
#import "CoinView.h"
#import "BetView.h"
#import "BullPoker.h"
#import "TexasPokerLeftAndRight.h"
#import "TexasPokerBetween.h"
#import "GameGainModel.h"

@class GoldFlowView;
@protocol GoldFlowViewDelegate <NSObject>

// 显示充值
- (void)clickRecharge;
//让游戏记录弹出
- (void)displayGameHistory;
//弹出游戏获胜视图
- (void)displayGameWinWithGainModel:(GameGainModel *)gainModel;
//倒计时还是5秒时主动请求接口,防止推送接收不到出现的问题
-(void)reloadGameData;

-(void)choseArcOrMrcGameWithView:(GoldFlowView *)goldFlowView ;
@end

@interface GoldFlowView : UIView<CAAnimationDelegate,UIGestureRecognizerDelegate,BetViewDelegate>
{
    BullPoker *_bullPokerView;//存放五张扑克牌(斗牛)
    PokerView *_pokerView;//存放三张扑克牌炸金花)
    TexasPokerLeftAndRight *_texasLR;//存放左右两边的扑克牌(德州扑克)
    TexasPokerBetween *_texasBetween;//存放中间的五张扑克牌(德州扑克)
    PokerDownView *_pokerDownView;//存放押注视图
    BetView *_historyView;
    BetView *_gameOverView;//游戏结束
    UILabel *_timeLable;//显示倒计时
    NetHttpsManager *_httpManager;
    GlobalVariables *_fanweApp;
    CGPoint _amountPoint;   //押注金额的中心位置
    CGPoint _betPoint;      //押注视图的中心位置
    CGPoint _coinPoint;     //金币余额的中心位置
    CGPoint _winCoinPoint;  //游戏胜利金额的中心位置
    NSInteger _bet;         //押注区域选项
    NSInteger _betCount;    //押注金额的选项
    NSString *_betMoney;    //押注金额
    UIImageView *_breathImg; //金币动画的图片
    BOOL _isClick;      //是否点击
}
@property (nonatomic, assign)  BOOL isArc;
@property (nonatomic, strong)  BetView *arcOrMrcGameView;
@property (nonatomic, strong)  AVAudioPlayer *audioPlayer;//声音播放器
@property (weak,   nonatomic)    id<GoldFlowViewDelegate>delegate;
@property (nonatomic, strong)  CoinView *coinView;//底部金币视图
@property (nonatomic, strong)  UIView *firstView;//第一副牌胜
@property (nonatomic, strong)  UIView *secondView;//第二副牌胜
@property (nonatomic, strong)  UIView *thirdView;//第三副牌胜
@property (nonatomic, strong)  BetView *betView;//第三副牌胜
@property (strong, nonatomic)  UIImageView *willStartIMG;
@property (strong, nonatomic)  UIImageView *animationIMG;//游戏的背景图片
@property (strong, nonatomic)  UIImageView *movingIMG;//移动的图片
@property (nonatomic, strong)  NSMutableArray * betImageArray; //装三个放押注数据的图的数组
@property (nonatomic, strong)  NSMutableArray * betMoneyLabArray;//押注数据的label的数组
@property (nonatomic, strong)  NSMutableArray * pokerArray; //9张牌
@property (nonatomic, strong)  NSMutableArray * animationArray;//动画组
@property (nonatomic, strong)  NSMutableArray * coinMoveArray;  //金币移动的位置
@property (nonatomic, strong)  NSMutableArray * coinBtnArray;   //选择押注金额的按钮的数组
@property (nonatomic, strong)  NSMutableArray * breathImgArray; //呼吸灯图片数组
@property (nonatomic, strong)  NSMutableArray * coinBeignArray; //押注金额的开始位置的数组
@property (nonatomic, strong)  NSMutableArray * betViewArray;   //押注视图的数组
@property (nonatomic, strong)  NSMutableArray * betArr;
@property (nonatomic, strong)  NSMutableArray * userBetArr;
@property (nonatomic, strong)  NSTimer * prokerTimer;
@property (nonatomic, assign)  NSInteger count;
@property (nonatomic, assign)  NSInteger currentMoney;       //当前账户余额
@property (nonatomic)BOOL isStartOpenCard;//判断是否开始开牌
@property (nonatomic)BOOL isStopAnimation;//判断是否发牌结束
@property (nonatomic, strong)  UIImageView *compareImg;//开始比较牌的大小
@property (nonatomic,copy) NSString * game_log_id;
@property (nonatomic, strong) NSMutableArray * smallArray;//装上面三组扑克牌视图的数组
@property (nonatomic, assign) BOOL canBet;//可以点击下注
@property (nonatomic, assign) BOOL isHost;//是否是主播
@property (nonatomic, assign) BOOL canCloseGame;//是否可以结束游戏（防止重复点击）
@property (nonatomic, assign) BOOL banker;      //是否是主播
@property (nonatomic, strong) NSArray * betOptionArray;//投注金额选项
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIImageView * alarmClock;//倒计时闹钟
@property (nonatomic, strong)  NSMutableArray * betLabelArr;//押注label数组
@property (nonatomic, strong)  NSMutableArray * userBetLabelArr;//个人押注label数组
@property (nonatomic, strong)   dispatch_source_t gameTimer;//GCD定时器
@property (nonatomic, strong) CAAnimationGroup * groupAntimation;
@property (nonatomic, strong) NSTimer * showPokerTimer;
@property (nonatomic, strong) NSDictionary * dic;
@property (nonatomic, copy) NSString * game_id;
@property (nonatomic, assign) int gameAction;
-(instancetype)initWithFrame:(CGRect)frame withBetArray:(NSArray *)betArray withIsHost:(BOOL ) isHost;
/**
 创建扑克牌视图
 @param hiden:创建时候是否隐藏视图
 @param type:游戏的类型
 @param card:存放需要创建视图时候需要的扑克牌
 */
-(void)creatPokerhiden:(BOOL)hiden gameType:(NSString *)type card:(NSArray *)card;


/**
 创建押注视图
 @param hiden:创建视图时候是否需要隐藏
 @param  type:游戏的类型
 */
-(void)creatBetAmount:(BOOL)hiden type:(NSString *)type;

/**
 发牌结束进入倒计时操作(主播端)
 @param time:本局游戏所剩下的时间
 */
-(void)overPokerKJTime:(int)time;

/**
  倒计时(观众端)
 @param  time:本局游戏所剩下的时间
 */
-(void)timeCountDown:(int)time;


/**
 是否能够进行押注
 @param isBet:判断当前是否能够押注
 */
- (void)whetherBet:(BOOL)isBet;

/**
 关闭发牌音效
 */
-(void)closeVideo;

/**
 游戏准备
 @param type:游戏类型(炸金花是1,斗牛是2 ,3德州扑克)
 @param card:存放扑克牌
 */
-(void)gameToPrepareTypeGoldenFlowerOrBull:(NSString *)type card:(NSArray *)card;
/**
 即将发牌等待中
 @param type:游戏类型
 */
-(void)beAbleToLicensingType:(NSString *)type;
/**
 正在发牌
 @param type:游戏类型
 */
-(void)licensingGameTypeGoldenFlowerOrBull:(NSString *)type;
/**
 *  游戏结束之后更新余额
 *  @param ID:游戏ID
 */
- (void)updateCoinWithID:(NSString *)ID;
/**
 开牌比较大小(倒计时未结束)
  @param leftdic   :存放第一副牌
  @param betweendic:存放第二副牌
  @param rigthdic  :存放第三副牌
  @param result    :三副牌的结果
  @param gameid    :游戏id
 */
-(void)startOpenCard:(NSDictionary *)leftdic between:(NSDictionary *)betweendic rigth:(NSDictionary *)rigthdic andResult:(NSInteger )result gameId:(id)gameid;
/**
 开牌比较大小(倒计时结束)
 @param leftdic   :存放第一副牌
 @param betweendic:存放第二副牌
 @param rigthdic  :存放第三副牌
 @param result    :三副牌的结果
 @param gameid    :游戏id
 */
-(void)startOpenCard2:(NSDictionary *)leftdic between2:(NSDictionary *)betweendic rigth2:(NSDictionary *)rigthdic andResult:(NSInteger )result;
/**
 *加载押注数据
 *@param betArray:存放押注数据
 */
//-(void)loadBetDataWith:(NSArray *)betArray;
/**
 押注发送请求
 @param str:传入游戏轮数
 @param tag:按钮的tag
 */
- (void)postBetMoneyStr:(NSString *)str withTag:(NSInteger)tag;

/**
 *押注按钮颜色变化
 @param coin:传入金额
 */
- (void)judgmentBetView:(NSInteger)coin;

/**
 获取开牌数据
 @param gameDataArray:开牌游戏数据
 */
-(void)openCardWith:(NSArray *)gameDataArray;

-(void)loadBetDataWithBetArray:(NSArray *)betArray andUserBetArray:(NSArray *)userBetArray;
/**
 
 @param optionArray:
 */
-(void)loadOptionArray:(NSArray *)optionArray;

/**
 获取呼吸灯和起始位置
 @param tag:按钮的tag值
 */
- (void)getCoinBreathAndPoint:(NSInteger)tag;

-(void)cancelTimer;

-(void)endAnmination;

//直播间关闭时关闭游戏相关的所有定时器
-(void)closeGameAboutTimer;

-(void)showPokerWithData:(NSArray *)dataPoker andResult:(NSString *)result;
@end
