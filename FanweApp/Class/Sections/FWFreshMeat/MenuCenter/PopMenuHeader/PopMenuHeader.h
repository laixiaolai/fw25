//
//  PopMenuHeader.h
//  FanweApp
//
//  Created by 岳克奎 on 17/3/6.
//  Copyright © 2017年 xfg. All rights reserved.


#ifndef PopMenuHeader_h
#define PopMenuHeader_h


#pragma ********************************** 枚举  ***********************
#pragma mark - 照片选择cell的类型
typedef NS_ENUM(NSUInteger, STDynamicSelectType) {
    STDynamicSelectTypeDefault        = 0,
    STDynamicSelectPhoto              = 1,  //相片
    STDynamicSelectVideo              = 2,  // 视频
};

#pragma mark - 微信模块
typedef NS_ENUM(NSUInteger, STDynamicWeChatType) {
    STDynamicWeChatTypeDefault        = 0,
    STDynamicWeChatShelve             = 1,  //未出售
    STDynamicWeChatSold               = 2,  // 已经出售
};
#pragma mark - 转场方式
typedef NS_ENUM(NSUInteger, STViewCTransitionType) {
    STViewCTransitionTypeOfPush       = 0,  //psuh
    STViewCTransitionTypeOfModal      = 1,  //Model
    STViewCTransitionOfChild          = 2,  // addSubView/aadChildViewC
};
#pragma mark -写真模块
typedef NS_ENUM(NSUInteger, STPhotoEditType) {
    STPhotoEditTypeDefault            = 0, // 默认显示bg  其余img hidden
    STPhotoEditPayPhoto               = 1, //编辑付费
    STPhotoEditPhotoCover             = 2, // 编辑相册封面

};

#pragma ********************************** 头文件  ***********************
//模块- 动态管理中心
#import "PopMenuCenter.h"
//模块-5- 视屏动态
#import "VideoDynamicViewC.h"

#endif /* PopMenuHeader_h */















