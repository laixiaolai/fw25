//
//  TimeTableViewCell.h
//  FanweApp
//
//  Created by GuoMs on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLable;//竞拍，延时值
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *twoLable;//切换时间，小时，分钟

@end
