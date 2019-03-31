//
//  PasteView.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasteViewDelegate <NSObject>
//取消，粘贴，x的代理事件
- (void)sentPasteWithIndex:(int)index withShareIndex:(int)shareIndex;

//点击空白的地方去除改视图
- (void)deletePasteView;

@end

@interface PasteView : UIView

@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (nonatomic, weak) id<PasteViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (nonatomic, assign) int shareIndex;

@end
