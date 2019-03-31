//
//  FWConversationTradeController.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWConversationTradeController.h"
#import "ChatTradeCell.h"
#import "IMModel.h"
@interface FWConversationTradeController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FWConversationTradeController
{
    int _select; //1.交易  2.好友  3.未关注
    NetHttpsManager *_httpManager;
    int _has_next; //是否还有下一页
    int _page;     //页数
    int _flag;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    _select = 1;
    _flagArr = NSMutableArray.new;
    _conversationArr = NSMutableArray.new;
    _httpManager = [NetHttpsManager manager];
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.mTableView];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableView registerNib:[UINib nibWithNibName:@"ChatTradeCell" bundle:nil] forCellReuseIdentifier:@"ChatTradeCell"];
    [FWMJRefreshManager refresh:self.mTableView target:self headerRereshAction:@selector(headerStartRefresh) footerRereshAction:@selector(footerStartRefresh)];
}

- (void)updateTableViewFrame
{
    CGFloat tableViewHeight;
    if (!self.isHaveLive)
    {
        tableViewHeight = kScreenH - 64;
    }
    else
    {
        tableViewHeight = kScreenH / 2 - 44;
    }
    [self.mTableView setFrame:CGRectMake(0, 0, kScreenW, tableViewHeight)];
}

- (void)headerStartRefresh
{
    [self.mTableView reloadData];
    [self loadDataWithPage:1];
}

- (void)footerStartRefresh
{
    if (_has_next == 1)
    {
        _page++;
        [self loadDataWithPage:_page];
    }
    else
    {
        [FWMJRefreshManager endRefresh:self.mTableView];
        return;
    }
}

#pragma mark--------------------------网络请求----------------------------
- (void)loadDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"message" forKey:@"ctl"];
    [parmDict setObject:@"getlist" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d", page] forKey:@"p"];
    [_httpManager POSTWithParameters:parmDict
                        SuccessBlock:^(NSDictionary *responseJson) {
                            
                            if ([responseJson toInt:@"status"] == 1)
                            {
                                NSDictionary *dataDic = [responseJson objectForKey:@"data"];
                                NSMutableArray *dataArr = NSMutableArray.new;
                                dataArr = dataDic[@"list"];
                                
                                NSDictionary *pageDic = dataDic[@"page"];
                                _has_next = [pageDic toInt:@"has_next"];
                                _page = [pageDic toInt:@"page"];
                                
                                if (_page == 1)
                                {
                                    [_conversationArr removeAllObjects];
                                    [_flagArr removeAllObjects];
                                }
                                
                                if (dataArr.count > 0)
                                {
                                    for (NSDictionary *dic in dataArr)
                                    {
                                        IMModel *model = [IMModel mj_objectWithKeyValues:dic];
                                        [_conversationArr addObject:model];
                                        [_flagArr addObject:@"0"];
                                    }
                                }
                                else
                                {
                                    [self showNoContentView];
                                    if (_isHaveLive)
                                    {
                                        self.noContentView.center = CGPointMake(self.view.frame.size.width/2, 87.5+40);
                                    }
                                }
                            }
                            [FWMJRefreshManager endRefresh:self.mTableView];
                            [self.mTableView reloadData];
                            
                        }
                        FailureBlock:^(NSError *error) {
                            [self showNoContentView];
                            [FWMJRefreshManager endRefresh:self.mTableView];
                        }];
}

#pragma mark----------------------tableView的协议方法------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _conversationArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _flagArr.count)
    {
        if ([_flagArr[indexPath.row] isEqualToString:@"0"])
        {
            return 60.0f;
        }
        else
        {
            if (indexPath.row < _conversationArr.count)
            {
                IMModel *model = _conversationArr[indexPath.row];
                CGFloat height = [model getHeight:model.content];
                return height;
            }
        }
    }
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMModel *model = _conversationArr[indexPath.row];
    NSString *CellIdentifier = @"ChatTradeCell";
    ChatTradeCell *cell = (ChatTradeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = (ChatTradeCell *) [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (model.send_user_name.length > 11)
    {
        cell.mname.text = [NSString stringWithFormat:@"%@...", [model.send_user_name substringToIndex:11]];
    }
    else
    {
        cell.mname.text = model.send_user_name;
    }
    [cell.mheadimg sd_setImageWithURL:[NSURL URLWithString:model.send_user_avatar] placeholderImage:kDefaultPreloadHeadImg];
    cell.mmsg.text = model.content;
    [cell judge:cell.mmsg.text];
    cell.mtime.text = model.create_date;
    if (indexPath.row < _flagArr.count)
    {
        if ([cell judge:cell.mmsg.text] > 17)
        {
            cell.contentFlag = _flagArr[indexPath.row];
        }
    }
    
    return cell;
}

#pragma mark 点击单元格的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleSelectedCell:indexPath];
}

- (void)handleSelectedCell:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if ([_flagArr[indexPath.row] isEqualToString:@"0"])
        {
            [_flagArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }
        else
        {
            [_flagArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
        [self.mTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
