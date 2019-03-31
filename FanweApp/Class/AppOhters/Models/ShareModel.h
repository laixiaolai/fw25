//
//  ShareModel.h
//  ZCTest
//
//  Created by GuoMs on 16/1/25.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

/**分享文字内容*/
@property (nonatomic, copy) NSString    *share_content;
/**分享图片的下载路径*/
@property (nonatomic, copy) NSString    *share_imageUrl;
/**分享的URL链接*/
@property (nonatomic, copy) NSString    *share_url;
/**分享标题*/
@property (nonatomic, copy) NSString    *share_title;

/**分享key*/
@property (nonatomic, strong) NSNumber  *share_key;

@property (nonatomic, strong) NSNumber  *w;
@property (nonatomic, strong) NSNumber  *h;

// 是否需要把分享结果通知服务端
@property (nonatomic, assign) BOOL      isNotifiService;
// 直播间ID
@property (nonatomic, copy) NSString    *roomIDStr;
// 直播间聊天组ID
@property (nonatomic, copy) NSString    *imChatIDStr;

@end
