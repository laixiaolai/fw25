//
//  UpgradeView.h
//  FanweApp
//
//  Created by yy on 16/10/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UpgradeBlock)();

@interface UpgradeView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *displayView;       //展示view
@property (weak, nonatomic) IBOutlet UILabel *upgradeLabel;     //提示消息
@property (weak, nonatomic) IBOutlet UILabel *exLabel;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;      //知道了

@property (nonatomic, copy) UpgradeBlock upgradeBlock;

+ (instancetype)EditNibFromXib;

@end
