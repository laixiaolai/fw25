//
//  ZWMsgCellRight.h
//  testChatVC
//
//  Created by zzl on 16/7/26.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class M80AttributedLabel;
@interface MsgCellRight : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *mmsglabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mlabelconstW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mlabelconstH;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *msv;
@property (weak, nonatomic) IBOutlet UIImageView *mfailedicon;

@end
