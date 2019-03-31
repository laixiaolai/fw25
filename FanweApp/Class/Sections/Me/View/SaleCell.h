//
//  SaleCell.h
//  FanweApp
//
//  Created by 岳克奎 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  ASaleCellDelegate <NSObject>
@optional
- (void)rorateSign:(UIButton *)sender;
@end
@interface SaleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel     *left_Name_Lab;
@property (weak, nonatomic) IBOutlet UIImageView *diamond_ImgView;
@property (weak, nonatomic) IBOutlet UILabel     *right_Num_Lab;
@property (weak, nonatomic) IBOutlet UIImageView *expand_ImgView;
@property(nonatomic, weak)id <ASaleCellDelegate >delegate;
//modle 未定！！！！！！！！！！！
//vc

//Method
@end
