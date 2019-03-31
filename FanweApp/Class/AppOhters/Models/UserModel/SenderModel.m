//
//  SenderModel.m
//  FanweApp
//
//  Created by xfg on 16/5/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SenderModel.h"

@implementation SenderModel

// 两个用户是否相同，可通过比较imUserId来判断
// 用户IMSDK的identigier
- (NSString *)imUserId{
    return self.user_id;
}
// 用户昵称
- (NSString *)imUserName{
    return self.nick_name;
}

// 用户头像地址
- (NSString *)imUserIconUrl{
    return self.head_image;
}

@end
