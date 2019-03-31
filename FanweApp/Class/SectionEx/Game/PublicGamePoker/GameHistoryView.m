//
//  GameHistoryView.m
//  FanweApp
//
//  Created by yy on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GameHistoryView.h"

@implementation GameHistoryView

- (id)initWithFrame:(CGRect)frame withGameID:(NSString *)gameID
{
    if (self = [super initWithFrame:frame]) {
        
        _dataArray = [[NSMutableArray alloc]init];
        _httpManager = [NetHttpsManager manager];
        
        //头部颜色
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, 40)];
        headerView.backgroundColor = kAppMainColor;
        [self addSubview:headerView];
        _gameID = [gameID integerValue];
        //头部文字
        if (_gameID == 4) {
            NSArray * labelArr = @[@"大",@"和",@"小"];
            for (int i=0; i<3; ++i) {
                CGFloat width = 0;
                if (i == 0) {
                    width = 48;
                }
                else if (i== 1)
                {
                    width = 34;
                }
                else if (i== 2)
                {
                    width = 24;
                }
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32+i*(32+52), 0, width, 40)];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = labelArr[i];
                titleLabel.textColor = [UIColor whiteColor];
                [headerView addSubview:titleLabel];
            }
            _historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 41, self.size.width, self.size.height - 41)];
        }
        else
        {
            UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.size.width-100)/2, 0, 100, 40)];
            headLabel.textAlignment = NSTextAlignmentCenter;
            headLabel.text = @"历史记录";
            headLabel.textColor = [UIColor whiteColor];
            [headerView addSubview:headLabel];
            _leftImg = [[UIImageView alloc]init];
            _midImg  = [[UIImageView alloc]init];
            _rightImg = [[UIImageView alloc]init];
            _gameID = [gameID integerValue];
            [self addSubview:_leftImg];
            [self addSubview:_midImg];
            [self addSubview:_rightImg];
            [self changePositionWithGameID:gameID];
            _lineLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 131, self.size.width, 1)];
            _lineLabel.backgroundColor = [UIColor whiteColor];
            [self addSubview:_lineLabel];
            _historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineLabel.frame), self.size.width, self.size.height - CGRectGetMaxY(_lineLabel.frame))];
        }
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.backgroundColor = [UIColor whiteColor];
        _historyTableView.tableFooterView = [[UIView alloc]init];
        [_historyTableView registerNib:[UINib nibWithNibName:@"GameHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"GameHistoryTableViewCell"];
        [self addSubview:_historyTableView];
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *winNum = nil;
    if (_dataArray.count > indexPath.row) {
        winNum = _dataArray[indexPath.row];
    }
    GameHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameHistoryTableViewCell" forIndexPath:indexPath];
    cell.gameID = _gameID;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell createCellWithArray:winNum withRow:indexPath.row];
    
    return cell;
}

#pragma mark    游戏历史记录请求
- (void)loadDataWithGameID:(NSString *)gameID withPodcastID:(NSString *)podcastID withPage:(NSString *)page
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"log" forKey:@"act"];
    [parmDict setObject:gameID forKey:@"game_id"];
    if (podcastID.length)
    {
        [parmDict setObject:podcastID forKey:@"podcast_id"];
    }
    [parmDict setObject:page forKey:@"number"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1) {
            _dataArray = [responseJson objectForKey:@"data"];
        }
        [_historyTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark    调整位置
- (void)changePositionWithGameID:(NSString *)gameID
{
    //1.炸金花 2.斗牛
    if ([gameID isEqualToString:@"1"])
    {
        _leftImg.frame = CGRectMake(23, 48, 50, 75);
        _midImg.frame = CGRectMake(100, 46, 63, 84);
        _rightImg.frame = CGRectMake(189, 43, 66, 84);
        _leftImg.image = [UIImage imageNamed:@"gm_stake_one"];
        _midImg.image = [UIImage imageNamed:@"gm_stake_two"];
        _rightImg.image = [UIImage imageNamed:@"gm_stake_three"];
    }
    else if ([gameID isEqualToString:@"2"])
    {
        _leftImg.frame = CGRectMake(23, 48, 55, 75);
        _midImg.frame = CGRectMake(104, 48, 55, 75);
        _rightImg.frame = CGRectMake(189, 48, 50, 75);
        _leftImg.image = [UIImage imageNamed:@"gm_bull_stake_one"];
        _midImg.image = [UIImage imageNamed:@"gm_bull_stake_two"];
        _rightImg.image = [UIImage imageNamed:@"gm_bull_stake_three"];
    }
    else if ([gameID isEqualToString:@"4"])
    {
//        _lineLabel.frame =CGRectMake(0, 131, self.size.width, 1);
//        _historyTableView.frame = CGRectMake(0, CGRectGetMaxY(_lineLabel.frame), self.size.width, self.size.height - CGRectGetMaxY(_lineLabel.frame));
    }
    else
    {
        
    }
}

@end
