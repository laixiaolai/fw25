//
//  STSeachView.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseView.h"
@protocol STSeachViewDelegate <NSObject>
@optional
@end

@interface STSeachView : STBaseView
@property(nonatomic,weak) id<STSeachViewDelegate>delegate;
@end
