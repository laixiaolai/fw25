//
//  PushMaTableViewCell.m
//  FanweApp
//
//  Created by GuoMs on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "PushMaTableViewCell.h"

@implementation PushMaTableViewCell

- (IBAction)isPushNotify:(id)sender
{
    if ([self.deleagte respondsToSelector:@selector(handleToTurnPushManage)])
    {
        [self.deleagte handleToTurnPushManage];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftNameLabel.textColor = kAppGrayColor1;
    self.turnOrOff.onTintColor = kAppMainColor;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"turnPush"]) {
        
        BOOL isturn = [[NSUserDefaults standardUserDefaults] boolForKey:@"turnOnOrOff"];
        if (isturn)
        {
            self.turnOrOff.on = NO;
//            self.turnImageView.image = [UIImage imageNamed:@"turnon"];
        }
        else
        {
            self.turnOrOff.on = YES;
//            self.turnImageView.image = [UIImage imageNamed:@"turnoff"];
            
        }
    }
    else
    {
        self.turnOrOff.on = YES;
//        self.turnImageView.image = [UIImage imageNamed:@"turnon"];
    }
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleToTurnPushManage:)];
//    [self.turnOrOff addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
