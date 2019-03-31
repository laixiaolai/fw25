//
//  MPCHeadView.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MPCHeadView.h"
#import "userPageModel.h"
#import "FWSystemMacro.h"

@implementation MPCHeadView

- (instancetype)initWithFrame:(CGRect)frame andHeadType:(int)headType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatMyViewWithType:headType];
    }
    return self;
}

- (void)creatMyViewWithType:(int)headType
{
    //底部透明图片
    self.clearImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 285)];
    self.clearImgView.userInteractionEnabled = YES;
    self.clearImgView.contentMode  = UIViewContentModeScaleAspectFill;
    self.clearImgView.clipsToBounds = YES;
    [self addSubview:self.clearImgView];
    
    //透明的view
    self.clearView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 285)];
    self.clearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    [self addSubview:self.clearView];
    
    // 返回
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0,kStatusBarHeight, 50,44);
    self.backButton.backgroundColor = [UIColor clearColor];
    if (headType == 1)
    {
     [self.backButton setImage:[UIImage imageNamed:@"fw_me_search"] forState:UIControlStateNormal];
    }else if (headType == 2)
    {
    [self.backButton setImage:[UIImage imageNamed:@"fw_me_comeBack"] forState:UIControlStateNormal];
    }
    self.backButton.tag = 100;
    [self.backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    //谁的主页
    self.outLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2-90, kStatusBarHeight, 180,44)];
    self.outLabel.textColor = kWhiteColor;
    self.outLabel.font = [UIFont systemFontOfSize:16];
    self.outLabel.textAlignment = NSTextAlignmentCenter;
    if (headType == 1)
    {
     self.outLabel.text = @"我的";
    }
    [self addSubview:self.outLabel];
    
    //直播
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.messageBtn.tag = 101;
    [self.messageBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.messageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.messageBtn];
    
    if (headType == 1)
    {
        self.messageBtn.frame = CGRectMake(kScreenW-40,kStatusBarHeight+(44-28)/2,30,28);
        // 设置角标
        [self initBadgeBtn:self.messageBtn];
        [self.messageBtn setImage:[UIImage imageNamed:@"fw_me_news"] forState:UIControlStateNormal];
    }else
    {
      self.messageBtn.frame = CGRectMake(kScreenW-60,kStatusBarHeight,50,44);
    }
    
    //头像
    self.headImgView = [[UIImageView alloc]init];
    self.headImgView.frame = CGRectMake(kScreenW/2-85*kScaleWidth/2,85,85*kScaleWidth, 85*kScaleWidth);
    self.headImgView.layer.borderWidth = 2;
    self.headImgView.image = kDefaultPreloadHeadImg;
    self.headImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.headImgView.layer.borderColor = kWhiteColor.CGColor;
    self.headImgView.layer.cornerRadius = 85*kScaleWidth/2;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.userInteractionEnabled = YES;
    [self addSubview:self.headImgView];
    
    //认证图标
    self.vImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame)-kViconWidthOrHeight2*1.3, CGRectGetMaxY(self.headImgView.frame)-kViconWidthOrHeight2*1.3, kViconWidthOrHeight2, kViconWidthOrHeight2)];
    [self addSubview:self.vImgView];
    self.vImgView.hidden = YES;
    
    //头像
    self.headImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headImgBtn.frame = CGRectMake(kScreenW/2-85*kScaleWidth/2,85,85*kScaleWidth, 85*kScaleWidth);
    self.headImgBtn.tag = 102;
    self.headImgBtn.backgroundColor = kClearColor;
    [self.headImgBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headImgBtn];
    
    //名字 性别 等级
    self.nameView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 -50, CGRectGetMaxY(self.headImgView.frame)+5, 100, 30)];
    self.nameView.backgroundColor = kClearColor;
    [self addSubview:self.nameView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = kWhiteColor;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.nameView addSubview:self.nameLabel];
    
    self.vipImgView = [[UIImageView alloc]init];
    [self.nameView addSubview:self.vipImgView];
    
    self.sexImgView = [[UIImageView alloc]init];
    [self.nameView addSubview:self.sexImgView];
    
    self.rankImgView = [[UIImageView alloc]init];
    [self.nameView addSubview:self.rankImgView];
    
    if (headType == 1)
    {
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editBtn setImage:[UIImage imageNamed:@"fw_me_bianji"] forState:UIControlStateNormal];
        self.editBtn.tag = 103;
        [self.editBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.nameView addSubview:self.editBtn];
    }else
    {
//       self.messageBtn.frame = CGRectMake(kScreenW - 60,20,50,44);
    }
    
    //签名
    self.signatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.nameView.frame), kScreenW,21)];
    self.signatureLabel.textAlignment = NSTextAlignmentCenter;
    self.signatureLabel.textColor = kWhiteColor;
    self.signatureLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.signatureLabel];
    
    //账号
    self.accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.signatureLabel.frame), kScreenW,21)];
    self.accountLabel.textColor = kWhiteColor;
    self.accountLabel.font = [UIFont systemFontOfSize:12];
    self.accountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.accountLabel];
    
    //认证和认证的图标
    self.certificateView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 -30, CGRectGetMaxY(self.accountLabel.frame), 60, 21)];
    self.certificateView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.certificateView];
    
    self.certificateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 15, 15)];
    self.certificateImgView.image = [UIImage imageNamed:@"fw_me_identifition"];
    self.certificateImgView.hidden = YES;
    [self.certificateView addSubview:self.certificateImgView];
    
    self.certificateLabel = [[UILabel alloc]init];
    self.certificateLabel.textColor = kWhiteColor;
    self.certificateLabel.font = [UIFont systemFontOfSize:12];
    self.certificateLabel.textAlignment = NSTextAlignmentCenter;
    [self.certificateView addSubview:self.certificateLabel];
    
    //底部的view
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.clearView.frame),kScreenW,62)];
    self.bottomView.backgroundColor = kBackGroundColor;

    [self addSubview:self.bottomView];
    
    
    @autoreleasepool
    {
        self.itemView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.clearView.frame)-20, kScreenW-20, 70)];
        self.itemView.layer.cornerRadius  = 3;
        self.itemView.layer.masksToBounds = YES;
        self.itemView.backgroundColor = kWhiteColor;
        [self addSubview:self.itemView];
        NSArray *array;
        if (headType == 1)
        {
           array = @[@"回播",@"小视频",@"关注",@"粉丝",];
        }else if (headType == 2)
        {
           array = @[@"送出",@"关注",@"粉丝",];
        }
        CGFloat labelW = (kScreenW-20-array.count-1)/array.count;
        for (int i = 0; i < array.count; i++)
        {
            UILabel *nameLabel    = [[UILabel alloc]initWithFrame:CGRectMake((labelW+1)*i,self.itemView.height/2 -25, labelW, 25)];
            nameLabel.tag         = i;
            nameLabel.text        = array[i];
            nameLabel.textColor   = kAppGrayColor3;
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.font        = [UIFont systemFontOfSize:12];
            [self.itemView addSubview:nameLabel];
            
            UILabel *numLabel     = [[UILabel alloc]initWithFrame:CGRectMake((labelW+1)*i,self.itemView.height/2, labelW, 25)];
            numLabel.tag          = array.count +i;
            numLabel.textColor    = kAppGrayColor1;
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.font         = [UIFont systemFontOfSize:12];
            [self.itemView addSubview:numLabel];
            
            UIButton  *itemBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBtn.frame           = CGRectMake((labelW+1)*i, 3, labelW, self.itemView.height-6);
            itemBtn.backgroundColor = kClearColor;
            itemBtn.tag             = 104 + i;
            [itemBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.itemView addSubview:itemBtn];
            
            if (i < array.count-1)
            {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((labelW+1)*i+labelW, 15, 1, 40)];
                lineView.backgroundColor = kAppSpaceColor4;
                [self.itemView addSubview:lineView];
            }
        }
    }
}

- (void)setViewWithModel:(UserModel *)model withUserId:(NSString *)userId
{
    cuserModel *cModel;
    if (model.user)
    {
        cModel = model.user;
    }else{
        cModel = [[cuserModel alloc]init];
    }
//    self.outLabel.text = [NSString stringWithFormat:@"%@的主页",userId];
    self.outLabel.text = @"用户主页";
    //底部透明图
    [self.clearImgView sd_setImageWithURL:[NSURL URLWithString:cModel.head_image]];
    //头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:cModel.head_image] placeholderImage:kDefaultPreloadHeadImg];
    
    //认证是否显示
    if ([model.user.is_authentication intValue]>0)
    {
        if (model.user.v_icon && ![model.user.v_icon isEqualToString:@""])
        {
            self.vImgView.hidden = NO;
            [self.vImgView sd_setImageWithURL:[NSURL URLWithString:model.user.v_icon] placeholderImage:kDefaultPreloadHeadImg];
        }else
        {
            self.vImgView.hidden = YES;
        }
    }else
    {
        self.vImgView.hidden = YES;
    }
    
    //名字 性别 等级
    if (cModel.nick_name.length < 1)
    {
        cModel.nick_name = @"暂无昵称";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:cModel.nick_name];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, cModel.nick_name.length)];
    CGFloat width =[cModel.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    if (width + 52 > (kScreenW+6))
    {
        width = kScreenW-52-6;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.nameLabel.attributedText = attr;
    self.nameLabel.frame = CGRectMake(0, 0, width,30);
    self.sexImgView.frame = CGRectMake(width+5,8,14,14);
    self.rankImgView.frame = CGRectMake(width+24,8,28,14);
    CGRect nameRect = self.nameView.frame;
    nameRect.size.width = (width+52);
    nameRect.origin.x = (kScreenW - (width + 52))/2;
    self.nameView.frame = nameRect;
    
    if ([cModel.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    if (cModel.user_level.length < 1)
    {
        cModel.user_level = @"1";
    }
    self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",cModel.user_level]];

    //签名
    if (cModel.signature.length < 1)
    {
        self.signatureLabel.text = @"TA好像忘记签名了";
    }else
    {
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:cModel.signature];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0,cModel.signature.length)];
        self.signatureLabel.attributedText = attr1;
    }
    if (cModel.luck_num.length && [cModel.luck_num intValue] > 0)
    {
     self.accountLabel.text = [NSString stringWithFormat:@"%@:%@",self.fanweApp.appModel.account_name,cModel.luck_num];
    }else
    {
     self.accountLabel.text = [NSString stringWithFormat:@"%@:%@",self.fanweApp.appModel.account_name,userId];
    }
    
    
    //认证
    NSString *v_explainString;
    if (cModel.v_explain.length < 1)
    {
        self.certificateView.hidden = YES;
        v_explainString = cModel.v_explain = @"未认证";
        
        CGRect rect = self.certificateView.frame;
        rect.size.height = 0;
        self.certificateView.frame = rect;
        
    }else
    {
        self.certificateView.hidden = NO;
        self.certificateImgView.hidden = NO;
        v_explainString = [NSString stringWithFormat:@"认证:%@",cModel.v_explain];
    }
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:v_explainString];
    self.certificateLabel.attributedText = attr2;
    CGFloat width1 =[v_explainString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
    self.certificateLabel.frame = CGRectMake(CGRectGetMaxX(self.certificateImgView.frame)+3, 0, width1, 21);

    //送出 关注 粉丝
    for (UILabel *label in self.itemView.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            if (label.tag == 3)
            {
                if (cModel.n_use_diamonds.length)
                {
                 label.text =cModel.n_use_diamonds;
                }else
                {
                  label.text =@"0";
                }
                
            }else if (label.tag == 4)
            {
                if (cModel.n_focus_count.length)
                {
                    label.text =cModel.n_focus_count;
                }else
                {
                    label.text =@"0";
                }
            }else if (label.tag == 5)
            {
                if (cModel.n_fans_count.length)
                {
                    label.text =cModel.n_fans_count;
                }else
                {
                    label.text =@"0";
                }
            }
        }
    }
    [self updateNewFrame];
}

- (void)setUIWithDict:(NSDictionary *)dict
{
    if ([dict count])
    {
        UserModel *model2 = [UserModel mj_objectWithKeyValues:dict];
        if (model2.live_in == FW_LIVE_STATE_ING)
        {
            [self.messageBtn setTitle:@"直播中" forState:UIControlStateNormal];
        }
        else if (model2.live_in == FW_LIVE_STATE_RELIVE)
        {
            [self.messageBtn setTitle:@"回播中" forState:UIControlStateNormal];
        }
    }else
    {
        self.messageBtn.hidden = YES;
    }
}

- (void)setCellWithModel:(userPageModel *)userInfoM
{
    //底部透明头像
    [self.clearImgView sd_setImageWithURL:[NSURL URLWithString:userInfoM.head_image]];
    
    //头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userInfoM.head_image] placeholderImage:kDefaultPreloadHeadImg];
    if (userInfoM.v_icon.length && [userInfoM.is_authentication intValue]== 2)
    {
        self.vImgView.hidden = NO;
        [self.vImgView sd_setImageWithURL:[NSURL URLWithString:userInfoM.v_icon] placeholderImage:kDefaultPreloadHeadImg];
    }else
    {
        self.vImgView.hidden = YES;
    }
    
    //账号 vip 性别 等级 编辑
    if (userInfoM.nick_name.length < 1)
    {
        userInfoM.nick_name = @"暂无昵称";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:userInfoM.nick_name];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, userInfoM.nick_name.length)];
    CGFloat width =[userInfoM.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    self.nameLabel.attributedText = attr;
    if ([userInfoM.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    if (userInfoM.user_level.length < 1)
    {
        userInfoM.user_level = @"1";
    }
    self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",userInfoM.user_level]];
    if ([userInfoM.is_vip isEqualToString:@"1"])
    {
        if (width + 20 + 19 + 33 + 30 + 5 > kScreenW)
        {
            width = kScreenW - 20 - 19 -33 - 30;
            self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        self.nameLabel.frame = CGRectMake(0, 0, width, 30);
        self.vipImgView.frame = CGRectMake(width+5, (15/2.0f), 15, 15);
        self.sexImgView.frame = CGRectMake(width+20+5, 8, 14, 14);
        self.rankImgView.frame = CGRectMake(width+20+19+5, 8, 28, 14);
        self.editBtn.frame = CGRectMake(width+20+19+33, 0, 30,30);
        
        CGRect nameRect = self.nameView.frame;
        nameRect.size.width = (width+20+19+33+30);
        nameRect.origin.x = (kScreenW - (width+20+19+33+30))/2;
        self.nameView.frame = nameRect;
    }else
    {
        if (width +19 +33 +30 > (kScreenW+6))
        {
            width = kScreenW-19 -33 -30-6;
            self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        self.nameLabel.frame = CGRectMake(0, 0, width, 30);
        self.sexImgView.frame = CGRectMake(width+5,8, 14, 14);
        self.rankImgView.frame = CGRectMake(width+24,8, 28, 14);
        self.editBtn.frame = CGRectMake(width+24+28, 0,30,30);
        CGRect nameRect = self.nameView.frame;
        nameRect.size.width = (width +19 +33 +30);
        nameRect.origin.x = (kScreenW - (width +19 +33 +30))/2;
        self.nameView.frame = nameRect;
    }
    
    //签名
    if (userInfoM.signature.length < 1)
    {
        self.signatureLabel.text = @"TA好像忘记签名了";
    }else
    {
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:userInfoM.signature];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0,userInfoM.signature.length)];
        self.signatureLabel.attributedText = attr1;
    }
    
    //账号
    if ([userInfoM.luck_num intValue] > 0)
    {
        if (self.fanweApp.appModel.account_name.length > 0)
        {
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.fanweApp.appModel.account_name, userInfoM.luck_num];
        }else
        {
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.fanweApp.appModel.account_name,userInfoM.luck_num];
        }
    }
    else
    {
        if (self.fanweApp.appModel.account_name.length > 0)
        {
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.fanweApp.appModel.account_name, userInfoM.user_id];
        }else
        {
            self.accountLabel.text =[NSString stringWithFormat:@"账号:%@", userInfoM.user_id];
        }
    }
    
    //认证
    NSString *v_explainString;
    if (userInfoM.v_explain.length < 1)
    {
        self.certificateView.hidden = YES;
        v_explainString = userInfoM.v_explain = @"未认证";
        CGRect rect = self.certificateView.frame;
        rect.size.height = 0;
        self.certificateView.frame = rect;
        
    }else
    {
        self.certificateView.hidden = NO;
        self.certificateImgView.hidden = NO;
        v_explainString = [NSString stringWithFormat:@"认证:%@",userInfoM.v_explain];
        NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:v_explainString];
        self.certificateLabel.attributedText = attr2;
        
        CGFloat width1 =[v_explainString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
        self.certificateLabel.frame = CGRectMake(CGRectGetMaxX(self.certificateImgView.frame)+3, 0, width1, 21);
        CGRect rect = self.certificateView.frame;
        rect.size.width = width1+20;
        rect.size.height = 21;
        self.certificateView.frame = rect;
        self.certificateLabel.frame = CGRectMake(18, 0, width1, 21);
    }


    //直播 小视频 关注 粉丝
    for (UILabel *label in self.itemView.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            if (label.tag == 4)
            {
                if (userInfoM.n_video_count.length)
                {
                    label.text = userInfoM.n_video_count;
                }else
                {
                    label.text =@"0";
                }
                
            }else if (label.tag == 5)
            {
                if (userInfoM.n_svideo_count.length)
                {
                    label.text =userInfoM.n_svideo_count;
                }else
                {
                    label.text =@"0";
                }
            }else if (label.tag == 6)
            {
                if (userInfoM.n_focus_count.length)
                {
                    label.text =userInfoM.n_focus_count;
                }else
                {
                    label.text =@"0";
                }
            }else if (label.tag == 7)
            {
                if (userInfoM.n_fans_count.length)
                {
                    label.text =userInfoM.n_fans_count;
                }else
                {
                    label.text =@"0";
                }
            }
        }
    }
    
    [self updateNewFrame];
}

- (void)updateNewFrame
{
    //透明图片和透明view
    CGRect  newRect = self.clearView.frame =self.clearImgView.frame;
    newRect.size.height = CGRectGetMaxY(self.certificateView.frame) +40;
    self.clearView.frame = newRect;
    
    //底部灰色view
    CGRect bottomRect = self.bottomView.frame;
    bottomRect.origin.y = CGRectGetMaxY(self.clearView.frame);
    self.bottomView.frame = bottomRect;
    //底部灰色view
    CGRect itemRect =  self.itemView.frame;
    itemRect.origin.y = CGRectGetMaxY(self.clearView.frame)-20;
    self.itemView.frame = itemRect;
    //本身的view
    CGRect myRect = self.frame;
    myRect.size.height = self.clearView.size.height+60;
    self.frame = myRect;

}

- (void)buttonClick:(UIButton *)btn
{
    if (self.headViewBlock)
    {
        self.headViewBlock((int)btn.tag);
    }
}

/**
 设置 角标
 
 @param sender 对应的控件
 */
- (void)initBadgeBtn:(UIButton *)sender
{
    //-好友
    _badge = [[JSBadgeView alloc]initWithParentView:sender alignment:JSBadgeViewAlignmentTopRight];
    _badge.badgePositionAdjustment = CGPointMake(-6, 3);
}


@end
