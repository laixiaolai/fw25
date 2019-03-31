//
//  AnchorCell.h
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SociatyDetailModel.h"

@interface AnchorCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorImgH;
@property (weak, nonatomic) IBOutlet UILabel *livingLbl;
@property (weak, nonatomic) IBOutlet UIImageView *anchorImg;
@property (weak, nonatomic) IBOutlet UILabel *anchorNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImg;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *predisentLbl;

- (void)configCellMsg:(SociatyDetailModel *)model;

@end
