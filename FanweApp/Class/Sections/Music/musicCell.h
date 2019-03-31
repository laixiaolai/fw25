//
//  musicCell.h
//  FanweApp
//
//  Created by zzl on 16/6/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRadialProgressView.h"

@interface musicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel    *mname;
@property (weak, nonatomic) IBOutlet UILabel    *msonger;
@property (weak, nonatomic) IBOutlet UILabel    *mlong;

@property (weak, nonatomic) IBOutlet UIButton   *mbt;

@property (weak, nonatomic) IBOutlet UIView     *mprocessBase;

@property (weak, nonatomic) IBOutlet MDRadialProgressView *mprogress;

//perct => 0-100,-1 表示隐藏
- (void)showProcess:(int)perct;

@end
