//
//  DatePicker.m
//  FanweApp
//
//  Created by GuoMs on 16/9/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "DatePickerOfView.h"

@implementation DatePickerOfView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.timeLable.frame.origin.y + self.timeLable.size.height + 5, kScreenW, 215)];
    [self addSubview:self.datePicker];
    [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.minuteInterval = 1;
    [self.datePicker addTarget:self action:@selector(handleSelectTime) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -- 日历
- (void)handleSelectTime
{
    NSDate *select  = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateAndTime = [dateFormatter stringFromDate:select];
    self.timeLable.text = dateAndTime;
}

@end
