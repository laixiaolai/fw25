//
//  CustomButton.h
//  自定义Button
//
//  Created by sunbk on 16/7/6.
//  Copyright © 2016年 xingyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIControl
@property (nonatomic, strong) UIImageView* customImgView;
@property (nonatomic, strong) UILabel* leftLabel;
@property (nonatomic, strong) UIButton* rightButton;
- (instancetype)initWithFrame:(CGRect)frame  bothLabelHeight:(CGFloat)height imgName:(NSString *)imgName;

@end
