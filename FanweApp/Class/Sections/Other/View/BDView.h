//
//  BDView.h
//  FanweApp
//
//  Created by fanwe2014 on 16/9/8.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDView : UIView

@property (weak, nonatomic) IBOutlet UIView       *topBackView;
@property (nonatomic, strong) UIDatePicker        *datePicker;
@property (weak, nonatomic) IBOutlet UILabel      *timeLabel;

@property (nonatomic, copy) void (^BDViewBlock)(int tagIndex); //0取消 1确定

- (void)creatMinTime:(NSString *)string;

@end
