//
//  ZWMsgVoiceCellLeft.m
//  testChatVC
//
//  Created by zzl on 16/7/26.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import "MsgVoiceCellLeft.h"

@implementation MsgVoiceCellLeft

- (void)awakeFromNib
{

    self.mheadimg.layer.borderColor = [UIColor clearColor].CGColor;
    self.mheadimg.layer.borderWidth = 1.0f;
    self.mheadimg.layer.cornerRadius = 20.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
