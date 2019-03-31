//
//  AddressTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *addAddressImgView;
@property (weak, nonatomic) IBOutlet UIImageView    *rightImgView;
@property (weak, nonatomic) IBOutlet UILabel        *namePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel        *addressLabel;

@end
