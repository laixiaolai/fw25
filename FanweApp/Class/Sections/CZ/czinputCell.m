//
//  czinputCell.m
//  iChatView
//
//  Created by zzl on 16/6/12.
//  Copyright © 2016年 ldh. All rights reserved.
//

#import "czinputCell.h"

@implementation czinputCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.contentView.layer.cornerRadius   = 5;
    self.contentView.layer.borderColor    = [UIColor clearColor].CGColor;
    self.contentView.layer.borderWidth    = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
