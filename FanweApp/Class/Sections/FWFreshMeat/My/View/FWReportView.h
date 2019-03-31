//
//  FWReportView.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reportDeleGate <NSObject>

//回退回上一个页面
- (void)reportComeBack;

@end

@interface FWReportView : UIView
@property (weak,nonatomic)id<reportDeleGate>RDeleGate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,strong)UIImageView *backImgView;

@end
