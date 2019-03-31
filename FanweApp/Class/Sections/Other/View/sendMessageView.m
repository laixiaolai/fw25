//
//  sendMessageView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "sendMessageView.h"

@implementation sendMessageView

- (void)awakeFromNib
{
    self.backView.backgroundColor = [UIColor redColor];
    self.soundView.backgroundColor = [UIColor redColor];
    self.messageFiled.backgroundColor = [UIColor yellowColor];
    self.messageFiled.layer.cornerRadius = 2;
    self.messageFiled.layer.borderWidth = 2;
    self.messageFiled.layer.borderColor = kBackGroundColor.CGColor;
    self.expressionView.backgroundColor = [UIColor orangeColor];
    self.addImgView.backgroundColor = [UIColor yellowColor];
}

@end
