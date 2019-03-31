//
//  ConverDiamondsViewController.m
//  FanweApp
//
//  Created by yy on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ConverDiamondsViewController.h"
#import "MBProgressHUD.h"
#import "FreshAcountModel.h"
@interface ConverDiamondsViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>

@end

@implementation ConverDiamondsViewController
{
    NSString *ratio;//兑换比例
    int rat;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [IQKeyboardManager sharedManager].enable = NO;
    //    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [_leftTextfield becomeFirstResponder];
    
    if (_whetherGame)
    {
        FWWeakify(self)
        [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
            
            FWStrongify(self)
            
            long currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
            self.tickte = [NSString stringWithFormat:@"%ld",currentDiamonds];
            self.acountLabel.text =[NSString stringWithFormat:@"账户:%@%@",self.tickte,self.fanweApp.appModel.diamond_name];
            
        }];
        [self obtainCoinProportion];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [IQKeyboardManager sharedManager].enable = YES;
    //    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.view.backgroundColor = kGrayTransparentColor4;
    _backView.layer.cornerRadius =5;
    
    _diamondsLabel.textColor = kAppGrayColor1;
    if (_whetherGame)
    {
        ratio = @"1";       //兑换比例
        _diamondsLabel.text = @"兑换游戏币";
        _rightTextField.text =@"0游戏币";
        _leftTextfield.placeholder =[NSString stringWithFormat:@"请输入%@金额",self.fanweApp.appModel.diamond_name];
    }
    else
    {
        _diamondsLabel.text = [NSString stringWithFormat:@"兑换%@",self.fanweApp.appModel.diamond_name];
        _rightTextField.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
        _acountLabel.text =[NSString stringWithFormat:@"账户:%@%@",_tickte,self.fanweApp.appModel.ticket_name];
        _leftTextfield.placeholder =[NSString stringWithFormat:@"请输入兑换的%@金额",self.fanweApp.appModel.ticket_name];
        [self requetRatio];
    }
    
    _acountLabel.textColor =kAppGrayColor3;
    _textFieldView.layer.cornerRadius =15;
    _textFieldView.backgroundColor = kGrayTransparentColor1;
    [_cancelButton addTarget:self action:@selector(cancelButtonActon) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    _rightTextField.delegate =self;
    _leftTextfield.delegate =self;
    //设置键盘
    _leftTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _rightTextField.textColor = kAppGrayColor1;
    _rightTextField.tag =300;
    if ([_rightTextField.text isEqualToString:@""]) {
        if (_whetherGame)
        {
            _rightTextField.text =@"0游戏币";
        }
        else
        {
            _rightTextField.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
        }
    }
    //兑换比例
    _exchangeRate_Lab.textColor = kAppGrayColor3;
    
    
}
#pragma marlk textfieldDelegate代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag ==300) {
        return NO;
    }
    else{
        return YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
    [self.view layoutIfNeeded];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    _backView.centerY =_backView.frame.origin.y+200;
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //    if ([_rightTextField.text intValue]>0) {
    //
    //
    //    }
    if (toBeString.length > 6 && range.length!=1){
        textField.text = [toBeString substringToIndex:6];
        return NO;
        
    }
    rat =[toBeString intValue] *[ratio floatValue];
    if (toBeString.floatValue >0) {
        [_converButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [_converButton addTarget:self action:@selector(converButtonActon) forControlEvents:UIControlEventTouchUpInside];
    }
    if (toBeString.floatValue ==0) {
        [_converButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    }
    if (_whetherGame) {
        _rightTextField.text= [NSString stringWithFormat:@"%d游戏币",rat];
    }
    else
    {
        _rightTextField.text= [NSString stringWithFormat:@"%d%@",rat,self.fanweApp.appModel.diamond_name];
    }
    
    NSLog(@"++++++++++++++++++++++++%d", rat);
    return [self validateNumber:string];
}
//- (BOOL)textFieldShouldClear:(UITextField *)textField;
//{
//    [_converButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
//
//    return YES;
//}
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

//取消
- (void)cancelButtonActon
{   //
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//兑换
- (void)converButtonActon
{
    //当输入金额 不足兑换 1钻石
    if(ratio.floatValue !=0){
        if (_rightTextField.text.floatValue == 0&&_leftTextfield.text.floatValue<1/ratio.floatValue) {
            [FanweMessage alert:@"请输入足够的兑换金额"];
            return;
        }
    }
    //当输入金额 大于账户
    if(_leftTextfield.text.floatValue > _tickte.floatValue)
    {
        [FanweMessage alert:@"兑换金额不得大于账户余额"];
        return;
    }
    if (rat >0)
    {
        [self showMyHud];
        if (_whetherGame)
        {
            [self exchangeCoin];
        }
        else
        {
            [self converDiamondsRequest];
        }
    }
}
#pragma marlk 砖石兑换
- (void)converDiamondsRequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"do_exchange" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",_leftTextfield.text] forKey:@"ticket"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"]==1)
         {
             if ([_rightTextField.text intValue])
             {
                 [self dismissViewControllerAnimated:YES completion:^{
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAcount" object:nil];
                 }];
             }
             else
             {
                 [FanweMessage alert:@"兑换失败"];
             }
         }
         
     } FailureBlock:^(NSError *error){
          FWStrongify(self)
         [self hideMyHud];
     }];
}

#pragma mark    钻石兑换游戏币
- (void)exchangeCoin
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"exchangeCoin" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",_leftTextfield.text] forKey:@"diamonds"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"]==1)
         {
             if ([_rightTextField.text intValue]>0)
             {
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCoin" object:nil];
                 [_leftTextfield resignFirstResponder];
                 [self dismissViewControllerAnimated:YES completion:^{
                     
                 }];
                 [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"兑换失败"];
             }
             
         }
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
         [FanweMessage alert:@"兑换失败"];
     }];
}

#pragma mark    获取游戏币兑换比例
- (void)obtainCoinProportion
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"exchangeRate" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] ==1)
         {
             ratio = [responseJson objectForKey:@"exchange_rate"];
             //兑换比例
             if (ratio != nil&& ![ratio isEqual:[NSNull null]]) {
                 self.exchangeRate_Lab.text = [NSString stringWithFormat:@"兑换比例: %@",ratio];
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
    
}

#pragma marlk 获得兑换比例
- (void)requetRatio
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"exchange" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if (responseJson)
         {
             if ([responseJson toInt:@"status"] ==1)
             {
                 FreshAcountModel *model3 =[[FreshAcountModel alloc]init];
                 model3 =[FreshAcountModel mj_objectWithKeyValues:responseJson];
                 
                 ratio =model3.ratio;
                 //兑换比例
                 if (ratio != nil&& ![ratio isEqual:[NSNull null]]) {
                     self.exchangeRate_Lab.text = [NSString stringWithFormat:@"兑换比例: %@",ratio];
                 }
             }
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_leftTextfield resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
