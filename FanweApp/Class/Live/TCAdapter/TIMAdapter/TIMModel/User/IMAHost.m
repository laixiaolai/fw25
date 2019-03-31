//
//  IMAHost.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAHost.h"

@implementation IMAHost

- (void)getMyInfo:(AppCommonBlock)block
{
    _reloadUserInfoTimes ++;
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"userinfo" forKey:@"act"];
    
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        
        NSDictionary *user = [responseJson objectForKey:@"user"];
        if (user && [user isKindOfClass:[NSDictionary class]])
        {
            TIMUserProfile *selfProfile = [[TIMUserProfile alloc]init];
            selfProfile.identifier = [user toString:@"user_id"];
            selfProfile.nickname = [user toString:@"nick_name"];
            selfProfile.faceURL = [user toString:@"head_image"];
            
            self.is_robot = [[user toString:@"is_robot"] boolValue];
            self.profile = selfProfile;
            self.profile.customInfo = user;
            self.customInfoDict = [NSMutableDictionary dictionaryWithDictionary:user];
            
            if (block)
            {
                AppBlockModel *blockModel = [AppBlockModel manager];
                blockModel.retDict = responseJson;
                blockModel.status = 1;
                block(blockModel);
            }
        }
        else
        {
            if (_reloadUserInfoTimes < 10)
            {
                [self performSelector:@selector(getMyInfo:) withObject:nil afterDelay:1];
            }
            
            if (block)
            {
                block([AppBlockModel manager]);
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
        if (block)
        {
            block([AppBlockModel manager]);
        }
        
    }];
}

- (void)setLoginParm:(TIMLoginParam *)loginParm
{
    _loginParm = loginParm;
    [_loginParm saveToLocal];
}

- (NSString *)userId
{
    return _profile ? _profile.identifier : _loginParm.identifier;
}

- (NSString *)icon
{
    return [NSString isEmpty:_profile.faceURL] ? nil : _profile.faceURL;
}

- (NSString *)remark
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}

- (NSString *)name
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}

- (NSString *)nickName
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual)
    {
        if ([object conformsToProtocol:@protocol(IMUserAble)])
        {
            id<IMUserAble> io = (id<IMUserAble>)object;
            isEqual = [[self imUserId] isEqualToString:[io imUserId]];
        }
    }
    return isEqual;
}

// 用户IMSDK的identigier
- (NSString *)imUserId
{
    return [self userId];
}

// 用户昵称
- (NSString *)imUserName
{
    return [self nickName];
}

// 用户头像地址
- (NSString *)imUserIconUrl
{
    return [self icon];
}

// 当前App对应的AppID
- (NSString *)imSDKAppId
{
    return TXYSdkAppId;
}

// 当前App的AccountType
- (NSString *)imSDKAccountType
{
    return TXYSdkAccountType;
}

- (long)getDiamonds
{
    return [[self.customInfoDict objectForKey:@"diamonds"] intValue];
}

- (void)setDiamonds:(NSString *)diamonds
{
    [self.customInfoDict setObject:diamonds forKey:@"diamonds"];
}

// 获取等级
- (long)getUserRank
{
    return [[self.customInfoDict objectForKey:@"user_level"] intValue];
}

// 设置等级
- (void)setUserRank:(NSString *)rank
{
    [self.customInfoDict setObject:rank forKey:@"user_level"];
}

- (long)getUserCoin
{
    if ([GlobalVariables sharedInstance].appModel.open_diamond_game_module == 1)
    {
        return [[self.customInfoDict objectForKey:@"diamonds"] intValue];
    }
    else
    {
        return [[self.customInfoDict objectForKey:@"coin"] intValue];
    }
}

- (void)setUserCoin:(NSString *)coin
{
    if ([GlobalVariables sharedInstance].appModel.open_diamond_game_module == 1)
    {
        [self.customInfoDict setObject:coin forKey:@"diamonds"];
    }
    else
    {
        [self.customInfoDict setObject:coin forKey:@"coin"];
    }
}

- (BOOL)isMe:(IMAUser *)user
{
    return [self.userId isEqualToString:user.userId];
}

@end
