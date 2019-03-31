//
//  MoreToolsView.h
//  FanweApp
//
//  Created by 王珂 on 17/4/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolsModel.h"

@class MoreToolsView;

@protocol MoreToolsViewDelegate <NSObject>

- (void)clickMoreToolsView:(MoreToolsView *) moreToolsView andToolsModel:(ToolsModel *)model;

- (void)clickCancleWithMoreToolsView:(MoreToolsView *)moreToolsView ;

@end

@interface MoreToolsView : UIView

@property(nonatomic, weak) id<MoreToolsViewDelegate>delegate;
@property (nonatomic, copy) NSString * title;

@end
