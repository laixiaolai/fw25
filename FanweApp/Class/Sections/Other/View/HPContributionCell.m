//
//  HPContributionCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "HPContributionCell.h"

@implementation HPContributionCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = kBackGroundColor;
    self.imgView1.layer.cornerRadius = 33/2.0f;
    self.imgView2.layer.cornerRadius = 33/2.0f;
    self.imgView3.layer.cornerRadius = 33/2.0f;
    
    self.imgView1.layer.masksToBounds = YES;
    self.imgView2.layer.masksToBounds = YES;
    self.imgView3.layer.masksToBounds = YES;
    self.fanweApp = [GlobalVariables sharedInstance];
    self.myNameLabel.text = [NSString stringWithFormat:@"%@贡献榜",self.fanweApp.appModel.ticket_name];
    self.myNameLabel.textColor = kAppGrayColor3;
}

- (void)setCellWithArray:(NSMutableArray *)imageArray
{
    if (imageArray.count > 2)
    {
        if ([imageArray[2] length])
        {
            [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:imageArray[2]] placeholderImage:[UIImage imageNamed:@"ic_me_qiuzhan"]];
        }
    }
    
    if (imageArray.count > 1)
    {
        if ([imageArray[1] length])
        {
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:imageArray[1]] placeholderImage:[UIImage imageNamed:@"ic_me_qiuzhan"]];
        }
    }
    
    if (imageArray.count > 0)
    {
        if ([imageArray[0] length])
        {
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"ic_me_qiuzhan"]];
        }
    }
    
}


@end
