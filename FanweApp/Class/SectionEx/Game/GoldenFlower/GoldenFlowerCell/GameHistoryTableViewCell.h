//
//  GameHistoryTableViewCell.h
//  FanweApp
//
//  Created by yy on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *historyNewImg;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *midImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (nonatomic, strong) NSArray * imageViewArr;
@property (nonatomic, assign) NSInteger gameID;
- (void)createCellWithArray:(NSNumber *)winNum withRow:(NSInteger)row;

@end
