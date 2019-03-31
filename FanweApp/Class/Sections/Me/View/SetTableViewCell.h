//
//  SetTableViewCell.h
//  FanweApp
//
//  Created by GuoMs on 16/7/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *setText;
@property (strong, nonatomic) IBOutlet UILabel *loginBack;
@property (strong, nonatomic) IBOutlet UILabel *memoryText;
@property (strong, nonatomic) IBOutlet UIImageView *comeBackIMG;

- (void)configurationCellWithSection:(NSInteger)section row:(NSInteger)row distribution_module:(NSString *)distribution_module;

@end
