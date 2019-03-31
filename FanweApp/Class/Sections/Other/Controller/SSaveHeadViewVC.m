//
//  SSaveHeadViewVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SSaveHeadViewVC.h"

@interface SSaveHeadViewVC ()

@end

@implementation SSaveHeadViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)initFWUI
{
    [super initFWUI];
    
    self.view.backgroundColor = kWhiteColor;
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kScreenW)];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView sd_setImageWithURL:self.url placeholderImage:kDefaultPreloadHeadImg];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgView addGestureRecognizer:tap];
    [self.view addSubview:self.imgView];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 50, 50);
    [backBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
    backBtn.layer.cornerRadius = 25;
    backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    backBtn.tag = 101;
    [backBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:backBtn];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenW*0.1, kScreenH-100, kScreenW*0.8, 40);
    button.backgroundColor = kAppMainColor;
    button.tag = 100;
    button.layer.cornerRadius = 18;
    [button setTitle:@"保存到相册" forState:0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:button];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(kScreenW*0.1,kScreenH-50,kScreenW*0.8, 40);
    deleteButton.tag = 101;
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [deleteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"X" forState:0];
    [deleteButton setTitleColor:kAppMainColor forState:0];
    [self.view addSubview:deleteButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = kClearColor;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)buttonClick:(UIButton *)button
{
    int index = (int)button.tag-100;
    if (index == 0)
    {
        UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }else if (index == 1)
    {
        [[AppDelegate sharedAppDelegate]popViewController];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        [FanweMessage alert:@"保存成功"];
        
    }else
    {
        [FanweMessage alert:@"保存失败"];
    }
}

- (void)tap
{
    [[AppDelegate sharedAppDelegate]popViewController];
}



@end
