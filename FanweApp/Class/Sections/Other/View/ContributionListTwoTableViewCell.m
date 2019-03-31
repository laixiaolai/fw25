//
//  ContributionListTwoTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/11.
//  Copyright © 2016年 xfg. All rights reserved.

#import "ContributionListTwoTableViewCell.h"

@implementation ContributionListTwoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _fanweApp = [GlobalVariables sharedInstance];
        
        self.backgroundColor = [UIColor whiteColor];
        self.bigHeadView = [[UIImageView alloc]init];
        self.smallHeadView = [[UIImageView alloc]init];
        self.nameLabel = [[UILabel alloc]init];
        self.rankingLabel = [[UILabel alloc]init];
        self.smallImgView = [[UIImageView alloc]init];
        self.ticketLabel = [[UILabel alloc]init];
        self.rankingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sexImgView = [[UIImageView alloc]init];
        self.rankingImgView = [[UIImageView alloc]init];
        self.vIconImageView = [[UIImageView alloc]init];
        self.view = [[UIView alloc]init];
        self.view.alpha = 0.5;
        self.buttonView = [[UIView alloc]init];
        self.buttonView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCellWithModel:(UserModel *)model withRow:(int)row
{
     if (row == 2)
    {
        //排名第几
        self.rankingButton.frame = CGRectMake(0, 40, 54, 20);
        [self.rankingButton setImage:[UIImage imageNamed:@"me_yp_bg2"] forState:0];
        self.rankingLabel.frame = CGRectMake(0, 0, 54, 20);
        self.rankingLabel.textAlignment = NSTextAlignmentCenter;
        self.rankingLabel.backgroundColor = [UIColor clearColor];
        self.rankingLabel.text = @"NO.2";
        self.rankingLabel.textColor = [UIColor whiteColor];
        self.rankingLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.rankingButton];
        [self.rankingButton addSubview:self.rankingLabel];
        
        //小图
        self.smallHeadView.frame = CGRectMake(kScreenW/2-19, 11, 38, 38);
        self.smallHeadView.layer.cornerRadius = self.smallHeadView.frame.size.height/2;
        self.smallHeadView.layer.masksToBounds = YES;
        [self.smallHeadView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
        [self addSubview:self.smallHeadView];
        
        //大图
        self.bigHeadView.frame = CGRectMake(kScreenW/2-31, 10, 61,45);
        self.bigHeadView.image = [UIImage imageNamed:@"me_yp_no_2"];
        [self addSubview:self.bigHeadView];
        
        //名字
        self.nameLabel.textColor = textColor4;
        if (model.nick_name.length < 1)
        {
            model.nick_name = @"方维";
        }
        NSString *string = [NSString stringWithFormat:@"%@",model.nick_name];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, string.length)];
        CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        self.buttonView.frame = CGRectMake(kScreenW/2-(width+52)/2,self.bigHeadView.frame.size.height+ self.bigHeadView.frame.origin.y+7, width+52, 20);
        self.nameLabel.frame = CGRectMake(0, 0, width, 20);
        [self addSubview:self.buttonView];
        self.nameLabel.attributedText = attr;
        [self.buttonView addSubview:self.nameLabel];
        
        //性别的图片
        self.sexImgView.frame = CGRectMake(self.nameLabel.frame.size.width+self.nameLabel.frame.origin.x+5,3, 14, 14);
        if ([model.sex isEqualToString:@"1"])
        {
            self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
        }else{
            self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
        }
        [self.buttonView addSubview:self.sexImgView];
        
        //排行版的图片
        self.rankingImgView.frame = CGRectMake(self.sexImgView.frame.size.width+self.sexImgView.frame.origin.x+5,3, 28, 14);
        self.rankingImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_level]];
        [self.buttonView addSubview:self.rankingImgView];
        
        //映票
        self.ticketLabel.textColor = textColor4;
        if (model.num.length < 1)
        {
            model.num = @"0";
        }
        self.ticketLabel.font = [UIFont systemFontOfSize:15];
        NSString *string1  = [NSString stringWithFormat:@"贡献 %@ %@",model.num, _fanweApp.appModel.ticket_name];
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:string1];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, string1.length)];
        //CGRect attributeRect1 = [attr boundingRectWithSize:CGSizeMake(kScreenW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil]; 多行的
        CGSize size1 =[string1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        [attr1 setAttributes:@{NSForegroundColorAttributeName : kAppGrayColor1} range:[string1 rangeOfString:model.num]];
        self.ticketLabel.frame = CGRectMake(kScreenW/2-size1.width/2, self.buttonView.frame.size.height+self.buttonView.frame.origin.y+7, size1.width+5, 20);
        self.ticketLabel.attributedText = attr1;
        [self addSubview:self.ticketLabel];
        
        
        //底部线
        self.view.frame = CGRectMake(10, 122, kScreenW-20, 1);
        self.view.backgroundColor = myTextColorLine5;;
        [self addSubview:self.view];
        
        
    }else if (row == 3)
    {
        //排名第几
        self.rankingButton.frame = CGRectMake(0, 40, 54, 20);
        [self.rankingButton setImage:[UIImage imageNamed:@"me_yp_bg2"] forState:0];
        self.rankingLabel.frame = CGRectMake(0, 0, 54, 20);
        self.rankingLabel.textAlignment = NSTextAlignmentCenter;
        self.rankingLabel.backgroundColor = [UIColor clearColor];
        self.rankingLabel.text = @"NO.3";
        self.rankingLabel.textColor = [UIColor whiteColor];
        self.rankingLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.rankingButton];
        [self.rankingButton addSubview:self.rankingLabel];

        //小图
        self.smallHeadView.frame = CGRectMake(kScreenW/2-19, 11, 37, 38);
        self.smallHeadView.layer.cornerRadius = self.smallHeadView.frame.size.width/2;
        self.smallHeadView.layer.masksToBounds = YES;
        [self.smallHeadView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
        [self addSubview:self.smallHeadView];
        
        //大图
        self.bigHeadView.frame = CGRectMake(kScreenW/2-26, 10, 51,45);
        self.bigHeadView.image = [UIImage imageNamed:@"me_yp_no_3"];
        [self addSubview:self.bigHeadView];
        
        //名字
        self.nameLabel.textColor = textColor4;
        if (model.nick_name.length < 1)
        {
            model.nick_name = @"方维";
        }
        NSString *string = [NSString stringWithFormat:@"%@",model.nick_name];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, string.length)];
        CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        self.buttonView.frame = CGRectMake(kScreenW/2-(width+52)/2,self.bigHeadView.frame.size.height+ self.bigHeadView.frame.origin.y+8, width+52, 20);
        [self addSubview:self.buttonView];
        self.nameLabel.frame = CGRectMake(0,0,width, 20);
        self.nameLabel.attributedText = attr;
        [self.buttonView addSubview:self.nameLabel];
        
        //性别的图片
        self.sexImgView.frame = CGRectMake(self.nameLabel.frame.size.width+self.nameLabel.frame.origin.x+5,3, 14, 14);
        if ([model.sex isEqualToString:@"1"])
        {
            self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
        }else{
            self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
        }
        [self.buttonView addSubview:self.sexImgView];
        
        //排行版的图片
        self.rankingImgView.frame = CGRectMake(self.sexImgView.frame.size.width+self.sexImgView.frame.origin.x+5,3, 28, 14);
        self.rankingImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_level]];
        [self.buttonView addSubview:self.rankingImgView];
        
        //映票
        self.ticketLabel.textColor = textColor4;
        if (model.num.length < 1)
        {
            model.num = @"0";
        }
        self.ticketLabel.font = [UIFont systemFontOfSize:15];
        NSString *string1  = [NSString stringWithFormat:@"贡献 %@ %@",model.num, _fanweApp.appModel.ticket_name];
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:string1];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, string1.length)];
        //CGRect attributeRect1 = [attr boundingRectWithSize:CGSizeMake(kScreenW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];多行的
        CGSize size1 =[string1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        [attr1 setAttributes:@{NSForegroundColorAttributeName : kAppGrayColor1} range:[string1 rangeOfString:model.num]];
        self.ticketLabel.frame = CGRectMake(kScreenW/2-size1.width/2, self.buttonView.frame.size.height+self.buttonView.frame.origin.y+6, size1.width+5, 20);
        self.ticketLabel.attributedText = attr1;
        [self addSubview:self.ticketLabel];
        
    }
    
    //认证
    self.vIconImageView.frame = CGRectMake(CGRectGetMaxX(self.smallHeadView.frame)-15, CGRectGetMaxY(self.smallHeadView.frame)-19, 15, 15);
    if (model.v_icon.length > 0) {
        self.vIconImageView.hidden = NO;
        [self.vIconImageView sd_setImageWithURL:[NSURL URLWithString:model.v_icon]];
    }
    else
    {
        self.vIconImageView.hidden = YES;
    }
    [self addSubview:self.vIconImageView];
}

@end
