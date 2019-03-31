//
//  GainsAccountBindVC.m
//  FanweApp
//
//  Created by hym on 2016/11/28.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GainsAccountBindVC.h"
#import "GainsWithdrawVC.h"
@interface GainsAccountBindVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfPayName;
@property (weak, nonatomic) IBOutlet UITextField *tfPayAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnAffirm;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@end

@implementation GainsAccountBindVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"账号绑定";
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
    //
    self.view.backgroundColor = kBackGroundColor;
    
    _httpManager = [NetHttpsManager manager];
}

- (void)backToVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (IBAction)onClick:(id)sender {
    
    if ([_tfPayName.text length] == 0) {
        
        [FanweMessage alert:@"请输入支付宝名称"];
        return;
    }
    
    if ([_tfPayAccount.text length] == 0) {
        
        [FanweMessage alert:@"请输入支付宝账号"];
        return;
    }
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"binding_alipay" forKey:@"act"];
    [parmDict setObject:_tfPayName.text forKey:@"alipay_name"];
    [parmDict setObject:_tfPayAccount.text forKey:@"alipay_account"];
    
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson){
        
         if ([responseJson toInt:@"status"] ==1)
         {
             GainsWithdrawVC *vc = [[GainsWithdrawVC alloc] initWithNibName:@"GainsWithdrawVC" bundle:nil];
             [[AppDelegate sharedAppDelegate] pushViewController:vc];
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

@end
