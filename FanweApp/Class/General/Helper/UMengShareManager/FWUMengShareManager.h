//
//  FWUMengShareManager.h
//  FanweApp
//
//  Created by xfg on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import "ShareModel.h"
#import "FanweSingleton.h"

typedef void (^FWUMengSuccBlock)(UMSocialShareResponse *response);

@interface FWUMengShareManager : FWBaseViewModel

// 单例模式
FanweSingletonH(Instance);

// 弹出分享面板
- (void)showShareViewInControllr:(UIViewController *)vc shareModel:(ShareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed;

// 根据分享类型进行分享
- (void)shareTo:(UIViewController *)vc platformType:(UMSocialPlatformType)platformType shareModel:(ShareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed;

@end
