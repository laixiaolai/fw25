//
//  STImgePickerViewC.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.

#import "STImgePickerViewC.h"
#import "UIImage+STCommon.h"
@interface STImgePickerViewC ()

@end

@implementation STImgePickerViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark ------------------------- System
-(void)showSystemImgPickerC
{
    UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
    imgPickerCtrl.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES)
    {
        imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //弹出模态
        [self presentViewController:imgPickerCtrl
                           animated:YES
                         completion:^{
                             
                         }];
        
    }else{
        
        
        return;
    }
    
}
#pragma mark -  系统 -完成照片选择回调（子重写）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info:%@",info);
    
}
#pragma - 系统imgPickerC -图片保存成功 回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"图片不写本地吧");
}
#pragma - 系统imgPickerC - 取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
}
#pragma *********************** Public 公有方法区域 *************************
#pragma mark ----- 设置IPC类型
// 启动IPC
-(void)showSystemIPC:(BOOL)isSystemIPC andMaxSelectNum:(int)maxSelectNum
{
    if (maxSelectNum == 0)
    {
        return;
    }
    // 系统
    if(isSystemIPC){
        UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
        //设置代理
        imgPickerCtrl.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
            
            imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            imgPickerCtrl.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            //弹出模态
            [self presentViewController:imgPickerCtrl animated:YES
                             completion:^{
                                 
                             }];
            
        }else{
            
            [[FWHUDHelper sharedInstance]tipMessage:@"设备不支持视频"];
            return;
        }
        
    }
    //第三方
    else{
        [self tzImagePickerController];
        self.tzImagePickerController.maxImagesCount = maxSelectNum;
        //写真动态 要求2-20 张。。。不再改变方法这样处理吧
        if(maxSelectNum == 20){
            self.tzImagePickerController.minImagesCount = 2;
        }
        //弹出模态
        [self presentViewController:self.tzImagePickerController
                           animated:YES
                         completion:^{
                             
                         }];
    }
    
}
#pragma mark -----IPC数据下发（子重写）
-(void)showSelectedMAray:(NSMutableArray *)selectedMArray
{
    
}

#pragma mark ---------- 发布（子重写）
//(为了统一，所有发布方法一致)
-(void)showPublishDynamic
{
    //Edit -1 价格
    
}
#pragma mark************************* Getter 方法区域 ****************************
#pragma mark-
-(TZImagePickerController *)tzImagePickerController
{
    if(!_tzImagePickerController)
    {
        //调用时候再决定最大选择数目
        _tzImagePickerController = [[TZImagePickerController alloc]
                                    initWithMaxImagesCount:9
                                    delegate:self];
        // 隐藏不可以选中的图片，默认是NO，不推荐将其设置为YES
        _tzImagePickerController.hideWhenCanNotSelect = YES;
        // 隐藏不可以选中的图片，默认是NO，不推荐将其设置为YES
        _tzImagePickerController.hideWhenCanNotSelect = YES;
        _tzImagePickerController.navigationBar.tintColor = kAppGrayColor1;
        _tzImagePickerController.naviBgColor = kAppGrayColor1;
        _tzImagePickerController.naviTitleColor = kAppGrayColor1;
        _tzImagePickerController.barItemTextColor = kAppGrayColor1;
    }
    return _tzImagePickerController;
}
#pragma mark************************* Delegate 协议方法区域 *************************
//第三方Photo选择-对应的代理方法
#pragma mark---------------- <TZImagePickerControllerDelegate>
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    //数据的下发留给 子类
    NSLog(@"phos --------%lu",(unsigned long)photos.count);
    self.photoMArray = photos.mutableCopy;//图文不需要这个，图文比较特殊，需要加+ 这个图 还能修改数组
    [self showSelectedMAray:photos.mutableCopy];
    [_tzImagePickerController removeFromParentViewController];
    _tzImagePickerController = nil;
}
- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
}
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    
}
// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset{
    
}
#pragma mark************************* Getter *********************
#pragma mark------------ 构建上传服务类
-(FWOssManager *)ossManager
{
    if (!_ossManager)
    {
        _ossManager = [[FWOssManager alloc]initWithDelegate:self];
    }
    return _ossManager;
}




#pragma mark************************* 地图类 (子类调用)*********************
-(void)showSTBMKViewC{
    
    STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
    FWWeakify(self)
    [stBMKCenter showAdressLatitudeLongitudeDataComplete:^(BOOL finished) {
        NSLog(@"-------%ld----",stBMKCenter.poiListMArray.count);
        FWStrongify(self)
        if (stBMKCenter.poiListMArray.count == 0)
        {
            return ;
        }
        
        
        
        STBMKViewC *newViewC = (STBMKViewC *)[STBMKViewC showSTBaseViewCOnSuperViewC:self
                                                                        andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                            andSTViewCTransitionType:STViewCTransitionTypeOfPush
                                                                         andComplete:^(BOOL finished,
                                                                                       STBaseViewC *stBaseViewC) {
                                                                             
                                                                         }];
        //
        [newViewC setDelegate:self];
        // 开启IQ
        newViewC.isOpenIQKeyboardManager = YES;
        // 加载View层
        [newViewC stBMKView];
        newViewC.stBMKView.dataSoureMArray = stBMKCenter.poiListMArray.mutableCopy;
        [newViewC.stBMKView.tableView reloadData];
        //跳转
        //TabBarc隐藏
        self.hidesBottomBarWhenPushed=YES;
        self.navigationController.navigationBar.tintColor = kAppGrayColor1;
        [self.navigationController pushViewController:newViewC
                                             animated:YES];
        newViewC.title = @"所在位置";
        newViewC.navigationController.navigationBar.hidden = NO;
        newViewC.navigationController.navigationBar.tintColor = kAppGrayColor1;
        
        //
        newViewC.navigationItem.rightBarButtonItem = newViewC.rightBarButtonItem;
        //改变颜色  必须跳转后
        [newViewC.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:kAppGrayColor1}];
        self.hidesBottomBarWhenPushed=YES;
    }];
}
#pragma mark----------- 地图数据更新 （留给子重写）
-(void)showUpdateLoactionInfoOfIndexPath{
    //找到cell
    // NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    //[self.graphicDynamicView.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]
    //   withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ceartVideoViewWithType:(int)type
{
    if (type == 0)
    {
        UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
        //设置代理
        imgPickerCtrl.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
            
            imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            imgPickerCtrl.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            //弹出模态
            [self presentViewController:imgPickerCtrl animated:YES
                             completion:^{
                                 
                             }];
            
        }else{
            
            [[FWHUDHelper sharedInstance]tipMessage:@"设备不支持视频"];
            return;
        }
    }else if(type == 1)
    {
        UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
        //设置代理
        imgPickerCtrl.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
            
            imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPickerCtrl.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            //弹出模态
            [self presentViewController:imgPickerCtrl animated:YES
                             completion:^{
                                 
                             }];
            
        }else{
            
            [[FWHUDHelper sharedInstance]tipMessage:@"设备不支持视频"];
            return;
        }
    }else
    {
        [[AppDelegate sharedAppDelegate]popViewController];
    }
}

- (void)showMyVideoView
{
    UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [headImgSheet addButtonWithTitle:@"拍摄视频"];
    [headImgSheet addButtonWithTitle:@"相册中获取视频"];
    [headImgSheet addButtonWithTitle:@"取消"];
    headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
    headImgSheet.delegate = self;
    [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark UIActionSheet的代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
        //设置代理
        imgPickerCtrl.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
            
            imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            imgPickerCtrl.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            //弹出模态
            [self presentViewController:imgPickerCtrl animated:YES
                             completion:^{
                                 
                             }];
            
        }else{
            
            [[FWHUDHelper sharedInstance]tipMessage:@"设备不支持视频"];
            return;
        }
        
    }else if (buttonIndex == 1)
    {
        UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
        //设置代理
        imgPickerCtrl.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
            
            imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPickerCtrl.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            //弹出模态
            [self presentViewController:imgPickerCtrl animated:YES
                             completion:^{
                                 
                             }];
            
        }else{
            
            [[FWHUDHelper sharedInstance]tipMessage:@"设备不支持视频"];
            return;
        }
        
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end







