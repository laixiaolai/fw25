//
//  SLiveRedBagView.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SLiveRedBagView.h"
#import "CustomMessageModel.h"
#import "SRedBagViewCell.h"

@implementation SLiveRedBagView

- (void)awakeFromNib
{
    [super awakeFromNib];
  
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.smallHeadViewSpaceH.constant = 25 *kScreenH/480;
    self.nameLabelSpaceH.constant = self.nameLabelSpaceH.constant *kScreenH/480;
    self.messageLabel2SpaceH.constant = self.messageLabel2SpaceH.constant *kScreenH/480;
    self.messageLabelSpaceH.constant = self.messageLabelSpaceH.constant *kScreenH/480;
    self.lineViewSpaceH.constant = self.lineViewSpaceH.constant *kScreenH/480;
    self.redButtonSpaceH.constant = self.redButtonSpaceH.constant *kScreenH/480;
    self.rebbagBigView.layer.cornerRadius = 6*kScreenH/480;
    self.rebbagBigView.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.dataArray = [[NSMutableArray alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"SRedBagViewCell" bundle:nil] forCellReuseIdentifier:@"SRedBagViewCell"];
    [FWMJRefreshManager refresh:self.myTableView target:self headerRereshAction:@selector(loadRedBagNet) shouldHeaderBeginRefresh:NO footerRereshAction:nil];
    
    self.headImgView.layer.cornerRadius = 30*kScreenW/320;
    self.headImgView.layer.masksToBounds = YES;
    
    self.smallHeadView.layer.cornerRadius = 27*kScreenW/320;
    self.smallHeadView.layer.masksToBounds = YES;
    
    self.redButton.userInteractionEnabled = YES;
    self.redButton.layer.cornerRadius = 30*kScreenW/320;
    self.redButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClick:)];
    self.luckImgView.userInteractionEnabled = YES;
    [self.luckImgView addGestureRecognizer:tap];
    
    self.lineView.backgroundColor = kAppSpaceColor2;
    self.redButtonSpaceH.constant= 95*kScreenH/480;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap1];
    
}

- (void)tap
{
  [self removeFromSuperview];
}

- (void)creatRedWithModel:(CustomMessageModel *)model
{
    self.customMessageModel = model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.sender.head_image]];
    self.nameLabel.text = model.sender.nick_name;
    _user_prop_id = model.user_prop_id;
    
    //抢完红包后的界面
    [self.smallHeadView sd_setImageWithURL:[NSURL URLWithString:model.sender.head_image]];
    self.nameLabel2.text = [NSString stringWithFormat:@"%@的红包",model.sender.nick_name];
    
}

- (void)changeRedPackageView{
    
    self.rebbagBigView.backgroundColor = kWhiteColor;
    self.headBackBroundView.hidden = YES;
    self.headImgView.hidden = YES;
    self.nameLabel.hidden = YES;
    self.messageLabel.hidden = YES;
    self.redButton.hidden = YES;
    
    self.lineView.hidden = NO;
    self.smallHeadBackBroundView.hidden = NO;
    self.smallHeadView.hidden = NO;
    self.nameLabel2.hidden = NO;
    self.messageLabel2.hidden = NO;
    self.luckButton.hidden = NO;
    self.luckImgView.hidden = NO;
    
    if (self.customMessageModel.redPackageTip && [self.customMessageModel.redPackageTip isKindOfClass:[NSString class]])
    {
        if (self.customMessageModel.redPackageTip.length)
        {
            _messageLabel2.text = self.customMessageModel.redPackageTip;
        }
    }
}

- (IBAction)redButtonClick:(UIButton *)sender
{
    self.redButton.userInteractionEnabled = NO;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"deal" forKey:@"ctl"];
    [dict setObject:@"red_envelope" forKey:@"act"];
    [dict setObject:_user_prop_id forKey:@"user_prop_id"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson){
       FWStrongify(self)
        self.customMessageModel.redPackageTip = [responseJson toString:@"error"];
        _messageLabel2.text = [responseJson toString:@"error"];
        
        _currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        _currentDiamonds += [responseJson toInt:@"diamonds"];
        [[IMAPlatform sharedInstance].host setDiamonds:[NSString stringWithFormat:@"%ld",(long)_currentDiamonds]];
        
        if (self.fanweApp.appModel.open_diamond_game_module == 1)
        {
            //更新游戏的余额
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCoin" object:nil];
        }
        
        [self changeRedPackageView];
        self.customMessageModel.isRedPackageTaked = YES;
        if (_rebBagDelegate && [_rebBagDelegate respondsToSelector:@selector(openRedbag:)])
        {
            [_rebBagDelegate openRedbag:self];
        }
        
    } FailureBlock:^(NSError *error)
     {
         
     }];
    
}

- (IBAction)deleteButtonClick:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)buttonClick:(id)sender
{
    self.luckButton.hidden = YES;
    self.luckImgView.hidden = YES;
    CGRect rect = self.frame;
    self.frame = rect;
    self.myTableView.hidden = NO;
    
    [self loadRedBagNet];
}

- (void)loadRedBagNet
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"deal" forKey:@"ctl"];
    [dict setObject:@"user_red_envelope" forKey:@"act"];
    [dict setObject:_user_prop_id forKey:@"user_prop_id"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [_dataArray removeAllObjects];
         NSArray *array = [responseJson objectForKey:@"list"];
         if (array.count > 0)
         {
             for (NSDictionary *dict in array)
             {
                 CustomMessageModel *model = [CustomMessageModel mj_objectWithKeyValues:dict];
                 [_dataArray addObject:model];
             }
         }
         [FWMJRefreshManager endRefresh:_myTableView];
         [self.myTableView reloadData];
         
     } FailureBlock:^(NSError *error)
     {
          FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.myTableView];
       
     }];

}

#pragma UItableViewDataDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count > 0)
    {
        return _dataArray.count;
    }else
    {
        return 1;
    }
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRedBagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SRedBagViewCell"];
    if (self.dataArray.count > 0)
    {
        CustomMessageModel *model = self.dataArray[indexPath.section];
        [cell creatCellWithModel:model andRow:(int)indexPath.section];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 35;
    }else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW*0.8, 35)];
        view.backgroundColor = kBackGroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW*0.8, 35)];
        label.text = @"TOP50";
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        return view;
    }else
    {
        return nil;
    }
}


@end
