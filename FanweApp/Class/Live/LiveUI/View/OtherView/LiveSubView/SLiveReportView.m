//
//  SLiveReportView.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SLiveReportView.h"
#import "reportModel.h"
#import "SReportViewCell.h"
@implementation SLiveReportView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self makeMYUI];
        [self loadData];
    }
    return self;
}

- (void)makeMYUI
{
    self.dataArray = [[NSMutableArray alloc]init];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.paymentTag = -1;
    self.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //底部白色的view
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - 240*kScaleWidth)/2, (kScreenH-300*kScaleHeight)/2 , 240*kScaleWidth, 320*kScaleHeight)];
    self.bottomView.backgroundColor = kBackGroundColor;
    self.bottomView.layer.cornerRadius = 5;
    self.bottomView.layer.masksToBounds = YES;
    [self addSubview:self.bottomView];
    
    //举报类型
    self.reportType = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bottomView.width, 60*kScaleHeight)];
    self.reportType.textColor = kAppGrayColor1;
    self.reportType.backgroundColor = kBackGroundColor;
    self.reportType.text = @"举报类型";
    self.reportType.font = [UIFont systemFontOfSize:16];
    self.reportType.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.reportType];
    
    //UITableView
    self.reportTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.reportType.frame), self.bottomView.width, 209*kScaleHeight)];
    self.reportTableView.dataSource = self;
    self.reportTableView.delegate = self;
    self.reportTableView.backgroundColor = kBackGroundColor;
    self.reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.reportTableView registerNib:[UINib nibWithNibName:@"SReportViewCell" bundle:nil] forCellReuseIdentifier:@"SReportViewCell"];
    [self.bottomView addSubview:self.reportTableView];
    [FWMJRefreshManager refresh:self.reportTableView target:self headerRereshAction:@selector(loadData) footerRereshAction:nil];
    
    //lineView2
    self.lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.reportTableView.frame), self.bottomView.width, 1)];
    self.lineView2.backgroundColor = kAppSpaceColor4;
    [self.bottomView  addSubview:self.lineView2];
    
    //取消
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0, CGRectGetMaxY(self.lineView2.frame), (self.bottomView.width-1)/2, 50*kScaleHeight);
    //    self.cancelButton.frame = CGRectMake(20*kScaleWidth, CGRectGetMaxY(self.lineView2.frame)+10*kScaleHeight, (self.bottomView.width-60*kScaleWidth)/2, 40*kScaleHeight);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    self.cancelButton.tag = 0;
    [self.cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.cancelButton];
    
    self.VLineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.lineView2.frame), 1, 50*kScaleHeight)];
    self.VLineView.backgroundColor = kAppSpaceColor4;
    [self.bottomView addSubview:self.VLineView];
    
    //确认
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.frame = CGRectMake(CGRectGetMaxX(self.VLineView.frame),CGRectGetMaxY(self.lineView2.frame),(self.bottomView.width-1)/2, 50*kScaleHeight);
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    self.confirmButton.tag = 1;
    [self.confirmButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.confirmButton];
    
}

- (void)loadData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"tipoff_type" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [_dataArray removeAllObjects];
         self.userInteractionEnabled = YES;
         if ([responseJson toInt:@"status"] == 1)
         {
             NSArray *array = [responseJson objectForKey:@"list"];
             if (array.count > 0)
             {
                 for (NSDictionary *dict in array)
                 {
                     reportModel *model = [[reportModel alloc]init];
                     model.ID = [dict toInt:@"id"];
                     model.name = [dict toString:@"name"];
                     [self.dataArray addObject:model];
                 }
                 [self.reportTableView reloadData];
             }
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         [FWMJRefreshManager endRefresh:self.reportTableView];
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         self.userInteractionEnabled = YES;
         [FWMJRefreshManager endRefresh:self.reportTableView];
     }];
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count > 0)
    {
        return self.dataArray.count;
    }else
    {
        return 0;
    }
}
//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SReportViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SReportViewCell" forIndexPath:indexPath];
    reportModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.name.length > 0)
    {
        cell.leftNameLabel.text = model.name;
    }else
    {
        cell.leftNameLabel.text = @"其他原因";
    }
    if (indexPath.row == self.paymentTag)
    {
        cell.selectImgView.image = [UIImage imageNamed:@"com_radio_selected_3"];
    }else
    {
        cell.selectImgView.image = [UIImage imageNamed:@"com_radio_normal_3"];
    }
    return cell;
}

#pragma mark 用来解决跟tableview等的手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]  || [NSStringFromClass([touch.view class]) isEqualToString:@"UIImageView"] || [touch.view isDescendantOfView:self.reportTableView] ||[touch.view isDescendantOfView:self.reportType] ||[touch.view isDescendantOfView:self.bottomView])
    {
        return NO;
    }else
    {
        return YES;
    }
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    if (self.reportDelegate)
    {
        if ([self.reportDelegate respondsToSelector:@selector(clickWithReportId: andBtnIndex: andView:)])
        {
            [self.reportDelegate clickWithReportId:self.reportId andBtnIndex:2 andView:self];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.paymentTag = indexPath.row;
    reportModel *model = _dataArray[indexPath.row];
    self.reportId = [NSString stringWithFormat:@"%d",model.ID];
    [self.reportTableView reloadData];
}

#pragma mark 0取消 1确认
- (IBAction)btnClick:(UIButton *)sender
{
    if (self.reportDelegate)
    {
        if ([self.reportDelegate respondsToSelector:@selector(clickWithReportId: andBtnIndex: andView:)])
        {
            [self.reportDelegate clickWithReportId:self.reportId andBtnIndex:(int)sender.tag andView:self];
        }
    }
}





@end
