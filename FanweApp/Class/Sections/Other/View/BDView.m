//
//  BDView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/9/8.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BDView.h"

@implementation BDView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.topBackView.backgroundColor = kAppMainColor;
    NSString *minStr = @"1970-01-01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [dateFormatter dateFromString:minStr];

    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.timeLabel.frame.origin.y + self.timeLabel.size.height + 8, kScreenW, 260)];
    [self addSubview:self.datePicker];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    self.datePicker.maximumDate = [NSDate date];
    self.datePicker.minimumDate = minDate;
    [self.datePicker addTarget:self action:@selector(handleSelectTime) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -- 日历
- (void)handleSelectTime
{
    NSDate *select  = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime = [dateFormatter stringFromDate:select];
    self.timeLabel.text = dateAndTime;
}

- (void)creatMinTime:(NSString *)string
{
    self.timeLabel.text = string;

}
- (IBAction)buttonClick:(UIButton *)sender
{
    if (self.BDViewBlock)
    {
        self.BDViewBlock((int)sender.tag);
    }
}

@end
