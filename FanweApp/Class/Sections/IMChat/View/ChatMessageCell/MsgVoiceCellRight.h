//
//  ZWMsgVoiceCellRight.h
//  testChatVC
//
//  Created by zzl on 16/7/26.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgVoiceCellRight : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mlongrateconstW;
@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;
@property (weak, nonatomic) IBOutlet UILabel *mlonglabel;
@property (weak, nonatomic) IBOutlet UIImageView *mvoiceicon;
@property (weak, nonatomic) IBOutlet UIImageView *mfailedicon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *msv;

@end
