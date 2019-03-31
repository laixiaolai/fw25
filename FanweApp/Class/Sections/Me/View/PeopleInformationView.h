//
//  PeopleInformationView.h
//  FanweApp
//
//  Created by ycp on 16/10/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleInformationView : UIView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *vipImageView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UIImageView *levelImageView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, weak)id delegate;
@end
@protocol PeopleInformationViewDelegate <NSObject>

- (void)editClickButton;

@end
