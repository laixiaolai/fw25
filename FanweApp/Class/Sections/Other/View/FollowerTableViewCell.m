//
//  FollowerTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FollowerTableViewCell.h"
#import "SenderModel.h"

@implementation FollowerTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = kWhiteColor;
    
    self.headImgView.layer.cornerRadius = 20*kAppRowHScale;
    self.headImgView.layer.masksToBounds = YES;
    
    self.commentLabel.textColor   = kAppGrayColor3;
    self.nameLabel.textColor      = kAppGrayColor1;
    self.lineView.backgroundColor = kAppSpaceColor4;
}

- (void)creatCellWithModel:(SenderModel *)model WithRow:(int)row
{
    self.joinBtn.tag = row;
    self.user_id = model.user_id;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    if (model.nick_name.length < 1)
    {
        model.nick_name = @"暂时还未命名";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.nick_name];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, model.nick_name.length)];
    self.nameLabel.attributedText = attr;
    
    if ([model.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    if (model.user_level > 0)
    {
     self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%d",model.user_level]];
    }else
    {
    self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_1"]];
    }
   
    if (model.signature.length < 1)
    {
        self.commentLabel.text = @"";
    }else
    {
        self.commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:model.signature];
        self.commentLabel.attributedText = attr1;
    }
    
    if ([model.follow_id integerValue] > 0)
    {
        self.rightImgView.image = [UIImage imageNamed:@"search_had_follow"];
    }else
    {
        self.rightImgView.image = [UIImage imageNamed:@"search_not_follow"];
    }
    
    if ([model.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId])
    {
        self.rightImgView.hidden = YES;
        self.joinBtn.hidden = YES;
    }else
    {
        self.rightImgView.hidden = NO;
        self.joinBtn.hidden = NO;
    }
    self.rightImgView.tag = 100+row;
}

- (IBAction)photoClick:(UIButton *)sender
{
    int section =(int) sender.tag;
    self.httpManager = [NetHttpsManager manager];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"follow" forKey:@"act"];
    if (self.user_id)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [self.httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             if ([responseJson toInt:@"has_focus"] == 1)
             {
                 self.rightImgView.image = [UIImage imageNamed:@"search_had_follow"];
                 
             }else
             {
                 self.rightImgView.image = [UIImage imageNamed:@"search_not_follow"];
                 
             }
             self.hasFonce = [responseJson toInt:@"has_focus"];
             if (self.delegate)
             {
                 if ([self.delegate respondsToSelector:@selector(loadAgainSection: withHasFonce:)])
                 {
                     [self.delegate loadAgainSection:section withHasFonce:self.hasFonce];
                 }
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

@end
