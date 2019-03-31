//
//  TwoSectionTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoSectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UILabel *cycleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mostTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) UIImageView *imgView1;
@property (nonatomic, strong) UIImageView *imgView2;
@property (nonatomic, strong) UIImageView *imgView3;

@property (nonatomic, strong) UILabel *priceLabel1;
@property (nonatomic, strong) UILabel *priceLabel2;
@property (nonatomic, strong) UILabel *priceLabel13;

- (void)creatCellWithArray:(NSMutableArray *)array;

@end
