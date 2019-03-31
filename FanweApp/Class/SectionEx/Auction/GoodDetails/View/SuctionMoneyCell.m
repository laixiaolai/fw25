//
//  SuctionMoneyCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SuctionMoneyCell.h"

@implementation SuctionMoneyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.fanweApp = [GlobalVariables sharedInstance];
    self.nameLabel.textColor = kAppGrayColor1;
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-1, kScreenW-10, 1)];
    self.lineView.backgroundColor = kAppSpaceColor4;
    [self addSubview:self.lineView];
}

- (void)setCellWithMoney:(NSString *)money
{
    NSString *moneyString;
    if ([money intValue] > 10000)
    {
        moneyString = [NSString stringWithFormat:@"%.2f万",[money floatValue]/10000];
    }else
    {
        moneyString = money;
    }
    
    NSString *string  = [NSString stringWithFormat:@"系统将在您的账户中扣取%@%@作为拍卖保证金暂时托管。",moneyString,self.fanweApp.appModel.diamond_name];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, moneyString.length)];
    //    [attr setAttributes:@{NSForegroundColorAttributeName : kAppMainColor} range:[string rangeOfString:moneyString]]; //设置会员名称的字体颜色
    self.nameLabel.attributedText = attr;
    
    
}


@end
