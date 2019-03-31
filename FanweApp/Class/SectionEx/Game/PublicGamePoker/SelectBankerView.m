//
//  SelectBankerView.m
//  FanweApp
//
//  Created by yy on 17/2/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SelectBankerView.h"

@implementation SelectBankerView

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)createStyle
{
    _dataArray   = [[NSMutableArray alloc]init];
    
    self.layer.cornerRadius         = 10;
    self.layer.masksToBounds        = YES;
    _titleLabel.textColor           = kAppGrayColor1;
    _horLabel.backgroundColor = kAppSpaceColor2;
    _verLabel.backgroundColor = kAppSpaceColor2;
    [_cancelButton setTitleColor:kGrayTransparentColor5 forState:UIControlStateNormal];
    [_confirmButton setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelAuction) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton addTarget:self action:@selector(confirmAuction) forControlEvents:UIControlEventTouchUpInside];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SelectBankerTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectBankerTableViewCell"];
}

#pragma mark    选择玩家上庄请求
- (void)selectBanker
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"games" forKey:@"ctl"];
    [mDict setObject:@"chooseBanker" forKey:@"act"];
    [mDict setObject:_banker_log_id forKey:@"banker_log_id"];
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] ==1)
        {
            _banker_log_id = nil;
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_tableView reloadData];
}

- (void)cancelAuction
{
    _banker_log_id = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(selectBankerViewDown)])
    {
        [_delegate selectBankerViewDown];
    }
}

- (void)confirmAuction
{
    if (_banker_log_id != nil) {
        [self selectBanker];
    }
    else
    {
        if (_dataArray.count > 0)
        {
            [[FWHUDHelper sharedInstance]tipMessage:@"请选择玩家"];
        }
        else
        {
            [[FWHUDHelper sharedInstance]tipMessage:@"暂时没有玩家上庄"];
        }
        
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectBankerViewDown)])
    {
        [_delegate selectBankerViewDown];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameBankerModel *model;
    if (indexPath.row < _dataArray.count) {
        model = _dataArray[indexPath.row];
    }
    SelectBankerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectBankerTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentLabel.text = model.banker_name;
    
    if (self.fanweApp.appModel.open_diamond_game_module == 1)
    {
        cell.coinLabel.text = [NSString stringWithFormat:@"%@%@",model.coin,self.fanweApp.appModel.diamond_name];
    }
    else
    {
        cell.coinLabel.text = [NSString stringWithFormat:@"%@游戏币",model.coin];
    }
    
    if (model.isSelect )
    {
        cell.commentLabel.textColor = kAppGrayColor1;
        cell.coinLabel.textColor = kAppGrayColor1;
        cell.iconImageView.image = [UIImage imageNamed:@"ic_live_pop_choose_on"];
    }
    else
    {
        cell.commentLabel.textColor = kAppGrayColor1;
        cell.coinLabel.textColor = kAppGrayColor1;
        cell.iconImageView.image = [UIImage imageNamed:@"ic_live_pop_choose_off"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    GameBankerModel *model;
    if (indexPath.row < _dataArray.count) {
        model = _dataArray[indexPath.row];
    }
    _banker_log_id = model.banker_log_id;
    
    for (GameBankerModel *model in _dataArray) {
        model.isSelect = NO;
    }
    model.isSelect = YES;
    [_tableView reloadData];
}

@end
