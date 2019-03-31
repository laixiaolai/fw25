//
//  FamilyListCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FamilyListCell.h"
#import "FamilyMemberModel.h"
#import "SenderModel.h"

@interface  FamilyListCell()
@property (weak, nonatomic) IBOutlet UIButton *kickOutBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, strong) UILabel *nameLabel2;
@property (nonatomic, strong) UIImageView *sexImgView2;
@property (nonatomic, strong) UIImageView *rankImgView2;
@property (nonatomic, strong) UIImageView * familyHeaderView;

@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, copy) NSString *user_id;

@end

@implementation FamilyListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FamilyListCell";
    FamilyListCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell== nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FamilyListCell class]) owner:nil options:nil] lastObject];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.familyHeaderView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.familyHeaderView];
    
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

- (void)creatCellWithModel:(SenderModel *)model WithRow:(int)row
{
    self.user_id = model.user_id;
    //    NSLog(@"*******************_______________________%@",model.head_image);
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
    self.familyHeaderView.frame = CGRectMake(CGRectGetMaxX(_rankImgView2.frame)+5, 8, 28, 16);
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
    if ([model.family_chieftain isEqualToString:@"1"]) {
        self.familyHeaderView.image = [UIImage imageNamed:@"me_family_header"];
    }
    self.familyHeaderView.hidden = [model.family_chieftain integerValue] == 1 ? NO : YES;
    //如果是家族族长，并且对应的cell的家族成员不是族长本人时，显示踢出家族的按钮
    if (self.isFamilyHeader == 1 && [model.family_chieftain isEqualToString:@"0"]) {
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
    //踢出家族，做删除操作
    if (_delegate && [_delegate respondsToSelector:@selector(kickOutWithFamilyListCell:)]) {
        [_delegate kickOutWithFamilyListCell:self];
    }
}

@end
