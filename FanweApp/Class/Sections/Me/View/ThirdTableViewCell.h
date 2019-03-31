//
//  ThirdTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThirdTableViewCell;

@protocol buttonClickDelegate <NSObject>
////取消认证类型
//- (void)cancelIdentificationView;
//获取认证类型
- (void)getIdentificationWithCell:(ThirdTableViewCell *)myCell;
@end

@interface ThirdTableViewCell : UITableViewCell

@property (nonatomic, weak) id<buttonClickDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *identificationButton;
@property (weak, nonatomic) IBOutlet UILabel *identificationType;
@property (weak, nonatomic) IBOutlet UILabel *identificationName;
@property (weak, nonatomic) IBOutlet UILabel *contactWay;
@property (weak, nonatomic) IBOutlet UITextField *typeTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *contactTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *identificationNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *identificationNumFiled;
@property (weak, nonatomic) IBOutlet UILabel *idStartLabel;

- (void)creatCellWithAuthentication:(int)authentication andIdTypeStr:(NSString *)idTypeStr andIdNameStr:(NSString *)idNameStr andIdContactStr:(NSString *)idContactStr andIdNumStr:(NSString *)idNumStr andShowIdNum:(int)idNum;

@end
