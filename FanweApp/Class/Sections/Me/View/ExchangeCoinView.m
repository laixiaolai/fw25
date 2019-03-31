//
//  ExchangeCoinView.m
//  FanweApp
//
//  Created by yy on 17/2/16.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ExchangeCoinView.h"

@implementation ExchangeCoinView

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)createSomething
{
    _httpManager = [NetHttpsManager manager];
    _fanweApp    = [GlobalVariables sharedInstance];
    [self createStyle];
}

- (void)createStyle
{
    [self.confirmButton addTarget:self
                           action:@selector(confirmButtonActon)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton setTitleColor:kAppGrayColor1
                             forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:kAppGrayColor1
                            forState:UIControlStateNormal];
    self.diamondLeftTextfield.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.diamondLeftTextfield.keyboardType      = UIKeyboardTypeNumberPad;
    self.textfieldBgView.layer.masksToBounds    = YES;
    self.textfieldBgView.layer.cornerRadius     = 5;
    self.textfieldBgView.layer.borderColor      = kAppGrayColor4.CGColor;
    self.textfieldBgView.layer.borderWidth      = 0.5;
    self.diamondLeftTextfield.delegate          = self;
    self.confirmButton.backgroundColor          = [UIColor whiteColor];
    self.cancelButton.backgroundColor           = [UIColor whiteColor];
    self.verticalLine.backgroundColor           = kAppGrayColor4;
    self.horizonLine.backgroundColor            = kAppGrayColor4;
    self.titleBgView.backgroundColor            = kAppMainColor;
    self.exchangeTitle.textColor                = kWhiteColor;
    self.diamondLabel.textColor                 = kAppGrayColor1;
    self.scaleLabel.textColor                   = kAppGrayColor1;
    self.coinLabel.textColor                    = kAppGrayColor1;
    self.layer.masksToBounds                    = YES;
    self.layer.cornerRadius                     = 10;
    
    if (_exchangeType == 1)
    {
        self.exchangeTitle.text = @"兑换游戏币";
        self.coinLabel.text = @"0游戏币";
        [self.confirmButton setTitle:@"兑换" forState:UIControlStateNormal];
    }
    else if (_exchangeType == 2)
    {
        self.exchangeTitle.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
        self.coinLabel.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
        [self.confirmButton setTitle:@"兑换" forState:UIControlStateNormal];
    }
    else if (_exchangeType == 3)
    {
        self.exchangeTitle.text = @"赠送游戏币";
        self.scaleLabel.hidden  = YES;
        self.coinLabel.hidden   = YES;
        [self.confirmButton setTitle:@"赠送" forState:UIControlStateNormal];
    }
    else if (_exchangeType == 4)
    {
        self.exchangeTitle.text = [NSString stringWithFormat:@"赠送%@",self.fanweApp.appModel.diamond_name];
        self.scaleLabel.hidden  = YES;
        self.coinLabel.hidden   = YES;
        [self.confirmButton setTitle:@"赠送" forState:UIControlStateNormal];
    }
}

#pragma marlk textfieldDelegate代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 6 && range.length!= 1){
        textField.text = [toBeString substringToIndex:6];
        return NO;
        
    }
    
//    if ([toBeString integerValue] > [_ticket integerValue])
//    {
//        [[FWHUDHelper sharedInstance]tipMessage:@"输入金额大于账户余额"];
//        
//        return NO;
//    }
    
    _rat = [toBeString integerValue] * [ratio floatValue];
    if (_exchangeType == 3 || _exchangeType == 4)
    {
        NSLog(@"%f",[_diamondLeftTextfield.text floatValue]);
        if ([toBeString integerValue] > 0)
        {
            [_confirmButton setTitleColor:kAppMainColor forState:UIControlStateNormal];
        }
        else
        {
            [_confirmButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        }
    }
    else
    {
        if (_rat >0)
        {
            [_confirmButton setTitleColor:kAppMainColor forState:UIControlStateNormal];
        }
        else
        {
            [_confirmButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        }
        
        if (_exchangeType == 1) {
            _coinLabel.text = [NSString stringWithFormat:@"%ld游戏币",(long)_rat];
        }
        else
        {
            _coinLabel.text = [NSString stringWithFormat:@"%ld%@",(long)_rat,self.fanweApp.appModel.diamond_name];
        }
    }
    
    NSLog(@"++++++++++++++++++++++++%ld", (long)_rat);
    return [self validateNumber:string];
}

//限制只输入数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark    获取游戏币兑换比例
- (void)obtainCoinProportion
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"exchangeRate" forKey:@"act"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] ==1)
         {
             ratio = [responseJson objectForKey:@"exchange_rate"];
             //兑换比例
             if (ratio != nil&& ![ratio isEqual:[NSNull null]])
             {
                 _scaleLabel.text = [NSString stringWithFormat:@"兑换比例: %@",ratio];
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

#pragma marlk 获得钻石兑换比例
- (void)requetRatio
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"exchange" forKey:@"act"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ((NSNull *)responseJson != [NSNull null])
         {
             if ([responseJson toInt:@"status"] ==1)
             {
                 FreshAcountModel *model3 =[[FreshAcountModel alloc]init];
                 model3 =[FreshAcountModel mj_objectWithKeyValues:responseJson];
                 
                 ratio =model3.ratio;
                 //兑换比例
                 if (ratio != nil&& ![ratio isEqual:[NSNull null]]) {
                     _scaleLabel.text = [NSString stringWithFormat:@"兑换比例: %@",ratio];
                 }
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
    
}

#pragma mark    钻石兑换游戏币
- (void)exchangeCoin
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"exchangeCoin" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",_diamondLeftTextfield.text] forKey:@"diamonds"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"]==1)
         {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCoin" object:nil];
            [_diamondLeftTextfield resignFirstResponder];
            [[FWHUDHelper sharedInstance]tipMessage:@"兑换成功"];
         }
         
     } FailureBlock:^(NSError *error)
     {
         [FanweMessage alert:@"请求失败"];
     }];
    
}

#pragma marlk 兑换钻石
- (void)converDiamondsRequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"do_exchange" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",_diamondLeftTextfield.text] forKey:@"ticket"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"]==1)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAcount" object:nil];
         }
         
     } FailureBlock:^(NSError *error)
     {
         [FanweMessage alert:@"请求失败"];
     }];
}

- (void)confirmButtonActon
{
    if (_exchangeType == 3 || _exchangeType == 4)
    {
        if ([_diamondLeftTextfield.text integerValue] < 1) {
            [[FWHUDHelper sharedInstance]tipMessage:@"请输入足够的金额"];
            return;
        }
    }
    else
    {
        //当输入金额 不足兑换 1钻石
        if(ratio.floatValue != 0)
        {
            if (_rat < 1 || [_diamondLeftTextfield.text integerValue] < 1)
            {
                //            [SVProgressHUD showInfoWithStatus:@"请输入足够的金额"];
                [[FWHUDHelper sharedInstance]tipMessage:@"请输入足够的金额"];
                return;
            }
        }

    }
       //当输入金额 大于账户
    if(_diamondLeftTextfield.text.integerValue > _ticket.floatValue)
    {
        _diamondLeftTextfield.text = nil;
        if (_exchangeType == 1) {
            _coinLabel.text = @"0游戏币";
        }
        else
        {
            _coinLabel.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
        }
        [_confirmButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        
        [[FWHUDHelper sharedInstance]tipMessage:@"输入金额不得大于账户余额"];
        
        return;
    }
    
    if (_exchangeType == 3 || _exchangeType == 4)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(comfirmClickWithExchangeCoinView:)])
        {
            [_delegate comfirmClickWithExchangeCoinView:self];
        }
        
        [self backToBefore];
        if (_delegate && [_delegate respondsToSelector:@selector(exchangeViewDownWithExchangeCoinView:)])
        {
            [_delegate exchangeViewDownWithExchangeCoinView:self];
        }
    }
    else
    {
        if (_rat > 0)
        {
            if (_exchangeType == 1)
            {
                [self exchangeCoin];
            }
            else if (_exchangeType == 2)
            {
                [self converDiamondsRequest];
            }
            
            [self backToBefore];
            if (_delegate && [_delegate respondsToSelector:@selector(exchangeViewDownWithExchangeCoinView:)])
            {
                [_delegate exchangeViewDownWithExchangeCoinView:self];
            }
        }
    }
    
}

- (void)backToBefore
{
    if (_exchangeType == 1)
    {
        _coinLabel.text = @"0游戏币";
    }
    else if (_exchangeType == 2)
    {
        _coinLabel.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
    }
    
    [self.confirmButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
}

- (IBAction)cancelButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeViewDownWithExchangeCoinView:)])
    {
        [_delegate exchangeViewDownWithExchangeCoinView:self];
    }
    [self backToBefore];
}

@end
