//
//  AuctionGoodsCell.m
//  FanweApp
//
//  Created by 王珂 on 16/10/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionGoodsCell.h"
#import "ShopGoodsModel.h"

@interface  AuctionGoodsCell()
{
    NetHttpsManager *_httpsManager;
}

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *diamondsImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIButton *toSetAuctionButton;

@end

@implementation AuctionGoodsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"AuctionGoodsCell";
    AuctionGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell== nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AuctionGoodsCell class]) owner:nil options:nil] lastObject];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _goodsImageView.clipsToBounds = YES;
    _titleLabel.font = kAppMiddleTextFont;
    _titleLabel.textColor = kAppGrayColor1;
    _desLabel.textColor = kAppGrayColor3;
    _desLabel.hidden = YES;
    _desLabel.font = kAppSmallTextFont;
    _priceLabel.textColor = kAppGrayColor1;
    _priceLabel.font = kAppSmallTextFont;
    _toSetAuctionButton.layer.cornerRadius = 13;
    _toSetAuctionButton.layer.masksToBounds = YES;
    _toSetAuctionButton.backgroundColor = kAppMainColor;
    [_toSetAuctionButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_toSetAuctionButton setTitle:@"设为拍卖" forState:UIControlStateNormal];
    _toSetAuctionButton.titleLabel.font = kAppSmallTextFont;
    _lineLabel.backgroundColor = kAppSpaceColor;
}

- (void)setModel:(ShopGoodsModel *)model
{
    _model = model;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    _titleLabel.text = model.name;
    if (model.descStr.length > 0)
    {
        _desLabel.hidden = NO;
        _desLabel.text = model.descStr;
    }
    else
    {
        _desLabel.hidden = YES;
    }
    _priceLabel.text = model.price;
}

//设为拍卖
- (IBAction)clickButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickAuctionWithAuctionGoodsCell:)])
    {
        [_delegate clickAuctionWithAuctionGoodsCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
