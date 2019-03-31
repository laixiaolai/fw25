//
//  SManageFriendVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/9/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SManageFriendVC.h"
#import "SenderModel.h"
#import "managerFriendTableViewCell.h"



@interface SManageFriendVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView             *myTableView;
@property (strong, nonatomic) UIButton                *backButton;         //取消,邀请或者踢出好友
@property (strong, nonatomic) UILabel                 *headLabel;          //头部提示的label
@property (strong, nonatomic) NSMutableArray          *dataArray;
@property (strong, nonatomic) NSMutableDictionary     *Mdict;              //装选中了多少个好友的字典
@property (strong, nonatomic) NSMutableArray          *idArray;            //id的数组
@property (copy, nonatomic) NSString                  *allIdString;        //选中好友的id

@property (strong, nonatomic) UIView                  *backView;
@property (assign, nonatomic) int                     currentPage;
@property (assign, nonatomic) int                     has_next;


@end

@implementation SManageFriendVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackGroundColor;
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
}

- (void)initFWUI
{
    [super initFWUI];
    self.dataArray   = [[NSMutableArray alloc]init];
    self.idArray     = [[NSMutableArray alloc]init];
    self.Mdict       = [[NSMutableDictionary alloc]init];
    
    [self creatMainView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)creatMainView
{
    self.headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
    self.headLabel.backgroundColor = kWhiteColor;
    self.headLabel.textColor = kAppGrayColor2;
    if (self.type == 0)
    {
        self.headLabel.text   = @"请选择要踢出的观众";
        
    }else
    {
        self.headLabel.text      = @"请选择要邀请的好友";
    }
    self.headLabel.textAlignment = NSTextAlignmentCenter;
    self.headLabel.font      = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.headLabel];
    
    
    self.myTableView = [[UITableView alloc]init];
    self.myTableView.frame = CGRectMake(0, 74, kScreenW, kScreenH-134);
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.backgroundColor = kWhiteColor;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"managerFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"managerFriendTableViewCell"];
    [self.view addSubview:self.myTableView];
    
    [FWMJRefreshManager refresh:self.myTableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-60, kScreenW, 60)];
    self.backView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.backView];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(20,10, kScreenW-40, 40);
    [self.backButton setTitle:@"取消" forState:UIControlStateNormal];
    self.backButton.backgroundColor = kBlackColor;
    [self.backButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backButton.layer.cornerRadius = self.backButton.frame.size.height/2;
    [self.backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.backButton];
}

- (void)initFWData
{
    [super initFWData];
    [self loadNetDataWithPage:1];
}

- (void)headerReresh
{
    [self loadNetDataWithPage:1];
}

- (void)footerReresh
{
    if (self.has_next == 1)
    {
        self.currentPage ++;
        [self loadNetDataWithPage:self.currentPage];
    }
    else
    {
        [FWMJRefreshManager endRefresh:self.myTableView];
    }
}

- (void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    if (self.type == 0)//踢人列表
    {
        [parmDict setObject:@"video" forKey:@"ctl"];
        [parmDict setObject:@"private_room_friends" forKey:@"act"];
        [parmDict setObject:_chatAVRoomId forKey:@"group_id"];
    }
    else if (self.type == 1)
    {
        [parmDict setObject:@"user" forKey:@"ctl"];
        [parmDict setObject:@"friends" forKey:@"act"];
    }
    
    if (_liveAVRoomId && ![_liveAVRoomId isEqualToString:@""])
    {
        [parmDict setObject:_liveAVRoomId forKey:@"room_id"];
    }
    
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             self.currentPage = [responseJson toInt:@"page"];
             if (self.currentPage == 1)
             {
                 [self.dataArray removeAllObjects];
             }
             self.has_next = [responseJson toInt:@"has_next"];
             NSArray *listArray = [responseJson objectForKey:@"list"];
             if (listArray && [listArray isKindOfClass:[NSArray class]])
             {
                 if (listArray.count > 0)
                 {
                     for (NSDictionary *dict in listArray)
                     {
                         SenderModel *sModel = [SenderModel mj_objectWithKeyValues:dict];
                         [self.dataArray addObject:sModel];
                     }
                 }
             }
             if (self.dataArray.count)
             {
                 [self hideNoContentView];
             }else
             {
                 [self showNoContentView];
             }
             [self.myTableView reloadData];
         }
         [FWMJRefreshManager endRefresh:self.myTableView];
         
     } FailureBlock:^(NSError *error) {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.myTableView];
     }];
}

#pragma mark -UITableViewDelegate&UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//返回段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //通过复用id(reusedID)来寻找,只有同种类型的cell才能算找到
    managerFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managerFriendTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SenderModel *model = self.dataArray[indexPath.section];
    [cell creatCellWithModel:model];
    
    if (self.idArray.count)
    {
        if ([self.idArray containsObject:model.user_id])
        {
            cell.rightImgView.image = [UIImage imageNamed:@"com_radio_selected_2"];
        }else
        {
            cell.rightImgView.image = [UIImage imageNamed:@"com_radio_normal_2"];
        }
    }else
    {
        cell.rightImgView.image = [UIImage imageNamed:@"com_radio_normal_2"];
    }
//    if (indexPath.section == self.dataArray.count-1)
//    {
//        cell.lineView.hidden = YES;
//    }
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*kAppRowHScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SenderModel *model = self.dataArray[indexPath.section];
    if (self.idArray.count)
    {
        if ([self.idArray containsObject:model.user_id])
        {
            [self.idArray removeObject:model.user_id];
        }else
        {
            [self.idArray addObject:model.user_id];
        }
    }else
    {
        [self.idArray addObject:model.user_id];
    }
    if (self.idArray.count)
    {
        if (self.type == 0)//踢出好友
        {
            [self.backButton setTitle:@"踢出观众" forState:UIControlStateNormal];
        }else
        {
            [self.backButton setTitle:@"邀请好友" forState:UIControlStateNormal];
        }
    }else
    {
        [self.backButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    [self.myTableView reloadData];
}

//button的点击事件
- (void)buttonClick:(UIButton *)button
{
    self.allIdString = @"";
    for (NSString *idString in self.idArray)
    {
        if (self.allIdString.length)
        {
            self.allIdString = [NSString stringWithFormat:@"%@,%@",self.allIdString,idString];
        }else
        {
            self.allIdString = [NSString stringWithFormat:@"%@",idString];
        }
    }
    if (self.allIdString.length)
    {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        if (self.type == 0)//踢人列表
        {
            [parmDict setObject:@"video" forKey:@"ctl"];
            [parmDict setObject:@"private_drop_user" forKey:@"act"];
            
        }else if (self.type == 1)
        {
            [parmDict setObject:@"video" forKey:@"ctl"];
            [parmDict setObject:@"private_push_user" forKey:@"act"];
            
        }
        if (_liveAVRoomId && ![_liveAVRoomId isEqualToString:@""])
        {
            [parmDict setObject:_liveAVRoomId forKey:@"room_id"];
        }
        [parmDict setObject:self.allIdString forKey:@"user_ids"];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
         {
             if ([responseJson toInt:@"status"] == 1)
             {
                 [self.navigationController popViewControllerAnimated:NO];
             }
         } FailureBlock:^(NSError *error)
         {
             NSLog(@"error===%@",error);
         }];
    }else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}



@end
