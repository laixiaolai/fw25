//
//  czbtCell.h
//  iChatView
//
//  Created by zzl on 16/6/12.
//  Copyright © 2016年 ldh. All rights reserved.
//


#import <UIKit/UIKit.h>

@class czModel;
@interface RefBt : UIButton

@property (nonatomic, weak) czModel* mRefObj;

@end

@interface czbtCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mleft;
@property (weak, nonatomic) IBOutlet UIView *mright;

@property (weak, nonatomic) IBOutlet RefBt *mleftbt;
@property (weak, nonatomic) IBOutlet RefBt *mrightbt;
@property (weak, nonatomic) IBOutlet UILabel *mleftinput;
@property (weak, nonatomic) IBOutlet UILabel *leftGivingCount;
@property (weak, nonatomic) IBOutlet UILabel *rightGivingCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelLayout;

@property (weak, nonatomic) IBOutlet UILabel *mrightinput;

- (void)setLeftBt:(float)price goldcount:(int)goldcount count:(NSString *)count;

- (void)setRightBt:(float)price goldcount:(int)goldcount count:(NSString *)count;

//v:0 正常 1:显示输入金额 2 隐藏
- (void)setLeftVisable:(int)v;

- (void)setRightVisable:(int)v;

@end
