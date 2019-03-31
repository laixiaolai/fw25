//
//  ProtocolTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lookProtocolDelegate <NSObject>
//进入协议的控制器
- (void)goToProtocolController;

@end

@interface ProtocolTableViewCell : UITableViewCell
@property (nonatomic, weak) id<lookProtocolDelegate>delegate;

@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *protocolButton;

@end
