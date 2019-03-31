//
//  ConversationModel.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ConversationModel.h"

@implementation ConversationModel

- (BOOL)isEqual:(id)object
{
    BOOL b = [super isEqual:object];
    if (!b)
    {
        return [self.mMsgID isEqualToString:((ConversationModel *) object).mMsgID];
    }
    return b;
}

- (NSString *)getTimeStr
{
    return [FWUtils formatTime:self.mMsgDate];
}

- (void)setMImgObj:(UIImage *)mImgObj
{
    _mImgObj = mImgObj;
    if (_mImgObj != nil)
    {
        self.mPicH = mImgObj.size.height / mImgObj.scale;
        self.mPicW = mImgObj.size.width / mImgObj.scale;
    }
}

//需要填充数据,,比如,语音要下载什么的,
- (void)fetchMsgData:(void (^)(NSString *errmsg))block
{
    block(@"下载数据失败");
}

@end
