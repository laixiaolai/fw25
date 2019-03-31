//
//  AddFriendView.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addFriendDelegate <NSObject>

//添加好友的代理
- (void)addFriendWithIndex:(int)index;
//移除该类
- (void)deleteFriendView;

@end

@interface AddFriendView : UIView

@property (nonatomic, weak) id<addFriendDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *wechatImgView;
@property (weak, nonatomic) IBOutlet UIImageView *qqImgView;
@property (weak, nonatomic) IBOutlet UIImageView *yinKeImgView;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;

@end
