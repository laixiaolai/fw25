//
//  SocietyMemberCell.m
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SocietyMemberCell.h"
#import "SocietyMemberModel.h"
@interface SocietyMemberCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *kickOutBtn;

@property (nonatomic, strong) UILabel *nameLabel2;
@property (nonatomic, strong) UIImageView *sexImgView2;
@property (nonatomic, strong) UIImageView *rankImgView2;
//@property (nonatomic, strong) UIImageView * societyHeaderView;
@property (nonatomic, strong) UILabel * societyHeaderLabel;
@property (nonatomic, copy) NSString *user_id;
@end

@implementation SocietyMemberCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SocietyMemberCell";
    SocietyMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SocietyMemberCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nameLabel.hidden = YES;
    self.nameLabel2 = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLabel2];
    self.sexImgView.hidden = YES;
    self.sexImgView2 = [[UIImageView alloc]init];
    [self.contentView addSubview:self.sexImgView2];
    
    self.rankImgView.hidden = YES;
    self.rankImgView2 = [[UIImageView alloc]init];
    [self.contentView addSubview:self.rankImgView2];
    self.societyHeaderLabel = [[UILabel alloc] init];
    self.societyHeaderLabel.backgroundColor = kAppMainColor;
    self.societyHeaderLabel.textColor = [UIColor whiteColor];
    self.societyHeaderLabel.textAlignment = NSTextAlignmentCenter;
    self.societyHeaderLabel.font = [UIFont systemFontOfSize:13];
    self.societyHeaderLabel.hidden = YES;
    [self.contentView addSubview:self.societyHeaderLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kScreenW, 1)];
    self.lineView.backgroundColor = myTextColorLine5;
    [self.contentView addSubview:self.lineView];
    
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    
    self.commentLabel.textColor = myTextColorLine3;
    self.kickOutBtn.backgroundColor = kAppMainColor;
    self.kickOutBtn.layer.cornerRadius = 15;
    self.kickOutBtn.layer.masksToBounds = YES;
    self.kickOutBtn.hidden = YES;
    self.kickOutBtn.enabled = NO;
}

- (void)creatCellWithModel:(SocietyMemberModel *)model WithRow:(int)row
{
    self.user_id = model.user_id;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    if (model.nick_name.length < 1)
    {
        model.nick_name = @"暂时还未命名";
    }
    self.nameLabel2.textColor = kGrayTransparentColor6;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.nick_name];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, model.nick_name.length)];
    CGFloat width =[model.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    if (width+ 85 > kScreenW-155)//名字控件需要控制长度
    {
        width = kScreenW - 155-85;
        self.nameLabel2.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.nameLabel2.frame = CGRectMake(60, 6, width, 21);
    self.sexImgView2.frame = CGRectMake(width+65, 9, 14, 14);
    self.rankImgView2.frame = CGRectMake(width+84, 8, 28, 16);
    self.societyHeaderLabel.frame = CGRectMake(CGRectGetMaxX(_rankImgView2.frame)+5, 8, 28, 16);
    self.nameLabel2.attributedText = attr;
    
    if ([model.sex isEqualToString:@"1"])
    {
        self.sexImgView2.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        self.sexImgView2.image = [UIImage imageNamed:@"com_female_selected"];
    }
    self.rankImgView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%d",(int)model.user_level]];
    if (model.signature.length < 1)
    {
        self.commentLabel.text = @"";
    }else
    {
        self.commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:model.signature];
        self.commentLabel.attributedText = attr1;
    }
    if ([model.society_chieftain isEqualToString:@"1"]) {
        self.societyHeaderLabel.text = @"会长";
        self.societyHeaderLabel.hidden = NO;
    }
    else
    {
        self.societyHeaderLabel.hidden = YES;
    }
    //如果是公会会长，并且对应的cell的公会成员不是会长本人时，显示踢出公会的按钮
    if (self.isSocietyHeader == 1 && [model.society_chieftain isEqualToString:@"0"]) {
        self.kickOutBtn.hidden = NO;
        self.kickOutBtn.enabled = YES;
        //        [_kickOutBtn setTitle:@"踢出家族" forState:UIControlStateNormal];
    }
    else
    {
        self.kickOutBtn.hidden = YES;
    }
}

- (IBAction)kickOutMember:(UIButton *)sender {
    //踢出公会，做删除操作
    if (_delegate && [_delegate respondsToSelector:@selector(kickOutWithSocietyMemberCell:)]) {
        [_delegate kickOutWithSocietyMemberCell:self];
    }
}

@end
