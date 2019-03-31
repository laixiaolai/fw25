//
//  EditAddressCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/10/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pushToMapDelegate <NSObject>

- (void)pushToMapController;

@end

@interface EditAddressCell : UITableViewCell

@property (nonatomic, weak) id<pushToMapDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UITextField *personFiled;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *cityFiled;
@property (weak, nonatomic) IBOutlet UIImageView *cityImgView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UILabel *smallAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *smallAddressFiled;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UITextField *defaultFiled;

@property (weak, nonatomic) IBOutlet UISwitch *myWitch;

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UIView *lineView4;
@property (weak, nonatomic) IBOutlet UIView *lineView5;


@end
