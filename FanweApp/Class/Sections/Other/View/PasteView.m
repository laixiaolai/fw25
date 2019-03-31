//
//  PasteView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/29.
//  Copyright © 2016年 xfg. All rights reserved.

#import "PasteView.h"

@implementation PasteView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = kClearColor;
    self.buttomView.layer.cornerRadius = 5;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
    self.contentlabel.alpha = 0.8;
    self.cancelButton.titleLabel.alpha = 0.8;
    self.pasteButton.titleLabel.alpha = 0.8;
    self.deleteButton.titleLabel.textColor = kAppGrayColor1;
    self.lineView1.backgroundColor = myTextColorLine4;
    self.lineView2.backgroundColor = myTextColorLine4;
    
}
- (void)tap
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(deletePasteView)])
        {
            [self.delegate deletePasteView];
        }
    }
}

- (IBAction)buttonClick:(UIButton *)sender
{
    int index =(int)sender.tag;
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(sentPasteWithIndex:withShareIndex:)])
        {
            [self.delegate sentPasteWithIndex:index withShareIndex:self.shareIndex];
        }
    }
   
}



@end
