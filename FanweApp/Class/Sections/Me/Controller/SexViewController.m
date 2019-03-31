//
//  SexViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SexViewController.h"

#define imgViewHeight 80

@interface SexViewController ()
{
    UIImageView                  *_manImgView;              //男
    UIImageView                  *_womanImgView;            //女
}
@end

@implementation SexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackGroundColor;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    if ([self.sexType isEqualToString:@"0"] || !self.sexType)
    {
        self.sexType = @"1";
    }
    self.title = @"性别";
    _manImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-imgViewHeight/2, (kScreenH-240)/2-imgViewHeight/2, imgViewHeight, imgViewHeight)];
    _manImgView.userInteractionEnabled = YES;
    _manImgView.layer.cornerRadius = _manImgView.frame.size.height/2;
    _manImgView.layer.masksToBounds = YES;
    if ([self.sexType isEqualToString:@"1"])
    {
        
        _manImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        _manImgView.image = [UIImage imageNamed:@"com_male_normal"];
    }
    [_manImgView addGestureRecognizer:tap1];
    [self.view addSubview:_manImgView];
    
    UILabel *sexlabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2-imgViewHeight/2, (kScreenH-240)/2+imgViewHeight/2, imgViewHeight, 24)];
    sexlabel.textAlignment = NSTextAlignmentCenter;
    sexlabel.text = @"男";
    sexlabel.textColor = kAppGrayColor2;
    sexlabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:sexlabel];
    
    _womanImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-imgViewHeight/2, (kScreenH-240)/2+imgViewHeight/2+50, imgViewHeight, imgViewHeight)];
    _womanImgView.userInteractionEnabled = YES;
    _womanImgView.layer.cornerRadius = _manImgView.frame.size.height/2;
    _womanImgView.layer.masksToBounds = YES;
    if ([self.sexType isEqualToString:@"2"])
    {
        _womanImgView.image = [UIImage imageNamed:@"com_female_selected"];
        
    }else
    {
        _womanImgView.image = [UIImage imageNamed:@"com_female_normal"];
    }
    [_womanImgView addGestureRecognizer:tap2];
    [self.view addSubview:_womanImgView];
    
    UILabel *sexlabel2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2-imgViewHeight/2, (kScreenH-240)/2+imgViewHeight*3/2+50, imgViewHeight, 24)];
    sexlabel2.textAlignment = NSTextAlignmentCenter;
    sexlabel2.text = @"女";
    sexlabel2.textColor = kAppGrayColor2;
    sexlabel2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:sexlabel2];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)backClick
{
    if (self.delgate)
    {
        if ([self.delgate respondsToSelector:@selector(changeSexWithString:)])
        {
            [self.delgate changeSexWithString:self.sexType];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tap1:(UITapGestureRecognizer *)tap
{
    [FWHUDHelper alert:@"性别只能修改保存一次"];
    _manImgView.image = [UIImage imageNamed:@"com_male_selected"];
    _womanImgView.image = [UIImage imageNamed:@"com_female_normal"];
    self.sexType = @"1";
    if (self.delgate)
    {
        if ([self.delgate respondsToSelector:@selector(changeSexWithString:)])
        {
            [self.delgate changeSexWithString:self.sexType];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tap2:(UITapGestureRecognizer *)tap
{
    [FWHUDHelper alert:@"性别只能修改保存一次"];
    _manImgView.image = [UIImage imageNamed:@"com_male_normal"];
    _womanImgView.image = [UIImage imageNamed:@"com_female_selected"];
    self.sexType = @"2";
    if (self.delgate)
    {
        if ([self.delgate respondsToSelector:@selector(changeSexWithString:)])
        {
            [self.delgate changeSexWithString:self.sexType];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
