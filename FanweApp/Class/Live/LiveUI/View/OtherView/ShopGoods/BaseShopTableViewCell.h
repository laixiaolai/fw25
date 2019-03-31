//
//  BaseShopTableViewCell.h
//  FanweApp
//
//  Created by 方维 on 2017/9/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseShopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *baseButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
