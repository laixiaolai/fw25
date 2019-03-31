//
//  ChatAudioRecordNoticeView.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NIMKit_ViewWidth 160
#define NIMKit_ViewHeight 110

#define NIMKit_TimeFontSize 30
#define NIMKit_TipFontSize 15

@interface ChatAudioRecordNoticeView : UIView
{
    UIImageView *_backgrounView;
    UIImageView *_tipBackgroundView;
}
@property (nonatomic, assign) int mstatus; //1 开始了,,2 显示上滑什么,,,3 显示取消

@property (nonatomic, assign) NSTimeInterval recordTime;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@end
