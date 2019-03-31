//
//  GameHistoryView.h
//  FanweApp
//
//  Created by yy on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameHistoryTableViewCell.h"
#import "GameDataModel.h"

@interface GameHistoryView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    GameHistoryModel *model;
}
@property (nonatomic, retain) UITableView       *historyTableView;
@property (nonatomic, strong) NSMutableArray    *dataArray;             //存储数据
@property (nonatomic, strong) NetHttpsManager   *httpManager;
@property (nonatomic, assign) NSInteger         gameID;                //游戏轮数
@property (nonatomic, strong) UIImageView       *leftImg;               //图左
@property (nonatomic, strong) UIImageView       *midImg;                //图中
@property (nonatomic, strong) UIImageView       *rightImg;              //图右
@property (nonatomic, strong) UILabel           *lineLabel;
- (id)initWithFrame:(CGRect)frame withGameID:(NSString *)gameID;

//请求数据
- (void)loadDataWithGameID:(NSString *)gameID withPodcastID:(NSString *)podcastID withPage:(NSString *)page;
//调整位置
- (void)changePositionWithGameID:(NSString *)gameID;
@end
