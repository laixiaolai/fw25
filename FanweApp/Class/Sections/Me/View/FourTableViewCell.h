//
//  FourTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FourTableViewCell;

@protocol sentImgviewDelegate <NSObject>
//传送图片的url
- (void)getImgWithtag:(int)tag andCell:(FourTableViewCell *)myCell;

@end

@interface FourTableViewCell : UITableViewCell

@property (nonatomic, weak) id <sentImgviewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView3;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (void)creatCellWithAuthentication:(int)authentication andHeadImgStr1:(NSString *)string1 andHeadImgStr2:(NSString *)string2 andHeadImgStr3:(NSString *)string3 andUrlStr:(NSString *)urlStr;

@end
