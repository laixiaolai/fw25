//
//  CreateAuctionView.h
//  FanweApp
//
//  Created by 王珂 on 16/10/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateAuctionViewDelegate <NSObject>

- (void)chooseButton:(UIButton *)button;

@end

@interface CreateAuctionView : UIView

@property (nonatomic, weak) id<CreateAuctionViewDelegate>delegate;

- (void)createVieWith:(NSInteger)i andNumber:(NSInteger)j;

@end
