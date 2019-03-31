//
//  SmallVideoCell.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmallVideoListModel;

@interface SmallVideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView        *bigImgView;
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *smallImgView;
@property (weak, nonatomic) IBOutlet UIView             *bottomView;
@property (weak, nonatomic) IBOutlet UILabel            *numLbale;
@property (weak, nonatomic) IBOutlet UIImageView        *videoImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraintW;



- (void)creatCellWithModel:(SmallVideoListModel *)model andRow:(int)row;

@end
