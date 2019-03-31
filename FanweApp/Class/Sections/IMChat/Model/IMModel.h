//
//  IMModel.h
//  FanweApp
//
//  Created by yy on 16/8/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMModel : NSObject

@property (nonatomic, copy) NSString *rs_count;      //记录总数
@property (nonatomic, copy) NSString *content;       //发送内容
@property (nonatomic, copy) NSString *create_date;   //时间
@property (nonatomic, assign) CGFloat contentHeight; //文本高度
@property (nonatomic, copy) NSString *send_user_name;
@property (nonatomic, copy) NSString *send_user_avatar; //头像

- (CGFloat)getHeight:(NSString *)content;

@end
