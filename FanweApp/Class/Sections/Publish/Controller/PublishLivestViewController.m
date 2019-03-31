//
//  PublishLivestViewController.m
//  FanweApp
//
//  Created by xgh on 2017/8/25.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <objc/runtime.h>
#import "PublishLivestViewController.h"
#import "PublishLiveShareView.h"
#import "PublishLiveViewModel.h"

@interface PublishLivestViewController ()<publishViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,OssUploadImageDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) FWOssManager                *ossManager;
@property (nonatomic, strong)NSString                     *timeString;//时间戳的字符串
@property (nonatomic, strong)NSString                     *uploadFilePath;
@property (nonatomic, strong)NSString                     *imageString;
@property (nonatomic, strong)PublishLiveShareView         *shareView;
@property (nonatomic, strong)VideoClassifiedModel         *videoClassmodel;

@end

@implementation PublishLivestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden =YES;
}

- (void)initFWUI
{
    [super initFWUI];
    self.liveView = [[PublishLiveView alloc]initWithFrame:self.view.bounds];
    self.liveView.delegate = self;
    [self.view addSubview:self.liveView];
    self.shareView = [[PublishLiveShareView alloc]initWithFrame:CGRectMake(0, self.view.height - 190, self.view.width, 50)];
    self.liveView.shareView = self.shareView;
    [self.liveView addSubview:self.shareView];
}

- (void)initFWData
{
    [super initFWData];
}

- (void)initFWVariables
{
    [super initFWVariables];
    if (self.fanweApp.appModel.open_sts == 1)
    {
        _ossManager = [[FWOssManager alloc]initWithDelegate:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.fanweApp.liveState.isInPubViewController = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.fanweApp.liveState.isInPubViewController = NO;
}

#pragma mark ----------- publishViewDelegate---------

- (void)closeThestartLiveViewDelegate
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectedTheImageDelegate
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

- (void)selectedTheClassifyDelegate
{
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"选择分类" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:alterVC.title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:kAppMainColor range:NSMakeRange(0, alertControllerStr.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, alertControllerStr.length)];
    Ivar m_currentTitleColor = NULL;
    unsigned int count = 0;
    Ivar *members = class_copyIvarList([UIAlertController class], &count);
    for (int i = 0 ; i < count; i++)
    {
        Ivar var = members[i];
        const char *memberName = ivar_getName(var);
        if (strcmp(memberName, "attributedTitle") == 0)
        {
            m_currentTitleColor = var;
        }
        object_setIvar(alterVC, m_currentTitleColor, alertControllerStr);
    }
    
    for (int i = 0; i < self.fanweApp.appModel.video_classified.count; i++)
    {
        VideoClassifiedModel * model = self.fanweApp.appModel.video_classified[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:model.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.liveView.topView.classifyBtn setTitle:model.title forState:UIControlStateNormal];
            self.videoClassmodel = model;
        }];
        
        Ivar m_currentColor = NULL;
        unsigned int num = 0;
        Ivar *actions = class_copyIvarList([UIAlertAction class], &num);
        for (int i = 0 ; i < num; i++)
        {
            Ivar var = actions[i];
            const char *memberName = ivar_getName(var);
            if (strcmp(memberName, "_titleTextColor") == 0)
            {
                m_currentColor = var;
            }
            object_setIvar(action, m_currentColor, kAppMainColor);
        }
        [alterVC addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消 " style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alterVC addAction:action];
    
    [self presentViewController:alterVC animated:YES completion:nil];
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (self.fanweApp.appModel.open_sts == 1)
        {
            if ([_ossManager isSetRightParameter])
            {
                [self saveImage:image withName:@"1.png"];
                _timeString = [_ossManager getObjectKeyString];
                [_ossManager asyncPutImage:_timeString localFilePath:_uploadFilePath];
            }
        }
        else
        {
            NSData *data=UIImageJPEGRepresentation(image, 1.0);
            [self saveImage:[UIImage imageWithData:data] withName:@"currentImage6.png"];
            
            [self performSelector:@selector(uploadAvatar) withObject:nil afterDelay:0.8];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIView animateWithDuration:0.1 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenH - self.tabBarController.tabBar.frame.size.height , kScreenW, self.tabBarController.tabBar.frame.size.height);
    } completion:^(BOOL finished) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }];
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
    if (stateCount == 0)
    {
        NSString *imgString= [NSString stringWithFormat:@"%@%@",_ossManager.oss_domain,_timeString];
        _imageString=[NSString stringWithFormat:@"./%@",_timeString];
        [self.liveView.selectedImageView sd_setImageWithURL:[NSURL URLWithString:imgString]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark 使用流文件上传头像
- (void)uploadAvatar
{
    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *photoName;
    photoName=[imageFile stringByAppendingPathComponent:@"currentImage6.png"];
    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",photoName]];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"avatar" forKey:@"ctl"];
    [parmDict setObject:@"uploadImage" forKey:@"act"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithDict:parmDict andFileUrl:fileUrl SuccessBlock:^(NSDictionary *responseJson){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            _imageString=[responseJson toString:@"path"];
            [self.liveView.selectedImageView sd_setImageWithURL:[NSURL URLWithString:[responseJson toString:@"server_full_path"]]];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
        
    }];
}
#pragma mark ---- 开始直播------
#pragma mark 点击事件

- (void)startThePublishLiveDelegate
{
    [self avAuthorizationCamera];
}

#pragma mark 相机权限
- (void)avAuthorizationCamera
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted)
                {
                    //第一次用户接受
                    [self avAuthorizationMic];
                }
                else
                {
                    //第一次用户接受
                    NSLog(@"第一次用户拒绝");
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            // 已经开启授权，可继续
            [self avAuthorizationMic];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            [self showAlertViewCAndMessageStr:@"请前往设置'隐私-麦克风'开启应用权限"];
            break;
        default:
            break;
    }
}

#pragma mark 麦克风权限
- (void)avAuthorizationMic
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                
                if (granted)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //第一次用户接受
                        [self showHostLiveBtn];
                    });
                }
                else
                {
                    //第一次用户接受
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            // 已经开启授权，可继续
            NSLog(@"已经开启授权，可继续");
            [self showHostLiveBtn];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            [self showAlertViewCAndMessageStr:@"请前往设置'隐私-麦克风'打开应用权限"];
            break;
        default:
            break;
    }
}

- (void)showAlertViewCAndMessageStr:(NSString *)messageStr
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击确认");
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 开始直播
- (void)showHostLiveBtn
{
    // 网络判断
    if (![FWUtils isNetConnected])
    {
        return;
    }
    
    [FWUtils closeKeyboard];
    
    if (!self.liveView.topView.pravicy)
    {
        if (!self.videoClassmodel)
        {
            if (self.fanweApp.appModel.is_classify == 1)
            {
                [[FWHUDHelper sharedInstance] tipMessage:@"请选择分类"];
                return;
            }
        }
    }
    
    self.liveView.startButton.userInteractionEnabled = NO;
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"add_video" forKey:@"act"];
    
    if (![FWUtils isBlankString:_imageString])
    {
        [mDict setObject:_imageString forKey:@"live_image"];
    }
    
    // 是否私密
    if (self.liveView.topView.pravicy)
    {
        [mDict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"is_private"];
    }
    else
    {
        [mDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"is_private"];
        [mDict setObject:self.shareView.shareStr forKey:@"share_type"];
    }
    // 房间标题
    if (self.liveView.textView.text.length > 0 && ![self.liveView.textView.text isEqualToString:@"给直播写个标题吧"])
    {
        [mDict setObject:self.liveView.textView.text forKey:@"title"];
    }
    
    // 地理位置
    if (self.liveView.topView.provinceSrting.length && self.liveView.topView.locationCityString.length && self.liveView.topView.isCanLocation)
    {
        [mDict setObject:self.liveView.topView.locationCityString forKey:@"city"];
        [mDict setObject:self.liveView.topView.provinceSrting forKey:@"province"];
    }
    else
    {
        [mDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"location_switch"];
    }
    
    if (self.videoClassmodel)
    {
        [mDict setObject:@(self.videoClassmodel.classified_id) forKey:@"video_classified"];
    }
    [self.liveView.startButton setTitle:@"正在努力配置直播..." forState:UIControlStateNormal];
    
    __weak UIButton *btn = self.liveView.startButton;
    
    [PublishLiveViewModel beginLive:mDict vc:self block:^(AppBlockModel *blockModel) {
        
        btn.userInteractionEnabled = YES;
        [btn setTitle:@"开始直播" forState:UIControlStateNormal];
        
    }];
}

#pragma mark API请求拿到直播类型，开始启动直播
- (void)closePublishViewCWith:(NSInteger )roomID
{
    __weak PublishLivestViewController *weak_Self = self;
    UIViewController *rootVC = weak_Self.presentingViewController;
    while (rootVC.presentingViewController)
    {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:^{
        //开启直播
        LIVE_CENTER_MANAGER.stSuspensionWindow.hidden = NO;//为了加载
        
        IMAHost *host = [IMAPlatform sharedInstance].host;
        if (!host)
        {
            [[FWIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
            return;
        }
        //配置信息
        TCShowUser *user = [[TCShowUser alloc] init];
        user.avatar = [host imUserIconUrl];
        user.uid = [host imUserId];
        user.username = [host imUserName];
        
        TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
        liveRoom.host = user;
        liveRoom.avRoomId = (int)roomID;
        liveRoom.title = [NSString stringWithFormat:@"%d",liveRoom.avRoomId];
        liveRoom.vagueImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict toString:@"head_image"];
        
        [LIVE_CENTER_MANAGER showLiveOfTCShowLiveListItem:liveRoom andLiveWindowType:liveWindowTypeOfSusOfFullSize andLiveType:FW_LIVE_TYPE_HOST andLiveSDKType:FW_LIVESDK_TYPE_KSY andCompleteBlock:^(BOOL finished) {
            
        }];
    }];
}

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
}

@end
