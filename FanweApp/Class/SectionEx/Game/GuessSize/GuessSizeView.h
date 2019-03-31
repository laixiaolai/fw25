//
//  GuessSizeView.h
//  FanweApp
//
//  Created by 方维 on 2017/5/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinView.h"
#import "BetView.h"
#import "GameRechargeView.h"
#import "GameGainModel.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
@class GuessSizeView;
@protocol GuessSizeViewDelegate <NSObject>

@optional

@required
// 显示充值
- (void)clickRecharge;
//让游戏记录弹出
- (void)displayGameHistory;
//弹出游戏获胜视图
- (void)displayGameWinWithGainModel:(GameGainModel *)gainModel;
//倒计时还是5秒时主动请求接口,防止推送接收不到出现的问题
- (void)reloadGameData;

- (void)choseArcOrMrcGameWithView:(UIView *)guessSizeView;

@end

@interface GuessSizeView : UIView<BetViewDelegate>
{
    BetView *_historyView;
    BetView *_gameOverView;  //游戏结束
    CGPoint _amountPoint;   //押注金额的中心位置
    CGPoint _betPoint;      //押注视图的中心位置
    CGPoint _coinPoint;     //金币余额的中心位置
    CGPoint _winCoinPoint;  //游戏胜利金额的中心位置
    NSInteger _bet;         //押注区域选项
    NSInteger _betCount;    //押注金额的选项
    NSString *_betMoney;    //押注金额
    UIImageView *_breathImg; //金币动画的图片
    BOOL _isClick;      //是否点击
    NetHttpsManager *_httpManager;
    GlobalVariables *_fanweApp;
}
@property (weak, nonatomic) IBOutlet UIImageView *deskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *clockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bigSizeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleSizeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smallSizeImageView;
@property (nonatomic, strong) UILabel  * timeLabel;
//存放三个押注视图
@property (nonatomic, strong) NSArray  * betImageArray;
@property (nonatomic, strong) NSMutableArray * betArr;
@property (nonatomic, strong) NSMutableArray * userBetArr;
@property (nonatomic, strong) NSMutableArray * betLabelArr;//押注label数组
@property (nonatomic, strong) NSMutableArray * userBetLabelArr;//个人押注label数组
@property (nonatomic, strong) NSArray * betOptionArray;//投注金额选项
@property (nonatomic, assign) BOOL isArc;
@property (nonatomic, strong) BetView *arcOrMrcGameView;
@property (nonatomic, strong) BetView *betView;
@property (nonatomic, strong) NSMutableArray * optionArr; // 押注倍率
@property (nonatomic, strong) NSMutableArray * coinMoveArray;  //金币移动的位置
@property (nonatomic, strong) NSMutableArray * coinBtnArray;   //选择押注金额的按钮的数组
@property (nonatomic, strong) NSMutableArray * breathImgArray; //呼吸灯图片数组
@property (nonatomic, strong) NSMutableArray * coinBeignArray; //押注金额的开始位置的数组
@property (nonatomic, strong) NSMutableArray * betViewArray;   //押注视图的数组
@property (nonatomic, strong) UIView * buttomView;
@property (nonatomic, strong) GameRechargeView *gameRechargeView;//底部金币视图
@property (nonatomic, assign) BOOL canBet;//可以点击下注
@property (nonatomic, assign) BOOL isHost;//是否是主播
@property (nonatomic, assign) BOOL canCloseGame;//是否可以结束游戏（防止重复点击）
//@property (nonatomic, strong) UIImageView * diceImageViewOne;
//@property (nonatomic, strong) UIImageView * diceImageViewTwo;
@property (nonatomic, strong) NSTimer * showDiceTimer;
@property (nonatomic, assign) int countTime;
@property (nonatomic, weak) id<GuessSizeViewDelegate>delegate;
@property (nonatomic, assign)  NSInteger currentMoney; //当前账户余额
@property (nonatomic, copy) NSString * game_log_id;
@property (nonatomic, strong) NSMutableArray * betMultipleLabelArr;
@property (nonatomic, strong) NSMutableArray * maskViewArr;
@property (nonatomic, strong) FLAnimatedImageView * diceImageViewOne;
@property (nonatomic, strong) FLAnimatedImageView * diceImageViewTwo;
@property (nonatomic, strong) NSArray * maskViewNameArr;

/**
 加载点数大小，此方法用于展示骰子大小时调用

 @param dicesArr 点数数组
 */
- (void)loadDiceWithDicesArr:(NSArray *)dicesArr andResultWinPostion:(NSInteger )winPostion;

/**
 加载押注数据

 @param betArray 总的押注数组
 @param userBetArray 个人押注数组
 */
- (void)loadBetDataWithBetArray:(NSArray *)betArray andUserBetArray:(NSArray *)userBetArray;

/**
 骰子打开倒计时

 @param time 倒计时时长
 */
- (void)showTime:(int)time;

/**
 创建游戏相关的label
 */
- (void)creatLabel;

/**
 创建下注相关视图
 */
- (void)createButtomView;

- (void)loadOptionArray:(NSArray *)optionArray;

- (void)disClockTime;

/**
 游戏结束更新余额

 @param ID 游戏ID
 */
- (void)updateCoinWithID:(NSString *)ID;

- (void)judgmentBetView:(NSInteger)coin;
@end
