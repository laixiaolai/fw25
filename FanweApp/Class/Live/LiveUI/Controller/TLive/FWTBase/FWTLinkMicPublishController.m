//
//  FWTLinkMicPublishController.m
//  FanweApp
//
//  Created by xfg on 2017/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWTLinkMicPublishController.h"

#define MAX_LINKMIC_MEMBER_SUPPORT  1

#define VIDEO_VIEW_WIDTH            120
#define VIDEO_VIEW_HEIGHT           160
#define VIDEO_VIEW_MARGIN_BOTTOM    70
#define VIDEO_VIEW_MARGIN_RIGHT     20

//小图标
#define BOTTOM_BTN_ICON_WIDTH  35


@implementation TCLivePlayListenerImpl

- (void)onPlayEvent:(int)evtID withParam:(NSDictionary*)param
{
    if (self.delegate)
    {
        [self.delegate onLivePlayEvent:self.playUrl withEvtID:evtID andParam:param];
    }
}

- (void)onNetStatus:(NSDictionary*) param
{
    if (self.delegate)
    {
        [self.delegate onLivePlayNetStatus:self.playUrl withParam:param];
    }
}

@end


@interface FWTLinkMicPublishController ()<ITCLivePlayListener>
{
    BOOL                    _isSupprotHardware;
}

@end


@implementation FWTLinkMicPublishController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _playItemArray = [NSMutableArray array];
    _linkMemeberSet = [NSMutableSet set];
    
    _isSupprotHardware = ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0);

    [self addLinkMicPlayItem];
}

- (void)addLinkMicPlayItem
{
    for (int i = 0; i<3; i++)
    {
        FWTLinkMicPlayItem* playItem = [[FWTLinkMicPlayItem alloc] init];
        playItem.videoView = [[UIView alloc] init];
        [self.view addSubview:playItem.videoView];
        
        playItem.livePlayListener = [[TCLivePlayListenerImpl alloc] init];
        playItem.livePlayListener.delegate = self;
        TXLivePlayConfig * playConfig0 = [[TXLivePlayConfig alloc] init];
        playItem.livePlayer = [[TXLivePlayer alloc] init];
        playItem.livePlayer.delegate = playItem.livePlayListener;
        [playItem.livePlayer setConfig: playConfig0];
        [playItem.livePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        playItem.pending = false;
        playItem.itemIndex = i;
        [playItem emptyPlayInfo];
        
        [_playItemArray addObject:playItem];
    }
}

#pragma mark - ----------------------- 推流模块 -----------------------
- (BOOL)startRtmp
{
    return [super startRtmp];
}

- (void)stopRtmp
{
    [super stopRtmp];
    
    for (FWTLinkMicPlayItem* playItem in _playItemArray)
    {
        [playItem stopPlay];
    }
}

#pragma mark - ----------------------- 连麦 -----------------------
#pragma mark 同意连麦
- (void)agreeLinkMick:(NSString *)streamPlayUrl applicant:(NSString *)userID
{
    self.txLivePushonfig.enableAEC = YES;
    [self.txLivePublisher setConfig:self.txLivePushonfig];
    
    if ([FWUtils isBlankString:streamPlayUrl] || [FWUtils isBlankString:userID])
    {
        return;
    }
}

#pragma mark 断开连麦
- (void)breakLinkMick:(NSString *)userID
{
    if (![FWUtils isBlankString:userID])
    {
        FWTLinkMicPlayItem *playItem = [self getPlayItemByUserID:userID];
        if (playItem)
        {
            [playItem stopPlay];
            [playItem emptyPlayInfo];
            
            if (_linkMicPublishDelegate && [_linkMicPublishDelegate respondsToSelector:@selector(playMickResult:userID:)])
            {
                [_linkMicPublishDelegate playMickResult:NO userID:userID];
            }
        }
    }
}

#pragma mark 调整连麦窗口
- (void)adjustPlayItem:(TLiveMickListModel *)mickListModel
{
    @synchronized (_linkMemeberSet)
    {
        [_linkMemeberSet removeAllObjects];
        
        if (!mickListModel.list_lianmai || [mickListModel.list_lianmai count] == 0)
        {
            for (FWTLinkMicPlayItem *playItem in _playItemArray)
            {
                [playItem stopPlay];
                [playItem stopLoading];
                [playItem emptyPlayInfo];
            }
            return;
        }
        
        for (TLiveMickModel *mickModel in mickListModel.list_lianmai)
        {
            BOOL isHasPlayItem = NO;
            FWTLinkMicPlayItem *tmpPlayItem;
            int i = 0;
            
            for (FWTLinkMicPlayItem *playItem in _playItemArray)
            {
                i ++;
                
                if ([playItem.userID isEqualToString:mickModel.user_id])
                {
                    isHasPlayItem = YES;
                    
                    TLiveMickLayoutParamModel *paramModel = mickModel.layout_params;
                    playItem.videoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                    
                    break;
                }
                
                if (([FWUtils isBlankString:playItem.userID] || i == [_playItemArray count]) && !tmpPlayItem)
                {
                    tmpPlayItem = playItem;
                }
            }
            
            if (!isHasPlayItem)
            {
                TLiveMickLayoutParamModel *paramModel = mickModel.layout_params;
                tmpPlayItem.videoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                
                [tmpPlayItem stopPlay];
                [tmpPlayItem emptyPlayInfo];
                
                tmpPlayItem.pending = YES;
                tmpPlayItem.isWorking = YES;
                tmpPlayItem.userID = mickModel.user_id;
                [tmpPlayItem setLoadingText:@"等待观众推流···"];
                [tmpPlayItem initLoadingView:tmpPlayItem.videoView];
                [tmpPlayItem startLoading];
                [tmpPlayItem startPlay:mickModel.play_rtmp2_acc];
            }
            
            //加入连麦成员列表
            [_linkMemeberSet addObject:mickModel.user_id];
        }
        
        for (FWTLinkMicPlayItem *playItem in _playItemArray)
        {
            if (!playItem.isWorking)
            {
                [playItem stopPlay];
                [playItem stopLoading];
                [playItem emptyPlayInfo];
            }
        }
        
        if ([_linkMemeberSet count] == 0 && self.txLivePushonfig.enableAEC)
        {
            self.txLivePushonfig.enableAEC = NO;
            [self.txLivePublisher setConfig:self.txLivePushonfig];
        }
    }
}

#pragma mark 通过用户ID来获取连麦视图
- (FWTLinkMicPlayItem *)getPlayItemByUserID:(NSString*)userID
{
    if (userID)
    {
        for (FWTLinkMicPlayItem* playItem in _playItemArray)
        {
            if ([userID isEqualToString:playItem.userID])
            {
                return playItem;
            }
        }
    }
    return nil;
}

- (FWTLinkMicPlayItem*)getPlayItemByStreamUrl:(NSString*)streamUrl
{
    if (streamUrl)
    {
        for (FWTLinkMicPlayItem* playItem in _playItemArray)
        {
            if ([streamUrl isEqualToString:playItem.playUrl])
            {
                return playItem;
            }
        }
    }
    return nil;
}

#pragma mark 连麦失败处理
- (void)handleLinkMicFailed:(NSString*)userID message:(NSString*)message
{
    if (userID)
    {
        FWTLinkMicPlayItem* playItem = [self getPlayItemByUserID:userID];
        if (playItem == nil)
        {
            return;
        }
        
        if (_linkMicPublishDelegate && [_linkMicPublishDelegate respondsToSelector:@selector(playMickResult:userID:)])
        {
            [_linkMicPublishDelegate playMickResult:NO userID:userID];
        }
        
        [playItem stopPlay];
        [playItem emptyPlayInfo];
        
        if (message != nil && message.length > 0)
        {
            [self toastTip:message];
        }
    }
}


#pragma mark - ----------------------- ITCLivePlayListener代理事件 -----------------------
- (void)onLivePlayEvent:(NSString*)strStreamUrl withEvtID:(int)event andParam:(NSDictionary*)param
{
    if (event != PLAY_EVT_PLAY_PROGRESS)
    {
        NSLog(@"==========playEvtID2:%d",event);
    }
    
    FWTLinkMicPlayItem * playItem = [self getPlayItemByStreamUrl:strStreamUrl];
    if (playItem == nil)
    {
        return;
    }
    
    if (event == PLAY_EVT_PLAY_BEGIN)
    {
        if (playItem.pending == YES)
        {
            playItem.pending = NO;
            [playItem stopLoading];
            
            if (_linkMicPublishDelegate && [_linkMicPublishDelegate respondsToSelector:@selector(playMickResult:userID:)])
            {
                [_linkMicPublishDelegate playMickResult:YES userID:playItem.userID];
            }
        }
    }
    else if (event == PLAY_EVT_PLAY_END)
    {
        [playItem stopLoading];
        
        if (playItem.pending == YES)
        {
            [self handleLinkMicFailed:playItem.userID message:@"拉流失败，结束连麦"];
        }
        else
        {
            [self handleLinkMicFailed:playItem.userID message:@"连麦观众视频断流，结束连麦"];
        }
    }
    else if (event == PLAY_ERR_NET_DISCONNECT)
    {
        [playItem stopLoading];
        
        [FWLiveSDKViewModel tLiveStopMick:_roomIDStr toUserId:playItem.userID];
        
        if (playItem.pending == YES)
        {
            [self handleLinkMicFailed:playItem.userID message:@"拉流失败，结束连麦"];
        }
        else
        {
            [self handleLinkMicFailed:playItem.userID message:@"连麦观众视频断流，结束连麦"];
        }
    }
    else if (event == PLAY_ERR_GET_RTMP_ACC_URL_FAIL)
    {
        if (playItem.reStartTimes < 5)
        {
            [playItem reStartPlay];
        }
        else
        {
            [playItem stopLoading];
            
            [FWLiveSDKViewModel tLiveStopMick:_roomIDStr toUserId:playItem.userID];
            
            if (playItem.pending == YES)
            {
                [self handleLinkMicFailed:playItem.userID message:@"拉流失败，结束连麦"];
            }
            else
            {
                [self handleLinkMicFailed:playItem.userID message:@"连麦观众视频断流，结束连麦"];
            }
        }
        playItem.reStartTimes ++;
    }
    else if (event == PUSH_WARNING_HW_ACCELERATION_FAIL || event == PLAY_WARNING_HW_ACCELERATION_FAIL)
    {
        [playItem stopLoading];
        
        [self handleLinkMicFailed:playItem.userID message:@"系统不支持硬编或硬解"];
        _isSupprotHardware = NO;
    }
}

- (void)onLivePlayNetStatus:(NSString*)playUrl withParam:(NSDictionary*)param
{
    
}


@end
