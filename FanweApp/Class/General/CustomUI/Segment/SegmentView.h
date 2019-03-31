//
//  SegmentView.h
//  live
//
//  Created by hysd on 15/8/19.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentView;

@protocol SegmentViewDelegate <NSObject>

- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index;

@end

@interface SegmentView : UIView

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, weak) id<SegmentViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andItems:(NSArray*)items andSize:(NSInteger)size border:(BOOL)border isrankingRist:(BOOL)isrankingRist;
- (void)setSelectIndex:(NSInteger)index;
- (NSInteger)getSelectIndex;
- (void)changeIndex;

@end
