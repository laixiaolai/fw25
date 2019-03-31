//
//  PushMaTableViewCell.h
//  FanweApp
//
//  Created by GuoMs on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapDelegate <NSObject>

- (void)handleToTurnPushManage;

@end

@interface PushMaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *turnOrOff;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;

@property (nonatomic, weak) id<TapDelegate>deleagte;

@end
