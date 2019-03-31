//
//  VideoCoverViewC.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STImgePickerViewC.h"
#import "VideoCoverView.h"
@interface VideoCoverViewC : STImgePickerViewC <STCollectionBaseViewDelegate>
@property(strong,nonatomic)  void(^selectImgInMarrayblock)(NSInteger  selectMArrayIndex);
@property(strong,nonatomic) VideoCoverView *videoCoverView;

@end
