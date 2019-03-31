//
//  PushManageViewController.m
//  FanweApp
//
//  Created by GuoMs on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "PushManageViewController.h"
#import "PushMaTableViewCell.h"
#import "PushModel.h"

@interface PushManageViewController ()<TapDelegate>

@property (strong, nonatomic) IBOutlet UITableView *pushManTabView;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation PushManageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"推送管理";
    self.dic = [NSMutableDictionary new];
    
    [self initPushMainTabView];
    
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}

- (void)initPushMainTabView
{
    self.pushManTabView.scrollEnabled = NO;
    [self.pushManTabView registerNib:[UINib nibWithNibName:@"PushMaTableViewCell" bundle:nil] forCellReuseIdentifier:@"turnOffCell"];
    self.pushManTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pushManTabView.backgroundColor = kBackGroundColor;
}

#pragma mark - cell的协议方法
- (void)handleToTurnPushManage
{
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:YES] forKey:@"turnPush"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"turnOnOrOff"])
    {
        [self.dic setValue:@"1" forKey:@"is_remind"];

        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"turnOnOrOff"];
    }else
    {
        [self.dic setValue:@"0" forKey:@"is_remind"];
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:YES] forKey:@"turnOnOrOff"];
    }
    [self managementPuahNetRequest];
}

#pragma mark - 推送管理网络请求
- (void)managementPuahNetRequest
{
    [self.dic setValue:@"settings" forKey:@"ctl"];
    [self.dic setValue:@"set_push" forKey:@"act"];
    [self.dic setValue:@"1" forKey:@"type"];
    if (self.userId.length > 0)
    {
        [self.dic setObject:self.userId forKey:@"to_user_id"];
    }
    
    [self.httpsManager POSTWithParameters:self.dic SuccessBlock:^(NSDictionary *responseJson){
//        if ([responseJson toInt:@"status"] == 1) {
//            PushModel *model = [PushModel mj_objectWithKeyValues:responseJson];
//            [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",model.error]];
//            NSLog(@"model.error === %@",model.error);
//        }
//        [self.pushManTabView reloadData];
    } FailureBlock:^(NSError *error){
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PushMaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"turnOffCell" forIndexPath:indexPath];
    cell.deleagte = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kScreenW == 375)
    {
        return 50;
    }
    else if (kScreenW > 375)
    {
        return 56;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- 返回区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

@end
