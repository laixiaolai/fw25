//
//  FWErrorCodeMacro.h
//  FanweApp
//
//  Created by xfg on 16/11/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef FWErrorCodeMacro_h
#define FWErrorCodeMacro_h

// 定义
typedef NS_ENUM(NSInteger, FWCodeTag)
{
    // 通用的
    FWCode_Normal_Error         =   9000, // 一般错误
    FWCode_Net_Error            =   9001, // 网络加载失败
    FWCode_Biz_Error            =   9002, // 业务请求失败，如：服务端返回的 status=0
    FWCode_Cancel               =   9003, // 业务上的取消
    
    
    // 某一个业务上的
    FWCode_Vip_Cancel           =   10001, // 非vip会员观看vip会员视频
};

#endif /* FWErrorCodeMacro_h */
