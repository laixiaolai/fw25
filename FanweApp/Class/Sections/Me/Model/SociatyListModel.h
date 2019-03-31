//
//  SociatyListModel.h
//  FanweApp
//
//  Created by 杨仁伟 on 2017/6/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SociatyListModel : NSObject

@property (nonatomic, copy)   NSString *society_chairman; //会长名称
@property (nonatomic, copy)   NSString *society_id; //公会ID
@property (nonatomic, copy)   NSString *society_image;
@property (nonatomic, copy)   NSString *society_name;
@property (nonatomic, copy)   NSString *society_user_count;
@property (nonatomic, copy)   NSString *gh_status;
@property (nonatomic, strong) NSNumber *type;

@end
