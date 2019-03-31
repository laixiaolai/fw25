//
//  MoreToolsCell.m
//  FanweApp
//
//  Created by 王珂 on 17/4/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MoreToolsCell.h"
#import "ToolsModel.h"
@implementation MoreToolsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.toolsLabel.textColor = kWhiteColor;
}

- (void)setModel:(ToolsModel *)model
{
    _model = model;
    self.toolsLabel.text = model.title;
    [self.toolsImageView setImage:[UIImage imageNamed:model.imageStr]];
    //[self.toolsImageView setHighlightedImage:[UIImage imageNamed:model.selectedImageStr]];
}

@end
