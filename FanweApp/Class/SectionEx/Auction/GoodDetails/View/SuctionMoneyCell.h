//
//  SuctionMoneyCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuctionMoneyCell : UITableViewCell

@property (nonatomic, strong) UIView         *lineView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic)GlobalVariables *fanweApp;

- (void)setCellWithMoney:(NSString *)money;

@end
