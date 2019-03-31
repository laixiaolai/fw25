//
//  GameGiftCell.h
//  FanweApp
//
//  Created by 王珂 on 17/4/28.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameGiftCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *diamondImageView;
@property (nonatomic , strong) GiftModel * model;
@end
