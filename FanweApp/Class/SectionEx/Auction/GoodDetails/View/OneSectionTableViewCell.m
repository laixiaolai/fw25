//
//  OneSectionTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.

#import "OneSectionTableViewCell.h"
#import "AcutionDetailModel.h"

@implementation OneSectionTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    //设定时分秒的背景
    self.auctionButton.layer.cornerRadius = self.auctionButton.frame.size.height/2;
    self.backgroundColor = kAppMainColor;
    
    self.timeLabel.textColor = self.maoHaoLabel2.textColor = self.maoHaoLabel.textColor = kAppGrayColor1;
    
    self.minuteLabel.textColor = self.secLabel.textColor = self.hourLabel.textColor = kWhiteColor;
    
    self.auctionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.auctionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.auctionButton setTitle:@"竞拍结束" forState:0];
    [self addSubview:self.auctionButton];
    
}

- (void)creatCellWithArray:(NSMutableArray *)array andStatue:(int)statue
{
    AcutionDetailModel *ADModel = array[0];
    if (statue == 0)//0竞拍中 1竞拍成功 2流拍 3失败
    {
        self.auctionImgView.hidden = YES;
        self.auctionButton.hidden = YES;
        self.auctionLabel.hidden = YES;
        
        self.rightImgView.hidden = NO;
        self.priceLabel.hidden = NO;
        self.timeLabel.hidden = NO;
        self.hourLabel.hidden = NO;
        self.minuteLabel.hidden = NO;
        self.secLabel.hidden = NO;
        self.goldImgView.hidden = NO;
        self.nowPriceLabel.hidden = NO;
        self.remainTimeLabel.hidden = NO;
        self.maoHaoLabel.hidden = NO;
        self.maoHaoLabel2.hidden = NO;
        self.priceLabel.text = ADModel.info.last_pai_diamonds;
        
    }else
    {
        self.auctionImgView.hidden = NO;
        self.auctionButton.hidden = NO;
        self.auctionLabel.hidden = NO;
        
        self.rightImgView.hidden = YES;
        self.priceLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        self.hourLabel.hidden = YES;
        self.minuteLabel.hidden = YES;
        self.secLabel.hidden = YES;
        self.goldImgView.hidden = YES;
        self.nowPriceLabel.hidden = YES;
        self.remainTimeLabel.hidden = YES;
        self.maoHaoLabel.hidden = YES;
        self.maoHaoLabel2.hidden = YES;
        if (statue == 1)
        {
            self.backImgView.backgroundColor = kAppMainColor;
            self.auctionImgView.image = [UIImage imageNamed:@"ac_success"];
            
            NSString *string = @"竞拍成功";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
            [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0]} range:NSMakeRange(0, string.length)];
            CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}].width;
            self.auctionLabel.frame = CGRectMake(self.auctionImgView.frame.size.width+self.auctionImgView.frame.origin.x+5,16,width, 20);
            self.auctionLabel.attributedText = attr;
            self.auctionButton.frame = CGRectMake(self.auctionLabel.frame.size.width+self.auctionLabel.frame.origin.x+5,16,65 ,20);
            self.auctionButton.backgroundColor = kYellowColor;
            [self.auctionButton setTitleColor:kAppMainColor forState:0];
            [self.auctionButton setTitle:@"结算中" forState:0];
            
            
        }else if (statue == 2)
        {
            self.backImgView.backgroundColor = kAppGrayColor6;
            self.auctionImgView.image = [UIImage imageNamed:@"ac_fail"];
            
            NSString *string = @"流拍";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
            [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0]} range:NSMakeRange(0, string.length)];
            CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}].width;
            self.auctionLabel.frame = CGRectMake(self.auctionImgView.frame.size.width+self.auctionImgView.frame.origin.x+5,16,width, 20);
            self.auctionLabel.attributedText = attr;
            CGRect rect = self.auctionButton.frame;
            rect = CGRectMake(self.auctionLabel.frame.size.width+self.auctionLabel.frame.origin.x+5,16,65 ,20);
            self.auctionButton.frame = rect;
            self.auctionButton.backgroundColor = kAppGrayColor7;
            [self.auctionButton setTitleColor:kWhiteColor forState:0];
            
        }else if (statue == 3)
        {
            self.backImgView.backgroundColor = kAppGrayColor6;
            self.auctionImgView.image = [UIImage imageNamed:@"ac_fail"];
            
            NSString *string = @"竞拍失败";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
            [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0]} range:NSMakeRange(0, string.length)];
            CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}].width;
            self.auctionLabel.frame = CGRectMake(self.auctionImgView.frame.size.width+self.auctionImgView.frame.origin.x+5,16,width, 20);
            self.auctionLabel.attributedText = attr;
            self.auctionButton.frame = CGRectMake(self.auctionLabel.frame.size.width+self.auctionLabel.frame.origin.x+5,16,90 ,20);
            [self.auctionButton setTitle:@"主播关闭竞拍" forState:0];
            self.auctionButton.backgroundColor = kAppGrayColor7;
            [self.auctionButton setTitleColor:kWhiteColor forState:0];
            
        }else if (statue == 4)
        {
            self.backImgView.backgroundColor = kAppMainColor;
            self.auctionImgView.image = [UIImage imageNamed:@"ac_success"];
            
            NSString *string = @"竞拍成功";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
            [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0]} range:NSMakeRange(0, string.length)];
            CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}].width;
            self.auctionLabel.frame = CGRectMake(self.auctionImgView.frame.size.width+self.auctionImgView.frame.origin.x+5,16,width, 20);
            self.auctionLabel.attributedText = attr;
            self.auctionButton.frame = CGRectMake(self.auctionLabel.frame.size.width+self.auctionLabel.frame.origin.x+5,16,65 ,20);
            self.auctionButton.backgroundColor = kYellowColor;
            [self.auctionButton setTitleColor:kAppMainColor forState:0];
            [self.auctionButton setTitle:@"竞拍结束" forState:0];
            
            
        }
        self.auctionButton.layer.cornerRadius = self.auctionButton.frame.size.height/2;
    }
    
    
}


@end
