//
//  PluginCenterView.h
//  FanweApp
//
//  Created by yy on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
#import "ToolsView.h"
#import "GamelistCollectionViewCell.h"

@protocol PluginCenterViewDelegate <NSObject>
// 加载游戏
- (void)loadGoldFlowerView:(GameModel *) model withGameID:(NSString *)gameID;
// 收起插件中心
- (void)closeGameList;
// 获取游戏或功能列表的个数
- (void)getCount:(NSMutableArray *)array;

@end

@interface PluginCenterView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,ToolsViewDelegate2>
{
    NetHttpsManager     *_httpManager;
    GlobalVariables     *_fanweApp;
    GameModel           *_gameModel;
    UICollectionView    *_gameCollectionView;
    MBProgressHUD       *_HUD;
}

@property (nonatomic, weak)   id<PluginCenterViewDelegate> delegate;
@property (nonatomic, strong) UIView            *bgView;                // 毛玻璃背景
@property (nonatomic, strong) ToolsView         *toolsView;             // 基础工具视图
@property (nonatomic, strong) UIButton          *closeBtn;
@property (nonatomic, strong) NSMutableArray    *gameListArray;
@property (nonatomic, strong) NSMutableArray    *dataSource;
@property (nonatomic, strong) UILabel           *headLab;
@property (nonatomic, copy)   NSString          *game_id;
@property (nonatomic, assign) BOOL              isGame;                 // 是否在游戏中

// 游戏开始初始化
- (void)initGamesForNetWorking;
// “关闭”按钮方法
- (void)closeClick;

@end
