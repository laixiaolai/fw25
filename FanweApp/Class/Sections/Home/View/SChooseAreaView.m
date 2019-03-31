//
//  SChooseAreaView.m
//
//
//  Created by 丁凯 on 2017/8/21.
//

#import "SChooseAreaView.h"
#import "SSelectAreaCell.h"

#define kBtnSpaceW (kScreenW - 270)/4.0f

@implementation SChooseAreaView

- (id)initWithFrame:(CGRect)frame andChooseType:(int)areaType andAreaStr:(NSString *)areaStr
{
    self = [super initWithFrame:frame];
    if (self)
    {
        int scrollIndex = 0;
        if (areaType == 2)
        {
            scrollIndex = 1;
        }else if (areaType == 1)
        {
            scrollIndex = 2;
        }
        self.sexType            = areaType;
        self.selectRow          = 0;
        self.chooseAreaStr      = areaStr;
        self.backgroundColor    = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        self.dataArray          = [[NSMutableArray alloc]init];
        self.nameArray          = [[NSMutableArray alloc]initWithObjects:@"看全部",@"只看女",@"只看男", nil];
        self.imageArray         = [[NSMutableArray alloc]initWithObjects:@"fw_area_all",@"fw_area_woman",@"fw_area_man", nil];
        [self creatMyUIWithType:scrollIndex];
    }
    return self;
}

- (void)creatMyUIWithType:(int)type
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    lineView.backgroundColor = kAppSpaceColor4;
    [self addSubview:lineView];
    
    [self addSubview:[self creatLabelWithStr:@"性别" andFrame:CGRectMake(10, 20, kScreenW-10, 30)]];
    for (int i = 0; i < 3; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kBtnSpaceW + (90+kBtnSpaceW)*i, 70, 90, 33);
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        [button setTitle:self.nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:button];
    }
    
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn.frame = CGRectMake(kBtnSpaceW + (90+kBtnSpaceW)*type, 70, 90, 33);
    [self addSubview:self.bottomBtn];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"fw_area_select"] forState:UIControlStateNormal];
    [self sendSubviewToBack:self.bottomBtn];
    [self addSubview:[self creatLabelWithStr:@"地区" andFrame:CGRectMake(10, 117, kScreenW-10, 30)]];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomBtn.frame)+70, kScreenW, self.height-71-70-CGRectGetMaxY(self.bottomBtn.frame))];
    self.myTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.dataSource      = self;
    self.myTableView.delegate        = self;
    [self addSubview:self.myTableView];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SSelectAreaCell" bundle:nil] forCellReuseIdentifier:@"SSelectAreaCell"];
    [FWMJRefreshManager refresh:self.myTableView target:self headerRereshAction:@selector(loadDataNet) footerRereshAction:nil];
    
    self.finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishBtn.frame = CGRectMake(10, CGRectGetMaxY(self.myTableView.frame)+10, kScreenW-20, 51);
    self.finishBtn.layer.cornerRadius = 20;
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.finishBtn setBackgroundImage:[FWUtils resizableImage:@"fw_area_finish"] forState:UIControlStateNormal];
    self.finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.finishBtn.layer.masksToBounds = YES;
    [self.finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.finishBtn];
    
}

#pragma mark 网络加载
- (void)loadDataNet
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"search_area" forKey:@"act"];
    [parmDict setObject:@(self.sexType) forKey:@"sex"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self.dataArray removeAllObjects];
         if ([responseJson toInt:@"status"] == 1)
         {
             NSArray *array = [responseJson objectForKey:@"list"];
             if (array)
             {
                 if (array.count > 0)
                 {
                     for (NSDictionary *dict in array)
                     {
                         UserModel *model = [UserModel mj_objectWithKeyValues:dict];
                         [self.dataArray addObject:model];
                     }
                 }
             }
             [self.myTableView reloadData];
             if (self.dataArray.count)
             {
                 [self hideNoContentViewOnView:self.myTableView];
                 [self getChooseRow];
                 NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.selectRow inSection:0];
                 [self.myTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
             }else
             {
                 [self showNoContentViewOnView:self.myTableView];
             }
             
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         [FWMJRefreshManager endRefresh:self.myTableView];
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.myTableView];
     }];
}

- (UILabel *)creatLabelWithStr:(NSString *)nameStr andFrame:(CGRect)frame
{
    UILabel  *myLabel = [[UILabel alloc]initWithFrame:frame];
    myLabel.text      = nameStr;
    myLabel.textColor = kAppGrayColor1;
    myLabel.font      = [UIFont systemFontOfSize:14];
    return myLabel;
}

#pragma mark - Tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count > 0)
    {
        return _dataArray.count;
    }else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *model = _dataArray[indexPath.row];
    SSelectAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSelectAreaCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kClearColor;
    if (indexPath.row == self.selectRow)
    {
        cell.bottomView.hidden = NO;
        cell.numLabel.textColor = cell.cityLabel.textColor = kWhiteColor;
    }else
    {
        cell.bottomView.hidden  = YES;
        cell.numLabel.textColor = cell.cityLabel.textColor = kAppGrayColor1;
    }
    cell.cityLabel.text = model.city;
    cell.numLabel.text  = model.number;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36*kAppRowHScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectRow   = (int)indexPath.row;
    if (indexPath.row < self.dataArray.count)
    {
        UserModel *model = _dataArray[indexPath.row];
        self.chooseAreaStr = model.city;
    }
    [self.myTableView reloadData];
}

#pragma mark 判断选择哪个row
- (void)getChooseRow
{
    self.selectRow = 0;
    for (int i = 0; i < self.dataArray.count; i++)
    {
        UserModel *model = self.dataArray[i];
        if ([model.city isEqualToString:self.chooseAreaStr])
        {
            self.selectRow = i;
        }
    }
}

- (void)finishBtnClick:(UIButton *)btn
{
    if (btn == self.finishBtn)
    {
        if (self.areaBlock)
        {
            self.areaBlock(self.chooseAreaStr, self.sexType);
        }
    }else
    {
        if (btn.tag == 1)//女
        {
         self.sexType         = 2;
        }else if (btn.tag == 2)//男
        {
         self.sexType         = 1;
        }else //男女
        {
         self.sexType         = 0;
        }
        
        [self loadDataNet];
        [UIView animateWithDuration:0.6 animations:^{
            CGRect rect          = self.bottomBtn.frame;
            rect.origin.x        = kBtnSpaceW + (90+kBtnSpaceW)*btn.tag;
            self.bottomBtn.frame = rect;
        }];
        
    }
}
//
//#pragma mark - ----------------------- 无内容视图 -----------------------
//
//- (void)showNoContentView
//{
//    [self.myTableView addSubview:self.noContentView];
//}
//
//- (void)hideNoContentView
//{
//    [self.noContentView removeFromSuperview];
//}
//
//- (FWNoContentView *)noContentView
//{
//    if (!_noContentView)
//    {
//        _noContentView = [FWNoContentView noContentWithFrame:CGRectMake(0, 0, 150, 175)];
//        _noContentView.center = CGPointMake(self.myTableView.frame.size.width/2, self.myTableView.frame.size.height/2);
//    }
//    return _noContentView;
//}

@end
