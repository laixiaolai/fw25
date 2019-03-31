//
//  FWLiveServiceViewModel.m
//  FanweApp
//
//  Created by xfg on 2017/8/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWLiveServiceViewModel.h"

@implementation FWLiveServiceViewModel

#pragma mark ------------------------ 直播生命周期 -----------------------

- (void)releaseAll
{
    
}

- (void)endLive
{
    
}


#pragma mark ------------------------ 业务、接口等 -----------------------

#pragma mark 主播开播时分享直播间
+ (void)hostShareCurrentLive:(ShareModel *)shareModel shareType:(NSString *)shareType vc:(UIViewController *)vc block:(FWVoidBlock)block
{
    NSString *shareString = shareType;
    UMSocialPlatformType socialPlatformType;
    
    if ([shareString isEqualToString:@"weixin"])
    {
        socialPlatformType = UMSocialPlatformType_WechatSession;
    }
    else if ([shareString isEqualToString:@"weixin_circle"])
    {
        socialPlatformType = UMSocialPlatformType_WechatTimeLine;
    }
    else if ([shareString isEqualToString:@"qq"])
    {
        socialPlatformType = UMSocialPlatformType_QQ;
    }
    else if ([shareString isEqualToString:@"qzone"])
    {
        socialPlatformType = UMSocialPlatformType_Qzone;
    }
    else
    {
        socialPlatformType = UMSocialPlatformType_Sina;
    }
    
    [[FWUMengShareManager sharedInstance] shareTo:vc platformType:socialPlatformType shareModel:shareModel succ:nil failed:nil];
}

#pragma mark 礼物信息的key
+ (NSMutableDictionary *)getGiftMsgKey:(CustomMessageModel *)msg
{
    NSMutableDictionary *tmpMDict = [NSMutableDictionary dictionary];
    
    if (msg.type == MSG_ADD_PRICE)
    {
        [tmpMDict setObject:msg.user.user_id forKey:@"user_id"];
        [tmpMDict setObject:msg.pai_id forKey:@"pai_id"];
    }
    else
    {
        [tmpMDict setObject:msg.sender.user_id forKey:@"user_id"];
        [tmpMDict setObject:msg.prop_id forKey:@"prop_id"];
    }
    
    return tmpMDict;
}

@end
