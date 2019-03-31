//
//  SocietyDetailVC.m
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SocietyDetailVC.h"
#import "AnchorCell.h"
#import "SocietyHeaderView.h"
#import "FansCell.h"
#import "ApplicantCell.h"
#import "SociatyDetailModel.h"
#import "EditSocietyViewController.h"
#import "NoCotentCell.h"


@interface SocietyDetailVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,FansCellDelegate,ApplicantCellDelegate, UIScrollViewDelegate>

{
    HMSegmentedControl   *segmentControl;
    SocietyHeaderView    *head;             //区头
    CGFloat              _lblShowH;         //点击更多按钮时候label的高度
    BOOL                 _isFirst;
    BOOL                 _isShow;           //是否展开
    NSInteger            _showRow;          //默认展开行数
    CGFloat              _showHeight;       //默认公告高度
    UIBlurEffect         *_frostedEffect;   //毛玻璃效果
}

@property (nonatomic, strong)        NSMutableArray *sociatyDetailArray;
@property (nonatomic, assign)        int currentPage;
@property (nonatomic, assign)        int has_next;
@property (nonatomic, copy)          NSString *tianTuanHeadImg;             // 公会头像
@property (nonatomic, assign)        NSInteger open_society_code;           // 是否开启邀请码
@property (nonatomic, strong)        UICollectionView *detailCollectionView;
@property (nonatomic, strong)        UICollectionViewFlowLayout *layout;

@end

static NSString *const anchor     = @"Anchor";
static NSString *const headerFlag = @"SocietyHeader";
static NSString *const fans       = @"Fans";
static NSString *const applicant  = @"applicant";
static NSString *const noContent  = @"NOCotent";
static NSString *const mySociety  = @"MySociety";
static CGFloat   const fixationH  = 308;            //表头除去label高度
static CGFloat   const slideH     = 50;             //滑块高度
static CGFloat   const margin5    = 5;              //单元格间距

@implementation SocietyDetailVC

- (NSMutableArray *)sociatyDetailArray
{
    if (!_sociatyDetailArray)
    {
        _sociatyDetailArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _sociatyDetailArray;
}

- (void)initFWUI
{
    [super initFWUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (isIOS11())
    {
        self.detailCollectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -54, kScreenW, kScreenH+54) collectionViewLayout:[self judgeUsageWhichOne]];
    }
    else
    {
        self.detailCollectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -64, kScreenW, kScreenH+64) collectionViewLayout:[self judgeUsageWhichOne]];
    }
    self.detailCollectionView.delegate        = self;
    self.detailCollectionView.dataSource      = self;
    self.detailCollectionView.backgroundColor = kAppSpaceColor3;
    [self.view addSubview:self.detailCollectionView];
    
    
    _isFirst                                  = YES;
    [self createSegmentControler];
    
    
    [self.detailCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AnchorCell class]) bundle:nil] forCellWithReuseIdentifier:anchor];
    [self.detailCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FansCell class]) bundle:nil] forCellWithReuseIdentifier:fans];
    [self.detailCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ApplicantCell class]) bundle:nil] forCellWithReuseIdentifier:applicant];
    [self.detailCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SocietyHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFlag];
    [self.detailCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NoCotentCell class]) bundle:nil] forCellWithReuseIdentifier:noContent];
    
    
    [FWMJRefreshManager refresh:self.detailCollectionView target:self headerRereshAction:@selector(headerNew) footerRereshAction:@selector(footerNew)];
}

#pragma mark ------------------------------------  表头:根据成员类型设置  -------------------------------------------
- (void)tableViewHeadMsgSetup
{
    if (self.type == 1)
    { //会长
        head.OperationBtn.hidden    = NO;
        if (self.open_society_code == 0)
        {
            head.OperationBtn.hidden    = YES;
        }
        if (!self.flagStr && self.open_society_code == 1)
        {
            head.operationBtnW.constant = 100;
        }
    }
    else
    {
        if (self.type == 0)
        { //该公会成员
            [self operationWithWidth:24 title:@"" imageStr:@"me_quit_society"];
        }
        else if (self.type == 2)
        {//其他公会成员
            head.OperationBtn.hidden    = YES;
        }
        else if (self.type == 3)
        { //无公会成员
            [self operationWithWidth:20 title:@"" imageStr:@"me_join_society"];
        }
        else if (self.type == 4)
        {
            [self operationWithWidth:100 title:@"入会申请中" imageStr:@""];
        }
        else if (self.type == 5)
        {
            [self operationWithWidth:100 title:@"退会申请中" imageStr:@""];
        }
    }
    //从个人中心界面跳转过来执行以下逻辑
    if ([self.flagStr isEqualToString:mySociety] && self.type == 1)
    {
        //审核状态判断
        if (self.mygh_status == 0)
        { //公会未审核
            [self propertyWithBtnEnable:NO btnTitle:@"状态：审核中"];
        }
        else if (self.mygh_status == 1)
        { //审核通过，展示公会邀请码
            head.operationBtnW.constant = 100;
            head.OperationBtn.enabled   = YES;
        }
        else if (self.mygh_status == 2)
        { //公会审核被拒绝
            [self propertyWithBtnEnable:YES btnTitle:@"重新申请"];
        }
    }
}
/**
 是否隐藏，操作按钮是否可编辑，标题，背景颜色
 
 @param enable 是否可编辑
 @param title 标题
 */
- (void)propertyWithBtnEnable:(BOOL)enable btnTitle:(NSString *)title
{
    head.OperationBtn.hidden = NO;
    head.OperationBtn.enabled = enable;
    [head.OperationBtn setTitle:title forState:UIControlStateNormal];
}

- (void)operationWithWidth:(CGFloat)width title:(NSString *)title imageStr:(NSString *)imageStr
{
    head.OperationBtn.hidden = NO;
    head.operationBtnW.constant = width;
    [head.OperationBtn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [head.OperationBtn setTitle:title forState:UIControlStateNormal];
}
#pragma mark  ------------------------------------- 请求数据 ----------------------------------------
//头部刷新
- (void)headerNew
{
    [self requestDataWithPage:1 withDetailType:(int)segmentControl.selectedSegmentIndex];
}

//尾部刷新
- (void)footerNew
{
    if (self.has_next == 1)
    {
        self.currentPage += 1;
        [self requestDataWithPage:1 withDetailType:(int)segmentControl.selectedSegmentIndex];
    }
    else
    {
        [self.detailCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestDataWithPage:(int)page withDetailType:(int)detailType
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@"society_app" forKey:@"ctl"];
    [paramDict setObject:@"society_details" forKey:@"act"];
    [paramDict setObject:[NSNumber numberWithInt:self.mySocietyID] forKey:@"society_id"];
    [paramDict setObject:[NSNumber numberWithInt:detailType] forKey:@"society_status"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
        MMWeakify(self)
        [self.httpsManager POSTWithParameters:paramDict SuccessBlock:^(NSDictionary *responseJson)
         {
             MMStrongify(self)
             if ([responseJson toInt:@"status"] == 1)
             {
                 if (page == 1)
                 {
                     [_sociatyDetailArray removeAllObjects];
                 }
                 NSArray *listArray = responseJson[@"list"];
                 if (listArray && listArray.count > 0)
                 {
                     SociatyDetailModel *spModel;
                     for (NSDictionary *sociatyDetailDict in listArray)
                     {
                         SociatyDetailModel *detailM = [SociatyDetailModel mj_objectWithKeyValues:sociatyDetailDict];
                         //判断是否公会长
                         if ([detailM.user_position intValue] == 1)
                         {
                             spModel = detailM;
                         }
                         else
                         {
                             [_sociatyDetailArray addObject:detailM];
                         }
                     }
                     //将其插入到数组第一个元素中
                     if (spModel)
                     {
                         [_sociatyDetailArray insertObject:spModel atIndex:0];
                     }
                 }
                 [self configurationResponseJson:responseJson];

                 if (self.type == 1)
                 {
                     //1、如果从我的个人中心进来，并且公会通过审核，展示公会邀请码；2、从首页进来是公会会长展示邀请码
                     if (([self.flagStr isEqualToString:mySociety] && self.mygh_status == 1) || !self.flagStr)
                     {
                         NSString *inviteCodeStr = [NSString stringWithFormat:@"邀请码：%@",responseJson[@"society_code"]];
                         if (inviteCodeStr)
                         {
                             [head.OperationBtn setTitle:inviteCodeStr forState:UIControlStateNormal];
                         }
                     }
                 }
                 [self tableViewHeadMsgSetup];
                 [self judgeUsageWhichOne];
                 [self.detailCollectionView reloadData];
             }
         } FailureBlock:^(NSError *error)
         {
             [FWMJRefreshManager endRefresh:self.detailCollectionView];
         }];
        [FWMJRefreshManager endRefresh:self.detailCollectionView];
}

- (void)configurationResponseJson:(NSDictionary *)responseJson
{
    head.societyNameLbl.text     = responseJson[@"society_name"];
    head.presidentLbl.text       = [NSString stringWithFormat:@"会长：%@",[responseJson toString:@"society_chairman"]];
    head.declarationLbl.text     = responseJson[@"society_explain"];
    [self societyTotalNumberOfPeople:[responseJson toInt:@"user_count"] + [responseJson toInt:@"fans_count"]];
    self.tianTuanHeadImg         = responseJson[@"society_image"];
    self.type                    = [responseJson toInt:@"type"];
    self.mygh_status             = [responseJson toInt:@"gh_status"];
    self.open_society_code       = [responseJson toInt:@"open_society_code"];
    [self showMoreBtnWithNumberOfLines:_showRow height:_showHeight isShow:NO angle:0.0];
    segmentControl.sectionTitles = [self configSegmentSectionTitle];
    [head.societyBgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:responseJson[@"society_image"]] forState:UIControlStateNormal placeholderImage:kDefaultPreloadImgSquare];
    [self frostedGlassEffectWithImage:head.tblHeadImg url:responseJson[@"society_image"]];
    NSDictionary *pageDict       = responseJson[@"page"];
    self.has_next                = [pageDict toInt:@"has_next"];
    self.currentPage = [pageDict toInt:@"page"];
}

- (void)societyTotalNumberOfPeople:(int)number
{
    //如果总的行数大于1，刚开始显示两行；等于1显示一行
    NSInteger row                     = [self takeOutNumberOfRowWithString:head.declarationLbl.text];
    head.declarationLbl.numberOfLines = row > 1 ? 2 : 1;
    _showRow                          = head.declarationLbl.numberOfLines;
    _showHeight                       = head.declarationLbl.font.lineHeight*_showRow+5;
    head.societyTotalLbl.text         = [NSString stringWithFormat:@"公会人数：%d",number];
    head.moreBtn.hidden = row == 1 ? YES : NO;
}

#pragma mark ------------------------------------  设置 layout  -------------------------------------------
- (UICollectionViewFlowLayout *)judgeUsageWhichOne
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    if (self.sociatyDetailArray.count) {
        if (segmentControl.selectedSegmentIndex == 0)
        {
            CGFloat layoutW                 = (kScreenW - margin5 * 4) / 3.0;
            _layout.minimumInteritemSpacing = 0;
            _layout.minimumLineSpacing      = 5;
            _layout.itemSize                = CGSizeMake(layoutW, layoutW + 25);
        }
        else
        {
            _layout.itemSize                = CGSizeMake(kScreenW, 60);
            _layout.minimumLineSpacing      = 0.5;
        }
    }
    else
    {
        _layout.itemSize                     = CGSizeMake(150, 300);
    }
    return _layout;
}

#pragma mark  ------------------------------------------ 设置毛玻璃效果 --------------------------------------------------
- (void)frostedGlassEffectWithImage:(UIImageView *)image url:(NSString *)url
{
    [image sd_setImageWithURL:[NSURL URLWithString:url] completed:nil];
    if (!_frostedEffect)
    {
        _frostedEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        [UIImage frostedGlassEffectWithView:image effect:_frostedEffect];
    }
}

/**
 根据label的宽高、字体获取行数
 
 @param string 文本
 @return 返回的行数
 */
- (NSInteger)takeOutNumberOfRowWithString:(NSString *)string
{
    head.declarationLbl.numberOfLines = 0;
    head.declarationLbl.text          = string;
    CGSize size                       = [head.declarationLbl.text boundingRectWithSize:CGSizeMake(kScreenW-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:head.declarationLbl.font} context:nil].size;
    head.declarationLbl.size          = CGSizeMake(kScreenW-30, size.height);
    CGFloat labelHeight               = [head.declarationLbl sizeThatFits:CGSizeMake(kScreenW-30, size.height)].height;
    NSInteger count = (NSInteger)(labelHeight / head.declarationLbl.font.lineHeight);
    return count;
}

#pragma mark    ---------------------------------------------- 收起或更多 ----------------------------------------------
- (void)showOrHide:(UIButton *)sender
{
    if (_isShow == NO)
    {
        _lblShowH = [self resetLineSpacing:5 text:head.declarationLbl.text];
        [self showMoreBtnWithNumberOfLines:0 height:_lblShowH isShow:YES angle:M_PI];
    }
    else
    {
        [self resetLineSpacing:5 text:head.declarationLbl.text];
        [self showMoreBtnWithNumberOfLines:_showRow height:_showHeight isShow:NO angle:0.0];
    }

    [self.detailCollectionView reloadData];
}

- (void)showMoreBtnWithNumberOfLines:(NSInteger)num height:(CGFloat)height isShow:(BOOL)isShow angle:(CGFloat)angle
{
    CGAffineTransform transform       = CGAffineTransformMakeRotation(angle);
    head.moreBtn.transform            = transform;
    _isShow                           = isShow;
    head.declarationLbl.numberOfLines = num;
    [head.declarationLbl lblHeight:height];
}

- (void)configurationWithNumberOfLines:(NSInteger)numberOfLines headTblSize:(CGSize)size
{
    head.declarationLbl.numberOfLines = numberOfLines;
    head.size                         = size;
}

- (CGFloat)resetLineSpacing:(NSInteger)lineSpacing text:(NSString *)text
{
    return [head.declarationLbl takeLblHeight:text withTextFontSize:14.0 lineSpaceing:lineSpacing size:CGSizeMake(kScreenW-30.0, MAXFLOAT)];
}

- (void)createSegmentControler
{
    segmentControl                             = [[HMSegmentedControl alloc] initWithSectionTitles:[self configSegmentSectionTitle]];
    segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:kAppMainColor};
    segmentControl.titleTextAttributes         = @{NSForegroundColorAttributeName:kAppGrayColor3,NSFontAttributeName:kAppMiddleTextFont_1};
    segmentControl.selectionIndicatorLocation  = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentControl.selectionIndicatorColor     = kAppMainColor;
    segmentControl.selectionIndicatorHeight    = 3;
    segmentControl.borderType                  = HMSegmentedControlBorderTypeBottom;
    [segmentControl addTarget:self action:@selector(memberClick:) forControlEvents:UIControlEventValueChanged];
    segmentControl.borderColor = kAppSpaceColor3;
}

#pragma mark    ---------------------------------------------- 切换列表 ----------------------------------------------
- (void)memberClick:(HMSegmentedControl *)selectSegment
{
    [self requestDataWithPage:1 withDetailType:(int)selectSegment.selectedSegmentIndex];
}

- (NSArray *)configSegmentSectionTitle
{
    NSArray *arrayTitle;
    NSString *anchorStr = [NSString stringWithFormat:@"主播"];
    NSString *fansStr   = [NSString stringWithFormat:@"粉丝"];
    NSString *joinStr   = [NSString stringWithFormat:@"成员申请"];
    NSString *outStr    = [NSString stringWithFormat:@"退出申请"];
    arrayTitle          = self.type == 1 ? @[anchorStr, fansStr, joinStr, outStr] : @[anchorStr, fansStr];
    return arrayTitle;
}

#pragma mark -------------------------- CollectionView delegate and dataSource ------------------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.sociatyDetailArray.count)
    {
        return self.sociatyDetailArray.count;
    }
    else
    {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.sociatyDetailArray.count)
    {
        SociatyDetailModel *model = self.sociatyDetailArray[indexPath.row];
        if (segmentControl.selectedSegmentIndex == 0)
        {
            AnchorCell *cell    = [collectionView dequeueReusableCellWithReuseIdentifier:anchor forIndexPath:indexPath];
            [cell configCellMsg:model];
            return cell;
        }
        else if (segmentControl.selectedSegmentIndex == 1)
        {
            FansCell *cell      = [collectionView dequeueReusableCellWithReuseIdentifier:fans forIndexPath:indexPath];
            [cell configCellMsg:model memberType:self.type];
            cell.delegate       = self;
            return cell;
        }
        else
        {
            ApplicantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:applicant forIndexPath:indexPath];
            [cell configCellMsg:model];
            cell.delegate       = self;
            return cell;
        }
    }
    else
    {
        NoCotentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:noContent forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.sociatyDetailArray.count) {
        if (segmentControl.selectedSegmentIndex == 0)
        {
            return UIEdgeInsetsMake(margin5, margin5, 0, margin5);
        }
        return UIEdgeInsetsZero;
    }
    else
    {
        return UIEdgeInsetsMake(0, (kScreenW-150)/2, 0, (kScreenW-150)/2);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFlag forIndexPath:indexPath];
    if (_isShow == NO)
    {
        segmentControl.frame = CGRectMake(0, fixationH+_showHeight, kScreenW, slideH);
    }
    else if (_isShow == YES)
    {
        segmentControl.frame = CGRectMake(0, fixationH+_lblShowH, kScreenW, slideH);
    }
    if (_isFirst == YES)
    {
        _isFirst = NO;
        [head addSubview:segmentControl];
        head.declarationLbl.textColor = kAppGrayColor1;
        [head.societyBgBtn addTarget:self action:@selector(societyBgClick) forControlEvents:UIControlEventTouchUpInside];
        [head.OperationBtn addTarget:self action:@selector(tiantuanOperationClick) forControlEvents:UIControlEventTouchUpInside];
        [head.moreBtn addTarget:self action:@selector(showOrHide:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self tableViewHeadMsgSetup];
    return head;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (_isShow == NO)
    {
        return CGSizeMake(kScreenW, fixationH+_showHeight+slideH);
    }
    else
    {
        return CGSizeMake(kScreenW, fixationH+_lblShowH+slideH);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SociatyDetailModel *model = self.sociatyDetailArray[indexPath.row];
    if (segmentControl.selectedSegmentIndex == 0)
    {
        NSArray *items;
        //会长、正在直播
        if (self.type == 1)//查看的人身份是会长
        {
            //会长、没直播
            if (model.user_position.intValue == 1 && model.live_in.intValue == 0) {
                items = @[MMItemMake(@"查看详情", MMItemTypeNormal, ^(NSInteger index)
                                     {
                                         [self jumpOffToHomePageWithModel:model];
                                     })];
            }
            //普通主播
            else if (model.user_position.intValue == 0)
            {
                if (model.live_in.intValue == 1)
                {
                    items = @[MMItemMake(@"观看直播", MMItemTypeNormal, ^(NSInteger index)
                                         {
                                             [self viewLivingWithIndex:indexPath.row];
                                         }),MMItemMake(@"查看详情", MMItemTypeNormal, ^(NSInteger index)
                                                       {
                                                           [self jumpOffToHomePageWithModel:model];
                                                       }),MMItemMake(@"踢出公会", MMItemTypeNormal, ^(NSInteger index)
                                                                     {
                                                                         [self pleaseGoOutOfSocietyWithIndex:indexPath];
                                                                     })];
                }
                else if (model.live_in.intValue == 0)
                {
                    items = @[MMItemMake(@"查看详情", MMItemTypeNormal, ^(NSInteger index)
                                         {
                                             [self jumpOffToHomePageWithModel:model];
                                         }),MMItemMake(@"踢出公会", MMItemTypeNormal, ^(NSInteger index)
                                                       {
                                                           [self pleaseGoOutOfSocietyWithIndex:indexPath];
                                                       })];
                }
            }
        }
        else { //查看者不是会长
            if (model.live_in.intValue == 0)
            {
                items = @[MMItemMake(@"查看详情", MMItemTypeNormal, ^(NSInteger index)
                                     {
                                         [self jumpOffToHomePageWithModel:model];
                                     })];
            }
            else if (model.live_in.intValue == 1)
            {
                items = @[MMItemMake(@"观看直播", MMItemTypeNormal, ^(NSInteger index)
                                     {
                                         [self viewLivingWithIndex:indexPath.row];
                                     }),MMItemMake(@"查看详情", MMItemTypeNormal, ^(NSInteger index)
                                                   {
                                                       [self jumpOffToHomePageWithModel:model];
                                                   })];
            }
        }
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        if (items.count > 0)
        {
            MMSheetView *alert = [[MMSheetView alloc] initWithTitle:nil items:items];
            [alert show];
        }
    }
    else
    {
        if (self.sociatyDetailArray.count > 0 && indexPath.row < self.sociatyDetailArray.count)
        {
            [self jumpOffToHomePageWithModel:model];
        }
    }
}

- (void)jumpOffToHomePageWithModel:(SociatyDetailModel *)model
{
    SHomePageVC *homeVC = [[SHomePageVC alloc]init];
    homeVC.user_id = model.user_id;
    homeVC.user_nickname = model.user_name;
    homeVC.type = 0;
    [[AppDelegate sharedAppDelegate]pushViewController:homeVC];
}

#pragma mark    ---------------------------------------------- 点击公会头像 ----------------------------------------------
- (void)societyBgClick
{
    if (!(self.type == 1))
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"你没有操作权限"];
        return;
    }
    else if (self.type == 1 && self.mygh_status == 0 && [self.flagStr isEqualToString:mySociety])
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"公会正在审核中"];
        return;
    }
    EditSocietyViewController * editSocietyVC = [[EditSocietyViewController alloc] init];
    editSocietyVC.type                        = 1;
    editSocietyVC.sociatyID                   = self.mySocietyID;
    editSocietyVC.sociatyName                 = head.societyNameLbl.text;
    editSocietyVC.sociatyManifasto            = head.declarationLbl.text;
    editSocietyVC.sociaHead                   = self.tianTuanHeadImg;
    [self.navigationController pushViewController:editSocietyVC animated:YES];
}
#pragma mark ------------------------------------------------ 根据偏移量设置状态栏颜色 ----------------------------------------------
//表头背景图片高度固定256，减去状态栏和导航栏高度 = 192，当偏移量 <= 192 状态栏为白色，反之为黑色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isIOS11()) {
        if (scrollView.contentOffset.y >= -59 && scrollView.contentOffset.y <= 187.0 )
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
        else
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    else {
        if (scrollView.contentOffset.y >= -64 && scrollView.contentOffset.y <= 192.0 )
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
        else
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
}

#pragma mark  ------------------------------------------------ 加入、退出公会 ----------------------------------------------
- (void)tiantuanOperationClick
{
    if (self.type == 0)
    {
        FWWeakify(self)
        [FanweMessage alert:@"退出公会" message:[NSString stringWithFormat:@"是否退出公会：%@？",head.societyNameLbl.text] destructiveAction:^{
            
            FWStrongify(self)
            NSMutableDictionary *parmDict = [self parmDictWithCtlValue:@"society_app" actValue:@"society_out" isAgree:@"" forId:@"" model:nil parmType:0];
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                
                if ([responseJson toInt:@"status"]==1)
                {
                    [[FWHUDHelper sharedInstance] tipMessage:@"退会申请已提交"];
                    [self operationWithWidth:100 title:@"退会申请中" imageStr:@""];
                    self.type = 5;
                }
            } FailureBlock:^(NSError *error) {
                
            }];
            
        } cancelAction:^{
            
        }];
        
        return;
    }
    else if (self.type == 3)
    {
        NSMutableDictionary *parmDict = [self parmDictWithCtlValue:@"society_app" actValue:@"society_join" isAgree:@"" forId:@"" model:nil parmType:0];
        
        FWWeakify(self)
        [FanweMessage alert:@"加入公会" message:[NSString stringWithFormat:@"是否加入公会：%@？",head.societyNameLbl.text] destructiveAction:^{
            
            FWStrongify(self)
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                
                if ([responseJson toInt:@"status"]==1)
                {
                    [[FWHUDHelper sharedInstance] tipMessage:@"入会申请已提交"];
                    [self operationWithWidth:100 title:@"入会申请中" imageStr:@""];
                    self.type = 4;
                }
            } FailureBlock:^(NSError *error) {
                
            }];
            
        } cancelAction:^{
            
        }];
        
        return;
    }
    else if (self.type == 4)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"入会申请中"];
        return;
    }
    else if (self.type == 5)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"退会申请中"];
        return;
    }
    if (self.mygh_status == 2)
    {
        NSMutableDictionary *parmDict = [self parmDictWithCtlValue:@"society_app" actValue:@"society_agree" isAgree:@"" forId:@"" model:nil parmType:0];
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"] == 1)
            {
                FWStrongify(self)
                [[FWHUDHelper sharedInstance] tipMessage:@"申请已提交"];
                [self propertyWithBtnEnable:NO btnTitle:@"状态：审核中"];
                head.operationBtnW.constant = 100;
                self.mygh_status = 0;
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    //邀请码从第四位开始取
    if (head.OperationBtn.currentTitle.length > 3)
    {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:[head.OperationBtn.currentTitle substringFromIndex:4]];
        [[FWHUDHelper sharedInstance] tipMessage:@"已复制"];
    }
}

#pragma mark ----------------------------------- 踢出公会 -----------------------------------
- (void)pleaseLeaveWithSocietyMember:(FansCell *)cell
{
    NSIndexPath *index = [self.detailCollectionView indexPathForCell:cell];
    [self pleaseGoOutOfSocietyWithIndex:index];
}

- (void)pleaseGoOutOfSocietyWithIndex:(NSIndexPath *)index
{
    FWWeakify(self)
    [FanweMessage alert:@"踢出成员" message:@"是否踢出该成员？" destructiveAction:^{
        
        FWStrongify(self)
        
        SociatyDetailModel *model = self.sociatyDetailArray[index.row];
        NSMutableDictionary *parmDict = [self parmDictWithCtlValue:@"society_app" actValue:@"member_del" isAgree:@"1" forId:@"member_id" model:model parmType:1];
        
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self deleteSelectRowWithNSIndexPath:index];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

#pragma mark ------------------------------- 观看直播 ----------------------------------
- (void)viewLiving:(ApplicantCell *)cell
{
    NSIndexPath *index = [self.detailCollectionView indexPathForCell:cell];
    [self viewLivingWithIndex:index.row];
}

- (void)fansViewLiving:(FansCell *)cell
{
    NSIndexPath *index = [self.detailCollectionView indexPathForCell:cell];
    [self viewLivingWithIndex:index.row];
}

- (void)viewLivingWithIndex:(NSInteger)index
{
    SociatyDetailModel *model = self.sociatyDetailArray[index];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@"society_app" forKey:@"ctl"];
    [paramDict setObject:@"join_zb" forKey:@"act"];
    [paramDict setObject:[NSNumber numberWithInt:[model.user_id intValue]]forKey:@"member_id"];
    if (![FWUtils isNetConnected])
    {
        return;
    }
    if ([self checkUser:[IMAPlatform sharedInstance].host])
    {
        TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
        item.chatRoomId          = model.group_id;
        item.avRoomId            = [model.room_id intValue];
        item.title               = model.room_id;
        item.vagueImgUrl         = model.user_image;
        
        TCShowUser *showUser     = [[TCShowUser alloc]init];
        showUser.uid             = model.user_id;
        showUser.avatar          = model.user_image;
        item.host                = showUser;
        
        if ([model.live_in intValue] == FW_LIVE_STATE_ING)
        {
            item.liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        else if ([model.live_in intValue] == FW_LIVE_STATE_RELIVE)
        {
            item.liveType = FW_LIVE_TYPE_RELIVE;
        }
        
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:item isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
        }];
    }
    else
    {
        [[FWHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
            [[FWIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        } completion:^{
            
        }];
    }
}

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
}

#pragma mark ------------------------------------- 拒绝申请 ----------------------------------------
- (void)refuseOfSociety:(ApplicantCell *)cell
{
    NSIndexPath *index = [self.detailCollectionView indexPathForCell:cell];
    SociatyDetailModel *model = self.sociatyDetailArray[index.row];
    
    //拒绝加入公会
    if (segmentControl.selectedSegmentIndex == 2)
    {
        FWWeakify(self)
        [FanweMessage alert:@"拒绝加入公会" message:@"是否拒绝该成员加入公会？" destructiveAction:^{
            
            FWStrongify(self)
            
            NSMutableDictionary *parmDict = [self parmDictWithCtlValue:@"society_app" actValue:@"join_check" isAgree:@"0" forId:@"applyFor_id" model:model parmType:2];
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                
                if ([responseJson toInt:@"status"] == 1)
                {
                    [self deleteSelectRowWithNSIndexPath:index];
                }
                
            } FailureBlock:^(NSError *error) {
                
            }];
            
        } cancelAction:^{
            
        }];
    }
    //拒绝退出公会
    else if (segmentControl.selectedSegmentIndex == 3)
    {
        FWWeakify(self)
        [FanweMessage alert:@"拒绝退出公会" message:@"是否拒绝该成员退出公会？" destructiveAction:^{
            
            FWStrongify(self)
            
            NSMutableDictionary *parmDict = [self parmDictWithCtlValue:@"society_app" actValue:@"out_check" isAgree:@"0" forId:@"applyFor_id" model:model parmType:2];
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                
                if ([responseJson toInt:@"status"] == 1)
                {
                    [self deleteSelectRowWithNSIndexPath:index];
                }
                
            } FailureBlock:^(NSError *error) {
                
            }];
            
        } cancelAction:^{
            
        }];
    }
}

#pragma mark ------------------------------------- 同意申请 ----------------------------------------
- (void)agreeOfSociety:(ApplicantCell *)cell
{
    NSIndexPath *index = [self.detailCollectionView indexPathForCell:cell];
    SociatyDetailModel *model = self.sociatyDetailArray[index.row];
    if (segmentControl.selectedSegmentIndex == 2)
    {
        FWWeakify(self)
        [FanweMessage alert:@"同意加入公会" message:@"是否同意该成员加入公会？" destructiveAction:^{
            
            FWStrongify(self)
            
            NSMutableDictionary *parmDict = [self parmDictWithCtlValue:@"society_app" actValue:@"join_check" isAgree:@"1" forId:@"applyFor_id" model:model parmType:2];
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                
                if ([responseJson toInt:@"status"]==1)
                {
                    [self deleteSelectRowWithNSIndexPath:index];
                }
                
            } FailureBlock:^(NSError *error) {
                
            }];
            
        } cancelAction:^{
            
        }];
        
    }
    else if (segmentControl.selectedSegmentIndex == 3)
    {
        FWWeakify(self)
        [FanweMessage alert:@"同意退出公会" message:@"是否同意该成员退出公会？" destructiveAction:^{
            
            FWStrongify(self)
            
            NSMutableDictionary *parmDict = [self parmDictWithCtlValue:@"society_app" actValue:@"out_check" isAgree:@"1" forId:@"applyFor_id" model:model parmType:2];
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                
                if ([responseJson toInt:@"status"]==1)
                {
                    [self deleteSelectRowWithNSIndexPath:index];
                }
                
            } FailureBlock:^(NSError *error) {
                
            }];
            
        } cancelAction:^{
            
        }];
    }
}

- (NSMutableDictionary *)parmDictWithCtlValue:(NSString *)ctlValue actValue:(NSString *)actValue isAgree:(NSString *)isAgree forId:(NSString *)forId model:(SociatyDetailModel *)model parmType:(int)type
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:ctlValue forKey:@"ctl"];
    [parmDict setObject:actValue forKey:@"act"];
    
    if (type == 1)
    {
        [parmDict setObject:[NSNumber numberWithInt:[model.user_id intValue]] forKey:forId];
    }
    else if (type == 2)
    {
        [parmDict setObject:[NSNumber numberWithInt:[model.user_id intValue]] forKey:forId];
        [parmDict setObject:isAgree forKey:@"is_agree"];
    }
    [parmDict setObject:[NSNumber numberWithInt:self.mySocietyID] forKey:@"society_id"];
    
    return parmDict;
}

- (void)deleteSelectRowWithNSIndexPath:(NSIndexPath *)index
{
    [self.sociatyDetailArray removeObjectAtIndex:index.row];
    [self judgeUsageWhichOne];
    [self.detailCollectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self requestDataWithPage:1 withDetailType:(int)segmentControl.selectedSegmentIndex];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

@end
