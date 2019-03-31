//
//  ContributionListThreeTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ContributionListThreeTableViewCell.h"


@implementation ContributionListThreeTableViewCell

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
    }
    return self;
}

- (void)setCellWithModel:(UserModel *)model withRow:(int)row
{
    //排名第几
    self.rankingButton.frame = CGRectMake(0, 15, 60, 20);
    [self.rankingButton setTitle:[NSString stringWithFormat:@"NO.%d",row] forState:0];
    self.rankingButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.rankingButton setTitleColor:[UIColor blackColor] forState:0];
    [self addSubview:self.rankingButton];
    
    //小图
    self.smallHeadView.frame = CGRectMake(60,10, 40, 40);
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
    self.nameLabel.textColor = kGrayTransparentColor6;
    if (model.nick_name.length < 1)
    {
        model.nick_name = @"方维";
    }
    NSString *string = [NSString stringWithFormat:@"%@",model.nick_name];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} range:NSMakeRange(0, string.length)];
    CGSize size =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    if (size.width > kScreenW -CGRectGetMaxX(self.smallHeadView.frame) - 52)
    {
        size.width = kScreenW -CGRectGetMaxX(self.smallHeadView.frame) - 52 - 10;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.nameLabel.frame = CGRectMake(self.smallHeadView.frame.size.width+self.smallHeadView.frame.origin.x+5,10,size.width, 20);
    self.nameLabel.attributedText = attr;
    [self addSubview:self.nameLabel];
    
    //    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.nameLabel.text];
    //    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, self.nameLabel.text.length)];
    //    CGFloat width =[self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    //    if (width > kScreenW-260)//名字控件需要控制长度
    //    {
    //        width = kScreenW - 260-5;
    //        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    }
    
    //性别的图片
    self.sexImgView.frame = CGRectMake(self.nameLabel.frame.size.width+self.nameLabel.frame.origin.x+5,12, 14, 14);
    [self addSubview:self.sexImgView];
    if ([model.sex isEqualToString:@"1"])//男
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }
    else if ([model.sex isEqualToString:@"2"])//女
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    
    
    //排行版的图片
    self.rankingImgView.frame = CGRectMake(self.sexImgView.frame.size.width+self.sexImgView.frame.origin.x+5,12, 28, 14);
    self.rankingImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_level]];
    [self addSubview:self.rankingImgView];
    
    //映票
    self.ticketLabel.textColor = textColor4;
    self.ticketLabel.font = [UIFont systemFontOfSize:13];
    if (model.num.length < 1)
    {
        model.num = @"0";
    }
    NSString *string1  = [NSString stringWithFormat:@"贡献 %@ %@",model.num, _fanweApp.appModel.ticket_name];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} range:NSMakeRange(0, string1.length)];
    //CGRect attributeRect1 = [attr boundingRectWithSize:CGSizeMake(kScreenW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];多行的
    CGSize size1 =[string1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    [attr1 setAttributes:@{NSForegroundColorAttributeName : kAppGrayColor1} range:[string1 rangeOfString:model.num]];
    self.ticketLabel.frame = CGRectMake(self.smallHeadView.frame.size.width+self.smallHeadView.frame.origin.x+5, self.nameLabel.frame.size.height+self.nameLabel.frame.origin.y, size1.width+5, 20);
    self.ticketLabel.attributedText = attr1;
    [self addSubview:self.ticketLabel];
    
    //底部线
    self.view.frame = CGRectMake(10, 59, kScreenW-20, 1);
    self.view.backgroundColor = myTextColorLine5;
    [self addSubview:self.view];
    
}



@end
