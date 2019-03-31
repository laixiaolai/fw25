//
//  LPhoneRegistVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/6/15.
//  Copyright © 2017年 xfg. All rights reserved.

#import "LPhoneRegistVC.h"
#import "FWOssManager.h"


@interface LPhoneRegistVC ()<UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,OssUploadImageDelegate>

@property (nonatomic, strong) FWOssManager            *ossManager;              //oss 类
@property (nonatomic, assign) int                     sexNum;                   //1-男，2-女
@property (nonatomic, copy) NSString                  *timeString;              //时间戳的字符串
@property (nonatomic, copy) NSString                  *uploadFilePath;          //
@property (nonatomic, copy) NSString                  *urlString;               //

@end

@implementation LPhoneRegistVC

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
    
    if (self.fanweApp.appModel.open_sts == 1)
    {
        _ossManager = [[FWOssManager alloc]initWithDelegate:self];
    }
    _urlString      = @"";
    self.sexNum     = 1;
    self.view.backgroundColor = kBackGroundColor;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.navigationItem.title = @"手机注册";
    self.headImgView.layer.cornerRadius  = 30;
    self.headImgView.layer.masksToBounds = YES;
    self.nameFiled.delegate = self;
    self.headLabel.textColor = kAppGrayColor3;
    self.textLabel.textColor = kAppGrayColor3;
    self.sexLabel.textColor  = kAppGrayColor3;
    self.nextBtn.layer.cornerRadius  = 20;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.backgroundColor     = kAppMainColor;
//    [self.nameFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if ([[_userInfoDic allKeys] containsObject:@"head_image"] && [_userInfoDic toString:@"head_image"].length>0)
    {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[_userInfoDic toString:@"head_image"]] placeholderImage:kDefaultPreloadHeadImg];
    }
    if (self.userName.length>0)
    {
        self.nameFiled.text = self.userName;
        self.textLabel.text = [NSString stringWithFormat:@"%d/16",(int)self.nameFiled.text.length];
    }
}

- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClick:(UIButton *)sender
{
    [self.nameFiled resignFirstResponder];
    switch (sender.tag) {
        case 0: //点击头像
        {
            UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [headImgSheet addButtonWithTitle:@"相机"];
            [headImgSheet addButtonWithTitle:@"从手机相册选择"];
            [headImgSheet addButtonWithTitle:@"取消"];
            headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
            headImgSheet.delegate = self;
            [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
            break;
        case 1: //选择男性
        {
            _sexNum = 1;
            [_rightSexBtn setImage:[UIImage imageNamed:@"com_female_normal"] forState:UIControlStateNormal];
            [_leftSexBtn setImage:[UIImage imageNamed:@"com_male_selected"] forState:UIControlStateNormal];
        }
            break;
        case 2://选择女性
        {
            _sexNum = 2;
            [_leftSexBtn setImage:[UIImage imageNamed:@"com_male_normal"] forState:UIControlStateNormal];
            [_rightSexBtn setImage:[UIImage imageNamed:@"com_female_selected"] forState:UIControlStateNormal];
        }
            break;
        case 3://下一步
        {
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"login" forKey:@"ctl"];
            [parmDict setObject:@"do_update" forKey:@"act"];
            [parmDict setObject:self.used_id forKey:@"id"];
            if (self.fanweApp.appModel.open_sts == 1)
            {
                if (_urlString.length < 1)
                {
                    if ([[_userInfoDic allKeys] containsObject:@"head_image"] && [_userInfoDic toString:@"head_image"].length>0)
                    {
                        [parmDict setObject:_userInfoDic[@"head_image"] forKey:@"head_image"];
                    }
                    else
                    {
                        [parmDict setObject:@"" forKey:@"head_image"];
                    }
                }
                else
                {
                    [parmDict setObject:_urlString forKey:@"head_image"];
                }
            }
            else
            {
                if (_urlString.length < 1 && [_urlString isEqualToString:@""] )
                {
                    [parmDict setObject:@"" forKey:@"head_image"];
                }
                else
                {
                    [parmDict setObject:_urlString forKey:@"head_image"];
                }
            }
            
            if (self.nameFiled.text.length < 1)
            {
                [FanweMessage alert:@"请输入你的昵称"];
                return;
            }
            [parmDict setObject:self.nameFiled.text forKey:@"nick_name"];
            [parmDict setObject:[NSString stringWithFormat:@"%d",_sexNum] forKey:@"sex"];
            [self showMyHud];
            FWWeakify(self)
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
             {
                 FWStrongify(self)
                 if ([responseJson toInt:@"status"] == 1)
                 {
                     [FWIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
                     
                     [[FWIMLoginManager sharedInstance] getUserSig:^{
                         
                         [[AppDelegate sharedAppDelegate] enterMainUI];
                         [self hideMyHud];
                     } failed:^(int errId, NSString *errMsg) {
                         [self hideMyHud];
                     }];
                 }else
                 {
                     [self hideMyHud];
                     [FanweMessage alertHUD:[responseJson toString:@"error"]];
                 }
             } FailureBlock:^(NSError *error)
             {
                 FWStrongify(self)
                 [self hideMyHud];
             }];
        }
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameFiled resignFirstResponder];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (mediaType){
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image)
        {
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        if(image){
            [_headImgView setImage:image];
        }
        
        if (self.fanweApp.appModel.open_sts == 1)
        {
            if ([_ossManager isSetRightParameter])
            {
                [self saveImage:image withName:@"1.png"];
                [self showMyHud];
                _timeString = [_ossManager getObjectKeyString];
                [_ossManager asyncPutImage:_timeString localFilePath:_uploadFilePath];
            }
            
        }else
        {
            NSData *data=UIImageJPEGRepresentation(image, 1);
            _headImgView.image = [UIImage imageWithData:data];
            
            [self saveImage:_headImgView.image WithName:@"image_head3.jpg"];
            [self performSelector:@selector(uploadAvatar) withObject:nil afterDelay:0.8];
        }
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 代理回调
- (void)uploadImageWithUrlStr:(NSString *)imageUrlStr withUploadStateCount:(int)stateCount
{
    [self hideMyHud];
    if (stateCount == 0)
    {
        _urlString = [NSString stringWithFormat:@"./%@",_timeString];
    }
    else
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"上传头像失败"];
    }
}
#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    _uploadFilePath = fullPath;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (void)uploadAvatar
{
    [self showMyHud];
    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *photoName=[imageFile stringByAppendingPathComponent:@"image_head3.jpg"];
    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",photoName]];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"avatar" forKey:@"ctl"];
    [parmDict setObject:@"uploadImage" forKey:@"act"];
    [parmDict setObject:self.used_id forKey:@"id"];
    FWWeakify(self)
    [self.httpsManager POSTWithDict:parmDict andFileUrl:fileUrl SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             _urlString = [responseJson toString:@"path"];
         }
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//限制字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger caninputlen;
    caninputlen = 16 - comcatstr.length;
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
        }
        
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  self.textLabel.text = [NSString stringWithFormat:@"%d/16",(int)textField.text.length];
}





@end
