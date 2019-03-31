//
//  FWEditTCell.h
//  FanweApp
//
//  Created by 丁凯 on 2017/6/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface FWEditTCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel      *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel      *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView  *headImgView;
@property (weak, nonatomic) IBOutlet UIImageView  *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView  *nextImgView;

@property (nonatomic, strong) UIView                *lineView;

@property (nonatomic, strong) NSMutableArray *nameArray;
- (void)creatCellWithStr:(NSString *)rightStr andSection:(int)section;

@end
