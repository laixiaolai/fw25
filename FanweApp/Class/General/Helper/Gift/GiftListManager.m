//
//  GiftListManager.m
//  FanweApp
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GiftListManager.h"

@implementation GiftListManager

FanweSingletonM(Instance);

- (id)init
{
    @synchronized(self)
    {
        if (self = [super init])
        {
            //获取Documents目录
            NSString *docPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            //还要指定存储文件的文件名称,仍然使用字符串拼接
            NSString *filePath2 = [docPath2 stringByAppendingPathComponent:@"giftlist.plist"];
            NSDictionary *list = [NSDictionary dictionaryWithContentsOfFile:filePath2];
            
            if (list && [list isKindOfClass:[NSDictionary class]])
            {
                [self setGiftList:list];
            }
            else
            {
                self.expiry_after = 0;
                self.giftMArray = [NSArray array];
                
                [self loadGiftList];
            }
        }
        return self;
    }
}

- (void)saveGiftList:(NSDictionary *)dict
{
    [self setGiftList:dict];
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"giftlist.plist"];
    [dict writeToFile:filePath atomically:YES];
}

- (void)setGiftList:(NSDictionary*)list
{
    if(list != nil)
    {
        self.giftMArray = [list objectForKey:@"list"];
        self.expiry_after = [[list objectForKey:@"expiry_after"] doubleValue];
    }
}

#pragma mark 重新加载礼物列表
- (void)reloadGiftList
{
    if (_expiry_after)
    {
        if (!_giftMArray || [_giftMArray count])
        {
            [self loadGiftList];
        }
        else
        {
            if ([[NSDate date] timeIntervalSince1970] > _expiry_after)
            {
                [self loadGiftList];
            }
        }
    }
    else
    {
        [self loadGiftList];
    }
}

#pragma mark 下载礼物列表数据
- (void)loadGiftList
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"app" forKey:@"ctl"];
    [mDict setObject:@"prop" forKey:@"act"];
    
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        
        if ([responseJson toInt:@"status"] == 1)
        {
            NSMutableDictionary *tmpMdict = [NSMutableDictionary dictionaryWithDictionary:responseJson];
            [self saveGiftList:tmpMdict];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}


@end
