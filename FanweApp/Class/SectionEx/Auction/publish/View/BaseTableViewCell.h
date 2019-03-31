//
//  BaseTableViewCell.h
//  FanweApp
//
//  Created by GuoMs on 16/8/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameL;
@property (strong, nonatomic) IBOutlet UITextField *text_field;

@end
