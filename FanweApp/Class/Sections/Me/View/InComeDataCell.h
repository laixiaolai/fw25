//
//  InComeDataCell.h
//  FanweApp
//
//  Created by 岳克奎 on 16/8/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InComeDataCell : UITableViewCell
//累计收入
@property (weak, nonatomic) IBOutlet UILabel *totalInCome_Lab;
//待结算
@property (weak, nonatomic) IBOutlet UILabel *pendSettlement_Lab;
//竞拍管理
@property (weak, nonatomic) IBOutlet UIButton *auctionManagement_Btn;
@end
