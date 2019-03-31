//
//  PluginCenterView.m
//  FanweApp
//
//  Created by yy on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "PluginCenterView.h"


@implementation PluginCenterView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        if (!_dataSource)
        {
            _dataSource = [[NSMutableArray alloc]init];
        }
        _httpManager = [NetHttpsManager manager];
        _fanweApp = [GlobalVariables sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whetherGame) name:@"closeGame" object:nil];
        [self initGamesForNetWorking];
        [self createCollection];
    }
    
    return self;
}

#pragma mark    创建collectionView等
- (void)createCollection
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    _bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.2];
    _bgView.layer.cornerRadius = kCornerRadius;
    _bgView.clipsToBounds = YES;
    [self addSubview:_bgView];
    
    // 毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
    [_bgView addSubview:effectView];
    
    _headLab = [[UILabel alloc]initWithFrame:CGRectMake(kDefaultMargin, 14, self.size.width-kDefaultMargin*2, pluginTitleHeight-14)];
    _headLab.text = @"基础工具";
    [_headLab setFont:[UIFont systemFontOfSize:16]];
    _headLab.textColor = kWhiteColor;
    _headLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_headLab];
    
    //基础工具视图
    _toolsView = [[ToolsView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headLab.frame) - 5, self.size.width, 125)];
    _toolsView.toPCVdelegate = self;
    [_bgView addSubview:_toolsView];
    
    //线2
    UILabel *secondLine = [[UILabel alloc]initWithFrame:CGRectMake(pluginMargin, CGRectGetMaxY(_toolsView.frame), self.size.width-2*pluginMargin, pluginLineHeight)];
    secondLine.backgroundColor = [kAppPluginSpaceColor colorWithAlphaComponent:0.5];
    [_bgView addSubview:secondLine];
    
    UILabel *secondHeadLab = [[UILabel alloc]initWithFrame:CGRectMake(kDefaultMargin, secondLine.height + secondLine.frame.origin.y + 10, self.size.width-kDefaultMargin*2, pluginTitleHeight-10)];
    secondHeadLab.text = @"游戏与功能列表";
    secondHeadLab.font = [UIFont systemFontOfSize:16];
    secondHeadLab.textColor = kWhiteColor;
    secondHeadLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:secondHeadLab];
    
    //线3
    UILabel *threeLine = [[UILabel alloc]initWithFrame:CGRectMake(pluginMargin, secondHeadLab.height + secondHeadLab.frame.origin.y, self.size.width-2*pluginMargin, pluginLineHeight)];
    threeLine.backgroundColor = [kAppPluginSpaceColor colorWithAlphaComponent:0.5];
    //    [_bgView addSubview:threeLine];
    
    //游戏列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((self.size.width-40)/3, (self.size.width)/3);
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 20);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _gameCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, threeLine.height + threeLine.frame.origin.y, self.size.width, self.size.height-CGRectGetMaxY(threeLine.frame)-kDefaultMargin) collectionViewLayout:layout];
    _gameCollectionView.alwaysBounceVertical = YES;
    _gameCollectionView.userInteractionEnabled = YES;
    _gameCollectionView.allowsMultipleSelection = YES; //允许多选
    _gameCollectionView.showsVerticalScrollIndicator = NO;
    _gameCollectionView.backgroundColor = [UIColor clearColor];
    _gameCollectionView.delegate = self;
    _gameCollectionView.dataSource = self;
    [_gameCollectionView registerNib:[UINib nibWithNibName:@"GamelistCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"GamelistCollectionViewCell"];
    [_bgView addSubview:_gameCollectionView];
    
}

#pragma mark    --------------------------collectionView代理方法--------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameModel *model;
    if (indexPath.row < _dataSource.count)
    {
        model = _dataSource[indexPath.row];
    }
    
    GamelistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GamelistCollectionViewCell" forIndexPath:indexPath];
    [cell creatCellWithModel:model withRow:(int)indexPath.row];
    if ([model.is_active isEqualToString:@"0"])
    {
        cell.gamePlaying_L.hidden = YES;
    }
    else if ([model.is_active isEqualToString:@"1"])
    {
        cell.gamePlaying_L.hidden = NO;
        if ([model.class_name isEqualToString:@"live_pay"])
        {
            cell.gamePlaying_L.text = @"使用中";
        }
        else
        {
            cell.gamePlaying_L.text = @"使用中";
        }
    }
    return cell;
}

#pragma mark    点击单元格方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击返回视图(收起)
    if ([self.delegate respondsToSelector:@selector(closeGameList)])
    {
        [self.delegate closeGameList];
    }
    if (!SUS_WINDOW.isPushStreamIng)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"直播开启中，请稍候!"];
    }
    else
    {
        if ([FWUtils isNetConnected])
        {
            _HUD = [[FWHUDHelper sharedInstance] loading:@""];
        }
        __weak MBProgressHUD *hud = _HUD;
        
        GameModel *model;
        if (indexPath.row < _dataSource.count)
        {
            model = _dataSource[indexPath.row];
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:@"app" forKey:@"ctl"];
        [dict setValue:@"plugin_status" forKey:@"act"];
        [dict setValue:[NSString stringWithFormat:@"%@",model.game_id] forKey:@"plugin_id"];
        [_httpManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) //通过该网络请求来判断功能插件的开启是否冲突
         {
             [[FWHUDHelper sharedInstance] stopLoading:hud];
             if ([responseJson toInt:@"status"] == 1)
             {
                 if ([responseJson toInt:@"is_enable"] == 1)
                 {
                     if (indexPath.row < _dataSource.count)
                     {
                         if ([model.class_name isEqualToString:@"live_pay"] || [model.class_name isEqualToString:@"pai"] || [model.class_name isEqualToString:@"shop"] || [model.class_name isEqualToString:@"live_pay_scene"] || [model.class_name isEqualToString:@"podcast_goods"])
                         {
                             if (_delegate && [_delegate respondsToSelector:@selector(loadGoldFlowerView:withGameID:)])
                             {
                                 [_delegate loadGoldFlowerView:model withGameID:0];
                             }
                         }
                         else
                         {
                             if (!_isGame)
                             {
                                 [self startPlayingGameWithStrid:model.child_id];
                             }
                         }
                     }
                 }else//后台判断当前是否可以继续（比如开了按场付费就不能再开按时付费）
                 {
                     [FanweMessage  alertHUD:[responseJson toString:@"error"]];
                 }
             }
             
         } FailureBlock:^(NSError *error) {
             [[FWHUDHelper sharedInstance] stopLoading:hud];
         }];
    }
}

#pragma mark    ---------------------------------网络请求----------------------------------
#pragma mark    加载插件列表(插件初始化)
- (void)initGamesForNetWorking{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"app" forKey:@"ctl"];
    [dict setValue:@"plugin_init" forKey:@"act"];
    [_httpManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1) {
            [_dataSource removeAllObjects];
            NSArray *dataArr = [responseJson valueForKey:@"list"];
            if (dataArr && [dataArr isKindOfClass:[NSArray class]])
            {
                if (dataArr.count)
                {
                    for (NSDictionary *dic in dataArr) {
                        GameModel *model = [GameModel mj_objectWithKeyValues:dic];
                        [_dataSource addObject:model];
                        
                        if ([dic toInt:@"is_active"] == 1) {
                            _game_id = [dic toString:@"id"];
                        }
                    }
                }
            }
            if (_delegate && [_delegate respondsToSelector:@selector(getCount:)]) {
                [_delegate getCount:_dataSource];
            }
            [_gameCollectionView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
    
}

#pragma mark    开始游戏
- (void)startPlayingGameWithStrid:(NSString *)idStr{
    NSMutableDictionary *parameterDic = [NSMutableDictionary new];
    [parameterDic setValue:@"games" forKey:@"ctl"];
    [parameterDic setValue:@"start" forKey:@"act"];
    [parameterDic setValue:@([idStr intValue]) forKey:@"id"];
    [_httpManager POSTWithParameters:parameterDic SuccessBlock:^(NSDictionary *responseJson){
        if ([responseJson toInt:@"status"] == 1) {
            _isGame = YES;
            _game_id = idStr;
            GameModel *model = [GameModel mj_objectWithKeyValues:responseJson];
            if (_delegate && [_delegate respondsToSelector:@selector(loadGoldFlowerView:withGameID:)])
            {
                [_delegate loadGoldFlowerView:model withGameID:idStr];
            }
            
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark “关闭”按钮方法
- (void)closeClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(closeGameList)])
    {
        [_delegate closeGameList];
    }
}

- (void)closeSelfView:(ToolsView *)toolsView
{
    [self closeClick];
}

- (void)whetherGame
{
    _isGame = NO;
}


@end
