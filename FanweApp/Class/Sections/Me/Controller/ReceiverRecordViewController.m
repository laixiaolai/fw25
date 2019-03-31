//
//  ReceiverRecordViewController.m
//  FanweApp
//
//  Created by yy on 16/7/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ReceiverRecordViewController.h"
#import "RecordModel.h"
#import "RecordTableViewCell.h"
@interface ReceiverRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NetHttpsManager *_httpManager;
    NSMutableArray * recordArray;
    NSString *totalMoney;
}
@end

@implementation ReceiverRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =kBackGroundColor;
    self.navigationItem.title =@"领取记录";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backpProfitVC) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    _httpManager =[NetHttpsManager manager];
    recordArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self loadReceiveNet];
}

- (void)creatTabel
{
    UITableView *receiveTabel =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStylePlain];
    receiveTabel.delegate =self;
    receiveTabel.dataSource =self;
    [self.view addSubview:receiveTabel];
    [receiveTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [receiveTabel registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (recordArray.count>0) {
        
      return recordArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString * cellID = @"Cell";
    RecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    RecordModel *model =[recordArray objectAtIndex:indexPath.row];
    cell.moneyLable.textColor = kAppGrayColor1;
    cell.recordStateLable.textColor =kAppGrayColor3;
    if ([model.is_pay isEqualToString:@"1"]) {
        cell.moneyLable.text =[NSString stringWithFormat:@"%@元",model.money];
        cell.timeLabel.text =model.create_time;
        cell.recordStateLable.text =@"兑换中";
        
    }
    else{
        cell.moneyLable.text =[NSString stringWithFormat:@"%@元",model.money];
        cell.timeLabel.text =model.pay_time;
        cell.recordStateLable.text =@"兑换成功";
    }
    return cell;
}
//添加标头中的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerSectionID = @"headerSectionID";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
    UILabel *label;
    
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW-20, 50)];
        label.text = [NSString stringWithFormat:@"累计领取:%@元",totalMoney];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment =NSTextAlignmentCenter;
        label.textColor =kAppGrayColor1;
        [headerView addSubview:label];
    }
    
    return headerView;
}
#pragma marlk 返回
- (void)backpProfitVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma marlk 请求领取记录
- (void)loadReceiveNet
{

    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"extract_record" forKey:@"act"];
    
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"]==1) {
             
            totalMoney = [responseJson objectForKey:@"total_money"];
             NSMutableArray *listArray =[responseJson objectForKey:@"list"];
             if ([listArray isKindOfClass:[NSMutableArray class]]) {
                 if (listArray.count>0) {
                     for (NSDictionary *dic in listArray) {
                          RecordModel *model = [ RecordModel mj_objectWithKeyValues:dic];
                         [recordArray addObject:model];
                     }

                 }
             }
              [self creatTabel];
         }
        
         else{
             NSLog(@"错误");
         }

         
     } FailureBlock:^(NSError *error)
     {
         
     }];

}
@end
