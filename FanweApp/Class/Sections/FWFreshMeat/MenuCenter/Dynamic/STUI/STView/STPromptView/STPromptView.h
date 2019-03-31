//
//  STPromptView.h
//  FanweApp
//
//  Created by 岳克奎 on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STBaseView.h"
@protocol STPromptViewDelegate <NSObject>

@optional
-(void)showBackRemoveSTPromptView;
@end
@interface STPromptView : STBaseView<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView  *promptBgImgView;
@property (weak, nonatomic) IBOutlet UIButton     *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView       *promptView;
@property(nonatomic,strong)UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic,weak)id<STPromptViewDelegate>delegate;
@end
