//
//  ChatMoreView.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatMoreView.h"

#define Bt_W 50.0f
#define Bt_H 75.0f
#define Bt_s 15.0f

@interface ButtonIcon : UIButton

@end

@implementation ButtonIcon

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTitleColor:kGrayColor forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    contentRect = CGRectMake(0, 0, 50, 50);
    return contentRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    contentRect = CGRectMake(-10, 50 + 5.0f, 70, 25);
    return contentRect;
}

@end

@interface ChatMoreView ()
{
    ButtonIcon *_albumBtn;  //图片
    ButtonIcon *_cameraBtn; //拍照
    UIView *_backView;
}

@end

@implementation ChatMoreView

- (instancetype)init
{

    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, kScreenW, kChatOtherViewHight);
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = kAppGrayColor1;

        //[self initUI];
    }
    return self;
}

- (void)setGiftView:(BOOL)hidden
{

    [_backView setHidden:hidden];
}

- (void)initWithBtnArray:(NSMutableArray *)array
{

    NSLog(@"%lu", (unsigned long) array.count);

    CGFloat perPageW = self.bounds.size.width;
    CGFloat perW = perPageW / 4.0f;
    CGFloat perH = 80;

    CGFloat xPoint = 20.0f;
    CGFloat yPoint = 15;

    int nextrow = 0;
    int nowrows = 0;

    for (int index = 0; index < array.count; index++)
    {
        NSArray *item = array[index];

        ButtonIcon *btn = [[ButtonIcon alloc] initWithFrame:CGRectMake(xPoint, yPoint, perW, perH)];
        [btn setTitle:item[0] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:item[1]] forState:UIControlStateNormal];
        [btn setTag:1000 + index];
        [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        nextrow++;

        xPoint += perW;
        if (nextrow == 4)
        { //4个就换一行
            nowrows++;
            nextrow = 0;
            xPoint = 0 * perPageW+20;
            yPoint += perH + 20;
        }
    }

    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 234)];
    _backView.backgroundColor = RGBA(233, 233, 233, 1);
    [_backView setHidden:YES];
    [self addSubview:_backView];
}

- (void)itemBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(chatMoreViewButton:)])
    {
        [self.delegate chatMoreViewButton:sender.tag];
    }
}

@end
