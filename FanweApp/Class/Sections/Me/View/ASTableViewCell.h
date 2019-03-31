//
//  ASTableViewCell.h
//  FanweApp
//
//  Created by GuoMs on 16/7/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;

@end
