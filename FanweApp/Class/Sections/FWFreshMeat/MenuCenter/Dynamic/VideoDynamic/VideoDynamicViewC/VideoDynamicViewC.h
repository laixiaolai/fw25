//
//  VideoDynamicViewC.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STImgePickerViewC.h"
#import "VideoDynamicView.h"
@interface VideoDynamicViewC : STImgePickerViewC <VideoDynamicViewDelegate,STTableViewBaseViewDelegate>
@property(nonatomic,strong)VideoDynamicView *videoDynamicView;
@property(strong,nonatomic)NSString  *recordVideoCoverURLStr;
@property(strong,nonatomic)NSString  *recordVideoURLStr;

@end
