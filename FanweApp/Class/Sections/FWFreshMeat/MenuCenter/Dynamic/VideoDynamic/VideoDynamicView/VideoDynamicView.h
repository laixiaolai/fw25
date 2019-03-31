//
//  VideoDynamicView.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableBaseView.h"
#import "STTableTextViewCell.h"
#import "STTablePhotoCell.h"
#import "STTableLeftRightLabCell.h"
#import "STTableCommitBtnCell.h"
#import "STTableShowVideoCell.h"
@class VideoDynamicView;
@protocol VideoDynamicViewDelegate <NSObject>
@optional
-(void)showSystemIPC:(BOOL)isSystemIPC andMaxSelectNum:(int)maxSelectNum;

- (void)showMyVideoView;

//去封面编辑页面
-(void)showOnVideoDynamicView:(VideoDynamicView *)videoDynamicView STTableShowVideoCell:(STTableShowVideoCell *)stTableShowVideoCell andChangeVideoCoverClick:(UIButton *)changeVideoCoverClick;
@end
@interface VideoDynamicView : STTableBaseView <STTableTextViewCellDeleagte,STTablePhotoCellDelegate,STTableShowVideoCellDelegate>
@property(nonatomic,strong)NSString *recordTextViewStr;
@property(nonatomic,weak)id<VideoDynamicViewDelegate>delegate;
@property(nonatomic,assign)NSInteger    recordSelectIndex;
@end
