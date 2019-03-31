//
//  ShopListTableViewCell.m
//  FanweApp
//
//  Created by yy on 16/9/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ShopListTableViewCell.h"
#import "ShopListModel.h"

@interface  ShopListTableViewCell()
{
    NetHttpsManager *_httpsManager;
}
@property (weak, nonatomic) IBOutlet UIImageView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;//商品详情描述
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *toEditButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation ShopListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopListTableViewCell";
    ShopListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell== nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShopListTableViewCell class]) owner:nil options:nil] lastObject];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _goodsView.clipsToBounds = YES;
    _titleLabel.font = kAppMiddleTextFont;
    _titleLabel.textColor = kAppGrayColor1;
    _desLabel.textColor = kAppGrayColor3;
    _desLabel.hidden = YES;
    _desLabel.font = kAppSmallTextFont;
    _priceLabel.textColor = kAppGrayColor1;
    _priceLabel.font = kAppSmallTextFont;
    _toEditButton.layer.cornerRadius = 13;
    _toEditButton.layer.masksToBounds = YES;
    _toEditButton.backgroundColor = kAppMainColor;
    [_toEditButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_toEditButton setTitle:@"编辑" forState:UIControlStateNormal];
    _toEditButton.titleLabel.font = kAppSmallTextFont;
    _lineLabel.backgroundColor = kAppSpaceColor;
}

- (void)setModel:(ShopListModel *)model
{
    _model = model;
    if (model.imgs.count > 0) {
        [_goodsView sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    }
    
    _titleLabel.text = model.name;
    _priceLabel.text =[NSString stringWithFormat:@"¥ %@",model.price];
//    if (model.showDes) {
//        _desLabel.hidden = NO;
//        _desLabel.text = model.descrStr;
//    }
//    else
//    {
//        _desLabel.hidden = YES;
//    }
    _desLabel.hidden = NO;
    _desLabel.text = model.descrStr;
}

- (IBAction)clickButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(enterEditWithShopListTableViewCell:)]) {
        [_delegate enterEditWithShopListTableViewCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
