//
//  AuctionAloneCell.m
//  FanweApp
//
//  Created by hym on 2016/12/1.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionAloneCell.h"
static NSString *const ID = @"AuctionAloneCell";
@interface AuctionAloneCell()
@property (weak, nonatomic) IBOutlet UIButton *btnAuction;

@end

@implementation AuctionAloneCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.btnAuction.layer.cornerRadius = 25.0f;
    self.btnAuction.layer.masksToBounds = YES;
    self.btnAuction.layer.borderColor = kAppMainColor.CGColor;
    self.btnAuction.layer.borderWidth = 1.0;
    self.btnAuction.backgroundColor = kAppMainColor;
    [self.btnAuction setTitleColor:kNavBarThemeColor  forState:UIControlStateNormal];

    self.contentView.backgroundColor = kBackGroundColor;
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    AuctionAloneCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (IBAction)onClickAuction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buttonActionGoNetVC:)]) {
        [self.delegate buttonActionGoNetVC:self.tile];
    }
    
}

- (void)setTile:(NSString *)tile {
    _tile = tile;
    [self.btnAuction setTitle:tile forState:UIControlStateNormal];
}
@end
