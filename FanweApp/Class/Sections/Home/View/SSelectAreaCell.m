//
//  SSelectAreaCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SSelectAreaCell.h"

@implementation SSelectAreaCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bottomView.backgroundColor = kAppGrayColor1;
    self.bottomView.layer.cornerRadius  = 30/2.0f;
    self.bottomView.layer.masksToBounds = YES;
}



@end
