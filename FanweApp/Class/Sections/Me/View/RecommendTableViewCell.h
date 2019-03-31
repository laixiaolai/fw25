//
//  RecommendTableViewCell.h
//  FanweApp
//
//  Created by 王珂 on 17/3/30.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecommendTableViewCell;

@protocol RecommendTableViewCellDelegate <NSObject>

@optional
- (void)clickRecommendViewWithBtn:(UIButton *)button andRecommendViewCell:(RecommendTableViewCell *)recommendViewCell;

- (void)choseRecommendTypeWithRecommendViewCell:(RecommendTableViewCell *)recommendViewCell;

@end

@interface RecommendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel                  *recommendLabel;
@property (weak, nonatomic) IBOutlet UITextField              *recommendTypeField;
@property (weak, nonatomic) IBOutlet UITextField              *recommendField;
@property (weak, nonatomic) IBOutlet UIButton                 *recommendTypeBtn;
@property (weak, nonatomic) id<RecommendTableViewCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
