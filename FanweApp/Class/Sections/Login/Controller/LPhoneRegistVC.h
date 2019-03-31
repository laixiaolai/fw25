//
//  LPhoneRegistVC.h
//  FanweApp
//
//  Created by 丁凯 on 2017/6/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

@interface LPhoneRegistVC : FWBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;        //头像imgview
@property (weak, nonatomic) IBOutlet UIButton *headBtn;               //头像button
@property (weak, nonatomic) IBOutlet UILabel *headLabel;              //头像文字提示
@property (weak, nonatomic) IBOutlet UIView *bottomView;              //名字底部view
@property (weak, nonatomic) IBOutlet UITextField *nameFiled;          //名字filed
@property (weak, nonatomic) IBOutlet UIButton *leftSexBtn;            //男性btn
@property (weak, nonatomic) IBOutlet UIButton *rightSexBtn;           //女性btn
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;               //性别label
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;               //下一步
@property (weak, nonatomic) IBOutlet UILabel *textLabel;              //文字多少的提示

@property (nonatomic, copy) NSString          *used_id;               //用户id
@property (nonatomic, copy) NSString          *userName;              //用户名字
@property (nonatomic, strong) NSDictionary    *userInfoDic;           //用户信息的字典

@end
