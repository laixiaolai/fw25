//
//  STDynamicCommonCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@interface STDynamicCommonCell : STTableBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;

@property (weak, nonatomic) IBOutlet UILabel     *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel     *lastMsgContentLab;
@property (weak, nonatomic) IBOutlet UILabel     *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *dynamicCoverImgView;
@property (weak, nonatomic) IBOutlet UIView      *separatorView;

@end
