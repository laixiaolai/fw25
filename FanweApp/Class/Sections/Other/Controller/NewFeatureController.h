//
//  NewFeatureController.h
//  FanweApp
//
//  Created by xfg on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理方法
@protocol NewFeatureControllerDelegate <NSObject>
@optional

/**
 最后一页按钮被点击调用的代理方法
 */
- (void)startAppClick;

@end


/**
 数据源代理方法
 */
@protocol NewFeatureControllerDatasourse <NSObject>
@optional

/**
 告诉控制器显示几张图片
 */
- (NSInteger)NewFeatureControllerPhotosNumber;
/** 
 告诉控制器显示什么图片 
 */
- (UIImageView *)NewFeatureControllerImageViewIndex:(NSUInteger)index;

@end


@interface NewFeatureController : UIViewController
{
    NSTimer *_timer;//定时器
    int _count;//计数器
}

/**
 数据源代理
 */
@property (weak,nonatomic) id<NewFeatureControllerDatasourse>Datasourse;

/**
 启动图轮播完后开始APP，有两种方式，一种通过代理，一种通过Block
 */
@property (weak,nonatomic) id<NewFeatureControllerDelegate>delegate;

/**
 设置开始APP回调
 */
- (void)setStartAppBlock:(void(^)())blockHangler;

@end
