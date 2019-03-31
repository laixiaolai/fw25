//
//  AdJumpViewModel.m
//  FanweApp
//
//  Created by xfg on 16/10/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AdJumpViewModel.h"
#import "LeaderboardViewController.h"

@implementation AdJumpViewModel

+ (id)adToOthersWith:(HMHotBannerModel *)bannerModel
{
    if (bannerModel.type == 0)      // 跳转到普通webview
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:bannerModel.url isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = bannerModel.title;
        return tmpController;
    }
    else if(bannerModel.type == 1)      // 跳转到排行榜
    {
        LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
        return lbVCtr;
    }
    
    LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
    return lbVCtr;
    
    return nil;
}

@end
