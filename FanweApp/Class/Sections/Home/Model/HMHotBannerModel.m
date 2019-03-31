//
//  HMHotBannerModel.m
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "HMHotBannerModel.h"

@implementation HMHotBannerModel

- (float)bannerHeight
{
    // 早期版本image_height写死为750，所以排除掉这个
    if (self.image_width && self.image_height && self.image_height != 750)
    {
        return self.image_height / self.image_width * kScreenW;
    }
    else
    {
        return kScreenW * 0.3;
    }
}

@end
