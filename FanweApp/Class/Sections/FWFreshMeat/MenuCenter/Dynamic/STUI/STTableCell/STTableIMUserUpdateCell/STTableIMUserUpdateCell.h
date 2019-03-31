//
//  STTableIMUserUpdateCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@interface STTableIMUserUpdateCell : STTableBaseCell
@property (weak, nonatomic) IBOutlet UILabel     *leftLab;
@property (weak, nonatomic) IBOutlet UILabel     *rightLab;
@property (weak, nonatomic) IBOutlet UIImageView *updateImgView;
@property (weak, nonatomic) IBOutlet UIView      *separatorView;

@end
