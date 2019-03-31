//
//  GameWinView.h
//  FanweApp
//
//  Created by yy on 16/12/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameGainModel.h"
@protocol GameWinViewDelegate <NSObject>
@optional
- (void)senGift:(GiftView *)giftView AndGiftModel:(GiftModel *)giftModel;
- (void)gameWinViewDown;
@end
@interface GameWinView : FWBaseView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *gameWinLab;
@property (weak, nonatomic) IBOutlet UIView *winBgView;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *gratuityLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *gratuityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *closeView;
@property (weak, nonatomic) IBOutlet UIImageView *gameCoinImageView;
@property (nonatomic, strong) GameGainModel * model;
@property (nonatomic, weak) id<GameWinViewDelegate>delegate;
//@property (nonatomic, assign) BOOL hadSelected;
+ (instancetype)EditNibFromXib;

@end
