//
//  STCollectionPhotoCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STCollectionPhotoCell.h"

@implementation STCollectionPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImgView.clipsToBounds = YES;
}

@end
