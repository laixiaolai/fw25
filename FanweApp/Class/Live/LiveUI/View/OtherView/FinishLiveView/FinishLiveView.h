//
//  FinishLiveView.h
//  FanweApp
//
//  Created by xfg on 2017/8/28.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"

@interface FinishLiveView : FWBaseView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIView *audienTicketContrainerView;
@property (weak, nonatomic) IBOutlet UILabel *audienceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;

@property (weak, nonatomic) IBOutlet UILabel *audienceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceNumLabel2;

@property (weak, nonatomic) IBOutlet UIButton *shareFollowBtn;
@property (weak, nonatomic) IBOutlet UIButton *backHomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *delLiveBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *acIndicator;

@property (nonatomic, copy) FWVoidBlock shareFollowBlock;
@property (nonatomic, copy) FWVoidBlock backHomeBlock;
@property (nonatomic, copy) FWVoidBlock delLiveBlock;
@property (weak, nonatomic) IBOutlet UILabel *ticketNameLabel;


- (IBAction)shareFollowAction:(id)sender;
- (IBAction)backHomeAction:(id)sender;
- (IBAction)delLiveAction:(id)sender;

@end
