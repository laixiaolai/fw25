//
//  DailyQuestTablView.m
//  PopupViewWindow
//
//  Created by 杨仁伟 on 2017/5/22.
//  Copyright © 2017年 yrw. All rights reserved.


#import "DailyQuestTablView.h"
#import "DailyQuestCell.h"
#import "BMListModel.h"

@interface DailyQuestTablView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray        *imgArray; //放图片
@property (nonatomic, strong) NSMutableArray        *taskArray; //放任务
@property (nonatomic, strong) NetHttpsManager       *httpsManager;

@end

@implementation DailyQuestTablView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        self = [[DailyQuestTablView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = kWhiteColor;
        self.separatorColor = [UIColor clearColor];
        [self headRefresh];
        [self loadNetDailyData];
    }
    return self;
}

- (void)headRefresh
{
    [FWMJRefreshManager refresh:self target:self headerRereshAction:@selector(loadNetDailyData) footerRereshAction:nil];
}

- (void)loadNetDailyData
{
    self.httpsManager = [NetHttpsManager manager];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"mission" forKey:@"ctl"];
    [parmDict setObject:@"getMissionList" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             [self.imgArray removeAllObjects];
             NSArray *listArr = [responseJson objectForKey:@"list"];
             if (listArr && [listArr isKindOfClass:[NSArray class]])
             {
                 if (listArr.count)
                 {
                     for (NSDictionary *listDict in listArr)
                     {
                         BMListModel *lModel = [BMListModel mj_objectWithKeyValues:listDict];
                         [self.imgArray addObject:lModel];
                     }
                 }
             }
             [self reloadData];
         }
         [FWMJRefreshManager endRefresh:self];
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self];
     }];
}

- (NSMutableArray *)imgArray
{
    if (!_imgArray)
    {
        _imgArray = [[NSMutableArray alloc]init];
    }
    return _imgArray;
}

- (NSMutableArray *)taskArray
{
    if (!_taskArray)
    {
        _taskArray  = [[NSMutableArray alloc]init];
    }
    return _taskArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag = @"DailyQuest";
    DailyQuestCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DailyQuestCell" owner:nil options:nil].firstObject;
    }
    if (self.imgArray.count)
    {
        BMListModel *lModel = _imgArray[indexPath.row];
        [cell creatCellWithModel:lModel andRow:(int)indexPath.row];
        [cell setTaskBlock:^(int btnCount){
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"mission" forKey:@"ctl"];
            [parmDict setObject:@"commitMission" forKey:@"act"];
            BMListModel *model = _imgArray[btnCount];
            [parmDict setObject:model.type forKey:@"type"];
            [_httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
             {
                 if ([responseJson toInt:@"status"] == 1)
                 {
//                     if ([responseJson toInt:@"open_daily_task"] == 0)
//                     {
//                         [[NSNotificationCenter defaultCenter]postNotificationName:@"closeEverydayTask" object:nil];
//                     }
                     NSDictionary *missionDict = [responseJson objectForKey:@"mission"];
                     if (missionDict && [missionDict isKindOfClass:[NSDictionary class]])
                     {
                         if (missionDict.count)
                         {
                             BMListModel *newModel = [BMListModel mj_objectWithKeyValues:missionDict];
                             [self.imgArray replaceObjectAtIndex:btnCount withObject:newModel];
                         }
                     }
                     [self reloadData];
                 }else
                 {
                     [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
                 }
             } FailureBlock:^(NSError *error)
             {
                 
             }];
        }];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headLbl = [UILabel quickLabelWithFrame:CGRectMake(0, 0, self.frame.size.width, 47*kScaleHeight) color:[UIColor darkGrayColor] font:18 text:@"每日任务" superView:nil];
    headLbl.textAlignment = NSTextAlignmentCenter;
    headLbl.backgroundColor = kWhiteColor;
    return headLbl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47*kAppRowHScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
