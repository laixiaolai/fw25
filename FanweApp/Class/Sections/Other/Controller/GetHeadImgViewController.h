//
//  GetHeadImgViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetHeadImgViewController : FWBaseViewController

@property (strong,nonatomic)UIImageView *headImgView;
@property (copy,nonatomic)NSString *headImgString;
@property(copy,nonatomic)NSString *userId;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneChoseButton;
@property (weak, nonatomic) IBOutlet UIButton *deleButton;

@end
