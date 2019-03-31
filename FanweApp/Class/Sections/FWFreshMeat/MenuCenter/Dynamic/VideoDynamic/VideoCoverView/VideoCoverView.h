//
//  VideoCoverView.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseView.h"
#import "STCollectionBaseView.h"
@class VideoCoverView;
@interface VideoCoverView : STCollectionBaseView
@property (weak, nonatomic) IBOutlet UIImageView *showSelectedImgView;
@property(nonatomic,assign)NSInteger selectIndexRow;
@end
