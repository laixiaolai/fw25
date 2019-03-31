//
//  SLeaderHeadView.m
//  FanweApp
//
//  Created by 丁凯 on 2017/9/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SLeaderHeadView.h"
#import "UserModel.h"

@implementation SLeaderHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kBackGroundColor;
        [self creatMyUI];
    }
    return self;
}

- (void)creatMyUI
{
    //底部视图
    self.bottomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height -108*kScaleHeight , self.width, 108*kScaleHeight)];
    self.bottomImgView.image = [UIImage imageNamed:@"hm_bottom"];
    self.bottomImgView.userInteractionEnabled = YES;
    [self addSubview:self.bottomImgView];
    
    //------------------------------左边部分------------------------------
    //头像
    self.LHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/6 -23*kScaleHeight,56*kScaleHeight, 46*kScaleHeight, 46*kScaleHeight)];
    self.LHeadImgView.layer.cornerRadius = 23*kScaleHeight;
    self.LHeadImgView.layer.masksToBounds = YES;
    self.LHeadImgView.userInteractionEnabled = YES;
    self.LHeadImgView.image = kDefaultPreloadHeadImg;
    [self addSubview:self.LHeadImgView];
    
    //等级头像
    self.LGoldImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/6 - 83*kScaleHeight/2,44*kScaleHeight, 83*kScaleHeight, 66*kScaleHeight)];
    self.LGoldImgView.image = [UIImage imageNamed:@"hm_halo1"];
    self.LGoldImgView.userInteractionEnabled = YES;
    self.LGoldImgView.tag = 1;
    [self addSubview:self.LGoldImgView];
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.LGoldImgView addGestureRecognizer:tap];
    
    //名字性别等级底部的view
    self.LNSRView = [[UIView alloc]initWithFrame:CGRectMake(self.width/6 - 40*kScaleWidth, CGRectGetMaxY(self.LGoldImgView.frame)+12*kScaleHeight, 80*kScaleWidth, 20*kScaleHeight)];
    self.LNSRView.backgroundColor = kWhiteColor;
    [self addSubview:self.LNSRView];
    
    //等级
    self.LRankImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.LNSRView.width-26, (self.LNSRView.height-13)/2, 26, 13)];
    [self.LNSRView addSubview:self.LRankImgView];
    
    //性别
    self.LSexImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.LNSRView.width -26-13-5, (self.LNSRView.height-13)/2, 13, 13)];
    [self.LNSRView addSubview:self.LSexImgView];
    
    //名字
    self.LNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.LNSRView.width-10-self.LSexImgView.width -self.LRankImgView.width , 20*kScaleHeight)];
    self.LNameLabel.textColor = kAppGrayColor1;
    self.LNameLabel.font = [UIFont systemFontOfSize:13];
    [self.LNSRView addSubview:self.LNameLabel];
    
    //印票
    self.LTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.LNSRView.frame)+2*kScaleHeight, self.width/3, 20*kScaleHeight)];
    self.LTicketLabel.textColor = kAppGrayColor3;
    self.LTicketLabel.textAlignment = NSTextAlignmentCenter;
    self.LTicketLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.LTicketLabel];
    
    
    //------------------------------中间边部分------------------------------
    //头像
    self.MHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2 -30*kScaleHeight,32*kScaleHeight, 60*kScaleHeight, 60*kScaleHeight)];
    self.MHeadImgView.layer.cornerRadius = 30*kScaleHeight;
    self.MHeadImgView.layer.masksToBounds = YES;
    self.MHeadImgView.userInteractionEnabled = YES;
    self.MHeadImgView.image = kDefaultPreloadHeadImg;
    [self addSubview:self.MHeadImgView];
    
    //等级头像
    self.MGoldImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2 - 83*kScaleHeight/2,10*kScaleHeight, 83*kScaleHeight, 90*kScaleHeight)];
    self.MGoldImgView.image = [UIImage imageNamed:@"hm_halo2"];
    self.MGoldImgView.userInteractionEnabled = YES;
    self.MGoldImgView.tag = 0;
    [self addSubview:self.MGoldImgView];
    
    //手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.MGoldImgView addGestureRecognizer:tap1];
    
    //名字性别等级底部的view
    self.MNSRView = [[UIView alloc]initWithFrame:CGRectMake(self.width/2 - 40*kScaleWidth, CGRectGetMaxY(self.MGoldImgView.frame)+12*kScaleHeight, 80*kScaleWidth, 20*kScaleHeight)];
    self.MNSRView.backgroundColor = kWhiteColor;
    [self addSubview:self.MNSRView];
    
    //等级
    self.MRankImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.LNSRView.width-26, (self.MNSRView.height-13)/2, 26, 13)];
    [self.MNSRView addSubview:self.MRankImgView];
    
    //性别
    self.MSexImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.MNSRView.width -26-13-5, (self.MNSRView.height-13)/2, 13, 13)];
    [self.MNSRView addSubview:self.MSexImgView];
    
    //名字
    self.MNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.MNSRView.width-10-self.MSexImgView.width -self.MRankImgView.width , 20*kScaleHeight)];
    self.MNameLabel.textColor = kAppGrayColor1;
    self.MNameLabel.font = [UIFont systemFontOfSize:13];
    [self.MNSRView addSubview:self.MNameLabel];
    
    //印票
    self.MTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.LTicketLabel.frame), CGRectGetMaxY(self.MNSRView.frame)+2*kScaleHeight, self.width/3, 20*kScaleHeight)];
    self.MTicketLabel.textColor = kAppGrayColor3;
    self.MTicketLabel.textAlignment = NSTextAlignmentCenter;
    self.MTicketLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.MTicketLabel];
    
    //------------------------------右边部分------------------------------
    //头像
    self.RHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width*5/6 -23*kScaleHeight,56*kScaleHeight, 46*kScaleHeight, 46*kScaleHeight)];
    self.RHeadImgView.layer.cornerRadius = 23*kScaleHeight;
    self.RHeadImgView.layer.masksToBounds = YES;
    self.RHeadImgView.userInteractionEnabled = YES;
    self.RHeadImgView.image = kDefaultPreloadHeadImg;
    [self addSubview:self.RHeadImgView];
    
    //等级头像
    self.RGoldImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width*5/6 - 83*kScaleHeight/2,44*kScaleHeight, 83*kScaleHeight, 66*kScaleHeight)];
    self.RGoldImgView.image = [UIImage imageNamed:@"hm_halo3"];
    self.RGoldImgView.userInteractionEnabled = YES;
    self.RGoldImgView.tag = 2;
    [self addSubview:self.RGoldImgView];
    
    //手势
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.RGoldImgView addGestureRecognizer:tap2];
    
    //名字性别等级底部的view
    self.RNSRView = [[UIView alloc]initWithFrame:CGRectMake(self.width*5/6 - 40*kScaleWidth, CGRectGetMaxY(self.RGoldImgView.frame)+12*kScaleHeight, 80*kScaleWidth, 20*kScaleHeight)];
    self.RNSRView.backgroundColor = kWhiteColor;
    [self addSubview:self.RNSRView];
    
    //等级
    self.RRankImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.LNSRView.width-26, (self.LNSRView.height-13)/2, 26, 13)];
    [self.RNSRView addSubview:self.RRankImgView];
    
    //性别
    self.RSexImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.RNSRView.width -26-13-5, (self.RNSRView.height-13)/2, 13, 13)];
    [self.RNSRView addSubview:self.RSexImgView];
    
    //名字
    self.RNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.RNSRView.width-10-self.RSexImgView.width -self.RRankImgView.width , 20*kScaleHeight)];
    self.RNameLabel.textColor = kAppGrayColor1;
    self.RNameLabel.font = [UIFont systemFontOfSize:13];
    [self.RNSRView addSubview:self.RNameLabel];
    
    //印票
    self.RTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.MTicketLabel.frame), CGRectGetMaxY(self.RNSRView.frame)+2*kScaleHeight, self.width/3, 20*kScaleHeight)];
    self.RTicketLabel.textColor = kAppGrayColor3;
    self.RTicketLabel.textAlignment = NSTextAlignmentCenter;
    self.RTicketLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.RTicketLabel];
}

- (void)setMyViewWithMArr:(NSMutableArray *)mArr andType:(int)type consumeType:(int)consumeType
{
    if (mArr.count)
    {
        NSString *str = consumeType > 3 ? @"消费" : @"获得";
        self.MGoldImgView.userInteractionEnabled = YES;
        UserModel *model1 = mArr[0];
        [self.MHeadImgView sd_setImageWithURL:[NSURL URLWithString:model1.head_image] placeholderImage:kDefaultPreloadHeadImg];
        self.MNameLabel.text = model1.nick_name;
        CGFloat width =[model1.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        [self updateViewWithWidth:width andView:self.MNSRView andLabel:self.MNameLabel andSexImg:self.MSexImgView andRankImg:self.MRankImgView andTag:3];
        //性别
        if ([model1.sex isEqualToString:@"1"])
        {
            self.MSexImgView.image = [UIImage imageNamed:@"com_male_selected"];
        }
        else
        {
            self.MSexImgView.image = [UIImage imageNamed:@"com_female_selected"];
        }
        //等级
        if ([model1.user_level intValue] !=0)
        {
            self.MRankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model1.user_level]];
        }
        else
        {
            self.MRankImgView.image = [UIImage imageNamed:@"rank_1"];
        }
        if (type == 1)
        {
            self.MTicketLabel.text = [NSString stringWithFormat:@"消费%@%@",model1.use_ticket,self.fanweApp.appModel.ticket_name];
        }
        else
        {
            NSString *ticketName = consumeType > 3 ? [GlobalVariables sharedInstance].appModel.diamond_name : [GlobalVariables sharedInstance].appModel.ticket_name;
            self.MTicketLabel.text = [NSString stringWithFormat:@"%@%@%@",str,model1.ticket,ticketName];
        }
        
        
        if (mArr.count > 1)
        {
            self.LGoldImgView.userInteractionEnabled = YES;
            UserModel *model2 = mArr[1];
            [self.LHeadImgView sd_setImageWithURL:[NSURL URLWithString:model2.head_image] placeholderImage:kDefaultPreloadHeadImg];
            self.LNameLabel.text = model2.nick_name;
            CGFloat width2 =[model2.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
            [self updateViewWithWidth:width2 andView:self.LNSRView andLabel:self.LNameLabel andSexImg:self.LSexImgView andRankImg:self.LRankImgView andTag:1];
            //性别
            if ([model2.sex isEqualToString:@"1"])
            {
                self.LSexImgView.image = [UIImage imageNamed:@"com_male_selected"];
            }
            else
            {
                self.LSexImgView.image = [UIImage imageNamed:@"com_female_selected"];
            }
            //等级
            if ([model2.user_level intValue] !=0)
            {
                self.LRankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model2.user_level]];
            }
            else
            {
                self.LRankImgView.image = [UIImage imageNamed:@"rank_1"];
            }
            
            if (type == 1)
            {
                self.LTicketLabel.text = [NSString stringWithFormat:@"消费%@%@",model2.use_ticket,self.fanweApp.appModel.ticket_name];
            }else
            {
                NSString *ticketName = consumeType > 3 ? [GlobalVariables sharedInstance].appModel.diamond_name : [GlobalVariables sharedInstance].appModel.ticket_name;
                self.LTicketLabel.text = [NSString stringWithFormat:@"%@%@%@",str,model2.ticket,ticketName];
            }
        }
        
        if (mArr.count > 2)
        {
            self.RGoldImgView.userInteractionEnabled = YES;
            UserModel *model3 = mArr[2];
            [self.RHeadImgView sd_setImageWithURL:[NSURL URLWithString:model3.head_image] placeholderImage:kDefaultPreloadHeadImg];
            self.RNameLabel.text = model3.nick_name;
            CGFloat width3 =[model3.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
            [self updateViewWithWidth:width3 andView:self.RNSRView andLabel:self.RNameLabel andSexImg:self.RSexImgView andRankImg:self.RRankImgView andTag:5];
            //性别
            if ([model3.sex isEqualToString:@"1"])
            {
                self.RSexImgView.image = [UIImage imageNamed:@"com_male_selected"];
            }
            else
            {
                self.RSexImgView.image = [UIImage imageNamed:@"com_female_selected"];
            }
            //等级
            if ([model3.user_level intValue] !=0)
            {
                self.RRankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model3.user_level]];
            }
            else
            {
                self.RRankImgView.image = [UIImage imageNamed:@"rank_1"];
            }
            if (type == 1)
            {
                self.RTicketLabel.text = [NSString stringWithFormat:@"消费%@%@",model3.use_ticket,self.fanweApp.appModel.ticket_name];
            }else
            {
                NSString *ticketName = consumeType > 3 ? [GlobalVariables sharedInstance].appModel.diamond_name : [GlobalVariables sharedInstance].appModel.ticket_name;
                self.RTicketLabel.text = [NSString stringWithFormat:@"%@%@%@",str,model3.ticket,ticketName];
            }
            
        }
        
        CGRect rect = self.frame;
        rect.size.height = 170*kScaleHeight;
        self.frame = rect;
        
    }else
    {
        CGRect rect = self.frame;
        rect.size.height = 0;
        self.frame = rect;
    }
}

- (void)updateViewWithWidth:(CGFloat)width andView:(UIView *)bottomView andLabel:(UILabel *)label andSexImg:(UIImageView *)sexImgView andRankImg:(UIImageView *)rankImgView andTag:(int)tag
{
    if (width +10 + 13 +26 +6 > self.width/3)
    {
        width = self.width/3 -10 -13 -26 -6;
    }
    
    CGRect rect      = label.frame;
    rect.size.width  = width;
    label.frame      = rect;
    
    CGRect rect1      = bottomView.frame;
    rect1.size.width  = width +10 + 13 +26;
    rect1.origin.x    = tag * self.width/6 -(width +10 + 13 +26)/2;
    bottomView.frame  = rect1;
    
    CGRect rect2      = sexImgView.frame;
    rect2.origin.x    = CGRectGetMaxX(label.frame) +5;
    sexImgView.frame  = rect2;
    
    CGRect rect3      = rankImgView.frame;
    rect3.origin.x    = CGRectGetMaxX(sexImgView.frame) +5;
    rankImgView.frame  = rect3;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.leadBlock)
    {
        self.leadBlock((int)tap.view.tag);
    }
    
}


@end
