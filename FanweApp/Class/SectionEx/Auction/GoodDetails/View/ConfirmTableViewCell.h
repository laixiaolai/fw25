//
//  ConfirmTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView      *selectImgView;
@property (weak, nonatomic) IBOutlet UILabel          *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton         *comfirmButton;
@property (weak, nonatomic) IBOutlet UIButton         *protocolButton;
@property (weak, nonatomic) IBOutlet UIView           *lineView;

@end
