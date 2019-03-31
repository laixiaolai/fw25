//
//  FansCell.h
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SociatyDetailModel.h"

@class FansCell;

@protocol FansCellDelegate <NSObject>

//踢出公会
- (void)pleaseLeaveWithSocietyMember:(FansCell *)cell;
//直播
- (void)fansViewLiving:(FansCell *)cell;

@end

@interface FansCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *fansViewLiveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *fansHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *fansNickNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *fansSexImg;
@property (weak, nonatomic) IBOutlet UIImageView *fansGradeImg;
@property (weak, nonatomic) IBOutlet UIButton *fansGoOutBtn;
@property (nonatomic, weak) id <FansCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *fansPridisentLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fansDistanceW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fansPridisentLblW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goOutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceWidth;

- (void)configCellMsg:(SociatyDetailModel *)model memberType:(int)memberType;

@end
