//
//  AuctionCell.h
//  FanweApp
//
//  Created by 岳克奎 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  AInComeDataCellDelegate <NSObject>
@optional
- (void)goNextVC:(UIButton *)sender;
@end
@interface AuctionCell : UITableViewCell
//兑换／微信提现

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_Array;

@property(nonatomic, weak)id <AInComeDataCellDelegate >delegate;
@end
