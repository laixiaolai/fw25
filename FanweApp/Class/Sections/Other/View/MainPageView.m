//
//  MainPageView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "MainPageView.h"

@interface  MainPageView()

@end

@implementation MainPageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.followButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    [self.defriendButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    [self.personLetterButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    
    self.HLineView.backgroundColor = self.VLineView1.backgroundColor = self.VLineView2.backgroundColor = kAppSpaceColor4;
    self.backGroundView.backgroundColor = kWhiteColor;
}

- (void)changeState
{
    //关注
    if (self.has_focus == 1)
    {
        [self.followButton setTitle:@"已关注" forState:0];
        [_followButton setImage:[UIImage imageNamed:@"fw_me_follow"] forState:UIControlStateNormal];
    }else
    {
        [self.followButton setTitle:@"关注" forState:0];
        [_followButton setImage:[UIImage imageNamed:@"fw_me_noFollow"] forState:UIControlStateNormal];
    }
    //拉黑
    if (self.has_black == 1)
    {
        [self.defriendButton setTitle:@"解除拉黑" forState:0];
        
    }else
    {
        [self.defriendButton setTitle:@"拉黑" forState:0];
    }
}

//关注
- (IBAction)followButton:(UIButton *)sender
{
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"follow" forKey:@"act"];
    [dictM setObject:[NSString stringWithFormat:@"%@",self.user_id] forKey:@"to_user_id"];
    
    [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
             _has_focus = [responseJson toInt:@"has_focus"];
             if ([responseJson toInt:@"status"] == 1)
             {
                 if (_has_focus == 1)//已关注
                 {
                     [mDict setObject:@"0" forKey:@"isShowFollow"];
                     [_followButton setTitle:@"已关注" forState:0];
                     [_followButton setImage:[UIImage imageNamed:@"fw_me_follow"] forState:UIControlStateNormal];
                     
                     if (self.has_black == 1)//解除拉黑
                     {
                         [self.defriendButton setTitle:@"拉黑" forState:0];
                     }
                     
                 }else if (_has_focus == 0)//关注
                 {
                     [_followButton setTitle:@"关注" forState:0];
                     [_followButton setImage:[UIImage imageNamed:@"fw_me_noFollow"] forState:UIControlStateNormal];
                     [mDict setObject:@"1" forKey:@"isShowFollow"];
                 }
                 [mDict setObject:[responseJson toString:@"follow_msg"] forKey:@"follow_msg"];
                 if (self.user_id.length)
                 {
                     [mDict setObject:self.user_id forKey:@"userId"];
                 }
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"liveIsShowFollow" object:mDict];
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

//私信
- (IBAction)privateLetter:(UIButton *)sender
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(sentPersonLetter:)])
        {
            [self.delegate sentPersonLetter:self.user_id];
        }
    }
}
//拉黑
- (IBAction)defriend:(UIButton *)sender
{
    self.defriendButton.userInteractionEnabled = NO;
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"set_black" forKey:@"act"];
    [dictM setObject:[NSString stringWithFormat:@"%@",self.user_id] forKey:@"to_user_id"];
    
    [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             _has_black = [responseJson toInt:@"has_black"];
             if (self.has_black == 1)//未拉黑
             {
                 [_defriendButton setTitle:@"解除拉黑" forState:0];
                 [self.followButton setTitle:@"关注" forState:0];
                 
             }else if (self.has_black == 0)//已拉黑
             {
                 [_defriendButton setTitle:@"拉黑" forState:0];
             }
             self.defriendButton.userInteractionEnabled = YES;
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

@end
