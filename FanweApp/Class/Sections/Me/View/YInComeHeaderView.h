//
//  YInComeHeaderView.h
//  FanweApp
//
//  Created by 岳克奎 on 16/8/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingdingStateModel.h"

@interface YInComeHeaderView : UIView



/*!
 *    @author Yue
 *
 *    @brief  自定义收益表头view
 *    prama   ticketName_Lab   钱票 名称
 *    prama   ticketNum_Lab    钱票 数量
 *    prama   sperataor_Lab    分割线
 *    prama   moneyName_Lab    红包 名称
 *    prama   moneNum_Lab      红包数量
 *    prama   model
 */
{
    YInComeHeaderView *header_View;
    GlobalVariables *_fanweApp;
}
@property (weak, nonatomic) IBOutlet UILabel  *ticketName_Lab;
@property (weak, nonatomic) IBOutlet UILabel  *ticketNum_Lab;
@property (weak, nonatomic) IBOutlet UILabel  *sperataor_Lab;
@property (weak, nonatomic) IBOutlet UILabel  *moneyName_Lab;
@property (weak, nonatomic) IBOutlet UILabel  *moneNum_Lab;
@property (strong,nonatomic)NSString           *ticket_Str;
@property (weak, nonatomic) IBOutlet UILabel  *bottomSeparataor_Gray_Lab;
@property (strong,nonatomic)BingdingStateModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyNumLab_Height_Constraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyNameLab_Height_Constraints;

+(YInComeHeaderView *)createYInComeHeaderViewWithFram:(CGRect)rect;


@end
