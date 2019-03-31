//
//  PrivateChatViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "PrivateChatViewController.h"
#import "sendMessageView.h"

#define NavigationHeight 64
#define buttonViewHeight 40

@interface PrivateChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
    sendMessageView *_messageView;
    UIView *_buttonView;//底部视图的View
    UITextField *_textFiled;
    UIImageView *_soundImgView;
    UIImageView *_expressionView;
    UIImageView *_addImgView;
    CGFloat _keyheight;
}
@end

@implementation PrivateChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-40)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    [self creatView];
    [self addChatToolBar];
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_myTableView addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textFiled resignFirstResponder];
    
    CGRect tabelViewRect = _myTableView.frame;
    tabelViewRect.origin.y = 0;
    _myTableView.frame = _myTableView.frame;
    
    CGRect buttonViewRect = _buttonView.frame;
    buttonViewRect.origin.y = kScreenH-NavigationHeight-buttonViewHeight;
    _buttonView.frame = buttonViewRect;
}

#pragma mark 键盘的显示和隐藏
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _keyheight = keyboardSize.height;
    
    CGRect tabelViewRect = _myTableView.frame;
    tabelViewRect.origin.y = -_keyheight;
    _myTableView.frame = _myTableView.frame;
    
    CGRect buttonViewRect = _buttonView.frame;
    buttonViewRect.origin.y = kScreenH-NavigationHeight-buttonViewHeight-_keyheight;
    _buttonView.frame = buttonViewRect;
}

//返回
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 加页面底部视图
- (void)addChatToolBar
{
    _buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-NavigationHeight-buttonViewHeight, kScreenW, buttonViewHeight)];
    _buttonView.backgroundColor = kBackGroundColor;
    [self.view addSubview:_buttonView];
    
    _soundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    _soundImgView.backgroundColor = [UIColor redColor];
    [_buttonView addSubview:_soundImgView];
    
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, kScreenW-125, 30)];
    _textFiled.layer.borderWidth = 1;
    _textFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textFiled.layer.cornerRadius = 3;
    [_buttonView addSubview:_textFiled];
    
    _expressionView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-80, 5, 30, 30)];
    _expressionView.backgroundColor = [UIColor redColor];
    [_buttonView addSubview:_expressionView];
    
    _addImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW- 40, 5, 30, 30)];
    _addImgView.backgroundColor = [UIColor redColor];
    [_buttonView addSubview:_addImgView];
    

}

- (void)creatView
{
   TIMConversation * conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:self.receiverId];
    [conversation getLocalMessage:10 last:nil succ:^(NSArray * msgList) {
        for (TIMMessage * msg in msgList) {
            if ([msg isKindOfClass:[TIMMessage class]])
            {
                NSLog(@"GetOneMessage:%@", msg);
            }
        }
    }fail:^(int code, NSString * err)
    {
        NSLog(@"Get Message Failed:%d->%@", code, err);
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count > 0)
    {
        return _dataArray.count;
    }else
    {
        return 0;
    }
}
//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   //MainLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainLiveTableViewCell"];
   static NSString *reusedID = @"reusedID";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
   if (cell == nil)
    {
        //如果找不到,就创建.并且打上复用id
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    }
   cell.textLabel.text = [NSString stringWithFormat:@"第%d行",(int)indexPath.row];
   return cell;
}








@end
