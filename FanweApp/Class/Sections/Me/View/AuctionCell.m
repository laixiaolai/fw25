//
//  AuctionCell.m
//  FanweApp
//
//  Created by 岳克奎 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionCell.h"

@implementation AuctionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //隐藏
   
  
}

- (void)setBtn_Array:(NSArray *)btn_Array
{
    _btn_Array = btn_Array;
    for(UIButton *btn in _btn_Array) {
    btn_Array = _btn_Array;
    //btn.layer.cornerRadius = btn.frame.size.height/2.0f;
    btn.layer.cornerRadius = 25.0f;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = kAppMainColor.CGColor;
    btn.layer.borderWidth =1.0;
    btn.backgroundColor = btn.tag ==2 ? kNavBarThemeColor: kAppMainColor;
    [btn setTitleColor:btn.tag ==1 ?kNavBarThemeColor:kAppMainColor
              forState:UIControlStateNormal];
    
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version]&&btn.tag == 2) {
        btn.hidden = YES;
    }
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version]&&btn.tag == 1) {
        btn.hidden = YES;
    }
}
    self.contentView.backgroundColor =kBackGroundColor;
    
}
- (IBAction)goNextVC:(UIButton *)sender {
    NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(goNextVC:)]) {
        [self.delegate goNextVC:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
