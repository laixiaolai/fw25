//
//  ManagerViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/5/31.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ManagerViewController.h"
#import "managerModel.h"
#import "FollowerTableViewCell.h"
#import "SenderModel.h"

@interface ManagerViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) NSMutableArray             *dataArray;
@property (strong, nonatomic) UITableView                *tableView;
@property (assign, nonatomic) int                        has_admin;
@property (strong, nonatomic) UILabel                    *headLabel;

@property (assign, nonatomic) int                        cur_num;
@property (assign, nonatomic) int                        max_num;

@end

@implementation ManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initFWUI
{
    [super initFWUI];
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = kBackGroundColor;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(buttonClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.navigationItem.title = @"管理员列表";
    
    self.headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    self.headLabel.backgroundColor = kBackGroundColor;
    self.headLabel.textAlignment = NSTextAlignmentCenter;
    self.headLabel.text       = @"(0/0)";
    self.headLabel.font       = [UIFont systemFontOfSize:14];
    self.headLabel.textColor  = kAppGrayColor1;
    [self.view addSubview:self.headLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, kScreenH-64-40)];
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FollowerTableViewCell" bundle:nil] forCellReuseIdentifier:@"FollowerTableViewCell"];
    [self.view addSubview:self.tableView];
    
    [FWMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(loadNetData) footerRereshAction:nil];
}

- (void)initFWData
{
    [super initFWData];
    [self loadNetData];
}

- (void)loadNetData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"user_admin" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             [self.dataArray removeAllObjects];
             self.cur_num = [responseJson toInt:@"cur_num"];
             self.max_num = [responseJson toInt:@"max_num"];
             self.headLabel.text = [NSString stringWithFormat:@"当前管理员(%d/%d)",self.cur_num,self.max_num];
             NSArray *array = [responseJson objectForKey:@"list"];
             if (array.count > 0)
             {
                 for (NSMutableDictionary *dict in array)
                 {
                     SenderModel *sModel = [SenderModel mj_objectWithKeyValues:dict];
                     [self.dataArray addObject:sModel];
                 }
             }
             [self.tableView reloadData];
         }
         [FWMJRefreshManager endRefresh:self.tableView];
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.tableView];
     }];
    
}
- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //通过复用id(reusedID)来寻找,只有同种类型的cell才能算找到
    FollowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerTableViewCell"];
    cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0)
    {
        SenderModel *model = self.dataArray[indexPath.section];
        [cell creatCellWithModel:model WithRow:(int)indexPath.section];
        cell.rightImgView.hidden = YES;
        cell.joinBtn.hidden      = YES;
        cell.lineView.hidden     = NO;
    }
    if (self.dataArray.count-1 == indexPath.section)
    {
        cell.lineView.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65*kAppRowHScale;
}

//删除操作,需要两个代理方法配合使用
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SenderModel *model = self.dataArray[indexPath.section];
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
        [dictM setObject:@"user" forKey:@"ctl"];
        [dictM setObject:@"set_admin" forKey:@"act"];
        if (model.user_id)
        {
         [dictM setObject:model.user_id forKey:@"to_user_id"];
        }
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
         {
             FWStrongify(self)
             self.has_admin = [responseJson toInt:@"has_admin"];
             if ([responseJson toInt:@"status"] == 1)
             {
                 if (self.has_admin == 0)
                 {
                     self.cur_num = self.cur_num-1;
                     self.headLabel.text = [NSString stringWithFormat:@"当前管理员(%d/%d)",self.cur_num,self.max_num];
                     [self.dataArray removeObjectAtIndex:indexPath.section];
                     [self.tableView reloadData];
                     [FanweMessage alertTWMessage:@"取消管理员成功"];
                 }
             }
             
         } FailureBlock:^(NSError *error)
         {
             [FanweMessage alertTWMessage:@"管理员设置失败，请重新操作"];
         }];
    }
}

//返回编辑类型.是增加还是删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}



@end
