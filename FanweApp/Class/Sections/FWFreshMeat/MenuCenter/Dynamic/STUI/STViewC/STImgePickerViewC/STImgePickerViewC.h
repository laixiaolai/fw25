//
//  STImgePickerViewC.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseViewC.h"
#import "TZImagePickerController.h"
#import "FWOssManager.h"
#import "STBMKViewC.h"
/**
 uploadImageDelegate  OSS上传服务类代理
 
 */
@interface STImgePickerViewC : STBaseViewC                <UINavigationControllerDelegate,
                                                          UIImagePickerControllerDelegate,
                                                          TZImagePickerControllerDelegate,
                                                          OssUploadImageDelegate,
                                                          STBMKViewCDelegate,UIActionSheetDelegate>
@property (nonatomic ,strong)NSMutableArray <UIImage *>   *photoMArray;            // record select img in mArray
@property (nonatomic ,strong)NSMutableArray <NSData *>    *videoMArray;            // record Video of nsdata in mArray
@property(nonatomic,strong) TZImagePickerController       *tzImagePickerController;// 第三方 仿微信图片选择器
@property(nonatomic,strong) FWOssManager                  *ossManager;             // OSS 上传服务类
-(void)showSystemImgPickerC;

#pragma *********************** Public 公有方法区域 *************************
#pragma mark - 设置IPC类型
// 启动IPC
-(void)showSystemIPC:(BOOL)isSystemIPC andMaxSelectNum:(int)maxSelectNum;
#pragma mark -----IPC数据下发（子重写）
-(void)showSelectedMAray:(NSMutableArray *)selectedMArray;
#pragma mark ---------- 发布（子重写）
-(void)showPublishDynamic;
#pragma mark ----------定位后调用（子 调用 不重写）
-(void)showSTBMKViewC;
#pragma mark ---------- 地图数据更新（子重写）
-(void)showUpdateLoactionInfoOfIndexPath;

//拍摄和相册
- (void)ceartVideoViewWithType:(int)type;

- (void)showMyVideoView;

@end
