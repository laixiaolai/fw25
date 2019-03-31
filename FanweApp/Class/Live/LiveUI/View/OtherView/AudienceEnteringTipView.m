//
//  AudienceEnteringTipView.m
//  FanweApp
//
//  Created by xfg on 16/6/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AudienceEnteringTipView.h"

@implementation AudienceEnteringTipView

- (id)initWithMyFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AudienceEnteringTipView" owner:self options:nil] lastObject];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
    }
    return self;
}

- (void)setContent:(UserModel *) userModel
{
    [self.rankImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",userModel.user_level]]];
    self.userNameLabel.text = userModel.nick_name;
}

@end
