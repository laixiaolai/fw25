//
//  ChatFriendCell.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSBadgeView;
@class M80AttributedLabel;

@interface ChatFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;

@property (weak, nonatomic) IBOutlet UILabel *mname;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *mmsg;

@property (weak, nonatomic) IBOutlet UILabel *mtime;
@property (weak, nonatomic) IBOutlet UIImageView *mlevel;

@property (weak, nonatomic) IBOutlet UIImageView *msex;
@property (weak, nonatomic) IBOutlet UIView *mcountview;
@property (weak, nonatomic) IBOutlet JSBadgeView *mjsbadge;
@property (weak, nonatomic) IBOutlet UIImageView *viconImageView;

- (void)setUnReadCount:(int)count;

@end
