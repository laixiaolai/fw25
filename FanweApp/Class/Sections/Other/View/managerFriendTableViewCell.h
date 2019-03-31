//
//  managerFriendTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SenderModel;
@class NetHttpsManager;

@interface managerFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView        *headImgView;
@property (weak, nonatomic) IBOutlet UILabel            *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *rightImgView;
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView        *rankImgView;

@property (weak, nonatomic) IBOutlet UIView             *lineView;


- (void)creatCellWithModel:(SenderModel *)model;

@end
