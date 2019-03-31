//
//  AccountRechargeOthermoneyTBCell.h
//  FanweApp
//
//  Created by hym on 2016/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^onClick)(id object);

@interface AccountRechargeOthermoneyTBCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *tfOtherMoney;
@property (weak, nonatomic) IBOutlet UILabel *lbOtherMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnOperation;
@property (copy, nonatomic) onClick block;
@property (copy, nonatomic) NSString * rate;

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@end
