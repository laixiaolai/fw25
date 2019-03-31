//
//  czbtCell.m
//  iChatView
//
//  Created by zzl on 16/6/12.
//  Copyright © 2016年 ldh. All rights reserved.
//


#import "czbtCell.h"

@implementation RefBt


@end
@implementation czbtCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.mleft.layer.cornerRadius   = 5;
    self.mleft.layer.borderColor    = [UIColor clearColor].CGColor;
    self.mleft.layer.borderWidth    = 1;
    
    self.mright.layer.cornerRadius   = 5;
    self.mright.layer.borderColor    = [UIColor clearColor].CGColor;
    self.mright.layer.borderWidth    = 1;
    
}

- (void)setLeftBt:(float)price goldcount:(int)goldcount count:(NSString *)count
{
    UILabel* ll = [self.mleft viewWithTag:2];
    ll.text = [NSString stringWithFormat:@"%d",goldcount];
    
    ll = [self.mleft viewWithTag:3];
    ll.text = [NSString stringWithFormat:@"售价:￥%.2f元",price];
    
    if ([count isEqualToString:@"" ]|| count ==nil) {
        self.leftGivingCount.hidden =YES;
        self.firstImageLayout1.constant +=10;
        self.firstLabelLayout1.constant +=10;

    }else
    {
         self.leftGivingCount.hidden =NO;
         self.leftGivingCount.text =count;
    }

    
}

- (void)setRightBt:(float)price goldcount:(int)goldcount count:(NSString *)count
{
    UILabel* ll = [self.mright viewWithTag:2];
    ll.text = [NSString stringWithFormat:@"%d",goldcount];
    
    ll = [self.mright viewWithTag:3];
    ll.text = [NSString stringWithFormat:@"售价:￥%.2f元",price];
    if ([count isEqualToString:@"" ]|| count ==nil) {
        self.rightGivingCount.hidden =YES;
        self.firstImageLayout.constant +=10;
        self.firstLabelLayout.constant +=10;
        self.secondLabelLayout.constant +=15;
        
    }else
    {
        self.rightGivingCount.hidden =NO;
         self.rightGivingCount.text =count;
    }
   
    
}

//v:0 正常 1:显示输入金额 2 隐藏
- (void)setLeftVisable:(int)v
{
    self.mleft.hidden = (v == 2);
    self.mleftinput.hidden = (v != 1);
    
}
- (void)setRightVisable:(int)v
{
    self.mright.hidden = (v == 2);
    self.mrightinput.hidden = (v != 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
