//
//  FWRecommendController.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/5.
//  Copyright © 2017年 xfg. All rights reserved.
//  推荐 GoodsVC.PModel =item;

#import "FWRecommendController.h"
#import "FWDynamicCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PersonCenterListModel.h"
#import "FWVideoDetailController.h"
#import "IDMPhotoBrowser.h"
#import "Pay_Model.h"
#import "Mwxpay.h"
#import "WXApi.h"
#import "FWReportController.h"
#import "FWPlayVideoController.h"
#import "FWPhotoManager.h"
#import "SHomePageVC.h"

@interface FWRecommendController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UIActionSheetDelegate,DynamicCellDelegate,IDMPhotoBrowserDelegate,IDMPhotoBrowserDelegate>
{
    
    int                   _page;                          //当前页数
    int                   _has_next;                      //是否还有下一页1代表有
    NSString              *_payMoney;                     //支付的钱
    int                   _imageRow;                      //哪个微博的row
    int                   _moreTag;                       //更多
    int                   _pushCount;                     //跳转时具体是哪个数据
    
}

@property (nonatomic,strong)UITableView             *tableView;                   //tableView
@property (nonatomic,strong)NSMutableArray          *dataArray;                   //说说的数组
@property (nonatomic,strong)FWPhotoManager          *photoManager;                //

@end

@implementation FWRecommendController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoManager = [[FWPhotoManager alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    _payArray = [[NSMutableArray alloc]init];
    [self creatMianView];
}

//创建主页
- (void)creatMianView
{
    self.navigationItem.title = @"我的动态";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:@"PaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationAction:) name:@"changeTableViewStatus" object:nil];
    self.tableView = [[UITableView alloc]init];
    if (self.tableViewType == 1)
    {
        self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-64);
    }else
    {
        self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-64-50);
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [_tableView registerClass:[FWDynamicCell class] forCellReuseIdentifier:@"FWDynamicCell"];
    
    [self loadNetDataWithPage:1];
    //下拉刷新
    [FWMJRefreshManager refresh:_tableView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:YES footerRereshAction:@selector(refresherOfNew)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"fw_personCenter_comeback" highImage:@"fw_personCenter_comeback"];
    [self showMyHud];
}

#pragma mark 返回
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 头尾部刷新
- (void)headerReresh
{
    [self loadNetDataWithPage:1];
}

- (void)refresherOfNew
{
    if (_has_next == 1)
    {
        _page ++;
        [self loadNetDataWithPage:_page];
    }
    else
    {
        [FWMJRefreshManager endRefresh:self.tableView];
        return;
    }
}

#pragma mark 加载数据
-(void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    if (self.tableViewType == 1)
    {
        [MDict setObject:@"user" forKey:@"ctl"];
        [MDict setObject:@"weibo_mine" forKey:@"act"];
    }else
    {
        [MDict setObject:@"discovery" forKey:@"ctl"];
        [MDict setObject:@"index" forKey:@"act"];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         _has_next = [responseJson toInt:@"has_next"];
         _page     = [responseJson toInt:@"page"];
         if (_page == 1)
         {
             [_dataArray removeAllObjects];
         }
         
         if ([responseJson toInt:@"status"] == 1)
         {
             NSArray *listArray = [responseJson objectForKey:@"list"];
             if (listArray && [listArray isKindOfClass:[NSArray class]])
             {
                 if ([listArray count])
                 {
                     for (NSDictionary *listDict in listArray)
                     {
                         PersonCenterListModel *listModel = [PersonCenterListModel mj_objectWithKeyValues:listDict];
                         [_dataArray addObject:listModel];
                     }
                 }
             }
             
         }
         
         [self.tableView reloadData];
         [FWMJRefreshManager endRefresh:self.tableView];
         
     } FailureBlock:^(NSError *error) {
         
         FWStrongify(self)
         [self hideMyHud];
         [FWMJRefreshManager endRefresh:self.tableView];
         
     }];
}

#pragma mark ----tabelView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
#pragma mark ----设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonCenterListModel *item = [_dataArray objectAtIndex:indexPath.row];
    CGFloat height ;
    @try {
        height = [tableView fd_heightForCellWithIdentifier:@"FWDynamicCell" cacheByIndexPath:indexPath configuration:^(FWDynamicCell *cell) {
            cell.fd_enforceFrameLayout = YES;
            [cell setData:item andRow:(int)indexPath.row];
        }];
        
    } @catch (NSException *exception) {
        
        height = 150;
    } @finally {
        
    }
    return height-10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FWDynamicCell" forIndexPath:indexPath];
    cell.DDelegate = self;
    PersonCenterListModel *item = _dataArray[indexPath.row];
    [cell setData:item andRow:(int)indexPath.row];
    cell.fd_enforceFrameLayout = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCenterListModel *item = _dataArray[indexPath.row];
    _pushCount = (int)indexPath.row;
    if ([item.type isEqualToString:@"video"])//视频动态
    {
        FWVideoDetailController *VideoVC = [[FWVideoDetailController alloc]init];
        VideoVC.weibo_id = item.weibo_id;
        VideoVC.lastView = 1;
        [[AppDelegate sharedAppDelegate] pushViewController:VideoVC];
    }
}

#pragma mark 点赞
- (void)onPressZanBtnOnDynamicCell:(FWDynamicCell *)cell andTag:(int)tag
{
    if (tag % 100 ==0)//点赞
    {
        [self zanreLoadRowWithTag:tag];
    }else if (tag % 100 == 1)//评论
    {
        
    }else if (tag % 100 == 2)//播放
    {
        
    }else if (tag % 100 == 3)//更多
    {
        [self getMoreViewWithTag:tag];
    }else if (tag % 100 == 4)//我要购买
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"我要购买功能还在完善中"];
    }else if (tag % 100 == 5)//红包
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"红包功能还在完善中"];
    }
}

#pragma mark 图片的点击事件(包括置顶)
- (void)onPressImageView:(FWDynamicCell *)cell andTag:(int)tag
{
    _imageRow = tag;
    if (tag % 100 == 20)//顶置
    {
        PersonCenterListModel *item = _dataArray[tag/100];
        [self setTopWithTag:item.weibo_id andTag:tag];
    }else if (tag % 100 == 21)//点击头像
    {
        PersonCenterListModel *item = _dataArray[tag/100];
        SHomePageVC *homePageVC = [[SHomePageVC alloc]init];
        homePageVC.user_id = item.user_id;
        homePageVC.type = 0;
        [[AppDelegate sharedAppDelegate] pushViewController:homePageVC];
    }else
    {
        PersonCenterListModel *item = _dataArray[tag/100];
        if ([item.type isEqualToString:@"red_photo"] /*|| [item.type isEqualToString:@"imagetext"]*/)
        {
            NSDictionary *imageDict = item.images[tag%100];
            if ([imageDict toInt:@"is_model"] == 1)
            {
                
            }else if ([imageDict toInt:@"is_model"] == 0)
            {
                [self.photoManager goToPhotoWithVC:self withTag:tag%100 withModel:item];
            }
        }else
        {
            if ([item.type isEqualToString:@"imagetext"])
            {
                
                [self.photoManager goToPhotoWithVC:self withTag:tag%100 withModel:item];
            }else if ([item.type isEqualToString:@"video"])
            {
                [self addPlayNumWithWeiBoId:item.weibo_id andTag:tag];
                FWPlayVideoController *playVC = [FWPlayVideoController new];
                playVC.playUrl =item.video_url;
                [[AppDelegate sharedAppDelegate] pushViewController:playVC];
            }else
            {
                [self.photoManager goToPhotoWithVC:self withTag:tag%100 withModel:item];
            }
        }
    }
}

#pragma mark 置顶
- (void)setTopWithTag:(NSString *)weibo_id andTag:(int)tag
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"set_top" forKey:@"act"];
    if (weibo_id.length)
    {
        [MDict setObject:weibo_id forKey:@"weibo_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             PersonCenterListModel *item = _dataArray[tag/100];
             item.is_top = [responseJson toString:@"is_top"];
             [_dataArray removeObjectAtIndex:tag/100];
             [_dataArray insertObject:item atIndex:0];
             [self.tableView reloadData];
         }
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark 点赞
- (void)zanreLoadRowWithTag:(int)tag
{
    PersonCenterListModel *item = _dataArray[tag/100];
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"publish_comment" forKey:@"act"];
    if (item.weibo_id)
    {
        [MDict setObject:item.weibo_id forKey:@"weibo_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    [MDict setObject:@"2" forKey:@"type"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             item.digg_count = [responseJson toString:@"digg_count"];
             item.has_digg   = [responseJson toInt:@"has_digg"];
             [_dataArray replaceObjectAtIndex:(tag/100) withObject:item];
         }
         NSIndexPath *te = [NSIndexPath indexPathForRow:(tag/100) inSection:0];//刷新某段某行
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}
#pragma mark 播放视频加1
- (void)addPlayNumWithWeiBoId:(NSString *)weiBoId andTag:(int)tag
{
    PersonCenterListModel *item = _dataArray[tag/100];
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"weibo" forKey:@"ctl"];
    [MDict setObject:@"add_video_count" forKey:@"act"];
    if (weiBoId.length)
    {
        [MDict setObject:weiBoId forKey:@"weibo_id"];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             item.video_count = [responseJson toString:@"video_count"];
             [_dataArray replaceObjectAtIndex:(tag/100) withObject:item];
         }
         NSIndexPath *te = [NSIndexPath indexPathForRow:(tag/100) inSection:0];//刷新某段某行
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma  mark 更多
- (void)getMoreViewWithTag:(int)tag
{
    _moreTag = tag;
    PersonCenterListModel *listModel = _dataArray[_moreTag/100];
    if (self.tableViewType == 1)
    {
        [self creatActionViewWithModel:listModel];
    }else
    {
        
        if ([listModel.user_id isEqualToString:[[IMAPlatform sharedInstance].host imUserId]])
        {
            UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [headImgSheet addButtonWithTitle:@"删除动态"];
            [headImgSheet addButtonWithTitle:@"取消"];
            headImgSheet.tag = 3;
            headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
            headImgSheet.delegate = self;
            [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
            
            //[self creatActionViewWithModel:listModel];
        }else
        {
            UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [headImgSheet addButtonWithTitle:@"举报该动态"];
            [headImgSheet addButtonWithTitle:@"举报该用户"];
            //            if (listModel.has_black == 0) [headImgSheet addButtonWithTitle:@"拉黑该用户"];
            //            else [headImgSheet addButtonWithTitle:@"解除拉黑"];
            [headImgSheet addButtonWithTitle:@"取消"];
            headImgSheet.tag = 1;
            headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
            headImgSheet.delegate = self;
            [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
    
}

- (void)creatActionViewWithModel:(PersonCenterListModel *)listModel
{
    UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if ([listModel.is_top intValue] == 1 && [listModel.is_show_top intValue] == 1)
    {
        [headImgSheet addButtonWithTitle:@"取消置顶"];
    }else
    {
        [headImgSheet addButtonWithTitle:@"置顶动态"];
    }
    [headImgSheet addButtonWithTitle:@"删除动态"];
    [headImgSheet addButtonWithTitle:@"取消"];
    headImgSheet.tag = 2;
    headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
    headImgSheet.delegate = self;
    [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if(actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self goToReportControllerWithTag:1];
        }else if (buttonIndex == 1)
        {
            [self goToReportControllerWithTag:2];
        }
        //        else if (buttonIndex == 2)
        //        {
        //            [self defriendAction];//拉黑或者解除拉黑
        //        }
    }else if (actionSheet.tag == 2)
    {
        PersonCenterListModel *listModel = _dataArray[_moreTag/100];
        if (buttonIndex == 0)
        {
            [self setTopWithTag:listModel.weibo_id andTag:_moreTag];
            
        }else if (buttonIndex == 1)
        {
            [self deleteDynamicWithString:listModel.weibo_id];
        }
    }else if (actionSheet.tag == 3)
    {
        PersonCenterListModel *listModel = _dataArray[_moreTag/100];
        if (buttonIndex == 0)
        {
            [self deleteDynamicWithString:listModel.weibo_id];
        }
    }
}

#pragma mark 删除某条动态
- (void)deleteDynamicWithString:(NSString *)string
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"del_weibo" forKey:@"act"];
    if (string.length)
    {
        [MDict setObject:string forKey:@"weibo_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             if (_moreTag/100 < _dataArray.count)
             {
                 [_dataArray removeObjectAtIndex:_moreTag/100];
                 [self.tableView reloadData];
             }
         }
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark 拉黑或者解除拉黑
- (void)defriendAction
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    PersonCenterListModel *listModel = _dataArray[_moreTag/100];
    if (listModel.user_id)
    {
        [MDict setObject:listModel.user_id forKey:@"to_user_id"];
    }
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"set_black" forKey:@"act"];
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             listModel.has_black = [responseJson toInt:@"has_black"];
             [_dataArray replaceObjectAtIndex:_moreTag/100 withObject:listModel];
             if ([responseJson toInt:@"has_black"] == 1) [[FWHUDHelper sharedInstance] tipMessage:@"拉黑成功"];//拉黑
             else [[FWHUDHelper sharedInstance] tipMessage:@"解除拉黑成功"];//解除拉黑
             
             for (int i = 0; i<_dataArray.count; i++)//拉黑或者解除拉黑之后该id的拉黑推荐状态都会改变(本地操作)
             {
                 PersonCenterListModel *backModel = _dataArray[i];
                 if ([backModel.user_id isEqualToString:listModel.user_id])
                 {
                     backModel.has_black = [responseJson toInt:@"has_black"];
                     [self.dataArray replaceObjectAtIndex:i withObject:backModel];
                 }
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

- (void)goToReportControllerWithTag:(int)tag
{
    FWReportController *reportVC = [[FWReportController alloc]init];
    PersonCenterListModel *item = _dataArray[_moreTag/100];
    reportVC.weibo_id = item.weibo_id;
    reportVC.to_user_id = item.user_id;
    if (tag == 1)//动态
    {
        reportVC.reportType = 1;
    }else if (tag == 2)
    {
        reportVC.reportType = 2;
    }
    [[AppDelegate sharedAppDelegate] pushViewController:reportVC];
}

#pragma mark =================付款的操作流程 =================
-(void)pushToPayControllerViewWithMoney:(float)count andType:(int)type
{
    [self getPayWayData];
    [self payActionViewWithMoney:count];
}

#pragma mark 取出支付方式的数据
- (void)getPayWayData
{
    [_payArray removeAllObjects];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"payWay.plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *payDict in arr)
    {
        [_payArray addObject:payDict];
    }
}


- (void)payActionViewWithMoney:(float)count
{
    UIActionSheet *paySheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    paySheet.tag = 4;
    for (int i = 0; i < _payArray.count; i ++)
    {
        NSDictionary *dict = _payArray[i];
        [paySheet addButtonWithTitle:[dict objectForKey:@"name"]];
    }
    [paySheet addButtonWithTitle:@"取消"];
    paySheet.cancelButtonIndex = paySheet.numberOfButtons-1;
    paySheet.delegate = self;
    [paySheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)payMoneyWithButtonCount:(int)count
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = _payArray[count];
    if ([[dict toString:@"id"] length] < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"支付id为空"];
        return;
    }else
    {
        [parmDict setObject:[dict toString:@"id"] forKey:@"pay_id"];
    }
    
    PersonCenterListModel *item = _dataArray[_imageRow/100];
    if (item.weibo_id.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"微博id不存在"];
        return;
    }
    [parmDict setObject:item.weibo_id forKey:@"weibo_id"];
    [parmDict setObject:@"pay" forKey:@"ctl"];
    [parmDict setObject:@"pay" forKey:@"act"];
    [parmDict setObject:_payMoney forKey:@"money"];
    [[FWHUDHelper sharedInstance] syncLoading:@"支付请求中,请稍后" inView:self.view];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [[FWHUDHelper sharedInstance] syncStopLoading];
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         if ([responseJson toInt:@"status"]==1)
         {
             NSDictionary *payDic =[responseJson objectForKey:@"pay"];
             NSDictionary *sdkDic =[payDic objectForKey:@"sdk_code"];
             NSString *sdkType =[sdkDic objectForKey:@"pay_sdk_type"];
             if ([sdkType isEqualToString:@"alipay"]) {
                 //支付宝支付
                 
             }
             else if ([sdkType isEqualToString:@"wxpay"])
             {
                 //微信支付
                 NSDictionary *configDic =[payDic objectForKey:@"config"];
                 NSDictionary *iosDic =[configDic objectForKey:@"ios"];
                 Mwxpay * wxmodel =[Mwxpay mj_objectWithKeyValues: iosDic];
                 PayReq* req = [[PayReq alloc] init];
                 req.openID = wxmodel.appid;
                 req.partnerId = wxmodel.partnerid;
                 req.prepayId = wxmodel.prepayid;
                 req.nonceStr = wxmodel.noncestr;
                 req.timeStamp = [wxmodel.timestamp intValue];
                 req.package = wxmodel.package;
                 req.sign = wxmodel.sign;
                 [WXApi sendReq:req];
                 
             }
             else
             {
                 NSLog(@"错误");
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         [[FWHUDHelper sharedInstance] syncStopLoading];
         [SVProgressHUD dismiss];
         [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
     }];
    
}

#pragma mark 微信支付成功后的通知事件
- (void)paySuccess
{
    [self updateTableViewRowAgain];
}

#pragma mark  点赞数量和评论数量刷新
- (void)getNotificationAction:(NSNotification *)notification
{
    NSMutableDictionary * infoDic = [notification object];
    if ([[infoDic objectForKey:@"reloadView"] integerValue] == 1)
    {
        if (_pushCount < _dataArray.count)
        {
            if ([[infoDic objectForKey:@"type"] isEqualToString:@"delete"])
            {
                [_dataArray removeObjectAtIndex:_pushCount];
                [_tableView reloadData];
            }else
            {
                PersonCenterListModel *listModel = _dataArray[_pushCount];
                if ([[infoDic objectForKey:@"type"] isEqualToString:@"dianZan"])//点赞
                {
                    listModel.digg_count = [infoDic objectForKey:@"count"];
                    listModel.has_digg =[[infoDic objectForKey:@"has_digg"] intValue];
                    
                }else if ([[infoDic objectForKey:@"type"] isEqualToString:@"comment"])//评论
                {
                    listModel.comment_count = [infoDic objectForKey:@"count"];
                    
                }else if ([[infoDic objectForKey:@"type"] isEqualToString:@"video"])//视频观看
                {
                    listModel.video_count = [infoDic objectForKey:@"count"];
                    
                }else if ([[infoDic objectForKey:@"type"] isEqualToString:@"payMoney"])//付款
                {
                    PersonCenterListModel *listModel = [PersonCenterListModel new];
                    listModel = [infoDic objectForKey:@"dictionary"];
                    
                }
                [_dataArray replaceObjectAtIndex:_pushCount withObject:listModel];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_pushCount inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];//加载某段某行
            }
        }
        
    }
}

#pragma mark 付款成功之后刷新UI
- (void)updateTableViewRowAgain
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"weibo" forKey:@"ctl"];
    [dict setObject:@"index" forKey:@"act"];
    PersonCenterListModel *item = _dataArray[_imageRow/100];
    if (item.weibo_id.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"微博id不存在"];
        return;
    }
    [dict setObject:item.weibo_id forKey:@"weibo_id"];
    [dict setObject:@"1" forKey:@"is_paid"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             PersonCenterListModel *listModel = [[PersonCenterListModel alloc]init];
             listModel.images = [[NSMutableArray alloc]init];
             listModel = [PersonCenterListModel mj_objectWithKeyValues:responseJson];
             [_dataArray replaceObjectAtIndex:_imageRow/100 withObject:listModel];
             NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_imageRow/100 inSection:0];
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];//加载某段某行
         }
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
     } FailureBlock:^(NSError *error)
     {
         [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
     }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}





@end
