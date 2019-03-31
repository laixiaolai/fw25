//
//  TwoImgView.h
//  FanweApp
//
//  Created by fanwe2014 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoImgView : UIView

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIImageView *iconImgView;

- (id)initWithFrame:(CGRect)frame;//初始化

- (void)getImgViewWithHeadImgString:(NSString *)headImgString andIconImgView:(NSString *)iconImgView;

@end
