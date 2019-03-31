//
//  AgreementViewController.m
//  FanweApp
//
//  Created by yy on 16/7/8.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AgreementViewController.h"
#import "PublishLivestViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"主播协议";
    UIColor *color = kAppGrayColor2;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    self.navigationItem.rightBarButtonItem = item;
    item.tintColor = kAppGrayColor2;
    
    UIButton *agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW *0.156, kScreenH-kNavigationBarHeight-kStatusBarHeight-60, kScreenW *0.6875, 40)];
    [agreeButton setTintColor:kAppMainColor];
    [agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [agreeButton setTitle:@"已阅读并同意" forState:UIControlStateNormal];
    [agreeButton setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [agreeButton.layer setBorderWidth:1];
    [agreeButton.layer setBorderColor:[kAppMainColor CGColor]];
    agreeButton.layer.masksToBounds = YES;
    agreeButton.layer.cornerRadius = 20;
    [self.view addSubview:agreeButton];
}

- (void)initFWUI
{
    [super initFWUI];
    
    self.webView.frame = CGRectMake(0, 0, kScreenW, kScreenH-kNavigationBarHeight-kStatusBarHeight-80);
    [self.webView.scrollView setShowsVerticalScrollIndicator:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)agreeButtonAction:(UIButton *)sender
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"agree" forKey:@"act"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]==1)
         {
             IMALoginParam *loginParam = [IMALoginParam loadFromLocal];
             loginParam.isAgree = 1;
             [loginParam saveToLocal];
             
             PublishLivestViewController *pushVC = [[PublishLivestViewController alloc] init];
            
             [self presentViewController:pushVC animated:YES completion:nil];
         }
         
     } FailureBlock:^(NSError *error){
     }];
}

@end
