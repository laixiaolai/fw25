//
//  FWZBarController.m
//  managemall
//
//  Created by GuoMS on 14-8-9.
//  Copyright (c) 2014年 GuoMs. All rights reserved.
//

#import "FWZBarController.h"
#import "MBProgressHUD.h"

@interface FWZBarController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *_HUD;
    
    BOOL isOpen;
    BOOL upOrdown;
    NSTimer *_time;
    int _num;
    
    NSString *_qrcodeStr; //扫码结果
}

@end

@implementation FWZBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //不懂为毛下面会多出一截。。。。。。
        CGRect bounds = self.view.bounds;
        bounds.size.height = bounds.size.height - 150;
        self.view.bounds = bounds;
    }
#endif
    self.view.backgroundColor = [UIColor whiteColor];
    
    isOpen = NO;
    upOrdown = NO;
    
    self.navigationItem.title = @"扫描二维码";
    
    FWWeakify(self)
    [self setupBackBtnWithBlock:^{
        FWStrongify(self)
        
        UIViewController *tmpController = [self.navigationController popViewControllerAnimated:YES];
        if (!tmpController)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        
    }];
}

- (void)initScan
{
    CGRect frame = [UIScreen mainScreen].bounds;
    
    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    CGFloat between = 50;
    CGFloat imageW = kScreenW-100;
    CGFloat imageH = kScreenW-100;
    CGFloat topHeight = (kScreenH-imageH-64)/2;
    
    self.readerView = [[ZBarReaderView new]init];
    CGRect newFrame = self.readerView.frame;
    newFrame.size.width = kScreenW;
    newFrame.size.height = kScreenH;
    self.readerView.frame = newFrame;
    
    [self.view addSubview:self.readerView];
    self.readerView.readerDelegate = self;
    //    self.readerView.showsFPS = YES;
    //关闭闪关灯
    self.readerView.torchMode = 0;
    
    self.readLine = [[UIView alloc]initWithFrame:CGRectMake(2, 0, imageW - 4, .3)];
    self.readLine.backgroundColor = [UIColor redColor];
    
    self.imagefr = [[UIImageView alloc]init];
    self.imagefr.frame = CGRectMake(between, topHeight, imageW, imageH);
    [self.view addSubview:self.imagefr];
    UIImage *image = [UIImage resizedImage:@"scan_border"];
    self.imagefr.contentMode = UIViewContentModeScaleAspectFit;
    //    self.imagefr.clipsToBounds = YES;
    self.imagefr.image = image;
    [self.view bringSubviewToFront:self.imagefr];
    [self.imagefr addSubview:self.readLine];
    
    _num = 0;
    _time = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    upOrdown = NO;
    
    self.top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, topHeight)];
    self.top.backgroundColor = color;
    [self.view addSubview:self.top];
    
    
    self.left = [[UIView alloc]initWithFrame:CGRectMake(0, topHeight, between, frame.size.height - topHeight)];
    self.left.backgroundColor = color;
    [self.view addSubview:self.left];
    
    
    self.right = [[UIView alloc]initWithFrame:CGRectMake(between + imageW, topHeight, kScreenW - between - imageW, frame.size.height - topHeight)];
    self.right.backgroundColor = color;
    [self.view addSubview:self.right];
    
    self.bottom = [[UIView alloc]initWithFrame:CGRectMake(between, topHeight + imageH, frame.size.width - 2 * between, frame.size.height - topHeight - imageH + 300)];
    self.bottom.backgroundColor = color;
    [self.view addSubview:self.bottom];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setTitle:@"开启" forState:UIControlStateNormal];
    [btn setTitle:@"关闭" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(kScreenW-80, topHeight-40, 30, 40);
    [self.top addSubview:btn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width - 2 * between, 40)];
    label.text = @"将二维码放入取景框中，即可自动扫描";
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textAlignment = NSTextAlignmentCenter;
    [self.bottom addSubview:label];
    [self.bottom bringSubviewToFront:label];
    
    //不显示跟踪框
    //    _readerView.tracksSymbols = NO;
    
    //二维码拍摄的屏幕大小
    CGRect rvBounsRect = CGRectMake(0, 0, kScreenW, [UIScreen mainScreen].bounds.size.height);
    //二维码拍摄时，可扫描区域的大小
    CGRect scanCropRect = CGRectMake(between-20, topHeight-20, imageW+40, imageH+40);
    //    CGRect scanCropRect = self.imagefr.frame;
    //设置ZBarReaderView的scanCrop属性
    _readerView.scanCrop = [self getScanCrop:scanCropRect readerViewBounds:rvBounsRect];
    //定时器使基准线闪动
}

//设置可扫描区的scanCrop的方法
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds
{
    CGFloat x, y, width, height;
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    height = 1 - rect.origin.x / rvBounds.size.width;
    return CGRectMake(x, y, width, height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initScan];
    [self.readerView start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.readerView stop];
    self.readerView = nil;
    self.imagefr = nil;
    self.readLine = nil;
    [_time invalidate];
    _time = nil;
}

#pragma mark 处理扫描结果
- (void)readerView:(ZBarReaderView *)view didReadSymbols:(ZBarSymbolSet *)syms fromImage:(UIImage *)img
{
    //处理扫描结果
    ZBarSymbol *sym = nil;
    for (sym in syms)
        break;
    //停止扫描
    [self.readerView stop];
    //停止定时器
    [_time invalidate];
    
    if (sym != nil)
    {
        NSString *resoult = sym.data;
        //解决中文乱码问题
        resoult =  [FWUtils returnUF8String:resoult];
        _qrcodeStr = resoult;
        
        if (_delegate && [_delegate respondsToSelector:@selector(getQRCodeResult:)])
        {
            [_delegate getQRCodeResult:_qrcodeStr];
            
            [self.view removeFromSuperview];
            [self.navigationController.view removeFromSuperview];
            [self.navigationController removeFromParentViewController];
        }
    }
}

- (BOOL)isNumText:(NSString *)str
{
    NSString *regex        = @"(/^[0-9]*$/)";
    NSPredicate *pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark 线的动画效果
- (void)animation1
{
    _num++;
    self.readLine.frame = CGRectMake(2, 2 * _num, kScreenW-104, .3);
    if (2 * _num == kScreenW-99 || 2 * _num == kScreenW-100)
    {
        _num = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.readerView = nil;
    self.imagefr = nil;
    self.readLine = nil;
    [_time invalidate];
    _time = nil;
}

//是否开启闪光灯
- (void)openAction:(UIButton *)btn
{
    if (isOpen)
    {
        btn.selected = NO;
        isOpen = NO;
        _readerView.torchMode = 0;
    }
    else
    {
        isOpen = YES;
        btn.selected = YES;
        _readerView.torchMode = 1;
    }
}

#pragma mark uialertViewdail
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showHideTabBar" object:@"1"];
    }
    else if (buttonIndex == 1)
    {
        //线重新开始移动
        _time = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        [self.readerView start];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    _HUD = nil;
}

@end
