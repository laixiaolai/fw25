//
//  EditFamilyViewController.m
//  FanweApp
//
//  Created by 王珂 on 16/9/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "EditFamilyViewController.h"
#import "AFNetworking.h"
#import "FWOssManager.h"

@interface EditFamilyViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate,UINavigationControllerDelegate,OssUploadImageDelegate>
{
    
    FWOssManager      *_ossManager;
    NSString          *_uploadFilePath;
    NSString          *_urlString;
    NSString          *_timeString;//时间戳的字符串
    
}
@property (nonatomic, strong) UIView * view1;
@property (nonatomic, strong) UIView * view2;
@property (nonatomic, strong) UIView * view3;
@property (nonatomic, strong) UIView * view4;
@property (nonatomic, strong) UIView * view5;
@property (nonatomic, strong) UIButton * headBtn;
@property (nonatomic, strong) UILabel * familyLabel;
@property (nonatomic, strong) UITextView * nameTextView;//家族名称
@property (nonatomic, strong) UITextView * desTextView;//家族宣言
@property (nonatomic, strong) UIButton   * editBtn;    //编辑按钮
@property (nonatomic, strong) UIButton   * managerBtn; //成员管理
@property (nonatomic, strong) UIButton   * ensureBtn;  //确认
@property (nonatomic, strong) NSMutableDictionary * dataDic;
@property (nonatomic, copy)  NSString * urlStr;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation EditFamilyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataDic = [NSMutableDictionary dictionary];
    _urlStr = @"";
    if (self.fanweApp.appModel.open_sts == 1)
    {
        _ossManager = [[FWOssManager alloc]initWithDelegate:self];
    }
    
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)createView
{
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"家族资料修改";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*375/1200)];
    _view1.backgroundColor = kFamilyBackGroundColor;
    [self.view addSubview:_view1];
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame), kScreenW, (kScreenH-64)*95/1200)];
    _view2.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:_view2];
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view2.frame), kScreenW, (kScreenH-64)*20/1200)];
    _view3.backgroundColor = kFamilyBackGroundColor;
    [self.view addSubview:_view3];
    _view4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view3.frame), kScreenW, (kScreenH-64)*310/1200)];
    _view4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view4];
    _view5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view4.frame), kScreenW, (kScreenH-64)*410/1200)];
    _view5.backgroundColor = kFamilyBackGroundColor;
    [self.view addSubview:_view5];
    _nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, CGRectGetHeight(_view2.frame))];
    //    _nameTextView.textAlignment = NSTextAlignmentCenter;
    //    _nameTextView.insertDictationResultPlaceholder = @""
    _nameTextView.delegate = self;
    //    _nameTextView.text =@"请输入家族名称";
    //    _nameTextView.textColor = [UIColor lightGrayColor];
    _nameTextView.font = [UIFont systemFontOfSize:15];
    //    _nameTextView.editable = NO;
    [_view2 addSubview:_nameTextView];
    _desTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, CGRectGetHeight(_view4.frame))];
    //    _desTextView.text = @"请输入家族宣言";
    //    _desTextView.textColor = [UIColor lightGrayColor];
    _desTextView.delegate = self;
    _desTextView.font = [UIFont systemFontOfSize:15];
    [_view4 addSubview:_desTextView];
    [self createBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    _uploadFilePath = fullPath;
    NSLog(@"uploadFilePath : %@", _uploadFilePath);
}

#pragma mark 代理回调
- (void)uploadImageWithUrlStr:(NSString *)imageUrlStr withUploadStateCount:(int)stateCount
{
    if (_HUD)
    {
        _HUD.hidden = YES;
    }
    if (stateCount == 0)
    {
        _urlStr = [NSString stringWithFormat:@"./%@",_timeString];
        NSLog(@"_urlString==%@",_urlStr);
    }
}

- (void)createBtn
{
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headBtn.frame = CGRectMake((kScreenW-90)/2, (CGRectGetHeight(_view1.frame)-117)/2, 90, 90);
    _headBtn.backgroundColor = [UIColor whiteColor];
    _headBtn.layer.cornerRadius = 45;
    _headBtn.layer.masksToBounds = YES;
    _headBtn.backgroundColor = [UIColor whiteColor];
    [_headBtn addTarget:self action:@selector(clickHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview:_headBtn];
    _familyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headBtn.frame)+10, kScreenW, 17)];
    _familyLabel.text = @"编辑家族头像";
    _familyLabel.textAlignment =  NSTextAlignmentCenter;
    _familyLabel.font = [UIFont systemFontOfSize:17];
    _familyLabel.textColor = kAppGrayColor2;
    [_view1 addSubview:_familyLabel];
    _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ensureBtn.frame = CGRectMake(25, 25, kScreenW-50, 40);
    _ensureBtn.backgroundColor = kAppMainColor;
    _ensureBtn.layer.cornerRadius = 20;
    _ensureBtn.layer.masksToBounds = YES;
    [_ensureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_ensureBtn addTarget:self action:@selector(ensureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_view5 addSubview:_ensureBtn];
    [self createDes];
}

- (void)createDes
{
    //如果是创建家族
    if (_type==0) {
        [_headBtn setBackgroundImage:[UIImage imageNamed:@"me_addPhoto"] forState:UIControlStateNormal];
        _nameTextView.text =@"请输入家族名称";
        _nameTextView.textColor = [UIColor lightGrayColor];
        _desTextView.text = @"请输入家族宣言";
        _desTextView.textColor = [UIColor lightGrayColor];
    }
    //如果是重新编辑家族资料
    else if (_type==1)
    {
        //        [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.family_logo] forState:UIControlStateNormal];
        [_headBtn sd_setImageWithURL:[NSURL URLWithString:_model.family_logo] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
        _nameTextView.text = _model.family_name;
        //如果是未通过审核则可以编辑家族名称
        _nameTextView.editable = _canEditAll==1?YES:NO;
        _nameTextView.textAlignment = _canEditAll==1? NSTextAlignmentLeft:NSTextAlignmentCenter;
        //        _nameTextView.textAlignment = NSTextAlignmentCenter;
        _nameTextView.textColor = [UIColor blackColor];
        _desTextView.text = _model.family_manifesto;
        _desTextView.textColor = [UIColor blackColor];
    }
}


//确认按钮
- (void)ensureBtnAction
{
    if ([_nameTextView.text isEqualToString:@"请输入家族名称"]&&[_nameTextView.textColor isEqual:[UIColor lightGrayColor]]) {
        [[FWHUDHelper sharedInstance] tipMessage:@"请填写家族名称"];
        return;
    }
    if ([_desTextView.text isEqualToString:@"请输入家族宣言"]&&[_desTextView.textColor isEqual:[UIColor lightGrayColor]]) {
        [[FWHUDHelper sharedInstance] tipMessage:@"请填写家族宣言"];
        return;
    }
    //  _desTextView.insertDictationResultPlaceholder
    //如果是创建家族
    if (_type==0) {
        if (_urlStr.length<1) {
            [[FWHUDHelper sharedInstance] tipMessage:@"请编辑头像"];
            return;
        }
        
        if (_desTextView.text.length<1) {
            [[FWHUDHelper sharedInstance] tipMessage:@"请填写家族宣言"];
            return;
        }
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"family" forKey:@"ctl"];
        [mDict setObject:@"create" forKey:@"act"];
        [mDict setObject:_urlStr forKey:@"family_logo"];
        [mDict setObject:_nameTextView.text forKey:@"family_name"];
        [mDict setObject:_desTextView.text forKey:@"family_manifesto"];
        [[FWHUDHelper sharedInstance] syncLoading:@"正在创建家族请等待"];
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [[FWHUDHelper sharedInstance] syncStopLoading];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[FWHUDHelper sharedInstance] syncStopLoading];
            }
            
        } FailureBlock:^(NSError *error) {
            [[FWHUDHelper sharedInstance] syncStopLoading];
        }];
    }
    else if (_type==1) // 如果是修改家族资料
    {
        if (_canEditAll==1&&_nameTextView.text.length<1) {
            [[FWHUDHelper sharedInstance] tipMessage:@"请填写家族名称"];
            return;
        }
        
        if (_desTextView.text.length<1) {
            [[FWHUDHelper sharedInstance] tipMessage:@"请填写家族宣言"];
            return;
        }
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"family" forKey:@"ctl"];
        [mDict setObject:@"save" forKey:@"act"];
        [mDict setObject:_model.family_id forKey:@"family_id"];
        if(_urlStr!=nil)
        {
            [mDict setObject:_urlStr forKey:@"family_logo"];
        }
        else
        {
            [mDict setObject:@"" forKey:@"family_logo"];
        }
        if (_nameTextView.text!= nil) {
            [mDict setObject:_nameTextView.text forKey:@"family_name"];
        }
        if (_desTextView.text!= nil) {
            [mDict setObject:_desTextView.text forKey:@"family_manifesto"];
        }
        [[FWHUDHelper sharedInstance] syncLoading:@"正在上传修改请等待"];
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [[FWHUDHelper sharedInstance] syncStopLoading];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[FWHUDHelper sharedInstance] syncStopLoading];
            }
            
        } FailureBlock:^(NSError *error) {
            [[FWHUDHelper sharedInstance] syncStopLoading];
        }];
    }
}

//编辑家族头像
- (void)clickHeadImage
{
    UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [headImgSheet addButtonWithTitle:@"相机"];
    [headImgSheet addButtonWithTitle:@"从手机相册选择"];
    [headImgSheet addButtonWithTitle:@"取消"];
    headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
    headImgSheet.delegate = self;
    [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalTransitionStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex == 1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.headBtn setImage:image forState:UIControlStateNormal];
    if (self.fanweApp.appModel.open_sts == 1)
    {
        if ([_ossManager isSetRightParameter])
        {
            [self saveImage:image withName:@"1.png"];
            _timeString= [_ossManager getObjectKeyString];
            [_ossManager asyncPutImage:_timeString localFilePath:_uploadFilePath];
        }
        
    }else
    {
        NSString *nameImage = [NSString stringWithFormat:@"familyHeadImage.jpg"];
        [self saveImage:image withName:nameImage];
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:nameImage];
        NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",fullPath]];
        [self pictureToNet:fileUrl];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)pictureToNet:(NSURL *)pictureUrl
{
    [[FWHUDHelper sharedInstance] syncLoading:nil];
    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString * photoName=[imageFile stringByAppendingPathComponent:@"familyHeadImage.jpg"];
    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",photoName]];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"avatar" forKey:@"ctl"];
    [parmDict setObject:@"uploadImage" forKey:@"act"];
    [parmDict setObject:self.user_id forKey:@"id"];
    
    [self.httpsManager POSTWithDict:parmDict andFileUrl:fileUrl SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             NSString *nameImage = [NSString stringWithFormat:@"familyHeadImage.jpg"];;
             NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:nameImage];
             UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
             [_headBtn setImage:savedImage forState:UIControlStateNormal];
             _urlStr = [responseJson toString:@"path"];
             [[FWHUDHelper sharedInstance] syncStopLoading];
         }
     } FailureBlock:^(NSError *error)
     {
         [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
         [[FWHUDHelper sharedInstance] syncStopLoading];
     }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//点击返回按钮
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView==_nameTextView) {
        if ([_nameTextView.text isEqualToString:@"请输入家族名称"]&&[_nameTextView.textColor isEqual:[UIColor lightGrayColor]]) {
            _nameTextView.text = @"";
            _nameTextView.textColor = [UIColor blackColor];
        }
        _nameTextView.textAlignment = NSTextAlignmentLeft;
    }
    else if (textView== _desTextView)
    {
        if ([_desTextView.text isEqualToString:@"请输入家族宣言"]&&[_desTextView.textColor isEqual:[UIColor lightGrayColor]]) {
            _desTextView.text = @"";
            _desTextView.textColor= [UIColor blackColor];
            
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    if (textView==_nameTextView) {
        if (_nameTextView.text.length<1) {
            _nameTextView.text =@"请输入家族名称";
            _nameTextView.textColor = [UIColor lightGrayColor];
            [[FWHUDHelper sharedInstance] tipMessage:@"请填写家族名称"];
            _ensureBtn.enabled = NO;
            _ensureBtn.backgroundColor = kAppGrayColor3;
        }
        else
        {
            _ensureBtn.enabled = YES;
            _ensureBtn.backgroundColor = kAppMainColor;
        }
    }
    else if (textView==_desTextView)
    {
        if (_desTextView.text.length<1) {
            _desTextView.text = @"请输入家族宣言";
            _desTextView.textColor = [UIColor lightGrayColor];
            [[FWHUDHelper sharedInstance] tipMessage:@"请填写家族宣言"];
            _ensureBtn.enabled = NO;
            _ensureBtn.backgroundColor = kAppGrayColor3;
        }
        else
        {
            _ensureBtn.enabled = YES;
            _ensureBtn.backgroundColor = kAppMainColor;
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;  //donot display the menu
    [_desTextView resignFirstResponder];                     //do not allow the user to selected anything
    [_nameTextView resignFirstResponder];
    return NO;
    
}




@end
