//
//  AuctionItemdetailsViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionItemdetailsViewController.h"
#import "OneSectionTableViewCell.h"
#import "TwoSectionTableViewCell.h"
#import "ThreeSectionTableViewCell.h"
#import "FourSectionTableViewCell.h"
#import "FiveSectionTableViewCell.h"
#import "SixSectionTableViewCell.h"
#import "SevenSectionTableViewCell.h"
#import "AcutionDetailModel.h"
#import "InfoModel.h"
#import "AcutionHistoryModel.h"
#import "JoinDataModel.h"
#import "areaView.h"
#import "DepositViewController.h"
#import "SevenSectionTableViewCell.h"
#import "GoodsDetailsCell.h"
#import "TitleViewCell.h"
#import "ImgTableViewCell.h"
#import "detailTableViewCell.h"


@interface AuctionItemdetailsViewController ()<UITableViewDelegate,UITableViewDataSource,acutionButtonDelegate,UIScrollViewDelegate,CellHeightDelegate>

@property (nonatomic, strong) UITableView                     *myTableView;
@property (nonatomic, strong) NSMutableArray                  *bigArray;                      //最外层的数组
@property (nonatomic, strong) NSMutableArray                  *dataArray;                     //竞拍记录的数组
@property (nonatomic, strong) NSMutableArray                  *picturesArr;                   //图片的数组
@property (nonatomic, strong) UIScrollView                    *scrollerView;
@property (nonatomic, strong) OneSectionTableViewCell         *oneSectionCell;
@property (nonatomic, assign) int                             secString;                      //竞拍剩余时间秒
@property (nonatomic, assign) int                             minString;                      //竞拍剩余时间分
@property (nonatomic, assign) int                             hourString;                     //竞拍剩余时间时
@property (nonatomic, assign) int                             has_join;                       //通过这个字段来判断是否有交保证金 0:未交保证金 1:已交保证金
@property (nonatomic, assign) int                             is_true;                        //通过这个字段来判断是否是虚拟产品 0虚拟 1普通商品
@property (nonatomic, assign) int                             acutionStatus;                  //通过这个字段来判断竞拍的状态 0竞拍中 1竞拍成功 2流拍 3失败
@property (nonatomic, assign) int                             has_next;
@property (nonatomic, assign) int                             page;
@property (nonatomic, assign) float                           bz_money;                       //保证金
@property (nonatomic, assign) int                             pai_left_time;                  //竞拍剩余时间(秒)
@property (nonatomic, assign) float                           height;
@property (nonatomic, assign) BOOL                            isFirst;                        //是否第一次加载
@property (nonatomic, assign) CGFloat                         height2;

@property (nonatomic, copy) NSString                          *pai_logs_url;                  //竞拍记录的url
@property (nonatomic, copy) NSString                          *url;                           //实物竞拍的url
@property (nonatomic, strong) UIView                          *alaphView;
@property (nonatomic, strong) UIImageView                     *alaphImgView;
@property (nonatomic, assign) int                             pai_nums;                       //竞拍次数
@property (nonatomic, assign) int                             buttonCount;                    //展开或者收缩
@property (nonatomic, strong) UIImageView                     *imgView;                       //返回
@property (nonatomic, strong) UIButton                        *button;
@property (nonatomic, strong) NSMutableArray                  *imgViewArray;                  //详情显示的图片


@property (nonatomic, strong) UIPageControl *pageC;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timers;

@end

@implementation AuctionItemdetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    self.view.backgroundColor = kBackGroundColor;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.navigationItem.title             = @"竞拍详情";
    self.isFirst = YES;
    self.dataArray = [[NSMutableArray alloc]init];
    self.imgViewArray = [[NSMutableArray alloc]init];
    self.picturesArr = [[NSMutableArray alloc]init];
    self.bigArray = [[NSMutableArray alloc]init];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kNavigationBarHeight-kStatusBarHeight)];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = kBackGroundColor;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"OneSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"OneSectionTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"TwoSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"TwoSectionTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ThreeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThreeSectionTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"FourSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"FourSectionTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"FiveSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"FiveSectionTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SixSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"SixSectionTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"TitleViewCell" bundle:nil] forCellReuseIdentifier:@"TitleViewCell"];
    [self.myTableView registerClass:[NSClassFromString(@"detailTableViewCell") class] forCellReuseIdentifier:@"detailTableViewCell"];
    [self.myTableView registerClass:[NSClassFromString(@"GoodsDetailsCell") class] forCellReuseIdentifier:@"GoodsDetailsCell"];
    [self.myTableView registerClass:[NSClassFromString(@"ImgTableViewCell") class] forCellReuseIdentifier:@"ImgTableViewCell"];
    [self.view addSubview:self.myTableView];
    
    self.scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW)];
    self.scrollerView.showsVerticalScrollIndicator = NO;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollerView.bounces = NO;
    self.scrollerView.delegate = self;
    self.scrollerView.pagingEnabled = YES;
    
    self.myTableView.tableHeaderView = self.scrollerView;
    [self startTimer];
    
    [self loadNetdata:1];
}

#pragma mark 开始定时器
- (void)startTimer
{
    if (!_timers)
    {
        _timers = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(handleTimerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timers forMode:NSRunLoopCommonModes];
    }
}

#pragma mark 关闭定时器
- (void)stopTimer
{
    [_timers invalidate];
    _timers = nil;
}

- (void)comeBack
{
    if (self.fanweApp.liveState)
    {
        [self backLiveVC];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark 网络加载
- (void)loadNetdata:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    if (self.type == 0)//观众
    {
        [parmDict setObject:@"pai_user" forKey:@"ctl"];
        [parmDict setObject:@"1" forKey:@"get_joindata"];
    }else//主播
    {
        [parmDict setObject:@"pai_podcast" forKey:@"ctl"];
        [parmDict setObject:@"1" forKey:@"page_size"];
    }
    [parmDict setObject:@"goods_detail" forKey:@"act"];
    if (self.productId)
    {
        [parmDict setObject:self.productId forKey:@"id"];
    }
    [parmDict setObject:@"1" forKey:@"p"];
    [parmDict setObject:@"1" forKey:@"get_pailogs"];
    [parmDict setObject:@"shop" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self.dataArray removeAllObjects];
         [self.picturesArr removeAllObjects];
         [self.imgViewArray removeAllObjects];
         if ([responseJson toInt:@"status"] == 1)
         {
             if ([responseJson objectForKey:@"data"])
             {
                 if ([[responseJson objectForKey:@"data"] count])
                 {
                     self.pai_logs_url = [[[responseJson objectForKey:@"data"] objectForKey:@"info"] toString:@"pai_logs_url"];
                     self.url = [[[responseJson objectForKey:@"data"] objectForKey:@"info"] toString:@"url"];
                     self.is_true = [[[responseJson objectForKey:@"data"] objectForKey:@"info"] toInt:@"is_true"];
                     self.has_join = [[responseJson objectForKey:@"data"] toInt:@"has_join"];
                     self.acutionStatus = [[[responseJson objectForKey:@"data"] objectForKey:@"info"] toInt:@"status"];
                     self.bz_money = [[[responseJson objectForKey:@"data"] objectForKey:@"info"] toFloat:@"bz_diamonds"];
                     self.pai_left_time = [[[responseJson objectForKey:@"data"]  objectForKey:@"info"] toInt:@"pai_left_time"];
                     self.pai_nums = [[[responseJson objectForKey:@"data"]  objectForKey:@"info"] toInt:@"pai_nums"];
                     if (self.acutionStatus == 0)//竞拍过程
                     {
                         [self timeGoWithSec];
                     }
                     AcutionDetailModel *ADModel = [AcutionDetailModel mj_objectWithKeyValues:[responseJson objectForKey:@"data"]];
                     [self.bigArray addObject:ADModel];
                     
                     //滚动图片
                     id pics = [[[responseJson objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"imgs"];
                     if (pics && [pics isKindOfClass:[NSArray class]])
                     {
                         if ([pics count])
                         {
                             for (NSMutableDictionary *dict in pics)
                             {
                                 [self.picturesArr addObject:dict];
                             }
                         }
                     }
                     if (self.picturesArr.count > 0)
                     {
                         if (self.picturesArr.count >= 2)
                         {
                             [self.picturesArr insertObject:_picturesArr.firstObject atIndex:_picturesArr.count];
                             [self.picturesArr insertObject:_picturesArr[_picturesArr.count  - 2] atIndex:0];
                             
                         }
                         [self takeTurnsOfPictures];
                         
                     }
                     id idArray = [[responseJson objectForKey:@"data"] objectForKey:@"pai_list"];
                     if (idArray && [idArray isKindOfClass:[NSArray class]])
                     {
                         if ([idArray count] > 0)
                         {
                             for (NSMutableDictionary *dictM in idArray)
                             {
                                 AcutionHistoryModel *model = [AcutionHistoryModel mj_objectWithKeyValues:dictM];
                                 [self.dataArray addObject:model];
                             }
                         }
                     }
                     
                     //实物竞拍详情的图片
                     id goods_detail = [[[[responseJson objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"commodity_detail"]objectForKey:@"goods_detail"];
                     if (goods_detail && [goods_detail isKindOfClass:[NSArray class]])
                     {
                         if ([goods_detail count] > 0)
                         {
                             for (NSMutableDictionary *dictM in goods_detail)
                             {
                                 AcutionHistoryModel *model = [AcutionHistoryModel mj_objectWithKeyValues:dictM];
                                 [self.imgViewArray addObject:model];
                             }
                         }
                     }
                 }
             }
         }
         [self.myTableView reloadData];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}

#pragma mark 定时器
- (void)timeGoWithSec
{
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeGo:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark -- dataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return autionTablevCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == thirdSection)//判断是否是虚拟的商品 0是虚拟的商品 1不是虚拟的商品
    {
        if (self.is_true == 0)
        {
            return 1;
        }else
        {
            return 0;
        }
    }else if (section == firstSection)
    {
        if (self.bigArray.count)
        {
            return 1;
        }else
        {
            return 0;
        }
    }
    else if (section == fifthSection)
    {
        if (self.dataArray.count)
        {
            if (self.dataArray.count >= 3)
            {
                return 3;
            }else
            {
                return self.dataArray.count;
            }
        }else
        {
            return 0;
        }
    }
    else if (section == seventhSection)
    {
        if (self.type == 1)//是主播
        {
            return 0;
        }else
        {
            if (self.acutionStatus == 0)//观众处于竞拍中才有返回一段
            {
                return 1;
            }else
            {
                return 0;
            }
        }
    }
    else if (section == sixthSection)
    {
        if (self.is_true == 1)//实物竞拍
        {
            if (self.buttonCount == 0)
            {
                return 1;
            }else
            {
                return self.imgViewArray.count+1;
            }
        }else//虚拟竞拍
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier1 = @"CellIdentifier1";
//    static NSString *CellIdentifier2 = @"CellIdentifier2";
//    static NSString *CellIdentifier3 = @"CellIdentifier3";
    if (indexPath.section == zeroSection)
    {
        self.oneSectionCell = [tableView dequeueReusableCellWithIdentifier:@"OneSectionTableViewCell"];
        self.oneSectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.bigArray.count > 0)
        {
            [self.oneSectionCell creatCellWithArray:self.bigArray andStatue:self.acutionStatus];
        }
        return self.oneSectionCell;
    }
    else if (indexPath.section == firstSection)
    {
        TitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleViewCell"];
        if (self.bigArray.count > 0)
        {
            AcutionDetailModel *model = self.bigArray[0];
            [cell setCellWithString:model.info.name];
        }
        return cell;
    }
    else if (indexPath.section == secondSection)
    {
        TwoSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwoSectionTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.bigArray.count > 0)
        {
            [cell creatCellWithArray:self.bigArray];
        }else
        {
            [cell creatCellWithArray:nil];
        }
        return cell;
    }
    else if (indexPath.section == thirdSection)
    {
        SixSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SixSectionTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.bigArray.count > 0)
        {
            AcutionDetailModel *model = self.bigArray[0];
            [cell setCellWithPlace:model.info.place andPlace:model.info.date_time];
        }
        return cell;
    }
    else if (indexPath.section == fourthSection)
    {
        ThreeSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThreeSectionTableViewCell"];
        if (self.pai_nums > 0)
        {
            [cell creatCellWithNum:self.pai_nums];
        }else
        {
            [cell creatCellWithNum:self.pai_nums];
        }
        if (self.dataArray.count)
        {
            cell.lineView.hidden = NO;
        }else
        {
           cell.lineView.hidden = YES;
        }
        return cell;
    }
    else if (indexPath.section == fifthSection)
    {
        FourSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FourSectionTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.dataArray.count)
        {
            AcutionHistoryModel *model = self.dataArray[indexPath.row];
            [cell creatCellWithModel:model withRow:(int)indexPath.row];
        }
        
        return cell;
    }else if(indexPath.section == sixthSection)
    {
        if (self.is_true == 0)
        {
            detailTableViewCell *cell = (detailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailTableViewCell"];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (cell == nil)
//            {
//                cell = [[detailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
            if (self.bigArray.count > 0)
            {
                AcutionDetailModel *model = self.bigArray[0];
                [cell setCellWithString:model.info.Description];
            }
            return cell;
        }else
        {
            if (indexPath.row == 0)
            {
                GoodsDetailsCell *cell = (GoodsDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"GoodsDetailsCell"];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                if (cell == nil) {
//                    cell = [[GoodsDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
//                    cell.delegate = self;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
                if (self.buttonCount == 0)
                {
                    cell.downUpImgView.image = [UIImage imageNamed:@"com_arrow_down_2"];
                }else
                {
                    cell.downUpImgView.image = [UIImage imageNamed:@"com_arrow_up_1"];
                }
                [cell setButtonCount:self.buttonCount];
                return cell;
                
            }else
            {
                ImgTableViewCell *cell = (ImgTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ImgTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                if (cell == nil) {
//                    cell = [[ImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
                if (self.imgViewArray.count > 0)
                {
                    AcutionHistoryModel *model = self.imgViewArray[indexPath.row-1];
                    [cell setCellWithModel:model];
                    if (indexPath.row-1 == self.imgViewArray.count)
                    {
                        cell.lineView.hidden = NO;
                    }
                }
                
                return cell;
            }
        }
    }else
    {
        FiveSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FiveSectionTableViewCell"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.has_join == 0 && self.pai_left_time > 0)//未交保证金
        {
            cell.auctionMoneyLabel.hidden = NO;
            cell.goldView.hidden = NO;
            cell.auctionLabel.hidden = NO;
            cell.depositButton.hidden = NO;
            cell.continueButton.hidden = YES;
            if (self.bz_money/10000 > 1)
            {
                cell.auctionMoneyLabel.text = [NSString stringWithFormat:@"%.2f万",self.bz_money/10000];
            }else
            {
                cell.auctionMoneyLabel.text = [NSString stringWithFormat:@"%.0f",self.bz_money];
            }
        }else
        {
            cell.auctionMoneyLabel.hidden = YES;
            cell.goldView.hidden = YES;
            cell.auctionLabel.hidden = YES;
            cell.depositButton.hidden = YES;
            cell.continueButton.hidden = NO;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == zeroSection)
    {
        return 50;
    }
    else if (indexPath.section == firstSection)
    {
//        CGFloat height;
        TitleViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TitleViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (self.bigArray.count)
//        {
            AcutionDetailModel *model = self.bigArray[0];
//            height = [cell setCellWithString:model.info.name];
//        }
        return [cell setCellWithString:model.info.name];
    }
    else if (indexPath.section == secondSection)
    {
        return 110;
    }
    else if (indexPath.section == thirdSection)
    {
        if (self.is_true == 0) //判断是否是虚拟的商品 0是虚拟的商品 1不是虚拟的商品
        {
            SixSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SixSectionTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.bigArray.count > 0)
            {
                AcutionDetailModel *model = _bigArray[0];
                self.height2 = [cell setCellWithPlace:model.info.place andPlace:model.info.date_time];
            }
            return self.height2;
        }else
        {
            return 0;
        }
    }
    else if (indexPath.section == seventhSection)//判断是否是主播 1是 0不是
    {
        if (self.type == 1)
        {
            return 0;
        }else
        {
            return 45;
        }
    }else if (indexPath.section == sixthSection)//商品详情
    {
        CGFloat height;
        if (self.is_true == 0)
        {
            return 45;
        }else
        {
            if (indexPath.row == 0)
            {
                return 50;
            }else
            {
                AcutionHistoryModel *model = self.imgViewArray[indexPath.row -1];
                if (model.image_width  == 0 || model.image_height == 0)
                {
                    return kScreenW+2;
                }else
                {
                    height = (model.image_height*kScreenW/model.image_width);
                    return height+2;
                }
            }
        }
    }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == thirdSection || section == fifthSection || section == sixthSection)
    {
        return 10;
    }else
    {
        return 0;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == thirdSection || section == fifthSection)
//    {
//        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenW , 10)];
//        backView.backgroundColor = kBackGroundColor;
//        return backView;
//    }else
//    {
//        return nil;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == fourthSection)//竞拍记录的点击事件
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:_pai_logs_url isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = @"竞拍记录";
        [self.navigationController pushViewController:tmpController animated:YES];
    }
}

#pragma mark -竞拍时间的倒计时
- (void)timeGo:(NSTimer *)sender
{
    if (self.pai_left_time == 0)
    {
        return;
    }
    self.pai_left_time --;
    self.hourString = self.pai_left_time/3600;
    self.minString  = (self.pai_left_time%3600)/60;
    self.secString = (self.pai_left_time)%60;
    self.oneSectionCell.secLabel.text = [NSString stringWithFormat:@"%02d",self.secString];
    self.oneSectionCell.minuteLabel.text = [NSString stringWithFormat:@"%02d",self.minString];
    self.oneSectionCell.hourLabel.text = [NSString stringWithFormat:@"%02d",self.hourString];
    
    if (self.secString == 0 && self.minString == 0 && self.hourString == 0)//竞拍时间为0后cell 需要改变里面控件的状态
    {
        [self.timer invalidate];
        self.timer = nil;
        [self performSelector:@selector(loadAgain) withObject:self afterDelay:1];
    }
}

- (void)loadAgain
{
    [self loadNetdata:1];//竞拍结束，重新刷新接口
}

#pragma mark -创建滚动视图
- (void)takeTurnsOfPictures{
    self.scrollerView.contentSize = CGSizeMake(kScreenW * self.picturesArr.count, 0);
    self.scrollerView.bounces = YES;
    if (self.picturesArr.count  < 4) {
        self.scrollerView.scrollEnabled = NO;
        [self.timers invalidate];
    }
    for (int i = 0; i < self.picturesArr.count; i ++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, kScreenW)];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.userInteractionEnabled = YES;
        [imageV sd_setImageWithURL:self.picturesArr[i]];
        [self.scrollerView addSubview:imageV];
    }
    if (self.picturesArr.count > 1)
    {
        [self.scrollerView setContentOffset:CGPointMake(kScreenW, 0)];
    }else
    {
        [self.scrollerView setContentOffset:CGPointMake(0, 0)];
    }
    //添加页控制器
    if (self.picturesArr.count > 3)
    {
        [self addPageControll];
    }
}

//图片上面的点
- (void)addPageControll{
    if (!self.pageC)
    {
        self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(40, kScreenW*0.9, kScreenW - 100, kScreenW*0.1)];
        self.pageC.numberOfPages = _picturesArr.count - 2;
        self.pageC.tag = 102;
        self.pageC.currentPage = 0;
        self.pageC.currentPageIndicatorTintColor = myPageColor;
        self.pageC.pageIndicatorTintColor = myCurrentPageColor;
        [self.myTableView addSubview:self.pageC];
    }
    
}
#pragma mark -定时器的方法
- (void)handleTimerAction:(NSTimer *)sender
{
    if (self.scrollerView.contentOffset.x == 0)
    {
        [self.scrollerView setContentOffset:CGPointMake( kScreenW * (self.picturesArr.count - 2), 0) animated:NO];
        self.pageC.currentPage = self.picturesArr.count - 2 - 1;
        return;
    }
    if (_scrollerView.contentOffset.x / kScreenW == self.picturesArr.count - 1)
    {
        self.pageC.currentPage = 0;
        [self.scrollerView setContentOffset:CGPointMake(kScreenW, 0) animated:NO];
        return;
    }
    
    [_scrollerView setContentOffset:CGPointMake(self.scrollerView.contentOffset.x +  kScreenW, 0) animated:YES];
    
    NSInteger selected = self.pageC.currentPage;
    if (selected == self.picturesArr.count - 2 - 1)
    {
        self.pageC.currentPage = 0;
    }else
    {
        self.pageC.currentPage = selected + 1;
    }
}

#pragma mark -滚动视图的代理方法
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]])
    {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.picturesArr.count >1)
    {
        if ([scrollView isMemberOfClass:[UIScrollView class]]) {
            if (self.scrollerView.contentOffset.x == kScreenW * (self.picturesArr.count - 1)) {
                self.pageC.currentPage = 0;
                [self.scrollerView setContentOffset:CGPointMake(kScreenW, 0) animated:NO];
            }
            if (self.scrollerView.contentOffset.x == 0) {
                self.pageC.currentPage = self.picturesArr.count - 1 - 2 ;
                [self.scrollerView setContentOffset:CGPointMake((self.picturesArr.count - 2) * kScreenW, 0) animated:NO];
            }
            self.pageC.currentPage = scrollView.contentOffset.x / kScreenW - 1;
        }
        [self startTimer];
    }
}

#pragma mark 继续参拍和参拍交保证金额的代理事件
- (void)buttonClickWithTag:(int)tag
{
    if (tag == 0)//参拍交保金额
    {
        DepositViewController *VC = [[DepositViewController alloc]init];
        if (self.is_true == 0)//虚拟
        {
            VC.type = 0;
        }else
        {
            VC.type = 1;
        }
        VC.bzMoney = [NSString stringWithFormat:@"%.0f",_bz_money];
        VC.productId = self.productId;
        [self.navigationController pushViewController:VC animated:YES];
        //[[AppDelegate sharedAppDelegate] pushViewController:VC];
    }else if (tag == 1)//继续参拍
    {
        if (self.isFromWebView == NO)
        {
            //            [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:NO nextViewController:nil delegateWindowRCNameStr:@"FWTabBarController" complete:^(BOOL finished) {
            //
            //            }];
            [self backLiveVC];
            //[SuspenionWindow popNextVCGoBackFullScreenWidnowLiveWithSelfNavController:self.navigationController];
        }else
        {
            [self goToLiveController];//进入直播间
        }
    }
}

//返回直播间
- (void)backLiveVC
{
    UIViewController *viewCtl;
    for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
    {
        viewCtl = [self.navigationController.viewControllers objectAtIndex:(i)];
        if ([viewCtl isKindOfClass:[FWTLiveController class]] || [viewCtl isKindOfClass:[FWKSYLiveController class]])
        {
            [self.navigationController popToViewController:viewCtl animated:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNetdata:1];
}

#pragma mark webView跳转过来主播还在直播进入直播间
- (void)goToLiveController
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"pai_user" forKey:@"ctl"];
    [parmDict setObject:@"go_video" forKey:@"act"];
    [parmDict setObject:self.productId forKey:@"pai_id"];
    [parmDict setObject:@"shop" forKey:@"itype"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson){
        
        if ([responseJson toInt:@"status"] == 1)
        {
            TCShowUser *showUser = [[TCShowUser alloc]init];
            showUser.uid = [responseJson toString:@"createrId"];
            showUser.avatar =[responseJson toString:@"loadingVideoImageUrl"];
            
            TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
            item.chatRoomId = [responseJson toString:@"groupId"];
            item.avRoomId = [responseJson toInt:@"roomId"];
            item.title = [responseJson toString:@"roomId"];
            item.vagueImgUrl = [responseJson toString:@"loadingVideoImageUrl"];
            item.host = showUser;
            item.liveType = FW_LIVE_TYPE_AUDIENCE;
            
            item.host = showUser;
            
            BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
            [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:item isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
            }];
        }
        
    }FailureBlock:^(NSError *error){
        
    }];
}

- (void)getCellHeightWithCount:(int)count
{
    self.buttonCount = count;
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:sixthSection] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)dealloc
{
    [self stopTimer];
}

@end
