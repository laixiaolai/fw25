//
//  MemberApplyCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "MemberApplyCell.h"
#import "SenderModel.h"

@interface  MemberApplyCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

@property (nonatomic, strong) UILabel *nameLabel2;
@property (nonatomic, strong) UIImageView *sexImgView2;
@property (nonatomic, strong) UIImageView *rankImgView2;

@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, copy) NSString *user_id;

@end
@implementation MemberApplyCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MemberApplyCell";
    MemberApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MemberApplyCell class]) owner:nil options:nil] lastObject];
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
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kScreenW, 1)];
    self.lineView.backgroundColor = myTextColorLine5;
    [self.contentView addSubview:self.lineView];
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    
    self.commentLabel.textColor = myTextColorLine3;
    self.agreeBtn.layer.cornerRadius = 15;
    self.agreeBtn.layer.masksToBounds = YES;
    self.agreeBtn.backgroundColor = kAppMainColor;
    self.refuseBtn.layer.cornerRadius = 15;
    self.refuseBtn.layer.masksToBounds = YES;
    self.refuseBtn.backgroundColor =kAppFamilyBtnColor;
}

- (void)creatCellWithModel:(SenderModel *)model WithRow:(int)row
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
    if (width+ 52 > kScreenW-200)//名字控件需要控制长度
    {
        width = kScreenW - 200-52;
        self.nameLabel2.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.nameLabel2.frame = CGRectMake(60, 6, width, 21);
    self.sexImgView2.frame = CGRectMake(width+65, 9, 14, 14);
    self.rankImgView2.frame = CGRectMake(width+84, 8, 28, 16);
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
}


- (IBAction)clickAgreeBtn:(UIButton *)sender
{
    //同意加入家族，做删除操作
    if (_delegate && [_delegate respondsToSelector:@selector(agreeWithMemberApplyCell:)]) {
        [_delegate agreeWithMemberApplyCell:self];
    }
}

- (IBAction)clickRefuseBtn:(UIButton *)sender
{
    //拒绝加入家族，做删除操作
    if (_delegate && [_delegate respondsToSelector:@selector(refuseWithMemberApplyCell:)]) {
        [_delegate refuseWithMemberApplyCell:self];
    }
}


@end
