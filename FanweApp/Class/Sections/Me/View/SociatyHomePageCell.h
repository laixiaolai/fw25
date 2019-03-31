//
//  TianTuanCell.h
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SociatyHomePageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *tianTuanImg;
@property (weak, nonatomic) IBOutlet UILabel *tianTuanNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *presidentLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tianTuanImgH;
@property (weak, nonatomic) IBOutlet UIView *underView;

@end
