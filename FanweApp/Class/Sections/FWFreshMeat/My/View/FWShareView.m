//
//  FWShareView.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWShareView.h"

@implementation FWShareView
-(id)initWithFrame:(CGRect)frame Delegate:(id<shareDeleGate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.SDeleGate = delegate;
        self.shareArray = [NSMutableArray new];
        self.backgroundColor = kBackGroundColor;
        self.fanweApp = [GlobalVariables sharedInstance];
        [self creatMainView];
    }
    return self;
}

- (void)creatMainView
{
    [self getShareArr];
    _buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.frame.size.height)];
    _buttomView.backgroundColor = kWhiteColor;
    [self addSubview:_buttomView];
    
    _shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, self.frame.size.height)];
    _shareLabel.text = @"分享至:";
    _shareLabel.textColor = RGB(153, 153, 153);
    _shareLabel.font = [UIFont systemFontOfSize:14];
    [_buttomView addSubview:_shareLabel];
    
    for (int i = 0; i < _shareArray.count; i ++)
    {
        UIImageView *shareImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-10-42-(10+42)*i, 9, 42, 42)];
        shareImgView.userInteractionEnabled = YES;
        shareImgView.tag = [_shareArray[i] intValue];
        if ([_shareArray[i] intValue] == 0)
        {
            shareImgView .image = [UIImage imageNamed:@"fw_share_weiBo"];
        }else if ([_shareArray[i] intValue] == 1)
        {
            shareImgView .image = [UIImage imageNamed:@"fw_share_circle"];
        }else if ([_shareArray[i] intValue] == 2)
        {
            shareImgView .image = [UIImage imageNamed:@"fw_share_wechat"];
        }else if ([_shareArray[i] intValue] == 3)
        {
            shareImgView .image = [UIImage imageNamed:@"fw_share_qq"];
        }else if ([_shareArray[i] intValue] == 4)
        {
            shareImgView .image = [UIImage imageNamed:@"fw_share_qqCircle"];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareImgTap:)];
        [shareImgView addGestureRecognizer:tap];
        [_buttomView addSubview:shareImgView];
    }
}

//0新浪 1朋友圈 2微信 3qq 4qq空间
- (void)getShareArr
{
    if (_fanweApp.appModel.qq_app_api == 1)//qq空间
    {
        [_shareArray addObject:@"4"];
    }
    if (_fanweApp.appModel.sina_app_api == 1)//新浪
    {
        [_shareArray addObject:@"0"];
    }
    if (_fanweApp.appModel.wx_app_api == 1)//朋友圈
    {
       [_shareArray addObject:@"1"];
    }
    if (_fanweApp.appModel.wx_app_api == 1)//微信
    {
       [_shareArray addObject:@"2"];
    }
    if (_fanweApp.appModel.qq_app_api == 1)//qq
    {
       [_shareArray addObject:@"3"];
    }
    
}

#pragma mark 图片的点击事件
- (void)shareImgTap:(UITapGestureRecognizer *)tap
{
    if (self.SDeleGate && [self.SDeleGate respondsToSelector:@selector(clickShareImgViewWithTag:)])
    {
        [self.SDeleGate clickShareImgViewWithTag:(int)tap.view.tag];
    }
}
@end
