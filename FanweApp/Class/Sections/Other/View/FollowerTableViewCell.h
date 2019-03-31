//
//  FollowerTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loadAgainDelegate <NSObject>

//重新加载某一段
- (void)loadAgainSection:(int)section withHasFonce:(int)hasFonce;

@end

@class SenderModel;

@interface FollowerTableViewCell : UITableViewCell

@property (nonatomic, weak) id<loadAgainDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton     *joinBtn;
@property (weak, nonatomic) IBOutlet UIImageView    *headImgView;
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView    *rankImgView;
@property (weak, nonatomic) IBOutlet UILabel        *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *rightImgView;
@property (weak, nonatomic) IBOutlet UIView         *lineView;
@property (nonatomic, strong) NetHttpsManager       *httpManager;
@property (nonatomic, copy) NSString                *user_id;

@property (nonatomic, assign) int section;
@property (nonatomic, assign) int hasFonce;

- (void)creatCellWithModel:(SenderModel *)model WithRow:(int)row;

@end
