//
//  FWConversationStrangerController.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWConversationStrangerController.h"
#import "ChatFriendCell.h"
#import "ChatTradeCell.h"
#import "FWBaseChatController.h"
#import "FWConversationServiceController.h"
#import "IMModel.h"
#import "JSBadgeView.h"
#import "M80AttributedLabel.h"

@interface FWConversationStrangerController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FWConversationStrangerController
{
    int _select; //1.交易  2.好友  3.未关注
    int _page;   //页数
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
    _select = 3;
    CGFloat tableViewHeight;
    if (!self.isHaveLive)
    {
        tableViewHeight = kScreenH - 64;
    }
    else
    {
        tableViewHeight = kScreenH / 2 - 44;
    }
    _conversationArr = NSMutableArray.new;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMChatMsgNotficationInList:) name:g_notif_chatmsg object:nil];
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.mTableView];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableView registerNib:[UINib nibWithNibName:@"ChatFriendCell" bundle:nil] forCellReuseIdentifier:@"ChatFriendCell"];
    [FWMJRefreshManager refresh:self.mTableView target:self headerRereshAction:@selector(headerStartRefresh) footerRereshAction:nil];
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

#pragma mrak-- ------------------------消息通知-- ------------------------

- (void)IMChatMsgNotficationInList:(NSNotification *)notfication
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(IMChatMsgNotficationInList:) withObject:notfication waitUntilDone:NO];
        return;
    }
    
    SFriendObj *bfindone = nil;
    SIMMsgObj *thatmsg = notfication.object;
    for (SFriendObj *one in _conversationArr)
    {
        
        if (one.mUser_id == thatmsg.mSenderId)
        {
            bfindone = one;
            break;
        }
    }
    if (bfindone)
    {
        [bfindone setLMsg:thatmsg.mCoreTMsg];
        [self.mTableView reloadData];
    }
}

- (void)headerStartRefresh
{
    [self.mTableView reloadData];
    
    SFriendObj *xxx = nil;
    
    [SFriendObj getMyFriendMsgList:_select
                           lastObj:xxx
                             block:^(SResBase *resb, NSArray *all, int unReadNum) {
                                 [self updateItem:unReadNum];
                                 [FWMJRefreshManager endRefresh:self.mTableView];
                                 [_conversationArr removeAllObjects];
                                 if (all.count)
                                 {
                                     [self hideNoContentView];
                                     [_conversationArr addObjectsFromArray:all];
                                 }
                                 else
                                 {
                                     [self showNoContentView];
                                     if (_isHaveLive)
                                     {
                                         self.noContentView.center = CGPointMake(self.view.frame.size.width/2, 87.5+40);
                                     }
                                 }
                                 [self.mTableView reloadData];
                                 
                             }];
}

#pragma mark----------------------tableView的协议方法------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _conversationArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFriendObj *oneobj = nil;
    
    if (indexPath.row < _conversationArr.count)
    {
        oneobj = [_conversationArr objectAtIndex:indexPath.row];
    }
    
    ChatFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatFriendCell"];
    [cell.mheadimg sd_setImageWithURL:[NSURL URLWithString:oneobj.mHead_image] placeholderImage:[UIImage imageNamed:@"ic_default_head"]];
    [cell.viconImageView sd_setImageWithURL:[NSURL URLWithString:oneobj.mV_icon]];
    if (oneobj.mNick_name.length > 11)
    {
        cell.mname.text = [NSString stringWithFormat:@"%@...", [oneobj.mNick_name substringToIndex:11]];
    }
    else
    {
        cell.mname.text = oneobj.mNick_name;
    }
    [cell.mmsg dealFace:oneobj.mLastMsg];
    
    cell.mtime.text = [oneobj getTimeStr];
    if (oneobj.mSex == 0)
    {
        cell.msex.image = [UIImage imageNamed:@"com_male_selected"];
    }
    else if (oneobj.mSex == 1)
    {
        cell.msex.image = [UIImage imageNamed:@"com_male_selected"];
    }
    else
    {
        cell.msex.image = [UIImage imageNamed:@"com_female_selected"];
    }
    NSString *ss = [NSString stringWithFormat:@"rank_%d", oneobj.mUser_level];
    
    cell.mlevel.image = [UIImage imageNamed:ss];
    
    [cell setUnReadCount:[oneobj getUnReadCount]];
    
    return cell;
}

#pragma mark 点击单元格的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFriendObj *oneobj = nil;
    
    if (indexPath.row < _conversationArr.count)
    {
        oneobj = [_conversationArr objectAtIndex:indexPath.row];
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationController.topViewController.navigationItem.backBarButtonItem = backItem;
    IMAUser *user = [[IMAUser alloc] initWith:[NSString stringWithFormat:@"%d", oneobj.mUser_id]];
    user.icon = oneobj.mHead_image;
    user.nickName = oneobj.mNick_name;
    user.remark = @"";
    if (self.isHaveLive == NO)
    {
        FWConversationServiceController *chatvc = [FWConversationServiceController makeChatVCWith:oneobj isHalf:NO];
        chatvc.dic = @{
                       @"mHead_image": oneobj.mHead_image,
                       @"mUser_id": @(oneobj.mUser_id)
                       };
        [[AppDelegate sharedAppDelegate] pushViewController:chatvc];
    }
    if (self.isHaveLive == YES)
    {
        //跳转 2去下界面
        [self itemBtnClick:oneobj];
    }
    [oneobj ignoreThisUnReadCount];
    [self.mTableView reloadData];
    [self reloadItem:_select];
}

#pragma mark-----------------------删除单元格方法------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SFriendObj *oneobj = nil;
        oneobj = [_conversationArr objectAtIndex:indexPath.row];
        [SVProgressHUD showWithStatus:@"操作中..."];
        
        [oneobj delThis:^(SResBase *resb) {
            
            if (resb.msuccess)
            {
                [SVProgressHUD dismiss];
                [_conversationArr removeObjectAtIndex:indexPath.row];
                
                [self.mTableView beginUpdates];
                [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.mTableView endUpdates];
                //获取角标
                [self reloadItem:_select];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
        }];
        if (_conversationArr.count == 0) {
            [self showNoContentView];
            if (_isHaveLive)
            {
                self.noContentView.center = CGPointMake(self.view.frame.size.width/2, 87.5+40);
            }
        }
    }
}

- (void)reloadItem:(int)selectItem
{
    if ([self.delegate respondsToSelector:@selector(reloadChatBadge:)])
    {
        [self.delegate reloadChatBadge:selectItem];
    }
}

- (void)updateItem:(int)unReadNum
{
    if ([self.delegate respondsToSelector:@selector(updateChatStrangerBadge:)])
    {
        [self.delegate updateChatStrangerBadge:unReadNum];
    }
}

- (void)itemBtnClick:(SFriendObj *)obj
{
    if ([self.delegate respondsToSelector:@selector(clickFriendItem:)])
    {
        [self.delegate clickFriendItem:obj];
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
