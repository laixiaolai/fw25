//
//  BMPopBaseView.h
//  FanweApp
//
//  Created by 丁凯 on 2017/5/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyQuestTablView.h"

typedef NS_ENUM(NSInteger, BMPopViewType)
{
    BMInputPassWord,     // 输入口令
    BMCreatRoom,         // 创建房间
    BMRoomInfo,          // 房间信息
    BMEachDaytask,       //每日任务
};

@interface BMPopBaseView : UIView
@property (nonatomic,assign) BMPopViewType                  popType;
@property (weak, nonatomic) IBOutlet UIView                 *bmButtomView;
@property (weak, nonatomic) IBOutlet UILabel                *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton               *closeBtn;    //关闭按钮的图标
@property (weak, nonatomic) IBOutlet UIButton               *closeButton; //关闭按钮的控件

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *buttomWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *buttomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *titleLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *titleLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *titlelabelSpaceLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *closeBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *closeBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *titleLabelH;
@property (strong, nonatomic) DailyQuestTablView            *dQTableView;
/**
  改变 bmButtomView的frame 和titleLabel的标题
 @param Width bmButtomView 的宽
 @param Height bmButtomView 的高
 @param titleStr titleLabel 的name
 */
- (void)updateUIframeWithWidth:(CGFloat)Width andHeight:(CGFloat)Height andTitleStr:(NSString *)titleStr andmyEunmType:(BMPopViewType)myEunmType;


@end
