//
//  WXContextViewController.h
//  FanweApp
//
//  Created by yy on 16/7/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXContextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *TieWxButton;
@property (weak, nonatomic) IBOutlet UIButton *TieMobileButton;
@property (weak, nonatomic) IBOutlet UIButton *TieWxNumberButton;
@property (nonatomic, strong) NSString *WxIsTie;
@property (nonatomic, strong) NSString *MobileIsTie;
@property (nonatomic, strong) NSString *WxNumberIsTie;

@end
