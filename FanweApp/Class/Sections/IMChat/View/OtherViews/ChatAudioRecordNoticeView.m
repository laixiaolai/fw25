//
//  ChatAudioRecordNoticeView.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatAudioRecordNoticeView.h"

@implementation ChatAudioRecordNoticeView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, NIMKit_ViewWidth, NIMKit_ViewHeight);
        _backgrounView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_input_record_indicator"]];
        [self addSubview:_backgrounView];

        _tipBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_input_record_indicator_cancel"]];
        _tipBackgroundView.hidden = YES;
        _tipBackgroundView.frame = CGRectMake(0, NIMKit_ViewHeight - CGRectGetHeight(_tipBackgroundView.bounds), NIMKit_ViewWidth, CGRectGetHeight(_tipBackgroundView.bounds));
        [self addSubview:_tipBackgroundView];

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont boldSystemFontOfSize:NIMKit_TimeFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];

        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:NIMKit_TipFontSize];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"手指上滑，取消发送";
        [self addSubview:_tipLabel];

        self.mstatus = 1;
    }
    return self;
}

- (void)setRecordTime:(NSTimeInterval)recordTime
{
    NSInteger minutes = (NSInteger) recordTime / 60;
    NSInteger seconds = (NSInteger) recordTime % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minutes, seconds];
}

- (void)setMstatus:(int)mstatus
{
    if (mstatus == 1)
    {
        [self setRecordTime:0];
    }
    else if (mstatus == 2)
    {
        _tipLabel.text = @"松开手指，取消发送";
        _tipBackgroundView.hidden = NO;
    }
    else
    {
        _tipLabel.text = @"手指上滑，取消发送";
        _tipBackgroundView.hidden = YES;
    }
    _mstatus = mstatus;
}

- (void)layoutSubviews
{
    CGSize size = [_timeLabel sizeThatFits:CGSizeMake(NIMKit_ViewWidth, MAXFLOAT)];
    _timeLabel.frame = CGRectMake(0, 36, NIMKit_ViewWidth, size.height);
    size = [_tipLabel sizeThatFits:CGSizeMake(NIMKit_ViewWidth, MAXFLOAT)];
    _tipLabel.frame = CGRectMake(0, NIMKit_ViewHeight - 10 - size.height, NIMKit_ViewWidth, size.height);
}

@end
