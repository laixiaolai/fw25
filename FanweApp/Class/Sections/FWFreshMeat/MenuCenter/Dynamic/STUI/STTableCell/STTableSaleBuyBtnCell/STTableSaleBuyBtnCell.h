//
//  STTableSaleBuyBtnCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@class STTableSaleBuyBtnCell;
@protocol STTableSaleBuyBtnCellDelegate <NSObject>

@optional
//bt事件外传
-(void)showSTTableSaleBuyBtnCell:(STTableSaleBuyBtnCell *)stTableSaleBuyBtnCell andClickBtn:(UIButton *)clickBtn;
@end
@interface STTableSaleBuyBtnCell : STTableBaseCell
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) id<STTableSaleBuyBtnCellDelegate>delegate;
@end
