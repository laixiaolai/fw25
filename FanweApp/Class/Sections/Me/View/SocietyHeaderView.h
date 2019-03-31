//
//  TianTuanHeaderView.h
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocietyHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *societyBgBtn;
@property (weak, nonatomic) IBOutlet UILabel *societyNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *presidentLbl;
@property (weak, nonatomic) IBOutlet UILabel *declarationLbl;
@property (weak, nonatomic) IBOutlet UIButton *OperationBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationBtnW;
@property (weak, nonatomic) IBOutlet UILabel *societyTotalLbl;
@property (weak, nonatomic) IBOutlet UIImageView *tblHeadImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTopH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBottomH;

@end
