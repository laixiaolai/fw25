//
//  AudienceEnteringTipView.h
//  FanweApp
//
//  Created by xfg on 16/6/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface AudienceEnteringTipView : UIView

@property (weak, nonatomic) IBOutlet UIImageView    *rankImgView;
@property (weak, nonatomic) IBOutlet UILabel        *userNameLabel;

- (id)initWithMyFrame:(CGRect)frame;

- (void)setContent:(UserModel *) userModel;

@end
