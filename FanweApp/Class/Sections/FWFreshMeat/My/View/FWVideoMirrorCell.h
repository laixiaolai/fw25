//
//  FWVideoMirrorCell.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonCenterListModel.h"

@protocol ZanandVideoDelegate <NSObject>
//tag=0视频 =1点赞
- (void)zanOrVideoClickWithTag:(int)tag;

@end

@interface FWVideoMirrorCell : UITableViewCell

@property (weak,nonatomic)id<ZanandVideoDelegate>ZVDelegate;             //代理
@property(nonatomic,strong) UIImageView *headImgView;                    //头像
@property(nonatomic,strong) UILabel *zanLabel;                           //zanLabel
@property(nonatomic,strong) UIImageView *zanImgView;                     //zan头像
@property(nonatomic,strong) UILabel *videoLabel;                         //videoLabel
@property(nonatomic,strong) UIImageView *videoImgView;                   //video头像
@property(nonatomic,strong) UILabel *nameLabel;                          //名字
@property(nonatomic,strong) TTTAttributedLabel *abstractLabel;           //简介
@property(nonatomic,strong) UIButton *videoBtn;                          //视频的点击
@property(nonatomic,strong) UIButton *ZanBtn;                            //赞的点击
@property(nonatomic,strong) UIImageView *iconImgView;                    //认证的图标
@property(nonatomic,strong) UIView      *lineView;                       //下划线

- (CGFloat)creatCellWithModel:(PersonCenterListModel *)model andRow:(int)row isVideo:(BOOL)isVideo;

@end
