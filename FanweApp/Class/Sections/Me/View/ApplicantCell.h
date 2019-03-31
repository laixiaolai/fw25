//
//  ApplicantCell.h
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SociatyDetailModel.h"

@class ApplicantCell;

@protocol ApplicantCellDelegate <NSObject>

//拒绝申请(包括退出和加入公会)
- (void)refuseOfSociety:(ApplicantCell *)cell;
//同意申请(包括退出和加入公会)
- (void)agreeOfSociety:(ApplicantCell *)cell;
//观看直播
- (void)viewLiving:(ApplicantCell *)cell;

@end

@interface ApplicantCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *applicantHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *applicantNickNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *applicantSexImg;
@property (weak, nonatomic) IBOutlet UIImageView *applicantGradeImg;
@property (weak, nonatomic) IBOutlet UIButton *applicantLivingBtn;
@property (weak, nonatomic) IBOutlet UIButton *applicantRefuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *applicantAgreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *applicantLivingLbl;

@property (nonatomic, weak) id <ApplicantCellDelegate> delegate;

- (void)configCellMsg:(SociatyDetailModel *)model;

@end
