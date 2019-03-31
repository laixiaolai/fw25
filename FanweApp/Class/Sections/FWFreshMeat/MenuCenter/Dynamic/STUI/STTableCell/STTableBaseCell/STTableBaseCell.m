//
//  STTableBaseCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableBaseCell.h"

@implementation STTableBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark--------- JSBadgeView
-(JSBadgeView *)jsBadgeView{
    if (!_jsBadgeView) {
        //cell 加消息个数
        _jsBadgeView = [[JSBadgeView alloc]initWithParentView:self
                                                    alignment:JSBadgeViewAlignmentCenterRight];
        _jsBadgeView.badgePositionAdjustment = CGPointMake(-30,15);
        _jsBadgeView.badgeBackgroundColor = kAppMainColor;
        _jsBadgeView.badgeText = nil;
        [_jsBadgeView setNeedsLayout];
    }
    return _jsBadgeView;
}
@end
