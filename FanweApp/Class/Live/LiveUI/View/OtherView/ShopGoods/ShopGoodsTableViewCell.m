//
//  ShopGoodsTableViewCell.m
//  UIAuctionShop
//
//  Created by 王珂 on 16/9/18.
//  Copyright © 2016年 qhy. All rights reserved.
//

#import "ShopGoodsTableViewCell.h"
#import "ShopGoodsModel.h"
#import "ShopGoodsUIView.h"

@interface  ShopGoodsTableViewCell()
{
    NetHttpsManager *_httpsManager;
}

@property (weak, nonatomic) IBOutlet UIImageView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *toPushButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation ShopGoodsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopGoodsTableViewCell";
    ShopGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell== nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShopGoodsTableViewCell class]) owner:nil options:nil] lastObject];;
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
    _toPushButton.layer.cornerRadius = 13;
    _toPushButton.layer.masksToBounds = YES;
    _toPushButton.backgroundColor = kAppMainColor;
    [_toPushButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_toPushButton setTitle:@"编辑" forState:UIControlStateNormal];
    _toPushButton.titleLabel.font = kAppSmallTextFont;
    _lineLabel.backgroundColor = kAppSpaceColor;
}

- (void)setModel:(ShopGoodsModel *)model
{
    _model = model;
    if (model.type==0)
    {
        [_toPushButton setTitle:@"推送" forState:UIControlStateNormal];
        _toPushButton.hidden = NO;
    }
    else if (model.type==1)
    {
        _toPushButton.hidden = YES;
        [self.toPushButton setTitle:@"购买" forState:UIControlStateNormal];
    }
    [_goodsView sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    _titleLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %@",model.price];
//    if (model.showDes)
//    {
//        _desLabel.hidden = NO;
//        _desLabel.text = model.descStr;
//    }
//    else
//    {
//        _desLabel.hidden = YES;
//    }
    _desLabel.hidden = NO;
    _desLabel.text = model.descStr;
}

- (IBAction)clickButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(closeViewWithShopGoodsTableViewCell:)])
    {
        [_delegate closeViewWithShopGoodsTableViewCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
