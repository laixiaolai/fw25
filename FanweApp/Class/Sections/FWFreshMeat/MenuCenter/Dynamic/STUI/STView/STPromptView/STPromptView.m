//
//  STPromptView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STPromptView.h"

@implementation STPromptView

#pragma mark -----------------------------life cycle -----------------------------------
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //因没实力化，子控件要在from nib 写
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setSubViews];
}
#pragma mark - 设置subView
-(void)setSubViews{
    //剪切
    self.promptView.layer.cornerRadius = 3;
    self.promptView.layer.masksToBounds = YES;
    
    //颜色调控
    _confirmBtn.backgroundColor = [UIColor colorWithRed:255/225.0f green:77/225.0f blue:127/225.0f alpha:1];

    //动画加载
     self.promptView.layer.transform = CATransform3DMakeScale(0.8f, 0.8f,1.0f);
    [UIView animateWithDuration:0.36 animations:^{
        self.promptView.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
    } completion:^(BOOL finished) {
        self.promptView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f,1.0f);
        //事件：整个View 退出
    }];

    
}
#pragma mark ------------------------ event response 事件响应区域 ------------------------
#pragma mark - 确认

- (IBAction)showConfirm:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.36 animations:^{
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1);
    } completion:^(BOOL finished) {
        self.layer.transform = CATransform3DMakeScale(1.0f, 1.0f,1.0f);
          sender.userInteractionEnabled = YES;
        //事件：整个View 退出
          [self showRomoveFromSuperView];
    }];
}


#pragma mark -
#pragma mark -
-(UITapGestureRecognizer *)panGestureRecognizer{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
        _tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return _tapGestureRecognizer;
}
-(void)tapGestureRecognizerClick:(UITapGestureRecognizer *)tap{
    [self showRomoveFromSuperView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![touch.view isDescendantOfView:_promptView]){
        return NO;
    }
    return YES;
}
#pragma mark - 退出
-(void)showRomoveFromSuperView{
    
    [self removeFromSuperview];
    if (_delegate &&[_delegate respondsToSelector:@selector(showBackRemoveSTPromptView)]) {
        [_delegate showBackRemoveSTPromptView];
    }
}
-(void)setDelegate:(id<STPromptViewDelegate>)delegate{
    _delegate = delegate;
}
@end
