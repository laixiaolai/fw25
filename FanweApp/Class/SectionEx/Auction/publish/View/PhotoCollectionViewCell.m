//
//  PhotoCollectionViewCell.m
//  FanweApp
//
//  Created by GuoMs on 16/10/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.photoIMG.contentMode = UIViewContentModeScaleAspectFill;
    self.photoIMG.clipsToBounds = YES;
}

@end
