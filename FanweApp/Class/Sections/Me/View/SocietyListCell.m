//
//  SocietyListCell.m
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SocietyListCell.h"
#import "SocietyListModel.h"
@interface SocietyListCell()
@property (nonatomic, strong) UIImageView * headView;            //公会头像
@property (nonatomic, strong) UILabel * familyNameLabel;         //公会名称
@property (nonatomic, strong) UILabel * headerNameLabel;        //公会会长名称
@property (nonatomic, strong) UILabel * numberLabel1;            //人数：
@property (nonatomic, strong) UILabel * numberLabel2;            //家族人数
@property (nonatomic, strong) UILabel * numberLabel3;            //人
//@property (nonatomic, strong) UIButton * applyBtn;               //加入家族
@property (nonatomic, strong) UILabel * lineLabel;               //画线
@end

@implementation SocietyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        //        _headView.backgroundColor = [UIColor redColor];
        _headView.layer.cornerRadius = 20;
        _headView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headView];
        _familyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, kScreenW-155, 18)];
        _familyNameLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_familyNameLabel];
        _headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 32, 90, 18)];
        _headerNameLabel.font = [UIFont systemFontOfSize:13.0];
        _headerNameLabel.textColor = kAppGrayColor3;
        _headerNameLabel.text = @"天使的眼泪";
        [self.contentView addSubview:_headerNameLabel];
        _numberLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerNameLabel.frame)+10, 32, 40, 18)];
        _numberLabel1.textColor = kAppGrayColor3;
        _numberLabel1.text = @"人数 :";
        _numberLabel1.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_numberLabel1];
        _numberLabel2 = [[UILabel alloc] init];
        _numberLabel2.textColor = kAppGrayColor1;
        _numberLabel2.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_numberLabel2];
        _numberLabel3 = [[UILabel alloc] init];
        _numberLabel3.textColor = kAppGrayColor3;
        _numberLabel3.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_numberLabel3];
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.frame = CGRectMake(kScreenW-85, 15, 75, 30);
        _applyBtn.layer.cornerRadius = 12;
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _applyBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_applyBtn];
        
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 59, kScreenW-10, 0.5)];
        _lineLabel.backgroundColor = kAppGrayColor4;
        _lineLabel.alpha = 0.5;
        [self.contentView addSubview:_lineLabel];
        _numberLabel1.hidden = YES;
        _numberLabel2.hidden = YES;
        _numberLabel3.hidden = YES;
    }
    return self ;
}

- (void)setModel:(SocietyListModel *)model
{
    _model = model;
    //    [_headView sd_setImageWithURL:[NSURL URLWithString:model.family_logo]];
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:kDefaultPreloadHeadImg];
    _familyNameLabel.text = model.name;
    _headerNameLabel.text = [NSString stringWithFormat:@"会长 : %@",model.nick_name];
    CGSize titleSize = [model.user_count boundingRectWithSize:CGSizeMake(kScreenW-290, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _numberLabel2.frame = CGRectMake(CGRectGetMaxX(_numberLabel1.frame), 32, titleSize.width, 18);
    _numberLabel2.text = model.user_count;
    _numberLabel3.frame = CGRectMake(CGRectGetMaxX(_numberLabel2.frame), 32, 13, 18);
    _numberLabel3.text = @"人";
    if ([model.is_apply intValue]==1) {
        _applyBtn.backgroundColor = kAppGrayColor3;
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"申请中" forState:UIControlStateNormal];
    }
    else if ([model.is_apply intValue]==0)
    {
        _applyBtn.backgroundColor = kAppMainColor;
        _applyBtn.enabled = YES;
        [_applyBtn addTarget:self action:@selector(clickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_applyBtn setTitle:@"加入公会" forState:UIControlStateNormal];
    }
    else if ([model.is_apply intValue]==2)
    {
        _applyBtn.backgroundColor = kAppGrayColor3;
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"已加入" forState:UIControlStateNormal];
    }
}

- (void)clickApplyBtn:(UIButton *)applyBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(applyWithSocietyListCell:)]) {
        [_delegate applyWithSocietyListCell:self];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
