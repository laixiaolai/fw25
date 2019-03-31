//
//  FWVideoDetailController.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWVideoDetailController.h"
#import "FWShareView.h"
#import "FWVideoMirrorCell.h"
#import "CommentModel.h"
#import "PersonCenterModel.h"
#import "PersonCenterListModel.h"
#import "FWReportController.h"
#import "FWReplyCell.h"
#import "FWPlayVideoController.h"
#import "SHomePageVC.h"

NS_ENUM(NSInteger, FWMyVideoDetailTabIndexs)
{
    FWPCDetailOneSection,                        //第一段
    FWPCDetailTwoSection,                        //第二段
    FWPCDetailThreeSection,                      //第三段
    EPCTab_Count,
};


@interface FWVideoDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,shareDeleGate,commentDeleGate,ZanandVideoDelegate,UIActionSheetDelegate>
{
    int                   _currentPage;                 //当前页数
    int                   _has_next;                    //是否还有下一页1代表有
    UIImageView           *_headImgView;                //播放图像
    UIImageView           *_playImgView;                //播放控件
    UIView                *_buttomView;                 //输入键盘底部的view
    UITextField           *_textField;                  //评论
    UIButton              *_commentBtn;                 //评论bt
    BOOL                  _isShowKeyBoard;              //是否显示键盘
    NSString              *_comment_id;                 //被评论的评论ID
    FWShareView           *_myShareView;                //分享view
    PersonCenterModel     *_detailModel;                //数据模型
    int                   _rowCount;                    //第三段哪一组
    NSMutableDictionary   *_shareDict;                  //分享的信息
}

@end

@implementation FWVideoDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    _shareDict   = [[NSMutableDictionary alloc]init];
    self.navigationItem.title = @"小视频详情";
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(moreChoose) image:@"fw_vdetail_more" highImage:@"fw_vdetail_more"];
    
    self.view.backgroundColor = kWhiteColor;
    [self creatMianView];
    [self keyboardMonitor];//通知
    
    FWWeakify(self)
    [self setupBackBtnWithBlock:^{
        
        FWStrongify(self)
        [self tap];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark    键盘监听
- (void)keyboardMonitor
{
    //键盘显示时发出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏时发出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    _isShowKeyBoard = YES;
    // 键盘弹出需要的时间
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取出键盘高度
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = currentFrame.origin.y - keyboardF.size.height - 115;
    _tableView.frame = currentFrame;
    
    // 执行动画
    [UIView animateWithDuration:animationDuration animations:^{
        _buttomView.y = kScreenH - keyboardF.size.height - 50 - 64;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // 键盘弹出需要的时间
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = 0 ;
    currentFrame.size.height = kScreenH- 64-50;
    _tableView.frame = currentFrame;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [_commentBtn setTitle:@"发表评论" forState:UIControlStateNormal];
        _buttomView.y = kScreenH - 114;

    }];

}

- (void)inputViewDown
{
    _textField.placeholder = @"请输入您的评论";
    _comment_id = @"";
    _isShowKeyBoard = NO;
    [_textField resignFirstResponder];
}

- (void)creatMianView
{
    _myShareView = [[FWShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60) Delegate:self];
    _shareArray = _myShareView.shareArray;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight-50)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [_tableView registerClass:[FWReplyCell class] forCellReuseIdentifier:@"FWReplyCell"];
    
    _buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-50-kStatusBarHeight-kNavigationBarHeight, kScreenW, 50)];
    _buttomView.backgroundColor = kWhiteColor;
    [self.view addSubview:_buttomView];
    
    //搜索框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, kScreenW -130, 40)];
    _textField.userInteractionEnabled = YES;
    _textField.layer.cornerRadius = 3;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.backgroundColor = kBackGroundColor;
    _textField.textColor = RGB(153, 153, 153);
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font = [UIFont systemFontOfSize:12];
    _textField.delegate = self;
    _textField.placeholder = @"请输入您的评论";
    [_buttomView addSubview:_textField];
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,40)];
    leftView.backgroundColor = [UIColor clearColor];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(kScreenW-110, 5, 100, 40);
    _commentBtn.layer.cornerRadius = 3;
    _commentBtn.backgroundColor = kAppMainColor;
    [_commentBtn setTitle:@"发表评论" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_buttomView addSubview:_commentBtn];
    
    [FWMJRefreshManager refresh:_tableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(refresherOfNew)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_tableView addGestureRecognizer:tap];
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenW*42)/75)];
    _headImgView.backgroundColor = kAppGrayColor1;
    _headImgView.image = kDefaultPreloadVideoHeadImg;
    _headImgView.contentMode = UIViewContentModeScaleAspectFit;
    _headImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *playTaps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playTap)];
    [_headImgView addGestureRecognizer:playTaps];
    
    _playImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-19, (kScreenW*42)/150 -19, 39, 39)];
    _playImgView.userInteractionEnabled = YES;
    _playImgView.image = [UIImage imageNamed:@"fw_personCenter_play"];
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playTap)];
    [_playImgView addGestureRecognizer:playTap];
    [_headImgView addSubview:_playImgView];
    _tableView.tableHeaderView = _headImgView;
}


- (void)showKeyBoard
{
    [_textField becomeFirstResponder];
}

- (void)tap
{
    _isShowKeyBoard = NO;
    [self inputViewDown];
}
- (void)playTap
{
    [self addPlayNumWithWeiBoId:_detailModel.info.weibo_id];
    FWPlayVideoController *playVC = [FWPlayVideoController new];
    playVC.playUrl =_detailModel.info.video_url;
    [[AppDelegate sharedAppDelegate] pushViewController:playVC];
}

#pragma mark 播放视频加1
- (void)addPlayNumWithWeiBoId:(NSString *)weiBoId
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"weibo" forKey:@"ctl"];
    [MDict setObject:@"add_video_count" forKey:@"act"];
    [MDict setObject:@"xr" forKey:@"itype"];
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
             _detailModel.info.video_count = [responseJson toString:@"video_count"];
             
             NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
             [postDict setObject:@"video" forKey:@"type"];
             [postDict setObject:[NSString stringWithFormat:@"%d",[responseJson toInt:@"video_count"]] forKey:@"count"];
             [postDict setObject:[NSString stringWithFormat:@"%d",self.lastView] forKey:@"reloadView"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableViewStatus" object:postDict];
         }
         NSIndexPath *te = [NSIndexPath indexPathForRow:0 inSection:FWPCDetailOneSection];//刷新某段某行
         [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

- (void)moreChoose
{
    if (_detailModel.is_admin)//是自己
    {
        UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [headImgSheet addButtonWithTitle:@"删除动态"];
        [headImgSheet addButtonWithTitle:@"取消"];
        headImgSheet.tag = 3;
        headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
        headImgSheet.delegate = self;
        [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
    }else
    {
        UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [headImgSheet addButtonWithTitle:@"举报该动态"];
        [headImgSheet addButtonWithTitle:@"举报该用户"];
        [headImgSheet addButtonWithTitle:@"取消"];
        headImgSheet.tag = 1;
        headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
        headImgSheet.delegate = self;
        [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}

#pragma mark 头部刷新
- (void)headerReresh
{
    [self loadNetDataWithPage:1];
}

- (void)refresherOfNew
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadNetDataWithPage:_currentPage];
    }
    else
    {
        [FWMJRefreshManager endRefresh:self.tableView];
    }
}
#pragma mark 加载数据
-(void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"weibo" forKey:@"ctl"];
    [MDict setObject:@"index" forKey:@"act"];
    [MDict setObject:@"xr" forKey:@"itype"];
    if (self.weibo_id.length)
    {
        [MDict setObject:self.weibo_id forKey:@"weibo_id"];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         _has_next = [responseJson toInt:@"has_next"];
         _currentPage = [responseJson toInt:@"page"];
         if (_currentPage == 1)
         {
             [_dataArray removeAllObjects];
         }
         if ([responseJson toInt:@"status"]== 1)
         {
             
             NSDictionary *shareD = [responseJson objectForKey:@"invite_info"];
             if (shareD && [shareD isKindOfClass:[NSDictionary class]]) {
                 if ([shareD count])
                 {
                     if ([[shareD objectForKey:@"clickUrl"] length])
                     {
                         [_shareDict setObject:[shareD objectForKey:@"clickUrl"] forKey:@"share_url"];
                     }else
                     {
                         [_shareDict setObject:@"" forKey:@"share_url"];
                     }
                     if ([[shareD objectForKey:@"content"] length])
                     {
                         [_shareDict setObject:[shareD objectForKey:@"content"] forKey:@"share_content"];
                     }else
                     {
                         [_shareDict setObject:@"" forKey:@"share_content"];
                     }
                     if ([[shareD objectForKey:@"imageUrl"] length])
                     {
                         [_shareDict setObject:[shareD objectForKey:@"imageUrl"] forKey:@"share_imageUrl"];
                     }else
                     {
                         [_shareDict setObject:@"" forKey:@"share_imageUrl"];
                     }
                     if ([[shareD objectForKey:@"title"] length])
                     {
                         [_shareDict setObject:[shareD objectForKey:@"title"] forKey:@"share_title"];
                     }else
                     {
                         [_shareDict setObject:@"" forKey:@"share_title"];
                     }
                 }
             }
             
             _detailModel = [PersonCenterModel mj_objectWithKeyValues:responseJson];
             //动态
             NSArray *comment_listArray = [responseJson objectForKey:@"comment_list"];
             if (comment_listArray && [comment_listArray isKindOfClass:[NSArray class]])
             {
                 if (comment_listArray.count)
                 {
                     for (NSDictionary *dict in comment_listArray)
                     {
                         CommentModel *CModel = [CommentModel mj_objectWithKeyValues:dict];
                         [self.dataArray addObject:CModel];
                     }
                 }
             }
             [_headImgView sd_setImageWithURL:[NSURL URLWithString:[[responseJson objectForKey:@"info"] objectForKey:@"photo_image"]] placeholderImage:kDefaultPreloadVideoHeadImg];
             
             [self.tableView reloadData];
             
         }else
         {
             [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         }
          [FWMJRefreshManager endRefresh:self.tableView];
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.tableView];
         NSLog(@"error==%@",error);
     }];
}

#pragma mark ----tabelView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EPCTab_Count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == FWPCDetailOneSection)
    {
        if (_detailModel.info!= nil)
        {
            return 1;
        }else
        {
            return 0;
        }
        
    }else if (section == FWPCDetailTwoSection)
    {
        if (_shareArray.count)
        {
            return 1;
        }else
        {
            return 0;
        }
        
    }else
    {
        return _dataArray.count;
    }
}
#pragma mark ----设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == FWPCDetailOneSection)
    {
        static NSString *CellIdentifier0 = @"CellIdentifier0";
        FWVideoMirrorCell *cell = (FWVideoMirrorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (cell == nil) {
            cell = [[FWVideoMirrorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSLog(@"height==%f",[cell creatCellWithModel:_detailModel.info andRow:(int)indexPath.section isVideo:YES])
        return [cell creatCellWithModel:_detailModel.info andRow:(int)indexPath.section isVideo:YES];
        
    }else if (indexPath.section == FWPCDetailTwoSection)
    {
        if (_shareArray.count)
        {
            return 60;
        }else
        {
            return 0;
        }
    }else //判断是否需要返回头像的高度
    {
        static NSString *CellIdentifier1 = @"CellIdentifier1";
        FWReplyCell *cell = (FWReplyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[FWReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return  [cell creatCellWithModel:_dataArray[indexPath.row] andRow:(int)indexPath.row];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == FWPCDetailOneSection)
    {
        static NSString *CellIdentifier2 = @"CellIdentifier2";
        FWVideoMirrorCell *cell = (FWVideoMirrorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[FWVideoMirrorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            cell.ZVDelegate =self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell creatCellWithModel:_detailModel.info andRow:(int)indexPath.section isVideo:YES];
        return cell;
    }else if (indexPath.section == FWPCDetailTwoSection)
    {
        static NSString *CellIdentifier3 = @"CellIdentifier3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackGroundColor;
        }
        [cell addSubview:_myShareView];
        return cell;
    }else
    {
        FWReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FWReplyCell" forIndexPath:indexPath];
        cell.CDelegate = self;
        [cell creatCellWithModel:_dataArray[indexPath.row] andRow:(int)indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == FWPCDetailThreeSection)
    {
        if (_dataArray.count)
        {
            return 10;
        }else
        {
            return 0;
        }
        
    }else
    {
        return 0;
    }
    
}
#pragma mark cell的回调
- (void)zanOrVideoClickWithTag:(int)tag
{
    if (tag == 0)//点赞
    {
        [self zanreLoadRowWithTag:tag];
    }else if (tag == 2)//点击头像
    {
        SHomePageVC *myVC = [[SHomePageVC alloc]init];
        myVC.user_id = _detailModel.info.user_id;
        myVC.type = 0;
        [[AppDelegate sharedAppDelegate] pushViewController:myVC];
    }
}
#pragma mark 点赞
- (void)zanreLoadRowWithTag:(int)tag
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"publish_comment" forKey:@"act"];
    if (_weibo_id.length)
    {
        [MDict setObject:_weibo_id forKey:@"weibo_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    [MDict setObject:@"2" forKey:@"type"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             _detailModel.info.digg_count = [responseJson toString:@"digg_count"];
             _detailModel.info.has_digg   = [responseJson toInt:@"has_digg"];
             NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
             
             [postDict setObject:@"dianZan" forKey:@"type"];
             [postDict setObject:[NSString stringWithFormat:@"%@",_detailModel.info.digg_count] forKey:@"count"];
             [postDict setObject:[NSString stringWithFormat:@"%d",_detailModel.info.has_digg] forKey:@"has_digg"];
             [postDict setObject:[NSString stringWithFormat:@"%d",self.lastView] forKey:@"reloadView"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableViewStatus" object:postDict];
         }
         NSIndexPath *te = [NSIndexPath indexPathForRow:0 inSection:FWPCDetailOneSection];//刷新某段某行
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark 置顶
- (void)setTopWithTag
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"set_top" forKey:@"act"];
    if (self.weibo_id)
    {
        [MDict setObject:self.weibo_id forKey:@"weibo_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             [self loadNetDataWithPage:1];
         }
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}


#pragma mark 拉黑
- (void)defriendAction
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"set_black" forKey:@"act"];
    if (_detailModel.info.user_id)
    {
        [MDict setObject:_detailModel.info.user_id forKey:@"to_user_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             if (![_detailModel.info.user_id isEqualToString:[[IMAPlatform sharedInstance].host imUserId]])
             {
                 [self.navigationController popViewControllerAnimated:YES];
                 [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
             }else
             {
                 [self loadNetDataWithPage:1];
             }
         }
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark 进入举报页面
- (void)goToReportControllerWithTag:(int)tag
{
    FWReportController *reportVC = [[FWReportController alloc]init];
    reportVC.weibo_id = _detailModel.info.weibo_id;
    reportVC.to_user_id = _detailModel.info.user_id;
    if (tag == 1)//动态
    {
        reportVC.reportType = 1;
    }else if (tag == 2)
    {
        reportVC.reportType = 2;
    }
    [[AppDelegate sharedAppDelegate] pushViewController:reportVC];
}

#pragma mark 删除某条动态
- (void)deleteDynamicWithString:(NSString *)string
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"del_weibo" forKey:@"act"];
    if (self.weibo_id)
    {
        [MDict setObject:self.weibo_id forKey:@"weibo_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self);
         if ([responseJson toInt:@"status"]== 1)
         {
             NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
             [postDict setObject:@"delete" forKey:@"type"];
             [postDict setObject:[NSString stringWithFormat:@"%d",self.lastView] forKey:@"reloadView"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableViewStatus" object:postDict];
             [self.navigationController popViewControllerAnimated:YES];
             
         }
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}


#pragma mark  ===================== 第二段的点击事件  ===============================
- (void)clickShareImgViewWithTag:(int)tag
{
    //0新浪 1朋友圈 2微信 3qq 4qq空间
    NSString *shareStr;
    if(tag == 0)  shareStr = @"sina";
    if(tag == 1)  shareStr = @"weixin_circle";
    if(tag == 2)  shareStr = @"weixin";
    if(tag == 3)  shareStr = @"qq";
    if(tag == 4)  shareStr = @"qzone";
    
    //0新浪 1朋友圈 2微信 3qq 4qq空间
    UMSocialPlatformType socialPlatformType;               //分享的类型
    if(tag == 0)  socialPlatformType = UMSocialPlatformType_Sina;
    if(tag == 1)  socialPlatformType = UMSocialPlatformType_WechatTimeLine;
    if(tag == 2)  socialPlatformType = UMSocialPlatformType_WechatSession;
    if(tag == 3)  socialPlatformType = UMSocialPlatformType_QQ;
    if(tag == 4)  socialPlatformType = UMSocialPlatformType_Qzone;
    ShareModel *SModel = [ShareModel mj_objectWithKeyValues:_shareDict];
    [[FWUMengShareManager sharedInstance] shareTo:self platformType:socialPlatformType shareModel:SModel succ:nil failed:nil];
    
    
}

#pragma mark  ===================== 第三段的点击事件  ===============================
#pragma mark 点击名字的回调
- (void)clickNameStringWithTag:(int)tag
{
    CommentModel *CModel = _dataArray[tag];
    SHomePageVC *myVC = [[SHomePageVC alloc]init];
    myVC.user_id = CModel.user_id;
    myVC.type = 0;
    [[AppDelegate sharedAppDelegate] pushViewController:myVC];
}

#pragma mark 点击动态的回调
- (void)commentNewsWithTag:(int)tag
{
    _rowCount = tag;
    CommentModel *CModel = _dataArray[tag];
    if (_detailModel.user_id >0)
    {
        if (_detailModel.is_admin)
        {
            if ([CModel.user_id intValue] == _detailModel.user_id)//如果是自己的评论，且是自己的回复就只有删除取消
            {
                UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                [headImgSheet addButtonWithTitle:@"删除"];
                [headImgSheet addButtonWithTitle:@"取消"];
                [headImgSheet setTintColor:kAppGrayColor1];
                headImgSheet.tag = 0;
                headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
                headImgSheet.delegate = self;
                [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
                
            }else//如果是自己的评论，但是是别人的评论就有删除回复取消
            {
                UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                [headImgSheet addButtonWithTitle:@"回复"];
                [headImgSheet addButtonWithTitle:@"取消"];
                [headImgSheet setTintColor:kAppGrayColor1];
                headImgSheet.tag = 2;
                headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
                headImgSheet.delegate = self;
                [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
                
            }
        }else
        {
            if ([CModel.user_id intValue] == _detailModel.user_id)//不是自己的评论，是回复别人的评论,只有删除
            {
                UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                [headImgSheet addButtonWithTitle:@"删除"];
                [headImgSheet addButtonWithTitle:@"取消"];
                [headImgSheet setTintColor:kAppGrayColor1];
                headImgSheet.tag = 0;
                headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
                headImgSheet.delegate = self;
                [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
            }else//不是自己的评论，是别人的评论,只能回复别人的评论
            {
                _isShowKeyBoard =! _isShowKeyBoard;
                if (_isShowKeyBoard == YES)
                {
                    [_commentBtn setTitle:@"回复" forState:UIControlStateNormal];
                    [_textField becomeFirstResponder];
                    _textField.placeholder = [NSString stringWithFormat:@"回复:%@",CModel.nick_name];
                    _comment_id = CModel.comment_id;
                    
                }else
                {
                    _textField.placeholder = @"请输入您的评论";
                    _comment_id = @"";
                    [self tap];
                }
            }
        }
    }
}

#pragma mark 删除某条评论
- (void)deleteCommentWithTag:(int)count
{
    CommentModel *CModel = _dataArray[_rowCount];
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"del_comment" forKey:@"act"];
    if (CModel.comment_id.length)
    {
        [MDict setObject:CModel.comment_id forKey:@"comment_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             [_dataArray removeObjectAtIndex:_rowCount];
             _detailModel.info.comment_count = [NSString stringWithFormat:@"%d",(int)_dataArray.count];
             [_tableView reloadData];
             
             NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
             [postDict setObject:@"comment" forKey:@"type"];
             [postDict setObject:[NSString stringWithFormat:@"%d",(int)_dataArray.count] forKey:@"count"];
             [postDict setObject:[NSString stringWithFormat:@"%d",self.lastView] forKey:@"reloadView"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableViewStatus" object:postDict];
             
         }
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark 发表评论
- (void)buttonClick
{
    if (_textField.text.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入评论的内容"];
        return;
    }
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"publish_comment" forKey:@"act"];
    [MDict setObject:@"1" forKey:@"type"];
    if (self.weibo_id.length)
    {
        [MDict setObject:self.weibo_id forKey:@"weibo_id"];
    }
    if (_comment_id.length)
    {
        [MDict setObject:_comment_id forKey:@"to_comment_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    [MDict setObject:_textField.text forKey:@"content"];
    [self inputViewDown];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             _textField.text = @"";
             
             NSDictionary *commentDict = [responseJson objectForKey:@"comment"];
             if (commentDict && [commentDict isKindOfClass:[NSDictionary class]])
             {
                 CommentModel *CModel = [CommentModel mj_objectWithKeyValues:commentDict];
                 [_dataArray insertObject:CModel atIndex:0];
             }
             _detailModel.info.comment_count =[NSString stringWithFormat:@"%d",(int)_dataArray.count] ;
             [_tableView reloadData];
             
             NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
             [postDict setObject:@"comment" forKey:@"type"];
             [postDict setObject:[NSString stringWithFormat:@"%d",(int)_dataArray.count] forKey:@"count"];
             [postDict setObject:[NSString stringWithFormat:@"%d",self.lastView] forKey:@"reloadView"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableViewStatus" object:postDict];
         }
         [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark UIActionSheet的回调事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (actionSheet.tag == 0)//如果是自己的评论，且是自己的回复就只有删除取消
    {
        if (buttonIndex == 0)
        {
            [self deleteCommentWithTag:_rowCount];
        }else if (buttonIndex == 1)
        {
            
        }
    }else if(actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self goToReportControllerWithTag:1];
        }else if (buttonIndex == 1)
        {
            [self goToReportControllerWithTag:2];
        }
    }else if(actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
            _isShowKeyBoard =! _isShowKeyBoard;
            if (_isShowKeyBoard == YES)
            {
                [_commentBtn setTitle:@"回复" forState:UIControlStateNormal];
                [_textField becomeFirstResponder];
                CommentModel *CModel =_dataArray[_rowCount];
                _textField.placeholder = [NSString stringWithFormat:@"%@",CModel.nick_name];
                _comment_id = CModel.comment_id;
                
            }else
            {
                _textField.placeholder = @"请输入您的评论";
                _comment_id = @"";
                [self tap];
            }
        }
    }else if(actionSheet.tag == 3)//自己对自己的更多去操作
    {
        if (buttonIndex == 0)
        {
            [self deleteDynamicWithString:self.weibo_id];
        }
    }
}

//去掉UItableview headerview黏性  ，table滑动到最上端时，header view消失掉。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


@end
