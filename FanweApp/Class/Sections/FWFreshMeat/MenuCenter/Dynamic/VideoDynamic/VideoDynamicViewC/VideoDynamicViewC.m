//
//  VideoDynamicViewC.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoDynamicViewC.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+STCommon.h"
#import "VideoCoverViewC.h"
#import "STVideoCoverLayout.h"
@interface VideoDynamicViewC ()

{
    NSTimer             *_imageTimer;        //上传视频的定时器
    int                 _timeCount;          //上传视频的时间超过三分钟就报超时
}
@end

@implementation VideoDynamicViewC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ossManager];
    _timeCount = 180;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(VideoDynamicView *)videoDynamicView{
    if (!_videoDynamicView) {
        _videoDynamicView = (VideoDynamicView *)[VideoDynamicView showSTBaseViewOnSuperView:self.view
                                                                            loadNibNamedStr:@"VideoDynamicView"
                                                                               andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                                                andComplete:^(BOOL finished,
                                                                                              STBaseView *stBaseView) {
                                                                                }];
        [_videoDynamicView setBaseDelegate:self];
        [_videoDynamicView setDelegate:self];
        _videoDynamicView.tableView.mj_footer.hidden = YES;
    }
    return _videoDynamicView;
}
#pragma ********************************* 子重写父 方法区域 *************************
#pragma mark -  系统 -完成照片选择回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取 选择的类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //这里只选择 视频
    if ([mediaType isEqualToString:@"public.movie"]) {
        //获取视图的url
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        AVURLAsset * asset1 = [AVURLAsset assetWithURL:url];
        CMTime   time = [asset1 duration];
        int seconds = ceil(time.value/time.timescale);
        //多帧图
        MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        moviePlayer.shouldAutoplay = NO;
        if ((int)seconds <3) {
            [[FWHUDHelper sharedInstance]tipMessage:@"选取视频时长太小"];
            //关闭当前的模态视图
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            return;
        }else if((int)seconds >=60) {
            [[FWHUDHelper sharedInstance]tipMessage:@"选取视频时长太大"];
            //关闭当前的模态视图
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }];
            return;
        }else{
            
        }
        
#pragma mark - 帧图数据
        NSMutableArray *tempImageMArray =@[].mutableCopy;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //数组 专门存
            //GCD 快速遍历
            NSLog(@"-----------se-----%d",seconds);
            if(!self.videoMArray)
            {
                self.videoMArray = @[].mutableCopy;
            }
            @autoreleasepool {
                [self movFileTransformToMP4WithSourceUrl:url completion:^(NSURL *Mp4FilePath) {
                    NSData *videoData = [NSData dataWithContentsOfURL:Mp4FilePath];
                    [self.videoMArray addObject:videoData];
                    
                    for (int i = 0;i< seconds;i++) {
                        UIImage *thumbnailImage = [UIImage st_thumbnailImageForVideo:Mp4FilePath atTime:i];
                        [tempImageMArray addObject:thumbnailImage];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //下发 帧图数组
                        [self showSelectedMAray:tempImageMArray];
                        //关闭当前的模态视图
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                            [self popoverPresentationController];
                        }];
                        
                    });
                    
                }];
            }
        });
        
    }
}
#pragma - 系统imgPickerC - 取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
    if (self.videoDynamicView.dataSoureMArray.count == 0) {
        [[AppDelegate sharedAppDelegate]  popViewController];
    }
}
#pragma mark -----IPC数据下发（子重写）
-(void)showSelectedMAray:(NSMutableArray *)selectedMArray{
    NSLog(@"-----3131------%lu----------",(unsigned long)selectedMArray.count);
    [self videoDynamicView];
    self.videoDynamicView.dataSoureMArray = selectedMArray;
    NSLog(@"-----------------%@",NSStringFromClass([selectedMArray[0] class]));
    [self.videoDynamicView.tableView reloadData];
}

#pragma ********************************* Delegate 代理  *************************
#pragma -------------- <STTableViewBaseViewDelegate>
-(void)showTableViewDidSelectIndexpath:(NSIndexPath *)indexPath andSTTableBaseView:(STTableBaseView *)stTableBaseView{
    if (indexPath.section == 3 && indexPath.row == 0)
    {
        [self showPublishDynamic];
    }
    //百度地图定位
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        //加载地图
        [self showSTBMKViewC];
    }
}
#pragma *************************  地图部分 *************************
/*
 //百度地图定位
 if(indexPath.section == 2 && indexPath.row == 0){
 //加载地图
 [self showSTBMKViewC];
 }
 }*/
#pragma -------------刷新 地图选择
// 因为父层去拿子层的View，好难 那就重写
-(void)showUpdateLoactionInfoOfIndexPath
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    [self.videoDynamicView.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]
                                           withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark ---------- 发布（子重写）
//(为了统一，所有发布方法一致)
-(void)showPublishDynamic
{
    //
    [self videoDynamicView];
    //1区0行 -动态文本
    if(!self.videoDynamicView.recordTextViewStr
       ||self.videoDynamicView.recordTextViewStr.length<1
       ||[self.videoDynamicView.recordTextViewStr isEqualToString:@"这一刻你的想法"]){
        [[FWHUDHelper sharedInstance]tipMessage:@"请编辑这一刻你的想法"];
        return;
    }
    //位置
    
    //帧图要存在
    
    //视频是否存在
    if (self.videoMArray.count == 0)
    {
        [[FWHUDHelper sharedInstance]tipMessage:@"视频数据不小心丢失了，请重新选择"];
        return;
    }
    
    // 数据预处理
    NSMutableArray <NSData *>*tempImgDataMArray = @[].mutableCopy;
    
    //处理帧图数据
    UIImage *image = self.videoDynamicView.dataSoureMArray[self.videoDynamicView.recordSelectIndex];
    [tempImgDataMArray addObject:UIImagePNGRepresentation(image)];
    //帧图存在
    if(tempImgDataMArray.count== 0)
    {
        [[FWHUDHelper sharedInstance]tipMessage:@"帧图数据不小心丢失了，请重新选择"];
        return;
    }
    //开启上传
    if (![self.ossManager isSetRightParameter])
    {
        [[FWHUDHelper sharedInstance]tipMessage:@"图片参数配置失败"];
        return;
    }
    FWWeakify(self);
    if (!_imageTimer)
    {
        _imageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(imageTimeGo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_imageTimer forMode:NSDefaultRunLoopMode];
    }
    [[FWHUDHelper sharedInstance]syncLoading:@"正在上传数据中..."];
    [self.ossManager showUploadOfOssServiceOfDataMarray:tempImgDataMArray
                                      andSTDynamicSelectType:STDynamicSelectPhoto
                                                 andComplete:^(BOOL finished,
                                                               NSMutableArray<NSString *> *urlStrMArray) {
                                                     FWStrongify(self)
                                                     if (urlStrMArray.count>0)
                                                     {
                                                         //图片url  str
                                                         self.recordVideoCoverURLStr = urlStrMArray[0];
                                                         //任务2：上传 视频 MOC 格式
//                                                         [[FWHUDHelper sharedInstance]syncLoading:@"正在上传数据中..."];
                                                         [self.ossManager showUploadOfOssServiceOfDataMarray:self.videoMArray
                                                                                           andSTDynamicSelectType:STDynamicSelectVideo
                                                                                                      andComplete:^(BOOL finished,
                                                                                                                    NSMutableArray<NSString *> *urlStrMArray) {
                                                                                                          [[FWHUDHelper sharedInstance]syncStopLoading];
                                                                                                          if(urlStrMArray.count>0)
                                                                                                          {
                                                                                                              self.recordVideoURLStr = urlStrMArray[0];
                                                                                                              [[FWHUDHelper sharedInstance]syncLoading:@"正在发布中..."];
                                                                                                              [self showHttpServiceublishDynamic];
                                                                                                          }
                                                                                                      }];
                                                     }
                                                     
                                                 }];
    
}

- (void)imageTimeGo
{
    _timeCount --;
    NSLog(@"timeCount===%d",_timeCount);
    if (_timeCount == 0)
    {
        [_imageTimer invalidate];
        _imageTimer = nil;
        [[FWHUDHelper sharedInstance]syncStopLoading];
        [[FWHUDHelper sharedInstance]tipMessage:@"视频上传超时"];
    }
}

#pragma----正式提交服务器 发布
-(void)showHttpServiceublishDynamic{
    //地图管理类
    STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
    //参数MDic
    NSMutableDictionary *parametersMDic = @{@"ctl"             :@"publish",
                                            @"act"             :@"do_publish",
                                            @"itype"           :@"xr",
                                            @"publish_type"    :@"video",                                  // 发布商品
                                            @"content"         :self.videoDynamicView.recordTextViewStr,   // 动态文本
                                            @"photo_image"     :self.recordVideoCoverURLStr,               // OSS 封面图 URL
                                            @"video_url"       :self.recordVideoURLStr,                    // OSS 视频   URL
                                            @"latitude"        :@(stBMKCenter.latitudeValue),              // 纬度值
                                            @"longitude"       :@(stBMKCenter.longitudeValue),             // 经度值
                                            @"city"            :stBMKCenter.cityNameStr,                   // 城市名称
                                            @"province"        :stBMKCenter.provinceStr,                   // 省会
                                            @"address"         :stBMKCenter.detailAdressStr,               // 具体坐标地址
                                            }.mutableCopy;
    FWWeakify(self)
    [[NetHttpsManager manager]POSTWithParameters:parametersMDic
                                    SuccessBlock:^(NSDictionary *responseJson) {
                                        [[FWHUDHelper sharedInstance]syncStopLoading];
                                        [_imageTimer invalidate];
                                        _imageTimer = nil;
                                        if( [[responseJson allKeys] containsObject:@"status"]&&[responseJson[@"status"] intValue] == 1)
                                        {
                                            //[[FWHUDHelper sharedInstance]tipMessage:@"发布成功!"];
                                            [FWHUDHelper alert:@"发布成功!" action:^{
                                                FWStrongify(self)
                                                // 执行退出
                                                @autoreleasepool {
                                                    self.recordSuperViewC = nil;
                                                    self.recordTabBarC = nil;
                                                    self.videoMArray = nil;
                                                    self.photoMArray = nil;
                                                    self.tzImagePickerController = nil;
                                                    self.ossManager  = nil;
                                                    self.videoDynamicView = nil;
                                                    self.navigationController.hidesBottomBarWhenPushed = NO;
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                    Noti_Post_Param(@"DynamicCommitSuccess", nil);
                                                }
                                            }];
                                        }
                                    } FailureBlock:^(NSError *error) {
                                        [[FWHUDHelper sharedInstance]syncStopLoading];
                                        [[FWHUDHelper sharedInstance]tipMessage:@"发布失败!"];
                                        
                                    }];
}
#pragma --------------  <VideoDynamicViewDelegate>
#pragma mark --去封面编辑页面
-(void)showOnVideoDynamicView:(VideoDynamicView *)videoDynamicView
         STTableShowVideoCell:(STTableShowVideoCell *)stTableShowVideoCell
     andChangeVideoCoverClick:(UIButton *)changeVideoCoverClick{
    //
    
    if (self.videoDynamicView.dataSoureMArray.count == 0)
    {
        return;
    }
    VideoCoverViewC *videoCoverViewC = (VideoCoverViewC *)[VideoCoverViewC showSTBaseViewCOnSuperViewC:self
                                                                                          andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                                              andSTViewCTransitionType:STViewCTransitionTypeOfPush
                                                                                           andComplete:^(BOOL finished,
                                                                                                         STBaseViewC *stBaseViewC) {
                                                                                               
                                                                                           }];
    videoCoverViewC.title = @"编辑视频封面";
    // 数组
    [videoCoverViewC videoCoverView];
    videoCoverViewC.videoCoverView.collectionView.backgroundColor = [UIColor whiteColor];
    videoCoverViewC.videoCoverView.collectionView.frame = CGRectMake(0,kScreenH-250, kScreenW, 150);
    //videoCoverViewC.videoCoverView.collectionView.backgroundColor = [UIColor redColor];
    //STVideoCoverLayout *layout = [STVideoCoverLayout new];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 2;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    videoCoverViewC.videoCoverView.collectionView.collectionViewLayout = layout;
    videoCoverViewC.videoCoverView.dataSourceMArray = self.videoDynamicView.dataSoureMArray;
    //设置首帧图
    [videoCoverViewC.videoCoverView.showSelectedImgView setImage:self.videoDynamicView.dataSoureMArray[0]];
    [videoCoverViewC.videoCoverView.collectionView reloadData];
    videoCoverViewC.navigationController.navigationBar.tintColor = kAppGrayColor1;
    [self.navigationController pushViewController:videoCoverViewC animated:YES];
    __weak typeof(self)weak_Self = self;
    videoCoverViewC.selectImgInMarrayblock = ^(NSInteger  selectMArrayIndex){
        weak_Self.videoDynamicView.recordSelectIndex = selectMArrayIndex;
        [stTableShowVideoCell.bgImgView setImage:[UIImage boxblurImage:weak_Self.videoDynamicView.dataSoureMArray[selectMArrayIndex] withBlurNumber:1]];
        [stTableShowVideoCell.videoCoverImgView  setImage:weak_Self.videoDynamicView.dataSoureMArray[selectMArrayIndex]];
        
        [stTableShowVideoCell.bgImgView setNeedsDisplay];
        [stTableShowVideoCell.videoCoverImgView setNeedsDisplay];
    };
}

#pragma mark mov格式转mp4格式
- (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSURL *Mp4FilePath))comepleteBlock
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                     
                     comepleteBlock(exportSession.outputURL);
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     
                     break;
             }
         }];
    }
}
@end

