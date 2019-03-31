//
//  SuctionDetailContactWayCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuctionDetailContactWayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *personTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;

@end
