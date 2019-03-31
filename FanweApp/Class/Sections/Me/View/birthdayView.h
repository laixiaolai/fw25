//
//  birthdayView.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LZDateDelegate <NSObject>
@optional
- (void)confrmCallBack:(NSInteger)Year month:(NSInteger)month day:(NSInteger)day andtag:(int)tagIndex;

@end

@interface birthdayView : UIView
{
    int _yearNum;
}
@property (nonatomic, weak) id<LZDateDelegate> delegate;

- (id)initWithDelegate:(id<LZDateDelegate>)delegate year:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

@end
