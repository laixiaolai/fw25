//
//  AuctionAloneCell.h
//  FanweApp
//
//  Created by hym on 2016/12/1.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  AuctionAloneCellDelegate <NSObject>

@optional
- (void)buttonActionGoNetVC:(NSString *)tile;

@end


@interface AuctionAloneCell : UITableViewCell

@property (nonatomic, weak) id <AuctionAloneCellDelegate> delegate;
@property (nonatomic, strong) NSString *tile;

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@end
