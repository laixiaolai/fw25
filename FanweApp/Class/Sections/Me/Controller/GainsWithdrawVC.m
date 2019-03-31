//
//  GainsWithdrawVC.m
//  FanweApp
//
//  Created by hym on 2016/11/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GainsWithdrawVC.h"
#import "IncomeViewController.h"
@interface GainsWithdrawVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbAllTickets;
@property (weak, nonatomic) IBOutlet UILabel *lbTodayTickets;
@property (weak, nonatomic) IBOutlet UITextField *tfWithdrawTickets;
@property (weak, nonatomic) IBOutlet UIButton *btnAffirm;
@property (weak, nonatomic) IBOutlet UILabel *lbRatioTickets;

@property (assign, nonatomic) CGFloat ratio;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (weak, nonatomic) IBOutlet UILabel *canGetLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UILabel *withdrawDepositLbl;
@end

@implementation GainsWithdrawVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self withdrawDeposit];
    
    self.title = @"提现";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                             itemWithTarget:self
                                             action:@selector(backToVC)
                                             image:@"com_arrow_vc_back"
                                             highImage:@"com_arrow_vc_back"];
    
    self.btnAffirm.layer.borderColor = kAppMainColor.CGColor;
    [self.btnAffirm setBackgroundColor:kAppMainColor];
    [self.btnAffirm setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
    self.btnAffirm.layer.borderWidth = 1.0f;
    self.btnAffirm.layer.cornerRadius = self.btnAffirm.frame.size.height/2.0f;
    self.btnAffirm.layer.masksToBounds = YES;
    self.tfWithdrawTickets.keyboardType = UIKeyboardTypeDecimalPad;
    self.view.backgroundColor = kBackGroundColor;
    self.lbRatioTickets.text = @"0";
    self.tfWithdrawTickets.delegate = self;
    [self.tfWithdrawTickets addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    //注意：事件类型是：`UIControlEventEditingChanged`
    _httpManager = [NetHttpsManager manager];
    [self reqData];
}

- (void)withdrawDeposit
{
    NSString *ticketName = [GlobalVariables sharedInstance].appModel.ticket_name;
    self.totalLbl.text = [NSString stringWithFormat:@"总%@数",ticketName];
    self.canGetLbl.text = [NSString stringWithFormat:@"今日可领%@数",ticketName];
    self.withdrawDepositLbl.text = [NSString stringWithFormat:@"%@提现",ticketName];
}

- (void)backToVC {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)reqData {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"money_carry_alipay" forKey:@"act"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] ==1) {
             _ratio = [responseJson toFloat:@"ratio"];
             _lbAllTickets.text = [NSString stringWithFormat:@"%d",([responseJson toInt:@"can_use_ticket"])];
             _lbTodayTickets.text = [responseJson toString:@"day_ticket_max"];
         }else {
             
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tfWithdrawTickets resignFirstResponder];
}

- (IBAction)onClick:(id)sender
{
    if ([_tfWithdrawTickets.text integerValue] == 0)
    {
        [FanweMessage alert:@"请输入要提现的印票数"];
        return;
    }
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"submit_refund_alipay" forKey:@"act"];
    [parmDict setObject:_tfWithdrawTickets.text forKey:@"ticket"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] ==1)
         {
             for (UIViewController *vc in self.navigationController.viewControllers)
             {
                 if ([vc isKindOfClass:[IncomeViewController class]])
                 {
                     [self.navigationController popToViewController:vc animated:YES];
                 }
                 [[FWHUDHelper sharedInstance] tipMessage:@"提现成功"];
             }
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

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
    
    if (res) {
        
    }
    
    return res;
}

- (void)passConTextChange:(id)sender{
    if ([self.tfWithdrawTickets.text length] == 0) {
        _lbRatioTickets.text = @"0元";
    }else {
       _lbRatioTickets.text = [NSString stringWithFormat:@"%0.2lf元",(self.ratio * [self.tfWithdrawTickets.text integerValue])];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
