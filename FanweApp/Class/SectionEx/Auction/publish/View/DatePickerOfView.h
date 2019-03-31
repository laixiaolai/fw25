//
//  DatePicker.h
//  FanweApp
//
//  Created by GuoMs on 16/9/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerOfView : UIView

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *CBtn;
@property (strong, nonatomic) IBOutlet UIButton *Qbtn;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;

@end
