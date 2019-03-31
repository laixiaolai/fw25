//
//  EnterAdrssCell.h
//  O2O
//
//  Created by fanwe2014 on 15/7/28.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterAdrssCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *adressName;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;

- (void)setCellContent:(NSString *)adressName description:(NSString *)description;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
