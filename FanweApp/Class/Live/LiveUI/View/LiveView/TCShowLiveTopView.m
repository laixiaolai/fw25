//
//  TCShowLiveTopView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveTopView.h"

#pragma mark - ----------------------- 内部类 TCShowLiveTimeView -----------------------
@implementation TCShowLiveTimeView

- (void)dealloc
{
    NSLog(@"11");
}

#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _liveItem = liveItem;
        _isHost = [liveItem isHost];
        
        [self addOwnViews];
        [self configOwnViews];
        self.backgroundColor = kGrayTransparentColor2;
        self.layer.cornerRadius = kLogoContainerViewHeight/2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    _isHost = [liveItem isHost];
    
    [self setHostVIcon:liveInfo];
}

- (void)addOwnViews
{
    _hostHeadBtn = [[MenuButton alloc] init];
    _hostHeadBtn.layer.masksToBounds = YES;
    [self addSubview:_hostHeadBtn];
    
    _hostVImgView = [[UIImageView alloc]init];
    [self addSubview:_hostVImgView];
    
    _liveTitle = [[UILabel alloc] init];
    _liveTitle.userInteractionEnabled = YES;
    _liveTitle.font = kAppSmallerTextFont;
    _liveTitle.textAlignment = NSTextAlignmentCenter;
    _liveTitle.textColor = kWhiteColor;
    _liveTitle.text = @"加载中...";
    [self addSubview:_liveTitle];
    
    _liveAudience = [[UILabel alloc] init];
    _liveAudience.userInteractionEnabled = YES;
    _liveAudience.font = kAppSmallerTextFont;
    _liveAudience.textAlignment = NSTextAlignmentCenter;
    _liveAudience.textColor = kWhiteColor;
    _liveAudience.text = @"0";
    [self addSubview:_liveAudience];
    
    _liveFollow = [[UIButton alloc] init];
    _liveFollow.titleLabel.font = kAppSmallerTextFont;
    _liveFollow.backgroundColor = kAppSecondaryColor;
    [_liveFollow setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    [_liveFollow setTitle:@"关注" forState:UIControlStateNormal];
    [self addSubview:_liveFollow];
}

#pragma mark 设置主播认证图标
- (void)setHostVIcon:(CurrentLiveInfo *)currentLiveInfo
{
    if ([currentLiveInfo.podcast.user.is_authentication intValue] == 2)
    {
        NSString *vIcon = currentLiveInfo.podcast.user.v_icon;
        
        if (vIcon && ![vIcon isEqualToString:@""])
        {
            _hostVImgView.hidden = NO;
            [_hostVImgView sd_setImageWithURL:[NSURL URLWithString:vIcon]];
        }
        else
        {
            _hostVImgView.hidden = YES;
        }
    }
}

- (void)configOwnViews
{
    NSString *url = [[_liveItem liveHost] imUserIconUrl];
    [_hostHeadBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
}

- (void)relayoutFrameOfSubViews
{
    _hostHeadBtn.frame = CGRectMake(2, (self.frame.size.height-kLogoContainerViewHeight+4)/2, kLogoContainerViewHeight-4, kLogoContainerViewHeight-4);
    _hostHeadBtn.layer.cornerRadius = _hostHeadBtn.frame.size.width/2;
    
    _hostVImgView.frame = CGRectMake(CGRectGetMaxX(_hostHeadBtn.frame)-kViconWidthOrHeight, CGRectGetMaxY(_hostHeadBtn.frame)-kViconWidthOrHeight, kViconWidthOrHeight, kViconWidthOrHeight);
    
    _liveTitle.frame = CGRectMake(kLogoContainerViewHeight, 0, kLiveStatusViewWidth, kLogoContainerViewHeight/2);
    
    _liveAudience.frame = CGRectMake(CGRectGetMaxX(_hostHeadBtn.frame), self.frame.size.height-kLogoContainerViewHeight/2, kLiveStatusViewWidth, kLogoContainerViewHeight/2);
    
    _liveFollow.frame = CGRectMake(CGRectGetMaxX(_liveAudience.frame), (self.frame.size.height-22)/2, kFollowBtnWidth, 22);
    _liveFollow.layer.cornerRadius = _liveFollow.frame.size.height/2;
}

- (void)onImUsersEnterLive
{
    NSString *audience = _liveAudience.text;
    if (audience && ![audience isEqualToString:@""])
    {
        audience = StringFromInt([audience intValue]+1);
    }
    else
    {
        audience = @"1";
    }
    
    _liveAudience.text = audience;
}

- (void)onImUsersExitLive
{
    NSString *audience = _liveAudience.text;
    if (audience && ![audience isEqualToString:@""] && [audience intValue])
    {
        audience = StringFromInt([audience intValue]-1);
    }
    else
    {
        audience = @"0";
    }
    _liveAudience.text = audience;
}

@end


#pragma mark - ----------------------- 内部类 LiveUserViewCell -----------------------
@interface LiveUserViewCell : UICollectionViewCell
{
    MenuButton        *_userIcon;
    UIImageView       *_vImgView;
}

@property (nonatomic, readonly) MenuButton *userIcon;
@property (nonatomic, readonly) UIImageView *vImgView; // 观众认证图标

@end

@implementation LiveUserViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _userIcon = [[MenuButton alloc] init];
        _userIcon.clipsToBounds = YES;
        _userIcon.backgroundColor = [UIColor clearColor];
        _userIcon.layer.cornerRadius = kLogoContainerViewHeight/2;
        _userIcon.layer.masksToBounds = YES;
        _userIcon.userInteractionEnabled = YES;
        [self.contentView addSubview:_userIcon];
        
        _vImgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-kViconWidthOrHeight, frame.size.height-kViconWidthOrHeight, kViconWidthOrHeight, kViconWidthOrHeight)];
        _vImgView.layer.cornerRadius = kViconWidthOrHeight/2;
        _vImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_vImgView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    _userIcon.frame = rect;
}

@end



#pragma mark - ----------------------- TCShowLiveTopView -----------------------
@implementation TCShowLiveTopView

#pragma mark - ----------------------- 直播生命周期 -----------------------
- (void)releaseAll
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_liveRateTimer)
    {
        [_liveRateTimer invalidate];
        _liveRateTimer = nil;
    }
    
    _liveItem = nil;
    _timeView.liveItem = nil;
}
- (void)dealloc
{
    [self releaseAll];
}

#pragma mark 开始直播
- (void)startLive
{
    
}

#pragma mark 暂停直播
- (void)pauseLive
{
    if (_liveRateTimer)
    {
        [_liveRateTimer invalidate];
        _liveRateTimer = nil;
    }
}

#pragma mark 重新开始直播
- (void)resumeLive
{
    [self monitorRateKBPS];
}

#pragma mark 结束直播
- (void)endLive
{
    [self releaseAll];
}

#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _liveItem = liveItem;
        _isHost = [liveItem isHost];
        _groupIdStr = [_liveItem liveIMChatRoomId];
        
        _httpManager = [NetHttpsManager manager];
        _userArray = [NSMutableArray array];
        
        _timeView = [[TCShowLiveTimeView alloc] initWith:liveItem liveController:liveController];
        
        [self addOwnViewsWith:_liveItem];
        
        [self monitorRateKBPS];
        
    }
    return self;
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    _isHost = [liveItem isHost];
    _groupIdStr = [_liveItem liveIMChatRoomId];
    
    _is_private = liveInfo.is_private;
    _has_admin = (int)liveInfo.podcast.has_admin;
    
    [_timeView refreshLiveItem:_liveItem liveInfo:liveInfo];
    
    _ticketNumLabel.text = liveInfo.podcast.user.ticket;
    
    if (![FWUtils isBlankString:liveInfo.video_title])
    {
        _timeView.liveTitle.text = liveInfo.video_title;
    }
    else
    {
        if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            _timeView.liveTitle.text = @"精彩回放";
        }
        else
        {
            _timeView.liveTitle.text = @"直播Live";
        }
    }
    
    // 当前直播间是否在竞拍
    if (liveInfo.pai_id == 0)
    {
        self.accountLabel.hidden = NO;
    }
    
    if ([liveInfo.luck_num intValue] > 1)
    {
        _accountLabel.text = [NSString stringWithFormat:@"%@:%@",[GlobalVariables sharedInstance].appModel.account_name,liveInfo.luck_num];
    }
    else
    {
        if (liveInfo.user_id.length > 1)
        {
            _accountLabel.text = [NSString stringWithFormat:@"%@:%@",[GlobalVariables sharedInstance].appModel.account_name,liveInfo.user_id];
        }
    }
    
    [_timeView.hostHeadBtn sd_setImageWithURL:[NSURL URLWithString:liveInfo.podcast.user.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
    
    if (!_isHost && liveInfo.podcast.has_focus == 0 && ![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        _isShowFollowBtn = YES;
    }
    
    [self relayoutOtherContainerViewFrame];
    [self relayoutFrameOfSubViews];
    
    [self.collectionView reloadData];
}

#pragma mark - ----------------------- 观众进、退操作 -----------------------

#pragma mark 首次获取观众列表
- (void)refreshAudienceList:(NSDictionary *)responseJson
{
    NSArray *array = [[responseJson objectForKey:@"viewer"] objectForKey:@"list"];
    if (array && [array isKindOfClass:[NSArray class]])
    {
        if ([array count])
        {
            NSMutableArray* userArray = [NSMutableArray array];
            for (NSDictionary *dict in array)
            {
                if (![[dict toString:@"user_id"] isEqualToString:[[_liveItem liveHost] imUserId]])
                {
                    UserModel *audience = [UserModel mj_objectWithKeyValues:dict];
                    [userArray addObject:audience];
                }
            }
            _userArray = userArray;
        }
    }
    
    FWWeakify(self)
    [UIView animateWithDuration:0 animations:^{
        
        FWStrongify(self)
        [self.collectionView reloadData];
        
    }];
    
    [self performSelector:@selector(setupLiveAudience:) withObject:[[responseJson objectForKey:@"viewer"] toString:@"watch_number"] afterDelay:0.3];
}

#pragma mark 初始化观众数量、列表
- (void)setupLiveAudience:(NSString *)watch_number
{
    if (![FWUtils isBlankString:watch_number])
    {
        if ([watch_number intValue] >= [_collectionView numberOfItemsInSection:0])
        {
            [_timeView.liveAudience setText:watch_number];
        }
        else
        {
            int numCount;
            if (_is_private)
            {
                numCount = (int)([_collectionView numberOfItemsInSection:0]-2);
            }
            else
            {
                numCount = (int)[_collectionView numberOfItemsInSection:0];
                [_timeView.liveAudience setText:StringFromInt(numCount)];
            }
        }
    }
    else
    {
        if ([_collectionView numberOfItemsInSection:0])
        {
            int numCount;
            if (_is_private)
            {
                numCount = (int)([_collectionView numberOfItemsInSection:0]-2);
            }
            else
            {
                numCount = (int)[_collectionView numberOfItemsInSection:0];
                [_timeView.liveAudience setText:StringFromInt(numCount)];
            }
        }
        else
        {
            _timeView.liveAudience.text = @"0";
        }
    }
}

#pragma mark 刷新观众列表
- (void)refreshLiveAudienceList:(CustomMessageModel *)customMessageModel
{
    if (customMessageModel.data && [customMessageModel.data isKindOfClass:[NSDictionary class]])
    {
        // 当 data_type == 1，主播、所有连麦观众收到的定时连麦消息
        if (customMessageModel.data_type == 0)
        {
            if ([GlobalVariables sharedInstance].refreshAudienceListTime < [[customMessageModel.data objectForKey:@"time"] longValue])
            {
                [GlobalVariables sharedInstance].refreshAudienceListTime = [[customMessageModel.data objectForKey:@"time"] longValue];
                
                NSArray *keyArray = [customMessageModel.data objectForKey:@"list_fields"];
                NSArray *valueAllArray = [customMessageModel.data objectForKey:@"list_data"];
                if (keyArray && [keyArray isKindOfClass:[NSArray class]] && valueAllArray && [valueAllArray isKindOfClass:[NSArray class]])
                {
                    [_userArray removeAllObjects];  // 清空头像的数组
                    if ([keyArray count] && [valueAllArray count])
                    {
                        NSMutableArray* userArray = [NSMutableArray array];
                        for (NSArray *valueArray in valueAllArray)
                        {
                            NSString *user_id;
                            if ([keyArray containsObject:@"user_id"])
                            {
                                user_id = [valueArray objectAtIndex:[keyArray indexOfObject:@"user_id"]];
                            }
                            
                            if (user_id)
                            {
                                if (![user_id isEqualToString:[[_liveItem liveHost] imUserId]])
                                {
                                    UserModel *userModel = [[UserModel alloc] init];
                                    userModel.user_id = user_id;
                                    
                                    if ([keyArray containsObject:@"user_level"])
                                    {
                                        userModel.user_level = [valueArray objectAtIndex:[keyArray indexOfObject:@"user_level"]];
                                    }
                                    
                                    if ([keyArray containsObject:@"head_image"])
                                    {
                                        NSString *headStr = [valueArray objectAtIndex:[keyArray indexOfObject:@"head_image"]];
                                        if (![FWUtils isBlankString:headStr])
                                        {
                                            if ([headStr hasPrefix:@"http://"] || [headStr hasPrefix:@"https://"])
                                            {
                                                userModel.head_image = headStr;
                                            }
                                            else
                                            {
                                                userModel.head_image = [NSString stringWithFormat:@"%@%@",[customMessageModel.data objectForKey:@"short_url"],headStr];
                                            }
                                        }
                                    }
                                    
                                    if ([keyArray containsObject:@"v_icon"])
                                    {
                                        NSString *iconStr = [valueArray objectAtIndex:[keyArray indexOfObject:@"v_icon"]];
                                        if (![FWUtils isBlankString:iconStr])
                                        {
                                            if ([iconStr hasPrefix:@"http://"] || [iconStr hasPrefix:@"https://"])
                                            {
                                                userModel.v_icon = iconStr;
                                            }
                                            else
                                            {
                                                userModel.v_icon = [NSString stringWithFormat:@"%@%@",[customMessageModel.data objectForKey:@"short_url"],iconStr];
                                            }
                                        }
                                    }
                                    
                                    if ([keyArray containsObject:@"is_authentication"])
                                    {
                                        userModel.is_authentication = [valueArray objectAtIndex:[keyArray indexOfObject:@"is_authentication"]];
                                    }
                                    
                                    [userArray addObject:userModel];
                                }
                            }
                        }
                        _userArray = userArray;
                    }
                    
                    FWWeakify(self)
                    [UIView animateWithDuration:0 animations:^{
                        
                        FWStrongify(self)
                        [self.collectionView reloadData];
                        
                    }];
                    
                    [self performSelector:@selector(setupLiveAudience:) withObject:[customMessageModel.data toString:@"watch_number"] afterDelay:0.3];
                }
            }
        }
    }
}

- (UserModel *)getUserOf:(NSString *)sender
{
    if (sender.length)
    {
        for(UserModel *user in _userArray)
        {
            if([user.user_id isEqualToString:sender])
            {
                return user;
            }
        }
    }
    return nil;
}

#pragma mark 观众进入直播间
- (void)onImUsersEnterLive:(UserModel *)userModel
{
    [_timeView onImUsersEnterLive];
    
    if (userModel)
    {
        [self addUsers:userModel];
    }
}

#pragma mark 添加用户
- (void)addUsers:(UserModel *)lu
{
    if (lu)
    {
        @synchronized(_userArray)
        {
            UserModel *liu = [self getUserOf:lu.user_id];
            if (liu)
            {
                @try {
                    
                    NSInteger tmpIndex = [_userArray indexOfObject:liu];
                    if (tmpIndex <= [_userArray count])
                    {
                        [_userArray replaceObjectAtIndex:tmpIndex withObject:lu];
                    }
                    
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
                [UIView animateWithDuration:0 animations:^{
                    [_collectionView reloadData];
                }];
            }
            else
            {
                if ([_userArray count])
                {
                    NSInteger tmpIndex = 0;
                    NSInteger user_level = 0;
                    
                    if ([lu.sort_num intValue])
                    {
                        user_level = [lu.sort_num intValue];
                    }
                    else
                    {
                        user_level = [lu.user_level intValue];
                    }
                    
                    for (NSInteger i=0; i<[_userArray count]; i++) {
                        UserModel *um = [_userArray objectAtIndex:i];
                        if (user_level >= [um.user_level intValue])
                        {
                            tmpIndex = i;
                            
                            break;
                        }
                        else if (i == [_userArray count]-1)
                        {
                            tmpIndex = i;
                        }
                    }
                    
                    @try {
                        
                        if (tmpIndex <= [_userArray count])
                        {
                            [_userArray insertObject:lu atIndex:tmpIndex];
                            
                            [UIView animateWithDuration:0 animations:^{
                                [_collectionView reloadData];
                            }];
                        }
                        
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    
                }else{
                    [_userArray addObject:lu];
                    [UIView animateWithDuration:0 animations:^{
                        [_collectionView reloadData];
                    }];
                }
            }
        }
    }
}

#pragma mark 观众退出直播间
- (void)onImUsersExitLive:(UserModel *)userModel
{
    [_timeView onImUsersExitLive];
    
    if (userModel)
    {
        [self deleteUsers:userModel];
    }
}

#pragma mark 删除用户
- (void)deleteUsers:(UserModel *)lu
{
    if (lu)
    {
        @synchronized(_userArray)
        {
            UserModel *liu = [self getUserOf:lu.user_id];
            if (liu)
            {
                [_userArray removeObject:liu];
                
                [UIView animateWithDuration:0 animations:^{
                    [_collectionView reloadData];
                }];
            }
        }
    }
}


#pragma mark - ----------------------- 初始化界面 -----------------------
- (void)addOwnViewsWith:(id<FWShowLiveRoomAble>)room
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kLogoContainerViewHeight, kLogoContainerViewHeight);
    layout.minimumLineSpacing = kDefaultMargin-2;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[LiveUserViewCell class] forCellWithReuseIdentifier:@"LiveUserViewCell"];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    @synchronized (_userArray)
    {
        [UIView animateWithDuration:0 animations:^{
            [_collectionView reloadData];
        }];
    }
    
    __weak TCShowLiveTopView *ws = self;
    [_timeView.hostHeadBtn setClickAction:^(id<MenuAbleItem> menu) {
        [ws clickLiveHost];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLiveHost)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_timeView.liveTitle addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLiveHost)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [_timeView.liveAudience addGestureRecognizer:tap2];
    
    if (![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[room liveHost] imUserId]]) {
        [_timeView.liveFollow addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self addSubview:_timeView];
    
    // 印票
    _otherContainerView = [[UIView alloc]init];
    _otherContainerView.frame = CGRectMake(0, 0, 0, kTicketContrainerViewHeight);
    _otherContainerView.layer.cornerRadius = _otherContainerView.frame.size.height/2;
    _otherContainerView.backgroundColor = kGrayTransparentColor2;
    _otherContainerView.clipsToBounds = YES;
    [self addSubview:_otherContainerView];
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToContribution)];
    [_otherContainerView addGestureRecognizer:sigleTap];
    
    _ticketNameLabel = [[UILabel alloc]init];
    _ticketNameLabel.textColor = kWhiteColor;
    _ticketNameLabel.font = [UIFont systemFontOfSize:14.0];
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    _ticketNameLabel.text = [NSString stringWithFormat:@"%@ : ",fanweApp.appModel.ticket_name];
    [_otherContainerView addSubview:_ticketNameLabel];
    
    _ticketNumLabel = [[UILabel alloc]init];
    _ticketNumLabel.textColor = kWhiteColor;
    _ticketNumLabel.font = [UIFont systemFontOfSize:14.0];
    _ticketNumLabel.text = @"0";
    [_otherContainerView addSubview:_ticketNumLabel];
    
    _moreImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lr_top_arrow_right"]];
    [_otherContainerView addSubview:_moreImgView];
    
    // 最高价（竞拍模块）
    _priceView = [[UIView alloc]init];
    _priceView.frame = CGRectMake(0, 0, 0, kTicketContrainerViewHeight);
    _priceView.layer.cornerRadius = _priceView .bounds.size.height/2;
    _priceView.backgroundColor = kGrayTransparentColor2;
    _priceView.clipsToBounds = YES;
    _priceView.userInteractionEnabled = YES;
    [self addSubview:_priceView];
    _priceView.hidden = YES;
    UITapGestureRecognizer *otherTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToAuction)];
    [_priceView addGestureRecognizer:otherTap];
    
    _titleNameLabel= [[UILabel alloc]init];
    _titleNameLabel.textColor = kWhiteColor;
    _titleNameLabel.font = [UIFont systemFontOfSize:15.0];
    [_priceView addSubview:_titleNameLabel];
    
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.textColor = kWhiteColor;
    _priceLabel.font = [UIFont systemFontOfSize:15.0];
    [_priceView addSubview:_priceLabel];
    
    _otherMoreView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lr_top_arrow_right"]];
    [_priceView addSubview:_otherMoreView];
    
    // 账号
    _accountLabel = [[UILabel alloc]init];
    _accountLabel.textColor = RGBA(255, 255, 255, 0.52);
    _accountLabel.font = [UIFont systemFontOfSize:13.0];
    _accountLabel.textAlignment = NSTextAlignmentRight;
    _accountLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _accountLabel.shadowOffset = CGSizeMake(1, 1);
    [self addSubview:_accountLabel];
    
    // 推拉流码率
    _kbpsContainerView = [[UIView alloc]init];
    _kbpsContainerView.frame = CGRectMake(0, 0, 100, kTicketContrainerViewHeight+6);
    _kbpsContainerView.backgroundColor = kClearColor;
    _kbpsContainerView.clipsToBounds = YES;
    [self addSubview:_kbpsContainerView];
    
    _kbpsSendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_kbpsContainerView.frame), CGRectGetHeight(_kbpsContainerView.frame)/2)];
    _kbpsSendLabel.textColor = kWhiteColor;
    _kbpsSendLabel.font = [UIFont systemFontOfSize:9.0];
    _kbpsSendLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _kbpsSendLabel.shadowOffset = CGSizeMake(1, 1);
    [_kbpsContainerView addSubview:_kbpsSendLabel];
    
    _kbpsRecvLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_kbpsContainerView.frame), CGRectGetHeight(_kbpsContainerView.frame)/2)];
    _kbpsRecvLabel.textColor = kWhiteColor;
    _kbpsRecvLabel.font = [UIFont systemFontOfSize:9.0];
    _kbpsRecvLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _kbpsRecvLabel.shadowOffset = CGSizeMake(1, 1);
    [_kbpsContainerView addSubview:_kbpsRecvLabel];
}

- (void)relayoutFrameOfSubViews
{
    CGFloat tmpWidth = 0;
    if (_isShowFollowBtn)
    {
        tmpWidth = kLogoContainerViewHeight+kLiveStatusViewWidth+kFollowBtnWidth+kDefaultMargin-2;
        _timeView.liveFollow.hidden = NO;
    }
    else
    {
        tmpWidth = kLogoContainerViewHeight+kLiveStatusViewWidth+kDefaultMargin-2;
        _timeView.liveFollow.hidden = YES;
    }
    _timeView.frame = CGRectMake(kDefaultMargin, kDefaultMargin/2, tmpWidth, kLogoContainerViewHeight+2);
    [_timeView relayoutFrameOfSubViews];
    
    _collectionView.frame = CGRectMake(CGRectGetMaxX(_timeView.frame)+kDefaultMargin, CGRectGetMinY(_timeView.frame), (self.frame.size.width-CGRectGetMaxX(_timeView.frame)-kDefaultMargin-kLogoContainerViewHeight-kDefaultMargin*2), CGRectGetHeight(_timeView.frame));
    
    _accountLabel.frame = CGRectMake((self.frame.size.width-self.frame.size.width/2-kDefaultMargin), CGRectGetMaxY(_collectionView.frame)+kDefaultMargin, self.frame.size.width/2, _otherContainerView.frame.size.height);
    
    [self relayoutOtherContainerViewFrame];
}

- (void)relayoutOtherContainerViewFrame
{
    CGSize ticketNameSize = [_ticketNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
    
    CGSize ticketNumSize = [_ticketNumLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
    
    _ticketNameLabel.frame = CGRectMake(kDefaultMargin, 0, ticketNameSize.width, CGRectGetHeight(_otherContainerView.frame));
    
    _ticketNumLabel.frame = CGRectMake(CGRectGetMaxX(_ticketNameLabel.frame)+2, 0, ticketNumSize.width+2, CGRectGetHeight(_otherContainerView.frame));
    
    _moreImgView.frame = CGRectMake(CGRectGetMaxX(_ticketNumLabel.frame)+4, (CGRectGetHeight(_otherContainerView.frame)-9)/2, 5, 9);
    
    _otherContainerView.frame = CGRectMake(kDefaultMargin, CGRectGetMaxY(_collectionView.frame)+kAppMargin2, CGRectGetMaxX(_moreImgView.frame)+kDefaultMargin, kTicketContrainerViewHeight);
    
    CGSize titleNameSize = [_titleNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
    
    CGSize priceSize = [_priceLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
    
    _titleNameLabel.frame = CGRectMake(kDefaultMargin, 0, titleNameSize.width, _priceView.frame.size.height);
    
    _priceLabel.frame = CGRectMake(CGRectGetMaxX(_titleNameLabel.frame)+kDefaultMargin, 0, priceSize.width, CGRectGetHeight(_priceView.frame));
    
    _otherMoreView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame)+4, (CGRectGetHeight(_priceView.frame)-9)/2, 5, 9);
    
    _priceView.frame = CGRectMake(kDefaultMargin, CGRectGetMaxY(_otherContainerView.frame)+kAppMargin2, CGRectGetMaxX(_otherMoreView.frame)+kDefaultMargin, kTicketContrainerViewHeight);
    
    CGRect newFrame = _kbpsContainerView.frame;
    newFrame.origin.x = CGRectGetMaxX(_otherContainerView.frame)+kDefaultMargin;
    newFrame.origin.y = CGRectGetMinY(_otherContainerView.frame) -3;
    _kbpsContainerView.frame = newFrame;
}


#pragma mark - ----------------------- UICollectionViewDataSource -----------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    @synchronized(_userArray)
    {
        if ([self.is_private isEqualToString:@"1"])//判断是否是私密来返回不同的数据源
        {
            if (![[[_liveItem liveHost] imUserId] isEqualToString:[IMAPlatform sharedInstance].host.imUserId] && self.has_admin == 0)//是否是私密直播的管理员
            {
                if (_userArray.count > 0)
                {
                    return _userArray.count;
                }else
                {
                    return 0;
                }
            }else
            {
                if (_userArray.count > 0)
                {
                    return _userArray.count+2;
                }else
                {
                    return 2;
                }
            }
            
        }else
        {
            if (_userArray.count > 0)
            {
                return _userArray.count;
            }else
            {
                return 0;
            }
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @synchronized(_userArray)
    {
        LiveUserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveUserViewCell" forIndexPath:indexPath];
        [cell sizeToFit];
        
        UserModel *audience;
        
        if ([self.is_private isEqualToString:@"1"])//是否私密
        {
            if (![[[_liveItem liveHost] imUserId] isEqualToString:[IMAPlatform sharedInstance].host.imUserId] && self.has_admin == 0)//是否是私密直播的管理员
            {
                audience = _userArray[indexPath.row];
                [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:audience.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
            }else
            {
                if (indexPath.row == 0){
                    [cell.userIcon setImage:[UIImage imageNamed:@"ic_live_add_viewer"] forState:0];
                }else if (indexPath.row == 1)
                {
                    [cell.userIcon setImage:[UIImage imageNamed:@"ic_live_minus_viewer"] forState:0];
                }else
                {
                    audience = _userArray[indexPath.row-2];
                    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:audience.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
                }
            }
        }else
        {
            audience = _userArray[indexPath.row];
            [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:audience.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
        }
        if ([audience.is_authentication integerValue] == 2)
        {
            cell.vImgView.hidden = NO;
            [cell.vImgView sd_setImageWithURL:[NSURL URLWithString:audience.v_icon]];
        }
        else
        {
            cell.vImgView.hidden = YES;
        }
        cell.userInteractionEnabled = YES;
        cell.userIcon.tag = indexPath.row;
        __weak TCShowLiveTopView *ws = self;
        [cell.userIcon setClickAction:^(id<MenuAbleItem> menu) {
            [ws userIconAction:menu];
        }];
        return cell;
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (void)userIconAction:(id)sender
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(clickTopViewUserHeaderMustQuitAllHalfVC:)])
    {
        [_toServicedelegate clickTopViewUserHeaderMustQuitAllHalfVC:self];
    }
    
    MenuButton *userIcon = (MenuButton *)sender;
    
    if ([self.is_private isEqualToString:@"1"])//判断是否是私密
    {
        if (![[[_liveItem liveHost] imUserId] isEqualToString:[IMAPlatform sharedInstance].host.imUserId] && self.has_admin == 0)//是否是私密直播的管理员
        {
            if (userIcon.tag < [_userArray count])
            {
                UserModel *userModel = [_userArray objectAtIndex:userIcon.tag];
                if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:userModel:)])
                {
                    [_toServicedelegate onTopView:self userModel:userModel];
                }
            }
        }else
        {
            if (userIcon.tag == 0 || userIcon.tag == 1)//+ -
            {
                if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:andCount:)])
                {
                    [_toServicedelegate onTopView:self andCount:(int)userIcon.tag];
                }
            }
            else
            {
                if (userIcon.tag < [_userArray count]+2)
                {
                    UserModel *userModel = [_userArray objectAtIndex:userIcon.tag-2];
                    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:userModel:)])
                    {
                        [_toServicedelegate onTopView:self userModel:userModel];
                    }
                }
            }
        }
    }
    else
    {
        if (userIcon.tag < [_userArray count])
        {
            UserModel *userModel = [_userArray objectAtIndex:userIcon.tag];
            if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:userModel:)])
            {
                [_toServicedelegate onTopView:self userModel:userModel];
            }
        }
    }
}

#pragma mark -点击LiveVC 的主播个人 图像
/*!
 *    @author Yue
 *
 *    @brief 直播左上角第一个btn，点击弹出个人信息，同时控制半VC 退出
 */
- (void)clickLiveHost
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(clickTopViewUserHeaderMustQuitAllHalfVC:)])
    {
        [_toServicedelegate clickTopViewUserHeaderMustQuitAllHalfVC:self];
    }
    UserModel *userModel = [[UserModel alloc]init];
    userModel.user_id = [[_liveItem liveHost] imUserId];
    userModel.nick_name = [[_liveItem liveHost] imUserName];
    userModel.head_image = [[_liveItem liveHost] imUserIconUrl];
    
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:userModel:)])
    {
        [_toServicedelegate onTopView:self userModel:userModel];
    }
}


#pragma mark - ----------------------- 其他 -----------------------

#pragma mark 刷新印票数量
- (void)refreshTicketCount:(NSString *)ticketCount
{
    _ticketNumLabel.text = ticketCount;
    [self relayoutOtherContainerViewFrame];
}

#pragma mark 监听推拉流请求的码率
- (void)monitorRateKBPS
{
    _liveRateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getRateKBPS) userInfo:nil repeats:YES];
}

- (void)getRateKBPS
{
    if (_toSDKDelegate && [_toSDKDelegate respondsToSelector:@selector(refreshKBPS:)])
    {
        [_toSDKDelegate refreshKBPS:self];
    }
}

- (void)goToContribution
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(goToContributionList:)])
    {
        [_toServicedelegate goToContributionList:self];
    }
}

- (void)goToAuction
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(goToAuctionList:)])
    {
        [_toServicedelegate goToAuctionList:self];
    }
}

- (void)followAction
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(followAchor:)])
    {
        [_toServicedelegate followAchor:self];
    }
}


@end
