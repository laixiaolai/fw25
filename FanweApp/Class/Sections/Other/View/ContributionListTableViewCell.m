//
//  ContributionListTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/7.
//  Copyright © 2016年 xfg. All rights reserved.

#import "ContributionListTableViewCell.h"

@implementation ContributionListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _fanweApp = [GlobalVariables sharedInstance];
        self.backgroundColor = [UIColor whiteColor];
        self.bigHeadView = [[UIImageView alloc]init];
        self.smallHeadView = [[UIImageView alloc]init];
        self.buttonView = [[UIView alloc]init];
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
        
        self.buttonView2 = [[UIView alloc]init];
        self.buttonView2.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCellWithModel:(UserModel *)model withType:(NSString *)type withNum:(int)num{
    
    if ([type isEqualToString:@"1"])//本次直播
    {
        self.backgroundColor = kWhiteColor;
        self.smallHeadView.hidden = NO;
        self.nameLabel.hidden = NO;
        //头像
        self.smallHeadView.frame = CGRectMake(kScreenW/2-20, 20, 40, 40);
        self.smallHeadView.layer.cornerRadius = self.smallHeadView.frame.size.height/2;
        self.smallHeadView.layer.masksToBounds = YES;
        [self.smallHeadView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
        [self addSubview:self.smallHeadView];
        
        //认证
        self.vIconImageView.frame = CGRectMake(CGRectGetMaxX(self.smallHeadView.frame)-15, CGRectGetMaxY(self.smallHeadView.frame)-15, 15, 15);
        if (model.v_icon.length > 0) {
            self.vIconImageView.hidden = NO;
            [self.vIconImageView sd_setImageWithURL:[NSURL URLWithString:model.v_icon]];
        }
        else
        {
            self.vIconImageView.hidden = YES;
        }
        [self addSubview:self.vIconImageView];
        
        //名字
        self.nameLabel.frame = CGRectMake(0,self.smallHeadView.frame.size.height+self.smallHeadView.frame.origin.y, kScreenW, 20);
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = textColor4;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        if (model.nick_name.length < 1)
        {
            model.nick_name = @"方维";
        }
        self.nameLabel.text = model.nick_name;
        
        NSString *nameString  = [NSString stringWithFormat:@"%@",model.nick_name];
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:nameString];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, nameString.length)];
        self.nameLabel.attributedText = attr1;
        [self addSubview:self.nameLabel];
        //图片
        self.smallImgView.frame = CGRectMake(0, 3, 18, 19);
        self.smallImgView.image = [UIImage imageNamed:@"me_ranking_yingpiao"];
        
        
        //映票
        //self.ticketLabel.frame = CGRectMake(kScreenW/2-25, self.nameLabel.frame.size.height+self.nameLabel.frame.origin.y, 150, 25);
        self.ticketLabel.textAlignment = NSTextAlignmentLeft;
        self.ticketLabel.font = [UIFont systemFontOfSize:15];
        self.ticketLabel.textColor = textColor4;
        
        if (model.ticket.length < 1)
        {
            model.ticket = @"0";
        }
        self.ticketLabel.font = [UIFont systemFontOfSize:15];
        // NSString *string  = [NSString stringWithFormat:@"%@ %@",model.ticket, _fanweApp.appModel.ticket_name];
        NSString *string  = [NSString stringWithFormat:@"%d %@",num, _fanweApp.appModel.ticket_name];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, string.length)];
        [attr setAttributes:@{NSForegroundColorAttributeName : kAppGrayColor1} range:[string rangeOfString:model.ticket]]; //设置会员名称的字体颜色
        CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        self.buttonView.frame = CGRectMake(kScreenW/2-(24+width)/2, self.nameLabel.frame.size.height+self.nameLabel.frame.origin.y, width, 25);
        [self addSubview:self.buttonView];
        self.ticketLabel.frame = CGRectMake(21, 0, width, 25);
        self.ticketLabel.attributedText = attr;
        [self.buttonView addSubview:self.ticketLabel];
        [self.buttonView addSubview:self.smallImgView];
        
    }else if ([type isEqualToString:@"0"])//累计直播
    {
        self.smallHeadView.hidden = YES;
        self.nameLabel.hidden = YES;
        self.vIconImageView.hidden = YES;
        self.smallImgView.frame = CGRectMake(0, 20, 18, 19);
        self.smallImgView.image = [UIImage imageNamed:@"me_ranking_yingpiao"];
        
        //映票
        self.ticketLabel.textAlignment = NSTextAlignmentLeft;
        self.ticketLabel.font = [UIFont systemFontOfSize:15];
        self.ticketLabel.textColor = textColor4;

        self.ticketLabel.font = [UIFont systemFontOfSize:15];
        // NSString *string  = [NSString stringWithFormat:@"%@ %@",model.ticket, _fanweApp.appModel.ticket_name];
        NSString *string  = [NSString stringWithFormat:@"%d %@",num, _fanweApp.appModel.ticket_name];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, string.length)];
        [attr setAttributes:@{NSForegroundColorAttributeName : kAppGrayColor1} range:[string rangeOfString:[NSString stringWithFormat:@"%d",num]]]; //设置会员名称的字体颜色
        CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        self.buttonView.frame = CGRectMake(kScreenW/2-(24+width)/2,0,width, 50);
        [self addSubview:self.buttonView];
        self.ticketLabel.frame = CGRectMake(21, 17, width, 25);
        self.ticketLabel.attributedText = attr;
        [self.buttonView addSubview:self.ticketLabel];
        [self.buttonView addSubview:self.smallImgView];
        self.backgroundColor = kBackGroundColor;
    }
}

- (void)setCellWithModel:(UserModel *)model withRow:(int)row
{
    self.smallHeadView.hidden = NO;
    self.nameLabel.hidden = NO;
    self.backgroundColor = kWhiteColor;
    if (row == 1)
    {
        //排名第几
        self.rankingButton.frame = CGRectMake(0, 30, 54, 20);
        [self.rankingButton setImage:[UIImage imageNamed:@"me_yp_bg2"] forState:0];
        self.rankingLabel.frame = CGRectMake(0, 0, 54, 20);
        self.rankingLabel.backgroundColor = [UIColor clearColor];
        self.rankingLabel.textAlignment = NSTextAlignmentCenter;
        self.rankingLabel.text = @"NO.1";
        self.rankingLabel.textColor = [UIColor whiteColor];
        self.rankingLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.rankingButton];
        [self.rankingButton addSubview:self.rankingLabel];
        
        //小图
        self.smallHeadView.frame = CGRectMake(kScreenW/2-26, 24, 48, 48);
        self.smallHeadView.layer.cornerRadius = self.smallHeadView.frame.size.height/2;
        self.smallHeadView.layer.masksToBounds = YES;
        [self.smallHeadView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
        [self addSubview:self.smallHeadView];
        
        //大图
        self.bigHeadView.frame = CGRectMake(kScreenW/2-51, 10, 96, 71);
        self.bigHeadView.image = [UIImage imageNamed:@"me_yp_no_1"];
        [self addSubview:self.bigHeadView];
        
        //认证
        self.vIconImageView.frame = CGRectMake(CGRectGetMaxX(self.smallHeadView.frame)-15, CGRectGetMaxY(self.smallHeadView.frame)-15, 15, 15);
        if (model.v_icon.length > 0) {
            self.vIconImageView.hidden = NO;
            [self.vIconImageView sd_setImageWithURL:[NSURL URLWithString:model.v_icon]];
        }
        else
        {
            self.vIconImageView.hidden = YES;
        }
        [self addSubview:self.vIconImageView];
        
        //名字
        if (model.nick_name.length < 1)
        {
            model.nick_name = @"方维";
        }
        
        NSString *string = [NSString stringWithFormat:@"%@",model.nick_name];
        self.nameLabel.textColor = kGrayTransparentColor6;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, string.length)];
        CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        self.buttonView2.frame = CGRectMake(kScreenW/2-(width+52)/2, self.bigHeadView.frame.size.height+ self.bigHeadView.frame.origin.y+8, width+52, 20);
        [self addSubview:self.buttonView2];
        self.nameLabel.frame = CGRectMake(0, 0,width, 20);
        self.nameLabel.textColor = textColor4;
        self.nameLabel.attributedText = attr;
        [self.buttonView2 addSubview:self.nameLabel];
        
        //性别的图片
        self.sexImgView.frame = CGRectMake(width+5,3, 14, 14);
        if ([model.sex isEqualToString:@"1"])
        {
            self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
        }else{
          self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
        }
        [self.buttonView2 addSubview:self.sexImgView];
        
        //排行版的图片
        self.rankingImgView.frame = CGRectMake(self.sexImgView.frame.size.width+self.sexImgView.frame.origin.x+5,3, 28, 14);
        if ([model.user_level integerValue] < 1)
        {
            model.user_level = @"1";
        }
        self.rankingImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_level]];
        [self.buttonView2 addSubview:self.rankingImgView];
        
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

        self.ticketLabel.frame = CGRectMake(kScreenW/2-size1.width/2, self.buttonView2.frame.size.height+self.buttonView2.frame.origin.y+6, size1.width+5, 20);
        self.ticketLabel.attributedText = attr1;
        [self addSubview:self.ticketLabel];
        
        //底部线
        self.view.frame = CGRectMake(10, 146, kScreenW-20, 1);
        self.view.backgroundColor = myTextColorLine5;;
        [self addSubview:self.view];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

@end
