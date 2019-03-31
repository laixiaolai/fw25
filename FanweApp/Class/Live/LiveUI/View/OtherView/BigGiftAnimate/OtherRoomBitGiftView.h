//
//  OtherRoomBitGiftView.h
//  FanweApp
//
//  Created by xfg on 2017/7/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"

@interface OtherRoomBitGiftView : FWBaseView

@property (nonatomic, strong) MenuButton *largeGiftBtn;

- (void)judgeGiftViewWith:(NSString *)str finishBlock:(FWVoidBlock)finishBlock;

@end
