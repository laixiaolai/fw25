//
//  choseMuiscVC.m
//  FanweApp
//
//  Created by zzl on 16/6/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "choseMuiscVC.h"
#import "musicCell.h"
#import "dataModel.h"
#import "MJRefresh.h"

@interface choseMuiscVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,musicDownloadDelegate,UIScrollViewDelegate>

@end

@implementation choseMuiscVC
{
    NSMutableArray*    _savedmusic;
    NSMutableArray*    _searchmusic;
    NSMutableArray*    _history;
    int         _pagesearch;
    int         _pagesaved;
    
    int         _datatype;// 0 下载歌曲,1 搜索数据,2历史记录
    
    NSString*   _keywords;
    
    musiceModel*    _selectback;
}

- (void)viewDidLoad
{
    self.mHidNarBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"点歌";
    
    _savedmusic     = NSMutableArray.new;
    _searchmusic    = NSMutableArray.new;
    _history        = NSMutableArray.new;
    
    self.msearchbar.delegate = self;
    self.msearchbar.backgroundColor = [UIColor whiteColor];
    
    self.msearchbar.layer.cornerRadius   = 5;
    self.msearchbar.layer.borderColor    = [UIColor whiteColor].CGColor;
    self.msearchbar.layer.borderWidth    = 1;
    
    _datatype = 0;
    
    UINib* nib = [UINib nibWithNibName:@"musicCell" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.mtableview.delegate = self;
    self.mtableview.dataSource = self;
    self.mtableview.tableFooterView = UIView.new;
    
    self.mTableView     = self.mtableview;
    self.mHaveFooter    = YES;
    self.mHaveHeader    = YES;
    
    self.mtableview.backgroundColor = [UIColor colorWithRed:240/255.0f green:247/255.0f blue:246/255.0f alpha:1];
    
    //搜索使用的
    nib = [UINib nibWithNibName:@"musicCell" bundle:nil];
    [self.msearchtableview registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.msearchtableview.delegate = self;
    self.msearchtableview.dataSource = self;
    self.msearchtableview.tableFooterView = UIView.new;
    
    [FWMJRefreshManager refresh:self.msearchtableview target:self headerRereshAction:@selector(headerStartRefresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerStartRefresh)];
    
    self.msearchtableview.backgroundColor = [UIColor colorWithRed:240/255.0f green:247/255.0f blue:246/255.0f alpha:1];
    
    self.mhistorytableview.delegate = self;
    self.mhistorytableview.dataSource = self;
    self.mhistorytableview.tableFooterView = UIView.new;
    
    [FWMJRefreshManager refresh:self.mhistorytableview target:self headerRereshAction:@selector(headerStartRefresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerStartRefresh)];
    
    self.mhistorytableview.backgroundColor = [UIColor colorWithRed:240/255.0f green:247/255.0f blue:246/255.0f alpha:1];
    
    [self forcesHeaderReFresh];
    
    // 下载失败 回调。去搜索界面 获取新的下载地址
    [self xw_addNotificationForName:@"musicDownFileFailure" block:^(NSNotification * _Nonnull notification) {
        //search bar
        _msearchbar.text = notification.userInfo[@"musicName"];
        _keywords = _msearchbar.text;
        [_msearchbar becomeFirstResponder];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (IBAction)backBtClicked:(UIButton *)sender
{
    [super backBtClicked:sender];
    if(self.mitblock)
    {
        self.mitblock(_selectback);
    }
    
    _selectback = nil;
    [_savedmusic removeAllObjects];
    [_searchmusic removeAllObjects];
    [_history removeAllObjects];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar                      // return NO to not become first responder
{
    if( searchBar.text.length == 0 )
    {
        [self showPage:YES];
        [self chageDataType:2 bforceload:NO];//刚刚上去 如果没有输入东西 就是 历史记录
    }
    else
    {
        [self showPage:YES];
        [self chageDataType:1 bforceload:NO];//如果有文字,就是搜索歌曲
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar   // called when cancel button pressed
{
    [self showPage:NO];
    [self chageDataType:0 bforceload:NO];//不搜索了,就是 本地歌曲
    searchBar.text =  nil;
    //[_searchmusic removeAllObjects];
    //[_history removeAllObjects];
    [searchBar resignFirstResponder];
    //刷新一下
    [self headerStartRefresh];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self headerStartRefresh];//n 35
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    _keywords = searchText;
    if( _keywords.length == 0 )
    {
        [self chageDataType:2 bforceload:YES];//如果搜索关键字删除完了, 就展示历史搜索记录
    }
    else
    {
        [self chageDataType:1 bforceload:YES];//搜索开始
        [self headerStartRefresh];//n 35
    }
}

- (void)chageDataType:(int)type bforceload:(BOOL)bforceload
{
    _datatype = type;
    UITableView* whattab = nil;
    
    BOOL brefrush =YES;
    if(_datatype == 0)
    { // 有数据就不管
        self.msearchtableview.hidden = YES;
        self.mhistorytableview.hidden = YES;
        self.mtableview.hidden = NO;
        if( _savedmusic.count && !bforceload ) brefrush= NO;
        
        whattab = self.mtableview;
        
    }
    else if(_datatype == 1)
    { // 如果搜索有数据,
        self.msearchtableview.hidden = NO;
        self.mhistorytableview.hidden = YES;
        self.mtableview.hidden = YES;
        if( _searchmusic.count && !bforceload ) brefrush= NO;
        
        whattab = self.msearchtableview;
    }
    else if(_datatype == 2)
    {
        self.msearchtableview.hidden = YES;
        self.mhistorytableview.hidden = NO;
        self.mtableview.hidden = YES;
        if( _history.count && !bforceload ) brefrush= NO;
        
        whattab = self.mhistorytableview;
    }
    
    if(brefrush)
        [whattab.mj_header beginRefreshing];
    else
        [whattab reloadData];
}

- (void)showPage:(BOOL)bshowsearch
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.mtopconsth.constant = bshowsearch ? 75:125;
        self.msearchbar.showsCancelButton = bshowsearch;
        [self.view layoutIfNeeded];
        
    }];
}

- (void)headerStartRefresh
{
    if( _datatype == 1 )
    { // 获取搜索数据
        _pagesearch = 1;
        [musiceModel searchMuisc:_keywords page:_pagesearch block:^(SResBase *resb, NSArray *all) {
            
            [FWMJRefreshManager endRefresh:self.msearchtableview];
            [_searchmusic removeAllObjects];
            
            if( resb.msuccess )
            {
                [_searchmusic addObjectsFromArray:all];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            [self.msearchtableview reloadData];
            
        }];
    }
    else if(_datatype == 0)
    { // 获取本地数据
        _pagesaved = 1;
        [musiceModel getMyMusicList:_pagesaved block:^(SResBase *resb, NSArray *all) {
            
            [self headerEndRefresh];
            [_savedmusic removeAllObjects];
            if( resb.msuccess )
            {
                [_savedmusic addObjectsFromArray: all];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            [self.mtableview reloadData];
        }];
    }
    else
    { // 获取历史搜索
        [_history removeAllObjects];
        NSArray *ta  = [musiceModel getSearchHistory];
        if( ta )
            [_history addObjectsFromArray:ta];
        
        [FWMJRefreshManager endRefresh:self.mhistorytableview];
        [self.mhistorytableview reloadData];
    }
}

- (void)footerStartRefresh
{
    if( _datatype == 1 )
    { // 搜索
        _pagesearch ++;
        [musiceModel searchMuisc:_keywords page:_pagesearch block:^(SResBase *resb, NSArray *all) {
            
            [FWMJRefreshManager endRefresh:self.msearchtableview];
            
            if( resb.msuccess )
            {
                if (all)
                {
                    if ([all count])
                    {
                        [_searchmusic addObjectsFromArray:all];
                    }
                    else
                    {
                        _pagesearch --;
                    }
                }
                else
                {
                    _pagesearch --;
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            [self.msearchtableview reloadData];
        }];
    }
    else if( _datatype == 0 )
    {
        _pagesaved ++;
        [musiceModel getMyMusicList:_pagesaved block:^(SResBase *resb, NSArray *all) {
            
            [self footerEndRefresh];
            
            if( resb.msuccess )
            {
                if (all)
                {
                    if ([all count])
                    {
                        [_savedmusic addObjectsFromArray:all];
                    }
                    else
                    {
                        _pagesaved --;
                    }
                }
                else
                {
                    _pagesaved --;
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            [self.mtableview reloadData];
        }];
    }
    else
    {
        [_history removeAllObjects];
        NSArray *ta  = [musiceModel getSearchHistory];
        if( ta )
            [_history addObjectsFromArray:ta];
        [FWMJRefreshManager endRefresh:self.mhistorytableview];
        [self.mhistorytableview reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( tableView == self.msearchtableview )
        return _searchmusic.count;
    else if( tableView == self.mtableview )
        return _savedmusic.count;
    else
        return _history.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark 删除单元格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mtableview || tableView == self.mhistorytableview)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mtableview || tableView == self.mhistorytableview)
        return YES;
    return NO;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView == self.mtableview || tableView == self.mhistorytableview)
        return @"删除";
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView == self.mtableview )
    {
        if( editingStyle == UITableViewCellEditingStyleDelete )
        {
            if (indexPath.row < _savedmusic.count)
            {
                musiceModel* oneobj =  _savedmusic[ indexPath.row ];
                [SVProgressHUD showWithStatus:@"正在删除..."];
                [oneobj delThis:^(SResBase *resb) {
                    if( resb.msuccess )
                    {
                        [SVProgressHUD dismiss];
                        [_savedmusic removeObject:oneobj];
                        [self.mtableview beginUpdates];
                        [self.mtableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.mtableview endUpdates];
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:resb.mmsg];
                    }
                }];
            }
        }
    }
    if ( tableView == self.mhistorytableview)
    {
        if ( editingStyle == UITableViewCellEditingStyleDelete)
        {
            if (indexPath.row < _history.count)
            {
                [musiceModel deleteHistory:indexPath.row];
                [_history removeObjectAtIndex:indexPath.row];
                [self.mhistorytableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    musiceModel * oneobj = nil;
    
    if( tableView == self.msearchtableview )
    {
        if (indexPath.row < _searchmusic.count)
        {
            oneobj =  _searchmusic[ indexPath.row];
        }
    }
    else if( tableView == self.mtableview )
    {
        if (indexPath.row < _savedmusic.count)
        {
            oneobj =  _savedmusic[ indexPath.row ];
        }
    }
    else
    {
        if (indexPath.row < _history.count)
        {
            oneobj =  _history[ indexPath.row ];
        }
    }
    
    if( [oneobj isKindOfClass:[NSString class]] )
    {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"h_cell"];
        cell.textLabel.text =(NSString*) oneobj;
        return cell;
    }
    else
    {
        musicCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.mname.text = oneobj.mAudio_name;
        cell.msonger.text = oneobj.mArtist_name;
        cell.mlong.text = [oneobj getTimeLongStr];
        if( oneobj.mmFileStatus == 1 )
        {
            [cell showProcess:-1];
            [cell.mbt setBackgroundImage:[UIImage imageNamed:@"ic_music_chose"] forState:UIControlStateNormal];
        }
        else if( oneobj.mmFileStatus == 0 )
        {
            [cell showProcess:-1];
            [cell.mbt setBackgroundImage:[UIImage imageNamed:@"ic_music_down"] forState:UIControlStateNormal];
        }
        else
        {//显示进度
            [cell showProcess:oneobj.mmPecent];
        }
        
        oneobj.mmUIRef = cell;
        
        return cell;
    }
}

#pragma mark 点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    musiceModel * oneobj = nil;
    
    if( tableView == self.msearchtableview )
    {
        if (indexPath.row < _searchmusic.count)
        {
            oneobj =  _searchmusic[ indexPath.row];
        }
    }
    else if( tableView == self.mtableview )
    {
        if (indexPath.row < _savedmusic.count)
        {
            oneobj =  _savedmusic[ indexPath.row ];
        }
    }
    else
    {
        if (indexPath.row < _history.count)
        {
            oneobj =  _history[ indexPath.row ];
        }
    }
    
    if( [oneobj isKindOfClass:[NSString class]] )
    {
        self.msearchbar.text = (NSString*)oneobj;
        [self searchBar:self.msearchbar textDidChange:(NSString*)oneobj];
    }
    else
    {
        if( oneobj.mmFileStatus == 1 )
        {//选择了
            [oneobj addThisToMyList:nil];//如果本地有,也添加到服务器,
            _selectback = oneobj;
            [self backBtClicked:nil];
        }
        else if( oneobj.mmFileStatus == 0 )
        {//下载
            oneobj.mmDelegate = self;
            [oneobj startDonwLoad:tableView];
        }
        else
        {//下载中,不处理
            
        }
    }
}

#pragma mark 滑动键盘下落
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.msearchbar resignFirstResponder];
}

#pragma mark   --------------------------------musicModel代理方法---------------------------------------
- (void)musicDownloading:(musiceModel *)obj context:(id)context needstop:(BOOL *)needstop
{
    NSInteger index;
    UITableView* tagtableview = (UITableView*)context;
    if( tagtableview == nil || tagtableview.isDragging || tagtableview.tracking || tagtableview.decelerating )
        return;
    
    if( 0 == obj.mmFileStatus )
    {
        [SVProgressHUD showErrorWithStatus:obj.mmDownloadInfo];
    }
    
    if( context == self.msearchtableview )
        index =  [_searchmusic indexOfObject:obj];
    else if(context == self.mtableview)
        index =  [_savedmusic indexOfObject:obj];
    
    if( index != NSNotFound /*&& !tagtableview.hidden*/ )
    {
        if( obj.mmUIRef )
        {
            musicCell* cell = (musicCell*) obj.mmUIRef;
            NSIndexPath* row = [tagtableview  indexPathForCell:cell];
            if( row && row.row == index )
            {
                [tagtableview reloadData];
                //[tagtableview reloadRowsAtIndexPaths:@[ row ] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
