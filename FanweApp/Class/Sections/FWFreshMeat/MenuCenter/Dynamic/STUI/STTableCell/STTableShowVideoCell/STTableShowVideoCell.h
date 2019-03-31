//
//  STTableShowVideoCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@class STTableShowVideoCell;
@protocol STTableShowVideoCellDelegate <NSObject>

@optional
-(void)showSystemIPC:(BOOL)isSystemIPC andMaxSelectNum:(int)maxSelectNum;
//修改视频封面
-(void)showSTTableShowVideoCell:(STTableShowVideoCell *)stTableShowVideoCell andChangeVideoCoverClick:(UIButton *)changeVideoCoverClick;
@end
@interface STTableShowVideoCell : STTableBaseCell
@property (weak, nonatomic) IBOutlet UIImageView             *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView             *videoCoverImgView;
@property (weak, nonatomic) IBOutlet UIButton                *changeCoverBtn;
@property (weak, nonatomic) IBOutlet UILabel                 *promptLab;
@property (weak, nonatomic) IBOutlet UIImageView             *changeVideoIconImgeView;
@property (weak, nonatomic) IBOutlet UILabel                 *changeVideoLab;
@property (weak, nonatomic) IBOutlet UIButton                *changeVideoBtn;
@property (weak, nonatomic) IBOutlet UIView                  *separatorView;
@property (weak, nonatomic) id<STTableShowVideoCellDelegate> delegate;
@end
