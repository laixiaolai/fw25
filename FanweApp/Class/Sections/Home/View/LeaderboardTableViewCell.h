//
//  LeaderboardTableViewCell.h
//  FanweApp
//
//  Created by yy on 16/10/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol LeaderboardTableViewDelegate <NSObject>

- (void)focusOn:(UIButton *)sender;

@end


@interface LeaderboardTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LeaderboardTableViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView    *headImgView;   //头像
@property (weak, nonatomic) IBOutlet UIImageView    *vImgView;      //V认证
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;     //名字
@property (weak, nonatomic) IBOutlet UIImageView    *sexImgView;    //性别
@property (weak, nonatomic) IBOutlet UIImageView    *rankImgView;   //等级
@property (weak, nonatomic) IBOutlet UILabel        *ticketLabel;   //善券
@property (weak, nonatomic) IBOutlet UIView         *lineView;
@property (weak, nonatomic) IBOutlet UILabel        *numLabel;      //名次

- (void)createCellWithModel:(UserModel *)model withRow:(int)row withType:(int)type;

@end
