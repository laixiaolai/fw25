//
//  NewestItemCell.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LivingModel;

@interface NewestItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paidLabelSpaceTopH;


- (void)setCellContent:(LivingModel *)LModel;
@end
