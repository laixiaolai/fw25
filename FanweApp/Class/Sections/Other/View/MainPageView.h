//
//  MainPageView.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol privateLetterDelegate <NSObject>
//私信的代理
- (void)sentPersonLetter:(NSString*)taguserid;

@end

@interface MainPageView : FWBaseView

@property (nonatomic, weak) id<privateLetterDelegate>delegate;

@property ( nonatomic,copy)  NSString           *user_id;
@property ( nonatomic,assign) int               has_focus;
@property ( nonatomic,assign) int               has_black;

@property (weak, nonatomic) IBOutlet UIView     *backGroundView;
@property (weak, nonatomic) IBOutlet UIButton   *followButton;
@property (weak, nonatomic) IBOutlet UIButton   *personLetterButton;
@property (weak, nonatomic) IBOutlet UIButton   *defriendButton;
@property (weak, nonatomic) IBOutlet UIView     *VLineView1;
@property (weak, nonatomic) IBOutlet UIView     *VLineView2;
@property (weak, nonatomic) IBOutlet UIView     *HLineView;

- (void)changeState;

@end
