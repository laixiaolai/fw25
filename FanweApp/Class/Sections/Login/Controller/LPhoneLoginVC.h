//
//  LPhoneLoginVC.h
//  FanweApp
//
//  Created by 丁凯 on 2017/6/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

@interface LPhoneLoginVC : FWBaseViewController

@property (nonatomic, assign) BOOL             LSecBPhone;                         //登入成功之后绑定手机
@property (nonatomic, assign) BOOL             LNSecBPhone;                        //未登入成功之后绑定手机
@property (nonatomic, copy) NSString           *loginType;                         //登入类型
@property (nonatomic, copy) NSString           *loginId;                           //登入id
@property (nonatomic, copy) NSString           *accessToken;                       //登入accessToken

@property (weak, nonatomic) IBOutlet UIView *firstBottomView;                      //图形验证码下面的view
@property (weak, nonatomic) IBOutlet UITextField *codeFiled;                       //图形验证码filed
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;                     //图形验证码imgView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstBottomViewH;         //图形验证码下面的view的高度

@property (weak, nonatomic) IBOutlet UIView *secondBottomView;                     //手机号码、验证码、登陆下面的view的高度
@property (weak, nonatomic) IBOutlet UIView *threeBottomView;                      //手机号码view的高度
@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;                      //手机号码filed
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;                            //验证btn
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeFiled;                  //验证码filed
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;                           //登陆btn
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondBottomViewSpaceH;   //距离firstBottomView的高度

@end
