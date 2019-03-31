//
//  ConverDiamondsViewController.h
//  FanweApp
//
//  Created by yy on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConverDiamondsViewController : FWBaseViewController

@property (weak, nonatomic) IBOutlet UIView         *backView;
@property (weak, nonatomic) IBOutlet UILabel        *diamondsLabel;
@property (weak, nonatomic) IBOutlet UILabel        *acountLabel;
@property (weak, nonatomic) IBOutlet UIView         *textFieldView;
@property (weak, nonatomic) IBOutlet UITextField    *rightTextField;
@property (weak, nonatomic) IBOutlet UITextField    *leftTextfield;
@property (weak, nonatomic) IBOutlet UIButton       *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton       *converButton;
@property (weak, nonatomic) IBOutlet UILabel        *exchangeRate_Lab;  // 兑换比例lab
@property (nonatomic, assign) BOOL                  whetherGame;        // 是否游戏兑换
@property (nonatomic, strong) NSString              *tickte;

@end
