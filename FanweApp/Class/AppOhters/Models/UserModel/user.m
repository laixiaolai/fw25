//
//  user.m
//  ZCTest
//
//  Created by GuoMs on 15/12/11.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import "user.h"


@implementation user


+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static user *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        instance=[super allocWithZone:zone];
        instance.selectC=[NSIndexPath indexPathForRow:1 inSection:0];
    });
    
    return instance;
}

+ (instancetype)shareUser{
    
    return [[user alloc] init];
}



- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSLog(@"encodeWithCoder");
    [encoder encodeObject:self.CoreLock forKey:@"CoreLock"];
    [encoder encodeObject:self.user_pwd forKey:@"user_pwd"];
    [encoder encodeObject:self.user_name forKey:@"user_name"];
    [encoder encodeObject:self.first_login forKey:@"first_login"];
   
}


- (id)initWithCoder:(NSCoder *)decoder
{
    NSLog(@"initWithCoder");
    if (self = [super init]) {
        self.CoreLock = [decoder decodeObjectForKey:@"CoreLock"];
        self.user_pwd = [decoder decodeObjectForKey:@"user_pwd"];
        self.user_name = [decoder decodeObjectForKey:@"user_name"];
        self.first_login = [decoder decodeObjectForKey:@"first_login"];
      
    }
    return self;
}
- (void)save{
    [NSKeyedArchiver archiveRootObject:[user shareUser] toFile:SavePath];
}

@end
