//
//  ApplyBankerView.m
//  FanweApp
//
//  Created by yy on 17/2/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ApplyBankerView.h"

@implementation ApplyBankerView

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)createStyle
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    _titleLabel.textColor = kAppGrayColor1;
    _horizontalLine.backgroundColor = kAppSpaceColor2;
    _coinTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _verticalLine.backgroundColor = kAppSpaceColor2;
    [_cancelButton setTitleColor:kGrayTransparentColor5 forState:UIControlStateNormal];
    [_confirmButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelAuction) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton addTarget:self action:@selector(confirmAuction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark    请求上庄
- (void)requestBanker
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"applyBanker" forKey:@"act"];
    [parmDict setObject:_video_id forKey:@"video_id"];
    [parmDict setObject:_coinTextfield.text forKey:@"coin"];
    
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson){
        
        FWStrongify(self)
        
        if ([responseJson toInt:@"status"] == 1)
        {
            NSString *coinStr = [NSString stringWithFormat:@"%@",[responseJson toString:@"coin"]] ;
            
            //存入本地
            [[IMAPlatform sharedInstance].host setUserCoin:coinStr];
            [[FWHUDHelper sharedInstance]tipMessage:@"上庄成功"];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenGrabBankerBtnWithCoin:)])
            {
                [self.delegate hiddenGrabBankerBtnWithCoin:coinStr];
            }
        }
        
    } FailureBlock:^(NSError *error){
        
    }];
}

//取消
- (void)cancelAuction
{
    if (_delegate && [_delegate respondsToSelector:@selector(bankerViewDown)]) {
        [_delegate bankerViewDown];
    }
}

//确定
- (void)confirmAuction
{
    //当输入金额 大于账户
    if(_coinTextfield.text.integerValue > [_coin integerValue])
    {
        _coinTextfield.text = nil;
        
        [[FWHUDHelper sharedInstance]tipMessage:@"输入金额不得大于账户余额"];
        
        return;
    }
    else
    {
        if ([_coinTextfield.text integerValue] > 0 && [_coinTextfield.text integerValue] >= [_principal integerValue]) {
            [self requestBanker];
            [self cancelAuction];
        }
        else if ([_coinTextfield.text integerValue] > 0 && [_coinTextfield.text integerValue] < [_principal integerValue])
        {
            [[FWHUDHelper sharedInstance]tipMessage:@"输入金额不得小于底金"];
            _coinTextfield.text = nil;
        }
        else
        {
            [[FWHUDHelper sharedInstance]tipMessage:@"请输入有效金额"];
            _coinTextfield.text = nil;
        }
    }
    
}



@end
