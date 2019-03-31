//
//  MessageView.m
//  live
//
//  Created by hysd on 15/7/22.
//  Copyright (c) 2015年 kenneth. All rights reserved.

#import "MessageView.h"
#import "UIImageView+WebCache.h"

@implementation MessageView

- (id)initWithView:(UIView*)view customMessageModel:(CustomMessageModel *)customMessageModel
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:self options:nil] lastObject];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.customMessageModel = customMessageModel;
        
        NSString *message = customMessageModel.desc;
        NSString *userName = customMessageModel.sender.nick_name;
        
        //头像
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height/2;
        self.logoImageView.clipsToBounds = YES;
        self.logoImageView.layer.borderWidth = 1;
        self.logoImageView.layer.borderColor = kAppMainColor.CGColor;
        self.logoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapLogo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLogoAction:)];
        [self.logoImageView addGestureRecognizer:tapLogo];
    
        NSString *headUrlStr = customMessageModel.sender.head_image;
        if(headUrlStr && ![headUrlStr isEqualToString:@""])
        {
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:headUrlStr] placeholderImage:kDefaultPreloadHeadImg];
        }else{
            self.logoImageView.image = [UIImage imageNamed:@"default_head.jpg"];
        }
        
        //昵称
        self.nameLabel.textColor = kAppGrayColor1;
        self.nameLabel.text = userName;
        
        //消息背景
        self.messageView.backgroundColor = kGrayTransparentColor3;
        self.messageView.layer.cornerRadius = self.messageView.frame.size.height/2;
        self.messageView.clipsToBounds = YES;
        
        //消息
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.numberOfLines = 1;
        self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.messageLabel.preferredMaxLayoutWidth = kScreenW-self.logoImageView.frame.size.width-50;
        self.messageLabel.text = message;
        
        self.date = [NSDate date];
        [view addSubview:self];
        
        CGSize size = [self systemLayoutSizeFittingSize:view.frame.size];
        self.frame = CGRectMake(kScreenW, BARRAGE_VIEW_Y_1, size.width, size.height);
        
        
    }
    return self;
}

- (void)tapLogoAction:(UITapGestureRecognizer *)tapGesture{
    
    CGPoint touchPoint = [tapGesture locationInView:self.logoImageView];
    if ([self.logoImageView.layer.presentationLayer hitTest:touchPoint]) {
        NSLog(@"presentationLayer");
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tapLogo:customMessageModel:)]) {
        [_delegate tapLogo:self customMessageModel:self.customMessageModel];
    }
}

@end
