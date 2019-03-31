//
//  ApplyBankerView.h
//  FanweApp
//
//  Created by yy on 17/2/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyBankerViewDelegate <NSObject>

- (void)bankerViewDown;

- (void)hiddenGrabBankerBtnWithCoin:(NSString *)coin;    //隐藏上庄按钮,并更新金额

@end

@interface ApplyBankerView : UIView

@property (nonatomic, weak) id<ApplyBankerViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView         *displayView;
@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;            //标题
@property (weak, nonatomic) IBOutlet UITextField    *coinTextfield;         //输入框
@property (weak, nonatomic) IBOutlet UILabel        *leastCoinLabel;        //底金
@property (weak, nonatomic) IBOutlet UILabel        *myCoinLabel;           //游戏余额
@property (weak, nonatomic) IBOutlet UIButton       *cancelButton;          
@property (weak, nonatomic) IBOutlet UIButton       *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel        *verticalLine;
@property (weak, nonatomic) IBOutlet UILabel        *horizontalLine;
@property (nonatomic, copy) NSString                *video_id;              //游戏直播间id
@property (nonatomic, copy) NSString                *coin;                  //游戏余额
@property (nonatomic, copy) NSString                *principal;                  //底金

+ (instancetype)EditNibFromXib;

- (void)createStyle;

/**
 *  @parm   videoID     直播间ID
 */
- (void)requestBanker;

@end
