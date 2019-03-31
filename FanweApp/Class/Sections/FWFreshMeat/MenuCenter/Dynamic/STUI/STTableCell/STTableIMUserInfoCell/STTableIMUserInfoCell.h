//
//  STTableIMUserInfoCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@interface STTableIMUserInfoCell : STTableBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *topLab;

@property (weak, nonatomic) IBOutlet UILabel *bottomLab;

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;// 显示 时间
@property (weak, nonatomic) IBOutlet UIImageView *rightChatImgView; // 右侧 聊天图标

@end
