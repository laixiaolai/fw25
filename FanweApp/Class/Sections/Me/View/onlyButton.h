//
//  onlyButton.h
//  FanweApp
//
//  Created by yy on 16/7/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface onlyButton : UIControl
@property (nonatomic, strong) UIImageView* customImgView;
@property (nonatomic, strong) UILabel* leftLabel;
@property (nonatomic, strong) UIButton* rightButton;
@property (nonatomic, strong) UILabel* imageLabel;

- (instancetype)initWithFrame:(CGRect)frame  bothLabelHeight:(CGFloat)height imgName:(NSString *)imgName;
@end
