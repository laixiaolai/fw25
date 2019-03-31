//
//  FWUtils.h
//  FanweApp
//
//  Created by xfg on 2017/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ValidateUrl) (NSURL *currentUrl,BOOL isSucc);

@interface FWUtils : NSObject

#pragma mark - ----------------------- 图片 -----------------------

/**
 下载图片
 @param url 图片url
 @param place 预置图片
 @param imageView 放置的图片
 */
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView;

/**
 画虚线
 @param frame 虚线的Frame
 @return UIImageView
 */
+ (UIImageView *)dottedLine:(CGRect)frame;

/**
 根据颜色生成图片
 @param color 颜色
 @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor*)color;

/**
 根据颜色生成图片
 @param color 颜色
 @param size 尺寸
 @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 通过图片Data数据第一个字节 来获取图片扩展名
 
 @param data 图片Data数据第一个字节
 @return 返回图片类型
 */
+ (NSString *)contentTypeForImageData:(NSData *)data;

/**
 图片拉伸
 
 @param imageName 图片名称
 @return 返回拉伸后的图片
 */
+ (UIImage *)resizableImage:(NSString *)imageName;

/**
 图片拉伸2

 @param imageName 图片名称
 @param edgeInsets 上、下相对于高的拉伸比例，左、右相对于宽的拉伸比例，比例：0~1之间
 @return 返回拉伸后的图片
 */
+ (UIImage *)resizableImage:(NSString *)imageName edgeInsets:(UIEdgeInsets)edgeInsets;

/**
 获得灰度图
 
 @param sourceImage 原图
 @return 返回处理后的图片
 */
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;

/**
 根据bundle中的文件名读取图片
 
 @param name 图片名称
 @return 返回图片
 */
+ (UIImage *)imageWithFileName:(NSString *)name;


#pragma mark - ----------------------- 字符串 -----------------------

/**
 是否空字符串
 @param string 字符串
 @return BOOL
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 判断字符串是否由数字组成
 @param string 字符
 @return BOOL
 */
+ (BOOL)isAllNum:(NSString *)string;

/**
 判断字符串是否为整数型
 @param string 字符串
 @return BOOL
 */
+ (BOOL)isPureInt:(NSString *)string;

/**
 判断是否为方维验证字符串
 @param string 字符串
 @return BOOL
 */
+ (BOOL)isFanwePwd:(NSString*)string;

/**
 解决字符串乱码问题
 @param str 字符串
 @return NSString
 */
+ (NSString*)returnUF8String:(NSString*)str;

/**
 float保留的位数,并返回string
 @param floatNum float数字
 @param markStr 单位
 @return NSString
 */
+ (NSString *)floatReservedString:(float)floatNum markStr:(NSString *)markStr;

/**
 float保留的位数,并返回string
 @param floatNum float数字
 @param markBackStr 单位
 @return NSString
 */
+ (NSString *)floatReservedString:(float)floatNum markBackStr:(NSString *)markBackStr;

/**
 判断传入的字符串是否符合HTTP路径的语法规则,即”HTTPS://” 或 “HTTP://”
 @param str 字符串
 @return NSURL
 */
+ (NSURL *)smartURLForString:(NSString *)str;

/**
 判断此路径是否能够请求成功
 @param candidate 路径
 @param validateResult 验证结果
 */
+ (void)validateUrl: (NSURL *)candidate validateResult:(ValidateUrl)validateResult;

/**
 移除字符串中的空格和换行
 
 @param str 字符串
 @return 返回字符串
 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str;


#pragma mark - ----------------------- 时间 -----------------------

/**
 获取时间 @"yyyy-MM-dd HH:mm:ss"
 @param str 时间戳
 @return NSString
 */
+ (NSString *)dateToString:(NSString*)str;


/**
 日期转化为xx分钟前，xx小时前，今天xx时间

 @param compareDate 替换的时间
 @return 格式化后的时间
 */
+ (NSString *)formatTime:(NSDate*)compareDate;


#pragma mark - ----------------------- 颜色 -----------------------

/**
 获取随机色
 @return UIColor
 */
+ (UIColor *)getRandomColor;

/**
 十六进制转换为uicolor
 @param color 色值，如："#ffaa55"
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;


#pragma mark - ----------------------- 转换 -----------------------

/**
 json转NSString
 @param object json字符串
 @return NSString
 */
+ (NSString *)dataTOjsonString:(id)object;

/**
 将NSDictionary或NSArray转化为JSON串
 @param theData NSDictionary或NSArray
 @return NSData
 */
+ (NSData *)toJSONData:(id)theData;

/**
 将JSON串转化为NSDictionary

 @param jsonStr JSON串
 @return NSDictionary
 */
+ (NSDictionary *)jsonStrToDict:(NSString *)jsonStr;


#pragma mark - ----------------------- 网络 -----------------------

/**
 判断网络是否连接状态
 @return BOOL
 */
+ (BOOL)isNetConnected;


#pragma mark - ----------------------- 软硬件 -----------------------

/**
 是否打开闪光灯
 @param isOpen 是否开启
 */
+ (void)turnOnFlash:(BOOL)isOpen;

/**
 获取app的cpu使用情况
 @return float
 */
+ (float)getAppCpuUsage;

/**
 统一关闭键盘
 */
+ (void)closeKeyboard;

/**
 获取app缓存大小

 @return 返回缓存大小
 */
+ (CGFloat)getCachSize;

/**
 清理app缓存
 */
+ (void)handleClearView;

/**
 几个常用的权限判断
 */
+ (void)judgeAuthorization;


#pragma mark - ----------------------- 坐标 -----------------------

/**
 获取view的坐标在整个window上的位置

 @param view 指定的view
 @param viewPoint 指定的view上面的点
 @return 返回坐标
 */
+ (CGPoint)getPointInWindow:(UIView *)view viewPoint:(CGPoint)viewPoint;


#pragma mark - ----------------------- KVC -----------------------

/**
 kvc 获取所有变量

 @param object NSObject
 @return NSArray
 */
+ (NSArray *)getAllIvar:(id)object;

/**
 kvc 获得所有属性

 @param object NSObject
 @return NSArray
 */
+ (NSArray *)getAllProperty:(id)object;

@end
