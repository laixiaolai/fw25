//
//  RecommendedPersonViewController.m
//  FanweApp
//
//  Created by 王珂 on 17/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RecommendedPersonViewController.h"

@interface RecommendedPersonViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NetHttpsManager *httpsManager;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * recommendPersonID;
@property (nonatomic, strong) UIButton * saveBtn;
@end

@implementation RecommendedPersonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"推荐人信息";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(returnToMeVc) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.dic = [NSMutableDictionary new];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    _titleLabel.textColor = kAppGrayColor1;
    _titleLabel.text = @"推荐人ID";
    [self.view addSubview:_titleLabel];
    _recommendPersonID = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, kScreenW-110, 30)];
    _recommendPersonID.keyboardType = UIKeyboardTypeNumberPad;
    _recommendPersonID.delegate = self;
    _recommendPersonID.textColor = kAppGrayColor1;
    _recommendPersonID.font = [UIFont systemFontOfSize:13];
    _recommendPersonID.borderStyle = UITextBorderStyleRoundedRect;
    _recommendPersonID.userInteractionEnabled = NO;
    [self.view addSubview:_recommendPersonID];
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(10, 150, kScreenW-20, 40);
    _saveBtn.backgroundColor = kAppMainColor;
    _saveBtn.layer.cornerRadius = 20;
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.hidden = YES;
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(postMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - 返回上一级
- (void)returnToMeVc{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_recommendPersonID resignFirstResponder];
    return YES;
}

- (void)postMessage
{
    [_recommendPersonID resignFirstResponder];
    if (_recommendPersonID.text.length)
    {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"user_center" forKey:@"ctl"];
        [mDict setObject:@"update_p_user_id" forKey:@"act"];
        [mDict setObject:_recommendPersonID.text forKey:@"p_user_id"];
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"] == 1)
            {
                _saveBtn.hidden = YES;
                _saveBtn.userInteractionEnabled = NO;
                _recommendPersonID.userInteractionEnabled = NO;
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)loadData
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user_center" forKey:@"ctl"];
    [mDict setObject:@"get_p_user_id" forKey:@"act"];
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            _saveBtn.hidden = [responseJson toInt:@"p_user_id"] > 0 ? YES : NO;
            _saveBtn.userInteractionEnabled = [responseJson toInt:@"p_user_id"] > 0 ? NO : YES;
            _recommendPersonID.userInteractionEnabled = [responseJson toInt:@"p_user_id"] > 0 ? NO : YES;
            if ([responseJson toInt:@"p_user_id"] > 0) {
                _recommendPersonID.text = [responseJson toString:@"p_user_id"];
            }
        }
    } FailureBlock:^(NSError *error) {
        
    }];
    
}

-(NetHttpsManager *)httpsManager
{
    if (_httpsManager == nil) {
        _httpsManager  = [NetHttpsManager manager];
    }
    return _httpsManager;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_recommendPersonID resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
