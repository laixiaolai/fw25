//
//  TwoSectionTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "TwoSectionTableViewCell.h"
#import "AcutionDetailModel.h"
#import "InfoModel.h"

@interface TwoSectionTableViewCell ()
{
    AcutionDetailModel *ADModel;
    InfoModel *IModel;
}
@end

@implementation TwoSectionTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lineView.backgroundColor = self.lineView2.backgroundColor = self.lineView3.backgroundColor =kAppSpaceColor4;
    
    self.view1 = [[UIView alloc]init];
    self.view2 = [[UIView alloc]init];
    self.view3 = [[UIView alloc]init];
    
    self.view1.backgroundColor = kClearColor;
    self.view2.backgroundColor = kClearColor;
    self.view3.backgroundColor = kClearColor;
    
    self.imgView1 = [[UIImageView alloc]init];
    self.imgView2 = [[UIImageView alloc]init];
    self.imgView3 = [[UIImageView alloc]init];
    
    self.imgView1.image = [UIImage imageNamed:@"ac_gold_diamond"];
    self.imgView2.image = [UIImage imageNamed:@"ac_gold_diamond"];
    self.imgView3.image = [UIImage imageNamed:@"ac_gold_diamond"];
    
    self.startPriceLabel.textColor = kAppGrayColor1;
    self.addPriceLabel.textColor   = kAppGrayColor1;
    self.depositLabel.textColor    = kAppGrayColor1;
    
    self.priceLabel1  = [[UILabel alloc]init];
    self.priceLabel2  = [[UILabel alloc]init];
    self.priceLabel13 = [[UILabel alloc]init];
    self.priceLabel13.textColor  = kAppGrayColor1;
    self.priceLabel1.textColor   = kAppGrayColor1;
    self.priceLabel2.textColor   = kAppGrayColor1;
    self.mostTimeLabel.textColor = kAppGrayColor1;
    self.cycleLabel.textColor    = kAppGrayColor1;
    
    [self addSubview:self.view1];
    [self addSubview:self.view2];
    [self addSubview:self.view3];
    
    self.backgroundColor = kAppPurpleColor;
}

- (void)creatCellWithArray:(NSMutableArray *)array
{
    if (array.count)
    {
        ADModel = array[0];
    }else
    {
        ADModel = [AcutionDetailModel new];
    }
    
    if (!ADModel.info)
    {
        IModel = [[InfoModel alloc]init];
    }else
    {
        IModel = ADModel.info;
    }
    
    
    //起拍价
    NSString *string;
    if (ADModel.info.qp_diamonds.length > 0)
    {
        string = ADModel.info.qp_diamonds;
    }else
    {
        string = @"0";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, string.length)];
    CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    self.imgView1.frame = CGRectMake(0, 4.5, 13, 10);
    self.priceLabel1.frame = CGRectMake(self.imgView1.frame.size.width+self.imgView1.frame.origin.x+3,0,width, 19);
    self.priceLabel1.attributedText = attr;
    self.view1.frame = CGRectMake((kScreenW-2)/6-(width+16)/2, 40, width+13+3, 19);
    [self.view1 addSubview:self.imgView1];
    [self.view1 addSubview:self.priceLabel1];
    
    //加价幅度
    NSString *string1;
    if (ADModel.info.jj_diamonds.length > 0)
    {
        string1 = ADModel.info.jj_diamonds;
    }else
    {
        string1 = @"0";
    }
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, string1.length)];
    CGFloat width1 =[string1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}].width;
    self.imgView2.frame = CGRectMake(0, 4.5, 13, 10);
    self.priceLabel2.frame = CGRectMake(self.imgView2.frame.size.width+self.imgView2.frame.origin.x+3,0,width1, 19);
    self.priceLabel2.attributedText = attr1;
    self.view2.frame = CGRectMake(kScreenW/2-(width1+16)/2, 40, width1+13+3, 19);
    [self.view2 addSubview:self.imgView2];
    [self.view2 addSubview:self.priceLabel2];
    
    //保证金
    NSString *string2;
    if (ADModel.info.bz_diamonds.length > 0)
    {
        string2 = ADModel.info.bz_diamonds;
    }else
    {
        string2 = @"0";
    }
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [attr2 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, string2.length)];
    CGFloat width2 =[string2 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}].width;
    self.imgView3.frame = CGRectMake(0, 4.5, 13, 10);
    self.priceLabel13.frame = CGRectMake(self.imgView3.frame.size.width+self.imgView3.frame.origin.x+3,0,width2, 19);
    self.priceLabel13.attributedText = attr2;
    
    self.view3.frame = CGRectMake((kScreenW-2)*5/6+2-(width2+16)/2, 40, width2+13+3, 19);
    
    [self.view3 addSubview:self.imgView3];
    [self.view3 addSubview:self.priceLabel13];
    
    if (IModel.pai_yanshi.length < 1)
    {
        IModel.pai_yanshi = @"0";
    }
    if (IModel.max_yanshi.length < 1)
    {
        IModel.max_yanshi = @"0";
    }
    self.cycleLabel.text = [NSString stringWithFormat:@"延时周期: %@分钟/次",IModel.pai_yanshi];
    self.mostTimeLabel.text = [NSString stringWithFormat:@"最大延时次数: %@次",IModel.max_yanshi];
    
}

@end
