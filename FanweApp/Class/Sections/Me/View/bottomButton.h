//
//  bottomButton.h
//  FanweApp
//
//  Created by yy on 16/7/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bottomButton : UIControl
@property (nonatomic, strong) UILabel* leftLabel;
@property (nonatomic, strong) UILabel* rightLabel;
@property (nonatomic, strong) UIImageView* rightImage;
- (instancetype)initWithFrame:(CGRect)frame  bothLabelHeight:(CGFloat)height imgName:(NSString *)imgName;

@end
