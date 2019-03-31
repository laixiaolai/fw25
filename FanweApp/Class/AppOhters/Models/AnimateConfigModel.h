//
//  AnimateConfigModel.h
//  FanweApp
//
//  Created by apple on 16/6/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimateConfigModel : NSObject

@property (nonatomic, assign) NSInteger     Id;

/**
 0：按像素显示模式（当某条边超出手机屏幕时该条边贴边），配合位置参数使用；
 1、全屏显示模式（gif图片四个角顶住手机屏幕的四个角）；
 2、至少两条边贴边模式（按比例缩放到手机屏幕边界的最大尺寸），配合位置参数使用；
 */
@property (nonatomic, assign) NSInteger     gif_gift_show_style;

@property (nonatomic, copy) NSString        *url;               // 动画地址
@property (nonatomic, assign) NSInteger     play_count;         // 播放次数;play_count>1时duration无效
@property (nonatomic, assign) double        duration;           // 播放时长（毫秒）play_count>1时duration无效
@property (nonatomic, assign) double        delay_time;         // 延时播放时间;从第delay_time毫秒开始播放，第一次播放使用延时
@property (nonatomic, assign) NSInteger     show_user;          // 1：在顶部显示用户名（赠送者） 0：不显示
@property (nonatomic, copy) NSString        *senderName;        // 赠送者
@property (nonatomic, assign) NSInteger     type;               // 0：使用path路径；1：屏幕上部；2：屏幕中间；3：屏幕底部
@property (nonatomic, copy) NSString        *path;              // 动画播放路径,格式待定;比如：从上到下；从左到右等
@property (nonatomic, assign) BOOL          isFinishAnimate;    // 是否已经结束动画

//首页-热门
@property (nonatomic, copy) NSString        *user_id;
@property (nonatomic, copy) NSString        *image;
@property (nonatomic, copy) NSString        *title;
@property (nonatomic, copy) NSString        *desc;

@end
