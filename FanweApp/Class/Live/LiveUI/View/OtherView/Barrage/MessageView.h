//
//  MessageView.h
//  live
//
//  Created by hysd on 15/7/22.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMessageModel.h"

@class MessageView;

@protocol MessageViewDelegate <NSObject>

// 点击弹幕头像
- (void)tapLogo:(MessageView *)messageView customMessageModel:(CustomMessageModel *)customMessageModel;

@end

@interface MessageView : UIView

@property (weak, nonatomic) IBOutlet UIView         *messageView;
@property (weak, nonatomic) IBOutlet UILabel        *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;

@property (nonatomic, weak) id<MessageViewDelegate> delegate;
@property (nonatomic, strong) CustomMessageModel    *customMessageModel;

@property (strong, nonatomic) NSDate                *date;

- (id)initWithView:(UIView*)view customMessageModel:(CustomMessageModel *)customMessageModel;

@end
