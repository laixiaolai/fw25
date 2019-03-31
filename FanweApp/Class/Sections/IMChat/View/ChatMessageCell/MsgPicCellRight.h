//
//  ZWMsgPicCellRight.h
//  testChatVC
//
//  Created by zzl on 16/7/26.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgPicCellRight : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;
@property (weak, nonatomic) IBOutlet UIImageView *mtagimg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mimgconstW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mimgconstH;
@property (weak, nonatomic) IBOutlet UIImageView *mfailedicon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *msv;

@end
