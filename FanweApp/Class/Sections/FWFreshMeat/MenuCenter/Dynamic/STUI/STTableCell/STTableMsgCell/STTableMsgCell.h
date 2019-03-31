//
//  STTableMsgCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@interface STTableMsgCell : STTableBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLab;
@property (weak, nonatomic) IBOutlet UIView      *separatorView;

@end
