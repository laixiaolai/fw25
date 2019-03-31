//
//  STBMKView.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableBaseView.h"
#import "STTableDoubleLabCell.h"
#import "STTableSearchCell.h"
#import "STTableLeftRightLabCell.h"
@protocol STBMKViewDelegate <NSObject>

@optional
@end
@interface STBMKView : STTableBaseView <STTableSearchCellDelegate>
@property(nonatomic,weak) id<STBMKViewDelegate>delegate;

@end
