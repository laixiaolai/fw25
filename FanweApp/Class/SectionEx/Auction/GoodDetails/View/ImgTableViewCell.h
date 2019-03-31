//
//  ImgTableViewCell.h
//  FanweApp
//
//  Created by lxt2016 on 16/11/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AcutionHistoryModel;

@interface ImgTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *pImgView;
@property (nonatomic, strong) UIView *lineView;

- (void)setCellWithModel:(AcutionHistoryModel *)mdeol;

@end
