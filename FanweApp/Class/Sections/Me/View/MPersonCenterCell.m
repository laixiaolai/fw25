//
//  MPersonCenterCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MPersonCenterCell.h"

@implementation MPersonCenterCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftImgView.contentMode   = UIViewContentModeScaleAspectFit;
    self.lefLabel.textColor        = kAppGrayColor1;
    self.rightLabel.textColor      = kAppGrayColor3;
    
    self.lineView                  = [[UIView alloc]initWithFrame:CGRectMake(10, 45*kAppRowHScale-1, kScreenH-10, 1)];
    self.lineView.backgroundColor  = kAppSpaceColor4;
    [self addSubview:self.lineView];

}
- (void)creatCellWithImgStr:(NSString *)imgStr andLeftStr:(NSString *)leftStr andRightStr:(NSString *)rightStr andSection:(int)section
{
    self.leftImgView.image = [UIImage imageNamed:imgStr];
    self.lefLabel.text     = leftStr;
    self.rightLabel.text   = rightStr;
    if (section == MPCOutPutSection)       //控制右边的箭头是否显示
    {
        self.rightImgView.hidden = YES;
    }else
    {
        self.rightImgView.hidden = NO;
    }
    
    if (section == MPCexchangeCoinsSection || section == MPCContributeSection)  //控制左边图片的大小
    {
        CGRect rect            = self.leftImgView.frame;
        rect.size.height       = 21;
        self.leftImgView.frame = rect;
    }else if (section == MPCGoodsMSection)
    {
        CGRect rect            = self.leftImgView.frame;
        rect.size.height       = 22.5;
        self.leftImgView.frame = rect;
    }else
    {
        CGRect rect            = self.leftImgView.frame;
        rect.size.height       = 20;
        self.leftImgView.frame = rect;
    }
    
    if (section == MPCOutPutSection || section == MPCContributeSection || section == MPCGameSISection ||section == MPCShopCartSection || section == MPCAutionMSection || section == MPCMyLitteShopSection ||section == MPCTradeSection ||section == MPCSetSection)
    {
        self.lineView.hidden = YES;
    }else
    {
        self.lineView.hidden = NO;
    }
}


@end
