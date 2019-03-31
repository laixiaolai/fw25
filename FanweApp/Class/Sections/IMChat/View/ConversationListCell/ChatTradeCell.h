//
//  ChatTradeCell.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMCellTradeDelegate <NSObject>

@end

@interface ChatTradeCell : UITableViewCell

@property (nonatomic, weak) id<IMCellTradeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;
@property (weak, nonatomic) IBOutlet UILabel *mname;
@property (weak, nonatomic) IBOutlet UILabel *mtime;
@property (weak, nonatomic) IBOutlet UILabel *mmsg;
@property (weak, nonatomic) IBOutlet UIImageView *mdownImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mMsg_LabRight_Constraint;
@property (nonatomic, copy) NSString *contentFlag; // cell是否展开 0未展开 1展开

- (CGFloat)judge:(NSString *)msg;

@end
