//
//  OneSectionTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneSectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secLabel;
@property (weak, nonatomic) IBOutlet UIImageView *auctionImgView;
@property (weak, nonatomic) IBOutlet UILabel *auctionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goldImgView;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maoHaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *maoHaoLabel2;
@property (nonatomic, strong) UIButton *auctionButton;

- (void)creatCellWithArray:(NSMutableArray *)array andStatue:(int)statue;

@end
