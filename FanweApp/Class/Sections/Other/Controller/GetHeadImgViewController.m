//
//  GetHeadImgViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GetHeadImgViewController.h"
#import "AFNetworking.h"
#import "FWOssManager.h"

#define kImgFrameDec 50
#define kImgSize 8000 //头像大小

@interface GetHeadImgViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,MBProgressHUDDelegate,OssUploadImageDelegate>

{
    CGFloat             _headImgWH;
    NSData              *_headImgData;
    CGSize              _size;
    FWOssManager        *_ossManager;
    NSString            *_uploadFilePath;
    NSString            *_urlString;
    NSString            *_timeString;//时间戳的字符串
    
}

@end

@implementation GetHeadImgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initFWUI
{
    [super initFWUI];
    _urlString = @"";
    if (self.fanweApp.appModel.open_sts == 1)
    {
        _ossManager = [[FWOssManager alloc]initWithDelegate:self];
    }
    _headImgWH = 600;
    self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kScreenW)];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.headImgString] placeholderImage:kDefaultPreloadHeadImg];
    self.headImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.headImgView.userInteractionEnabled = YES;
    [self.view addSubview:self.headImgView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 50, 50);
    [backBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
    backBtn.layer.cornerRadius = 25;
    backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [backBtn addTarget:self action:@selector(comeBack) forControlEvents:UIControlEventTouchUpInside];
    [self.headImgView addSubview:backBtn];
    
    self.photoButton.layer.cornerRadius = self.photoButton.frame.size.height/2;
    self.photoButton.backgroundColor = kAppMainColor;
    self.phoneChoseButton.layer.cornerRadius = self.phoneChoseButton.frame.size.height/2;
    self.phoneChoseButton.backgroundColor = kAppMainColor;
    
    [self.deleButton setTitleColor:kAppMainColor forState:0];
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
    [self hideMyHud];
    if (stateCount == 0)
    {
        _urlString = [NSString stringWithFormat:@"./%@",_timeString];
        [self updateHeadImage];
    }else
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"oss上传头像失败"];
    }
}

- (IBAction)buttonClick:(UIButton *)sender
{
    int tag = (int) sender.tag;
    switch (tag)
    {
        case 0:
            [self getHeadImgViewTakePhone];
            break;
        case 1:
            [self getHeadImgViewFromLocal];
            break;
        case 2:
            [self comeBack];
            break;
            
        default:
            break;
    }
}

- (void)getHeadImgViewTakePhone
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)getHeadImgViewFromLocal
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)comeBack
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerEditedImage];
    if (mediaType)
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image)
        {
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        if(image)
        {
            [self.headImgView setImage:image];
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
            NSLog(@"image.size.height==%f,image.size.height==%f",image.size.height,image.size.height);
            NSData *data=UIImageJPEGRepresentation(image, 1);
            self.headImgView.image = [UIImage imageWithData:data];
            
            [self saveImage:self.headImgView.image withName:@"image_head.jpg"];
            [self performSelector:@selector(uploadAvatar) withObject:nil afterDelay:0.8];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)getHeadNet
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"do_update" forKey:@"act"];
    [parmDict setObject:self.userId forKey:@"id"];
    if (self.fanweApp.appModel.open_sts)
    {
        if (_urlString.length < 1 && [_urlString isEqualToString:@""])
        {
            [parmDict setObject:@"" forKey:@"oss_path"];
        }else
        {
            [parmDict setObject:_urlString forKey:@"oss_path"];
        }
    }
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             [[FWHUDHelper sharedInstance] tipMessage:@"头像更换成功"];
         }
     }FailureBlock:^(NSError *error)
     {
         
     }];
}

- (void)imageDidCut:(UIImage *)image
{
    NSData *data=UIImageJPEGRepresentation(image, 0.00001);
    self.headImgView.image = [UIImage imageWithData:data];
    [self performSelector:@selector(uploadAvatar) withObject:nil afterDelay:0.8];
}

- (void)cyclicCompression:(UIImage *)image
{
    _headImgWH -= kImgFrameDec;
    CGSize imagesize = image.size;
    imagesize.height = _headImgWH;
    imagesize.width = _headImgWH;
    UIImage *theImage = [self imageWithImageSimple:image scaledToSize:imagesize];
    _headImgData = UIImageJPEGRepresentation(theImage,0.00001);
}

//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 使用流文件上传头像
- (void)uploadAvatar
{
    [self showMyHud];
    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *photoName=[imageFile stringByAppendingPathComponent:@"image_head.jpg"];
    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",photoName]];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"avatar" forKey:@"ctl"];
    [parmDict setObject:@"uploadImage" forKey:@"act"];
    if (self.userId)
    {
        [parmDict setObject:self.userId forKey:@"id"];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithDict:parmDict andFileUrl:fileUrl SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             _urlString = [responseJson toString:@"path"];
             [self hideMyHud];
             [self updateHeadImage];
         }else
         {
             [FWHUDHelper alert:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error)
     {
         [self hideMyHud];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)updateHeadImage
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"do_update" forKey:@"act"];
    [parmDict setObject:self.userId forKey:@"id"];
    if (_urlString.length < 1 && [_urlString isEqualToString:@""])
    {
        [parmDict setObject:@"" forKey:@"normal_head_path"];
    }else
    {
        [parmDict setObject:_urlString forKey:@"normal_head_path"];
    }
    [parmDict setObject:@"1" forKey:@"type"];
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         [self hideMyHud];
     } FailureBlock:^(NSError *error)
     {
         [self hideMyHud];
     }];
}

@end
