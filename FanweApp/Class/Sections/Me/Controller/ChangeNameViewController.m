//
//  ChangeNameViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ChangeNameViewController.h"

@interface ChangeNameViewController ()<UITextFieldDelegate>
{
    UITextField              *_textFiled;
    UILabel                  *_numLabel;
    UIButton                 *_rightButton;
    UILabel                  *_nickInfoLabel;

}
@end

@implementation ChangeNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 5.0f;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)initFWUI
{
    [super initFWUI];
    self.view.backgroundColor = kBackGroundColor;
    if ([self.viewType isEqualToString:@"1"])
    {
        self.title = @"编辑昵称";
    }else if ([self.viewType isEqualToString:@"2"])
    {
        self.title = @"编辑签名";
    }else if ([self.viewType isEqualToString:@"3"])
    {
        self.title = @"编辑职业";
    }
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-40, 5, 40, 30)];
    [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [_rightButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton addTarget:self action:@selector(saveEditButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 40)];
    whiteView.backgroundColor = kWhiteColor;
    [self.view addSubview:whiteView];
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kScreenW-20, 40)];
    _textFiled.clearsContextBeforeDrawing = YES;
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled.delegate = self;
    [_textFiled becomeFirstResponder];
    _textFiled.textColor = kAppGrayColor2;
    _textFiled.font = [UIFont systemFontOfSize:15];
    _textFiled.layer.cornerRadius = 3;
    [_textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textFiled.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:_textFiled];
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-80, 60, 60, 20)];
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.textColor = kAppGrayColor3;
    _numLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_numLabel];
    
    if ([self.viewType isEqualToString:@"2"])
    {
        _textFiled.placeholder = @"请输入小于33个文字";
        _numLabel.text = [NSString stringWithFormat:@"%d/32",(int)_textFiledName.length];
    }else
    {
        _textFiled.placeholder = @"请输入小于17个文字";
        _numLabel.text = [NSString stringWithFormat:@"%d/16",(int)_textFiledName.length];
    }
    
    if (self.textFiledName.length > 0)
    {
        _textFiled.text = self.textFiledName;
    }
    
    if ([self.viewType isEqualToString:@"1"] && self.nickInfo.length>0)
    {
        _nickInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, kScreenW-40, 20)];
        _nickInfoLabel.backgroundColor = kBackGroundColor;
        _nickInfoLabel.textAlignment = NSTextAlignmentRight;
        _nickInfoLabel.textColor = kAppGrayColor3;
        _nickInfoLabel.font = kAppSmallTextFont_1;
        _nickInfoLabel.text = self.nickInfo;
        [self.view addSubview:_nickInfoLabel];
    }
}

//限制字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger caninputlen;
    if ([self.viewType isEqualToString:@"2"])
    {
        caninputlen = 32 - comcatstr.length;
    }else
    {
        caninputlen = 16 - comcatstr.length;
    }
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = string.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [string substringWithRange:rg];
            
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
            if ([self.viewType isEqualToString:@"2"])
            {
                _numLabel.text = [NSString stringWithFormat:@"%d/32",(int)textField.text.length];
            }else
            {
                _numLabel.text = [NSString stringWithFormat:@"%d/16",(int)textField.text.length];
            }
            
        }
        return NO;
    }
}

// 监听改变按钮
- (void)textFieldDidChange:(UITextField*) sender
{
    if ([self.viewType isEqualToString:@"2"])
    {
        if (_textFiled.text.length > 32)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入小于33个文字"];
            NSString *s = [_textFiled.text substringToIndex:32];
            _textFiled.text = s;
            return;
        }
        _numLabel.text = [NSString stringWithFormat:@"%d/32",(int)_textFiled.text.length];
    }else
    {
        if (_textFiled.text.length > 16)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入小于17个文字"];
            NSString *s = [_textFiled.text substringToIndex:17];
            _textFiled.text = s;
            return;
        }
        _numLabel.text = [NSString stringWithFormat:@"%d/16",(int)_textFiled.text.length];
    }
}

- (void)backClick
{
    [_textFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES ];
}

//保存
- (void)saveEditButton
{
    [_textFiled resignFirstResponder];
    NSString *temp = [_textFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (temp.length < 1)
    {
        if ([self.viewType isEqualToString:@"1"])
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请编辑昵称"];
            
        }else if ([self.viewType isEqualToString:@"2"])
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请编辑签名"];
            
        }else if ([self.viewType isEqualToString:@"3"])
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请编辑职业"];
            
        }
        return;
    }
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(changeNameWithString:withType:)])
        {
            [self.delegate changeNameWithString:temp withType:self.viewType];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textFiled resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.viewType isEqualToString:@"2"])
    {
        _numLabel.text = [NSString stringWithFormat:@"%d/32",(int)_textFiled.text.length];
    }else
    {
        _numLabel.text = [NSString stringWithFormat:@"%d/16",(int)_textFiled.text.length];
    }
}


@end
