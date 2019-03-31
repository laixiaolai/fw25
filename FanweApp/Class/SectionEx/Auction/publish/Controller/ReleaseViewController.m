//
//  ReleaseViewController.m
//  拍卖
//
//  Created by GuoMs on 16/8/5.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import "ReleaseViewController.h"
#import "BaseTableViewCell.h"
#import "TimeTableViewCell.h"
#import "CdescriptTableViewCell.h"
#import "HeaderView.h"
#import "FWHUDHelper.h"
#import "TagsModel.h"
#import "MapViewController.h"
#import "DatePickerOfView.h"
#import "AuctionHeaderView.h"
#import "FWOssManager.h"
#import "AuctionGoodsModel.h"

@interface ReleaseViewController ()<AddPhotoDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,MapChooseAddressControllerDelegate,QMapLocationViewDelegate,OssUploadImageDelegate>
{
    CGSize           _size;
    UIButton        *_rightButton;
    NSMutableDictionary *editPhotoDic;//编辑
    QMapLocationView *_mapLocationView; //腾讯地图
    CAKeyframeAnimation * keyAnimaion;//删除图片动画
    UIButton *btn;//删除图片
    
    FWOssManager *_ossManager;
    NSString *_uploadFilePath;
    NSString *_urlString;
    NSString *_timeString;//时间戳的字符串
    BOOL _fistTime;
    BOOL _fistDelay;
    BOOL _fistMax;
    
}
@property (strong, nonatomic) IBOutlet UITableView *releaseTabView;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, copy) NSString *textData;
@property (nonatomic, strong) UIImageView *addPhoto;
@property (nonatomic, strong) NSMutableDictionary *editInfo;//编辑
@property (nonatomic, strong) NSMutableDictionary *shopDic;//虚拟购物
@property (nonatomic, strong) NSMutableDictionary *entiShopDic;//实体购物
@property (nonatomic, strong) NSMutableArray *editArr;//存放修改前的数据 NSMutableArray
@property (nonatomic, strong) NSMutableArray *shopAuctionArr;//实物竞拍头部商品信息
@property (nonatomic, strong) AuctionHeaderView * auctionView;
@property (nonatomic, strong) NSMutableArray *pictArr;//存储上传后的图片
@property (nonatomic, copy)  NSString * bzStr;//保证金
@property (nonatomic, copy)  NSString * addPriceStr;//加价幅度
@property (nonatomic, copy)  NSString * auctionTimeStr;//竞拍时长
@property (nonatomic, copy)  NSString * delayTimeStr;//延时时间
@property (nonatomic, copy)  NSString * maxDelayTimeStr;//最大延时
@property (nonatomic, strong) AuctionGoodsModel * entityAuctionModel;//实物竞拍的模型

@property (nonatomic, copy)  NSString * nameStr;//商品名称
@property (nonatomic, copy)  NSString * priceStr;//实物商品价格
@property (nonatomic, copy)  NSString * urlStr;//实物商品网址链接
@property (nonatomic, copy)  NSString * expressPriceStr;//实物商品快递费
@property (nonatomic, copy)  NSString * desStr;//商品描述
@property (nonatomic, copy)  NSString * contactStr;//联系人
@property (nonatomic, copy)  NSString * mobileStr;//联系电话
@property (nonatomic, copy)  NSString * qpPriceStr;//起拍价
@property (nonatomic, strong) UILabel * placehoderLabel;
@property (nonatomic, strong) UIView  *dateView;
@property (nonatomic, strong) DatePickerOfView *datePicker;
@end

@implementation ReleaseViewController

/**
 *****新增时候的商品照片
 **/
-(UIImageView *)addPhoto{
    if (!_addPhoto) {
        self.addPhoto = [UIImageView new];
    }
    return _addPhoto;
}
/**
 *****存储虚拟购物数据
 **/
-(NSMutableDictionary *)shopDic{
    if (!_shopDic) {
        self.shopDic = [NSMutableDictionary new];
    }
    return _shopDic;
}

/**
 *****存储实体购物数据
 **/
-(NSMutableDictionary *)entiShopDic{
    if (!_entiShopDic) {
        self.entiShopDic = [NSMutableDictionary new];
    }
    return _entiShopDic;
}
/**
 *****存放修改前的数据
 **/
- (NSMutableArray *)editArr{
    if (!_editArr) {
        self.editArr = [NSMutableArray new];
    }
    return _editArr;
}
//实物竞拍数据
- (NSMutableArray *)shopAuctionArr
{
    if (!_shopAuctionArr) {
        _shopAuctionArr = [NSMutableArray new];
    }
    return _shopAuctionArr;
}


- (NSMutableArray *)pictArr{
    if (!_pictArr) {
        self.pictArr = [NSMutableArray new];
    }
    return _pictArr;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始定位
    [_mapLocationView startLocate];
    _fistMax = YES;
    _fistDelay = YES;
    _fistTime = YES;
    //处理 竞拍+悬浮+弹出发布界面UI问题
    //#if  kSupportAuction
    //    _tableView_Top_Constraint.constant = 64;//防止崩溃
    //    _navBar_View.title_Lab.text = @"商品";
    //#else
    //    _tableView_Top_Constraint.constant = 0;
    //#endif
    //    _navBar_View.hidden = !(kSupportAuction == 1);
    //    [self.view  layoutIfNeeded];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //停止定位
    [_mapLocationView stopLocate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 5, 75, 25)];
    self.placehoderLabel.text = @"请描述商品";
    self.placehoderLabel.textColor = kAppGrayColor3;
    self.placehoderLabel.font = kAppMiddleTextFont;
    
    self.view.backgroundColor = kWhiteColor;
    //头部
    self.headerView = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]lastObject];
    self.headerView.isOTOShop = _isOTOShop;
    self.headerView.delegate = self;
    [self.releaseTabView registerNib:[UINib nibWithNibName:@"BaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"BaseCell"];//带输入框的
    [self.releaseTabView registerNib:[UINib nibWithNibName:@"TimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeCell"];
    [self.releaseTabView registerNib:[UINib nibWithNibName:@"CdescriptTableViewCell" bundle:nil]  forCellReuseIdentifier:@"desCell"];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(returnToMeVc) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-40, 5, 40, 30)];
    [_rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [_rightButton setTitleColor:kAppMainColor forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    if ([self.shopType isEqualToString:@"VirtualShopping"]) {
        self.title = @"虚拟商品拍卖设置";
        [self getLabelNetWorking];
        [self creatPickView];
        _mapLocationView = [QMapLocationView sharedInstance];
        [_rightButton addTarget:self action:@selector(releaseEditButton) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        self.releaseTabView.contentSize = CGSizeMake(kScreenW, kScreenH);
        if ([self.shopType isEqualToString:@"EditShopping"]){
            //self.title = @"修改商品信息";
            self.navigationItem.title = @"编辑购物商品";
            [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
            [self editShop];
            [self.editArr addObject:self.model.name];
            [self.editArr addObject:self.model.price];
            if (self.model.url.length>0) {
                [self.editArr addObject:self.model.url];
            }
            if (self.fanweApp.appModel.open_podcast_goods == 0 && self.model.kd_cost.length >0) {
                [self.editArr addObject:self.model.kd_cost];
            }
            [self.editArr addObject:self.model.descrStr];
            [_rightButton addTarget:self action:@selector(EditShoppingButton) forControlEvents:UIControlEventTouchUpInside];
            self.placehoderLabel.hidden = YES;
        }
        else if ([self.shopType isEqualToString:@"EntityAuctionShopping"])
        {
            self.title = @"星店商品拍卖设置";
            [self addShopGoodsData];
            [self.shopAuctionArr addObject:self.auctionGoodsModel.name];
            [self.shopAuctionArr addObject:self.auctionGoodsModel.price];
            [self.shopAuctionArr addObject:self.auctionGoodsModel.imgs];
            //        [self addAuctionGoodsView];
            
            [_rightButton addTarget:self action:@selector(releaseButton) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            //       self.title = @"实物商品拍卖设置";
            self.title =self.fanweApp.appModel.open_podcast_goods == 1? @"商品设置": @"产品设置";
            [self addShop];
            [_rightButton addTarget:self action:@selector(EntityShoppingEditButton) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (self.fanweApp.appModel.open_sts == 1)
    {
        _ossManager = [[FWOssManager alloc]initWithDelegate:self];
    }
    //当悬浮 恢复、、发布VC 键盘下去
    //    [self xw_addNotificationForName:@"GoodsPublishVCResign" block:^(NSNotification * _Nonnull notification) {
    //        [self.view  endEditing:YES];
    //    }];
}

- (void)popVC
{
    if ([self.shopType isEqualToString:@"EditShopping"] ||[self.shopType isEqualToString:@"EntityShopping"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.fanweApp.appModel.open_pai_module intValue] == 1)
    {
        //        [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:NO nextViewController:nil delegateWindowRCNameStr:@"FWTabBarController" complete:^(BOOL finished) {
        //        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 获取标签
- (void)getLabelNetWorking
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@"pai_podcast" forKey:@"ctl"];
    [dict setValue:@"tags" forKey:@"act"];
    [dict setObject:@"shop" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1) {
            NSArray * listArr = responseJson[@"data"][@"list"];
            NSArray * tagsArr = [TagsModel mj_objectArrayWithKeyValuesArray:listArr];
            if (tagsArr.count > 0)
            {
                self.headerView.tagsArr = tagsArr;
                UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 176)];
                [headerV addSubview:self.headerView];
                //[self.pictArr insertObject:[NSString stringWithFormat:@"me_addPhoto"] atIndex:self.pictArr.count];
                [self.pictArr insertObject:[NSString stringWithFormat:@"me_addPhoto"] atIndex:0];
                [self.headerView getPicturearr:self.pictArr block:^{
                    
                }];
                self.releaseTabView.tableHeaderView = headerV;
                [self.releaseTabView reloadData];
            }else{
                self.headerView.frame = CGRectMake(0, 0, kScreenW, 120);
                UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
                [headerV addSubview:self.headerView];
                //[self.pictArr insertObject:[NSString stringWithFormat:@"me_addPhoto"] atIndex:self.pictArr.count];
                [self.pictArr insertObject:[NSString stringWithFormat:@"me_addPhoto"] atIndex:0];
                [self.headerView getPicturearr:self.pictArr block:^{
                    
                }];
                self.releaseTabView.tableHeaderView = headerV;
                [self.releaseTabView reloadData];
            }
        }
    } FailureBlock:^(NSError *error) {
        
    }];
    
}

-(AuctionHeaderView *)auctionView
{
    if (_auctionView == nil) {
        _auctionView = [[AuctionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    }
    return _auctionView;
}

- (void)addAuctionGoodsView
{
    //    self.auctionView = [[AuctionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    
    //    self.auctionView.backgroundColor = kAppGrayColor3;
    //    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    //    [headerV addSubview:self.auctionView];
    __weak typeof (self) weakSelf = self;
    weakSelf.releaseTabView.tableHeaderView = weakSelf.auctionView;
    weakSelf.auctionView.model = weakSelf.entityAuctionModel;
    [weakSelf.releaseTabView reloadData];
}

- (void)addShopGoodsData
{
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"pai_podcast" forKey:@"ctl"];
    [mDict setObject:@"addpaidetail" forKey:@"act"];
    if (self.auctionGoodsModel.goodsId.length>0) {
        [mDict setObject:self.auctionGoodsModel.goodsId forKey:@"goods_id"];
    }
    else
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"商品ID不能为空"];
        return;
    }
    [mDict setObject:@"shop" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1) {
            self.entityAuctionModel = [AuctionGoodsModel mj_objectWithKeyValues:[responseJson objectForKey:@"data"]];
            [self addAuctionGoodsView];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark -- 新增实物商品
- (void)addShop{
    self.headerView.frame = CGRectMake(0, 0, kScreenW, 120);
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    [headerV addSubview:self.headerView];
    //[self.pictArr insertObject:[NSString stringWithFormat:@"me_addPhoto"] atIndex:self.pictArr.count];
    [self.pictArr insertObject:[NSString stringWithFormat:@"me_addPhoto"] atIndex:0];
    [self.headerView getPicturearr:self.pictArr block:^{
        
    }];
    self.releaseTabView.tableHeaderView = headerV;
    [self.releaseTabView reloadData];
    
}
#pragma mark -- 编辑商品
- (void)editShop{
    self.pictArr = [self.model.imgs mutableCopy];
    NSLog(@"%@",self.pictArr);
    self.editInfo = [NSMutableDictionary new];
    if (self.pictArr.count > 0) {
        //        for (int i = 0; i < self.pictArr.count; i++) {
        //            NSLog(@"%@",self.pictArr[i]);
        //            [_entiShopDic setObject:[NSString stringWithFormat:@"%@",self.pictArr[i]] forKey:[NSString stringWithFormat:@"%d",i]];
        //        }
        [self.editInfo setObject:self.model.name forKey:@"name"];
        [self.editInfo setObject:self.model.price forKey:@"price"];
        if (self.model.url.length>0) {
            [self.editInfo setObject:self.model.url forKey:@"url"];
        }
        if (self.model.descrStr.length>0) {
            [self.editInfo setObject:self.model.descrStr forKey:@"description"];
        }
        if (self.fanweApp.appModel.open_podcast_goods == 0 && self.model.kd_cost.length >0) {
            [self.editInfo setObject:self.model.kd_cost forKey:@"kd_cost"];
            self.expressPriceStr = self.model.kd_cost;
        }
        NSLog(@"%@",self.editInfo);
        self.nameStr = self.model.name;
        self.priceStr = self.model.price;
        self.urlStr = self.model.url;
        self.desStr = self.model.descrStr;
        self.headerView.frame = CGRectMake(0, 0, kScreenW, 120);
        UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
        [headerV addSubview:self.headerView];
        if (!_isOTOShop) {
            //[self.pictArr insertObject:[NSString stringWithFormat:@"me_addPhoto"] atIndex:self.pictArr.count];
            [self.pictArr insertObject:[NSString stringWithFormat:@"me_addPhoto"] atIndex:0];
        }
        //[self.pictArr insertObject:[NSString stringWithFormat:@"addPhoto"] atIndex:self.pictArr.count];
        [self.headerView getPicturearr:self.pictArr block:^{
            
        }];
        self.releaseTabView.tableHeaderView = headerV;
        [self.releaseTabView reloadData];
    }
}
#pragma mark -- 发布重新编辑的商品
- (void)EditShoppingButton{
    [self.view endEditing:YES];
    [self.editInfo setObject:@"shop" forKey:@"ctl"];
    [self.editInfo setObject:@"edit_goods" forKey:@"act"];
    [self.editInfo setObject:[NSString stringWithFormat:@"%@",self.model.ID] forKey:@"id"];
    if (self.pictArr.count == 1 && [self.pictArr containsObject:@"me_addPhoto"])
    {
        if (_isOTOShop) {
            [FanweMessage alert:@"请上传图片"];
        }
        else
        {
            [FanweMessage alert:@"至少上传一张图片(最多5张)"];
        }
        return;
    }
    if (_nameStr.length == 0) {
        [[FWHUDHelper sharedInstance] tipMessage:@"商品名称不能为空"];
        return;
    }
    if (_priceStr.length == 0) {
        [[FWHUDHelper sharedInstance] tipMessage:@"商品价格不能为空"];
        return;
    }
    else
    {
        NSString *priceRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
        NSPredicate *priceTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",priceRegex];
        if (![priceTest evaluateWithObject:_priceStr]) {
            [self.view endEditing:YES];
            [[FWHUDHelper sharedInstance] tipMessage:@"请保证输入的商品价格小数点最多两位"];
            return;
        }
    }
    if (_urlStr.length == 0 ) {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入网址"];
        return;
    }
    if (self.fanweApp.appModel.open_podcast_goods == 0) {
        if (_expressPriceStr.length == 0) {
            [[FWHUDHelper sharedInstance] tipMessage:@"快递费不能为空"];
            return;
        }
        else
        {
            [self.editInfo setObject:_expressPriceStr forKey:@"kd_cost"];
        }
    }
    
    if ([self.pictArr containsObject:@"me_addPhoto"] && !_isOTOShop)
    {
        [self.pictArr removeObject:@"me_addPhoto"];
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.pictArr options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *JSONStr  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.editInfo setObject:JSONStr forKey:@"imgs"];
    
    [self.editInfo setObject:_nameStr forKey:@"name"];
    [self.editInfo setObject:_priceStr forKey:@"price"];
    [self.editInfo setObject:_urlStr forKey:@"url"];
    if (_desStr.length>0) {
        [self.editInfo setObject:_desStr forKey:@"description"];
    }
    NSMutableDictionary * editDic = self.editInfo.mutableCopy;
    [editDic setObject:@"shop" forKey:@"itype"];
    [[FWHUDHelper sharedInstance] syncLoading:@"正在发布请等待"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:editDic SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        [[FWHUDHelper sharedInstance] syncStopLoading];
        
        if ([responseJson toInt:@"status"] == 1)
        {
            [self popVC];
        }
        else
        {
            [self addPhotoWhenFailed];
        }
        
    } FailureBlock:^(NSError *error) {
        FWStrongify(self);
        [[FWHUDHelper sharedInstance] syncStopLoading];
        [self addPhotoWhenFailed];
        
    }];
    
}
#pragma mark -- 实体商品发布
- (void)EntityShoppingEditButton{
    [self.view endEditing:YES];
    [self.entiShopDic setObject:@"shop" forKey:@"ctl"];
    [self.entiShopDic setObject:@"add_goods" forKey:@"act"];
    [self.entiShopDic setObject:[IMAPlatform sharedInstance].host.userId forKey:@"user_id"];
    if (self.pictArr.count == 1 && [_pictArr containsObject:@"me_addPhoto"]) {
        if (_isOTOShop) {
            [FanweMessage alert:@"请上传图片"];
        }
        else
        {
            [FanweMessage alert:@"至少上传一张图片(最多5张)"];
        }
        return;
    }else{
        if (_nameStr.length == 0) {
            [[FWHUDHelper sharedInstance] tipMessage:@"商品名称不能为空"];
            return;
        }
        if (_priceStr.length == 0) {
            [[FWHUDHelper sharedInstance] tipMessage:@"商品价格不能为空"];
            return;
        }
        else
        {
            NSString *priceRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
            NSPredicate *priceTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",priceRegex];
            if (![priceTest evaluateWithObject:_priceStr]) {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请保证输入的商品价格小数点最多两位"];
                return;
            }
        }
        if (_urlStr.length == 0 ) {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入网址"];
            return;
        }
        if (self.fanweApp.appModel.open_podcast_goods == 0) {
            if (_expressPriceStr.length == 0 ) {
                [[FWHUDHelper sharedInstance] tipMessage:@"快递费不能为空"];
                return;
            }
            else
            {
                [self.entiShopDic setObject:_expressPriceStr  forKey:@"kd_cost"];
            }
        }
        //        if (!_desStr || [_desStr isEqualToString:@""]) {
        //            [[FWHUDHelper sharedInstance] tipMessage:@"商品描述不能为空"];
        //            return;
        //        }
        
        if ([self.pictArr containsObject:@"me_addPhoto"] && self.pictArr.count > 1)
        {
            [self.pictArr removeObject:@"me_addPhoto"];
        }
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.pictArr options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *JSONStr  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.entiShopDic setObject:JSONStr forKey:@"imgs"];
        
        [self.entiShopDic setObject:_nameStr forKey:@"name"];
        [self.entiShopDic setObject:_urlStr forKey:@"url"];
        [self.entiShopDic setObject:_priceStr forKey:@"price"];
        if (_desStr.length>0) {
            [self.entiShopDic setObject:_desStr forKey:@"description"];
        }
        NSMutableDictionary * entiDic = self.entiShopDic.mutableCopy;
        [entiDic setObject:@"shop" forKey:@"itype"];
        [[FWHUDHelper sharedInstance] syncLoading:@"正在发布请等待"];
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:entiDic SuccessBlock:^(NSDictionary *responseJson) {
            FWStrongify(self)
            [[FWHUDHelper sharedInstance] syncStopLoading];
            
            if ([responseJson toInt:@"status"] == 1)
            {
                [self popVC];
            }
            else
            {
                [self addPhotoWhenFailed];
            }
            
        } FailureBlock:^(NSError *error) {
            FWStrongify(self)
            [[FWHUDHelper sharedInstance] syncStopLoading];
            [self addPhotoWhenFailed];
        }];
    }
}

- (void)addPhotoWhenFailed
{
    if (!_isOTOShop)
    {
        if (![self.pictArr containsObject:@"me_addPhoto"] && self.pictArr.count != 5)
        {
            //[self.pictArr addObject:@"me_addPhoto"];
            [self.pictArr insertObject:@"me_addPhoto" atIndex:0];
        }
    }
}

#pragma mark -- 虚拟商品发布
- (void)releaseEditButton{
    [self.view endEditing:YES];
    [self.shopDic setObject:@"0" forKey:@"is_true"];
    [self.shopDic setObject:@"pai_podcast" forKey:@"ctl"];
    [self.shopDic setObject:@"addpai" forKey:@"act"];
    //提交地理位置
    NSError *parseErr = nil;
    NSMutableDictionary *geoDic = [NSMutableDictionary new];
    if (self.fanweApp.addressJsonStr != nil) {
        
        [geoDic setObject:self.fanweApp.addressJsonStr forKey:@"district"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:geoDic options:NSJSONWritingPrettyPrinted error:&parseErr];
        NSString *geograJSONStr  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.shopDic setObject:geograJSONStr forKey:@"district"];
    }
    if (self.fanweApp.addressJsonStr != nil) {
        [geoDic setObject:self.fanweApp.addressJsonStr forKey:@"district"];
    }
    else if (_keyWordStr.length>0)
    {
        [geoDic setObject:_keyWordStr forKey:@"district"];
    }
    if (geoDic != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:geoDic options:NSJSONWritingPrettyPrinted error:&parseErr];
        NSString *geograJSONStr  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.shopDic setObject:geograJSONStr forKey:@"district"];
    }
    else
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入地址"];
        return;
    }
    NSError *parseError1 = nil;
    if (self.pictArr.count == 1 && [self.pictArr containsObject:@"me_addPhoto"]) {
        [FanweMessage alert:@"至少上传一张图片(最多5张)"];
        return;
    }else{
        if (_nameStr.length > 0) {
            [self.shopDic setObject:_nameStr forKey:@"name"];
        }
        else
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入商品名称"];
            return;
        }
        
        if (_contactStr.length > 0) {
            [self.shopDic setObject:_contactStr forKey:@"contact"];
        }
        else
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入联系人姓名"];
            return;
        }
        
        if (_mobileStr.length > 0) {
            if (![_mobileStr isTelephone]) {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入正确的电话号码"];
                return;
            }
            [self.shopDic setObject:_mobileStr forKey:@"mobile"];
        }
        else
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入电话号码"];
            return;
        }
        
        if (_qpPriceStr.length < 1 ||[_qpPriceStr integerValue]== 0)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"竞拍起拍价格不能为空或0"];
            return;
        }
        [self.shopDic setObject:_qpPriceStr forKey:@"qp_diamonds"];
        
        if (_bzStr.length < 1||[_bzStr integerValue]== 0)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"竞拍保证金不能为空或0"];
            return;
        }
        
        [self.shopDic setObject:_bzStr forKey:@"bz_diamonds"];
        
        if (_addPriceStr.length < 1 || [_addPriceStr integerValue]== 0)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"加价幅度不能为空或0"];
            return;
        }
        [self.shopDic setObject:_addPriceStr forKey:@"jj_diamonds"];
        if (_auctionTimeStr.floatValue < 24 && _auctionTimeStr.floatValue >0) {
            
            [self.shopDic setObject:_auctionTimeStr forKey:@"pai_time"];
        }
        else{
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入有效的竞拍时间"];
            return;
        }
        if (_delayTimeStr.integerValue < 60 && _delayTimeStr.integerValue >0)
        {
            
            [self.shopDic setObject:_delayTimeStr forKey:@"pai_yanshi"];
        }else
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入延时值"];
            return;
        }
        if ([_maxDelayTimeStr integerValue ]< 10 && [_maxDelayTimeStr length]>0 && [_maxDelayTimeStr integerValue ]>=0)
        {
            
            [self.shopDic setObject:_maxDelayTimeStr forKey:@"max_yanshi"];
            
        }else
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入最大延时"];
            return;
        }
        
        if (_desStr.length > 0) {
            [self.shopDic setObject:_desStr forKey:@"description"];
        }
        else
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"描述不能为空"];
            return;
        }
        
        
        if ([self.pictArr containsObject:@"me_addPhoto"] && self.pictArr.count > 1)
        {
            [self.pictArr removeObject:@"me_addPhoto"];
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.pictArr options:NSJSONWritingPrettyPrinted error:&parseError1];
        NSString *JSONStr  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.shopDic setObject:JSONStr forKey:@"imgs"];
        
        [[FWHUDHelper sharedInstance] syncLoading:@"正在发布请等待"];
        NSMutableDictionary * shopdic = self.shopDic.mutableCopy;
        [shopdic setObject:@"shop" forKey:@"itype"];
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:shopdic SuccessBlock:^(NSDictionary *responseJson) {
            FWStrongify(self)
            [[FWHUDHelper sharedInstance] syncStopLoading];
            
            if ([responseJson toInt:@"status"] == 1)
            {
                [self popVC];
                if (_delegate && [_delegate respondsToSelector:@selector(onReleaseVCAuctionId:)])
                {
                    [_delegate onReleaseVCAuctionId:[responseJson toInt:@"pai_id"]];
                }
            }
            else
            {
                [self addPhotoWhenFailed];
                if (![responseJson[@"error"] isEqualToString:@""])
                {
                    if ([[responseJson toString:@"error"] rangeOfString:@"直播间已关闭"].location != NSNotFound)
                    {
                        [self popVC];
                    }
                }
            }
            
        } FailureBlock:^(NSError *error) {
            FWStrongify(self)
            [self addPhotoWhenFailed];
            
        }];
    }
}

#pragma mark -- 实物竞拍商品发布
- (void)releaseButton{
    [self.view endEditing:YES];
    
    if ([FWUtils isBlankString:_bzStr]) {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入竞拍保证金"];
        return;
    }
    if (_addPriceStr.length == 0)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入加价幅度"];
        return;
    }
    if (_auctionTimeStr.length == 0)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入竞拍时间"];
        return;
    }
    if (_delayTimeStr.length == 0)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入延时时间"];
        return;
    }
    if (_maxDelayTimeStr.length == 0)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入最大延时"];
        return;
    }
    NSError *parseError1 = nil;
    [self.shopDic setObject:@"1" forKey:@"is_true"];
    [self.shopDic setObject:@"pai_podcast" forKey:@"ctl"];
    [self.shopDic setObject:@"addpai" forKey:@"act"];
    [self.shopDic setObject:_auctionGoodsModel.goodsId forKey:@"goods_id"];
    [self.shopDic setObject:_auctionGoodsModel.price forKey:@"qp_diamonds"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_auctionGoodsModel.imgs options:NSJSONWritingPrettyPrinted error:&parseError1];
    NSString *JSONStr  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.shopDic setObject:JSONStr forKey:@"imgs"];
    [self.shopDic setObject:_auctionGoodsModel.name forKey:@"name"];
    if (_auctionGoodsModel.descStr.length>0) {
        [self.shopDic setObject:_auctionGoodsModel.descStr forKey:@"description"];
    }
    if (_entityAuctionModel.shop_id.length > 0)
    {
        [self.shopDic setObject:_entityAuctionModel.shop_id forKey:@"shop_id"];
    }
    if (_entityAuctionModel.shop_name.length > 0)
    {
        [self.shopDic setObject:_entityAuctionModel.shop_name forKey:@"shop_name"];
    }
    
    if (_auctionTimeStr.floatValue < 24 && _auctionTimeStr.floatValue >0) {
        
        [self.shopDic setObject:_auctionTimeStr forKey:@"pai_time"];
    }
    else{
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入有效的竞拍时间"];
        return;
    }
    if (_delayTimeStr.integerValue < 60 && _delayTimeStr.integerValue >0) {
        
        [self.shopDic setObject:_delayTimeStr forKey:@"pai_yanshi"];
    }
    if ([_maxDelayTimeStr integerValue ]< 10 && [_maxDelayTimeStr integerValue ]>=0) {
        
        [self.shopDic setObject:_maxDelayTimeStr forKey:@"max_yanshi"];
    }
    
    NSMutableDictionary * dic = self.shopDic.mutableCopy;
    [dic setObject:@"shop" forKey:@"itype"];
    [[FWHUDHelper sharedInstance] syncLoading:@"正在发布请等待"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        [[FWHUDHelper sharedInstance] syncStopLoading];
        
        if ([responseJson toInt:@"status"] == 1)
        {
            [self popVC];
            if (_delegate && [_delegate respondsToSelector:@selector(onReleaseVCAuctionId:)])
            {
                [_delegate onReleaseVCAuctionId:[responseJson toInt:@"pai_id"]];
            }
        }
        else
        {
            if (![responseJson[@"error"] isEqualToString:@""])
            {
                [[FWHUDHelper sharedInstance] syncStopLoading];
                if ([[responseJson toString:@"error"] rangeOfString:@"直播间已关闭"].location != NSNotFound)
                {
                    [self popVC];
                }
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}



#pragma mark -- 标签的代理点击事件
- (void)handleWithGoodsTag:(NSString *)goodsTag
{
    if (goodsTag.length > 0)
    {
         [self.shopDic setObject:goodsTag forKey:@"tags"];
    }
}

#pragma mark -- 点击增加图片的代理方法
- (void)handleToTapPhoto:(UITapGestureRecognizer *)tap{
    self.addPhoto = (UIImageView *)tap.view;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:picker animated:YES completion:nil];
    //    UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    ////    [headImgSheet addButtonWithTitle:@"相机"];
    //    [headImgSheet addButtonWithTitle:@"从手机相册选择"];
    //    [headImgSheet addButtonWithTitle:@"取消"];
    //    headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
    //    headImgSheet.delegate = self;
    //    [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalTransitionStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex == 1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (mediaType){
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image)
        {
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        if (self.fanweApp.appModel.open_sts == 1)
        {
            if ([_ossManager isSetRightParameter])
            {
                [self saveImage:image withName:@"1.png"];
                _timeString = [_ossManager getObjectKeyString];
                [_ossManager asyncPutImage:_timeString localFilePath:_uploadFilePath];
            }
        }else{
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            NSString *nameImage = [NSString stringWithFormat:@"currentImage%ld.jpg",self.addPhoto.tag];
            [self saveImage:image withName:nameImage];
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:nameImage];
            NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",fullPath]];
            [self pictureToNet:fileUrl];
            
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 上传图片
- (void)uploadImageWithUrlStr:(NSString *)imageUrlStr withUploadStateCount:(int)stateCount
{
    if (stateCount == 0)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",_ossManager.oss_domain,_timeString];
        NSLog(@"%@",urlString);
        //#if kSupportAuction
        //    [imgdict addObject:urlString];
        //    NSLog(@"%@",imgdict);
        
        //#endif
        if (self.isOTOShop)
        {
            if (self.addPhoto.tag  < self.pictArr.count - 1 ) {//替换---已存在图片情况下
                [self.pictArr replaceObjectAtIndex:self.addPhoto.tag withObject:urlString];
            }
            else
            {
                [self.pictArr insertObject:urlString atIndex:self.pictArr.count - 1];
            }
        }
        else
        {
            if (self.addPhoto.tag  < self.pictArr.count - 1 && self.addPhoto.tag > 0) {//替换---已存在图片情况下
                [self.pictArr replaceObjectAtIndex:self.addPhoto.tag withObject:urlString];
            }
            else if (self.addPhoto.tag == 0 && self.pictArr.count == 5)
            {
                if ([self.pictArr.firstObject isEqual:@"me_addPhoto"])
                {
                    [self.pictArr addObject:urlString];
                    [self.pictArr removeObject:@"me_addPhoto"];
                }
                else
                {
                    [self.pictArr replaceObjectAtIndex:self.addPhoto.tag withObject:urlString];
                }
            }
            else{//增加
                [self.pictArr addObject:urlString];
                //[self.pictArr insertObject:urlString atIndex:self.pictArr.count - 1];
            }
        }
        [self.headerView getPicturearr:self.pictArr block:^{
            [self.headerView.getPhotoCollection reloadData];
        }];
    }else
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"上传头像失败"];
    }
    //#if kSupportH5Shopping
    //    if ([self.shopType isEqualToString:@"EditShopping"]){
    //        [_entiShopDic setObject:urlString forKey:[NSString stringWithFormat:@"%ld",self.addPhoto.tag]];
    //
    //    }else{
    //        [self.pictArr addObject:urlString];
    //    }
    //#endif
    
}

#pragma mark -- 文件流上传图片
- (void)pictureToNet:(NSURL *)pictureUrl
{
    [[FWHUDHelper sharedInstance] syncLoading:nil];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"pai_podcast" forKey:@"ctl"];
    [parmDict setObject:@"upload" forKey:@"act"];
    [parmDict setObject:[IMAPlatform sharedInstance].host.userId forKey:@"id"];
    
    [[NetHttpsManager manager] POSTWithDict:parmDict andFileUrl:pictureUrl SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
        {
            NSLog(@"%@",self.pictArr);
            NSString * pictStr = [responseJson toString:@"server_full_path"];
            if (self.isOTOShop)
            {
                if (self.addPhoto.tag  < self.pictArr.count - 1 ) {//替换---已存在图片情况下
                    [self.pictArr replaceObjectAtIndex:self.addPhoto.tag withObject:pictStr];
                }
                else
                {
                    //[self.pictArr addObject:pictStr];
                    [self.pictArr insertObject:pictStr atIndex:self.pictArr.count - 1];
                }
            }
            else
            {
                if (self.addPhoto.tag  < self.pictArr.count - 1 && self.addPhoto.tag > 0) {//替换---已存在图片情况下
                    [self.pictArr replaceObjectAtIndex:self.addPhoto.tag withObject:pictStr];
                }
                else if (self.addPhoto.tag == 0 && self.pictArr.count == 5)
                {
                    if ([self.pictArr.firstObject isEqual:@"me_addPhoto"])
                    {
                        [self.pictArr addObject:pictStr];
                        [self.pictArr removeObject:@"me_addPhoto"];
                    }
                    else
                    {
                        [self.pictArr replaceObjectAtIndex:self.addPhoto.tag withObject:pictStr];
                    }
                    //                    [self.pictArr replaceObjectAtIndex:self.addPhoto.tag withObject:pictStr];
                }
                else{//增加
                    [self.pictArr addObject:pictStr];
                    //[self.pictArr insertObject:urlString atIndex:self.pictArr.count - 1];
                }
            }
            //            if (self.addPhoto.tag  < self.pictArr.count - 1 && self.addPhoto.tag > 0)
            //            { // 替换---已存在图片情况下
            //                [self.pictArr replaceObjectAtIndex:self.addPhoto.tag withObject:[responseJson toString:@"server_full_path"]];
            //            }
            //            else
            //            { // 增加
            //                if (self.isOTOShop)
            //                {
            //                    [self.pictArr insertObject:[responseJson toString:@"server_full_path"] atIndex:self.pictArr.count - 1];
            //                }
            //                else
            //                {
            //                     [self.pictArr addObject:[responseJson toString:@"server_full_path"]];
            //                }
            //                //[self.pictArr insertObject:[responseJson toString:@"server_full_path"] atIndex:self.pictArr.count - 1];
            //                //[self.pictArr addObject:[responseJson toString:@"server_full_path"]];
            //            }
            [self.headerView getPicturearr:self.pictArr block:^{
                [self.headerView.getPhotoCollection reloadData];
            }];
            [[FWHUDHelper sharedInstance] syncStopLoading];
        }
        
        [[FWHUDHelper sharedInstance] syncStopLoading];
        
    } FailureBlock:^(NSError *error) {
        
        [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
        [[FWHUDHelper sharedInstance] syncStopLoading];
        
    }];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    _uploadFilePath = fullPath;
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 返回上一级
- (void)returnToMeVc
{
    NSString * str;
    if (_isOTOShop )
    {
        if ([self.shopType isEqualToString:@"EditShopping"])
        {
            str = @"确定放弃修改商品信息？";
        }
        else if ([self.shopType isEqualToString:@"EntityShopping"])
        {
            str = @"确定放弃新增商品？";
        }
    }
    else
    {
        str = @"确定放弃新增竞拍商品？";
    }
    
    FWWeakify(self)
    [FanweMessage alert:nil message:str destructiveAction:^{
        
        FWStrongify(self)
#if kSupportAuction
        [self.navigationController setNavigationBarHidden:YES animated:YES];
#endif
        
#if kSupportH5Shopping
        
#endif
        [self popVC];
        
    } cancelAction:^{
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.shopType isEqualToString:@"VirtualShopping"])
    {
        return 5;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#pragma mark ---  虚拟商品返回分区行数
    if ([self.shopType isEqualToString:@"VirtualShopping"]) {
        switch (section) {
            case 0:
            {
                return 1;
            }
                break;
            case 1:
            {
                return 4;
            }
                break;
            case 2:
            {
                return 3;
            }
                break;
            case 3:
            {
                return 3;
            }
                break;
            case 4:
            {
                return 1;
            }
                break;
                
            default:
                break;
        }
        
    }
#pragma mark ---  实物竞拍返回分区行数
    else if([self.shopType isEqualToString:@"EntityAuctionShopping"])
    {
        switch (section) {
            case 0:
            {
                return 2;
            }
                break;
            case 1:
            {
                return 3;
            }
                break;
            default:
                break;
        }
    }
    //O2T
    else{
#pragma mark ---  实物商品返回分区行数
        switch (section) {
            case 0:
            {
                if (self.fanweApp.appModel.open_podcast_goods == 1 && _isOTOShop) {
                    return 3;
                }
                return 4;
            }
                break;
            case 1:
            {
                return 1;
            }
                break;
            default:
                break;
        }
    }
    return 0;
}
#pragma mark -- 返回区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.shopType isEqualToString:@"EntityAuctionShopping"])
    {
        return 0.1f;
    }
    else if (section == 0) {
        return 16.0f;
    }
    return 0.1f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark ---  虚拟商品返回cell
    if ([self.shopType isEqualToString:@"VirtualShopping"]) {//虚拟商品
        if (indexPath.section == 4) {
            //拍品描述
            CdescriptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"desCell" forIndexPath:indexPath];
            cell.desTextView.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.desTextView addSubview:self.placehoderLabel];
            return cell;
        }else if (indexPath.section == 3){
            
            NSArray *aTitle = @[@"竞拍时间",@"延时值",@"最大延时"];
            NSArray *timeN = @[@"小时",@"分钟",@"次"];
            TimeTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
            timeCell.textField.delegate = self;
            [timeCell.textField addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
            timeCell.nameLable.text = aTitle[indexPath.row];
            timeCell.twoLable.text = timeN[indexPath.row];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                timeCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                timeCell.textField.tag = 6;
                if (_fistTime) {
                    timeCell.textField.text = @"0.3";
                    _auctionTimeStr = timeCell.textField.text;
                    [self.shopDic setObject:timeCell.textField.text forKey:@"pai_time"];
                }
            }else if (indexPath.row == 1){
                timeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                timeCell.textField.tag = 7;
                if (_fistDelay) {
                    timeCell.textField.text = @"3";
                    _delayTimeStr = timeCell.textField.text;
                    [self.shopDic setObject:timeCell.textField.text forKey:@"pai_yanshi"];
                }
            }else{
                timeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                timeCell.textField.tag = 8;
                if (_fistMax) {
                    timeCell.textField.text = @"3";
                    _maxDelayTimeStr = timeCell.textField.text;
                    [self.shopDic setObject:timeCell.textField.text forKey:@"max_yanshi"];
                }
            }
            return timeCell;
        }else{
            BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.text_field.delegate = self;
            [cell.text_field addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
            if (indexPath.section == 0 ) {
                cell.nameL.text = @"拍品名称";
                cell.text_field.tag = 0;
                cell.text_field.placeholder = @"请输入拍品名称";
            }else if (indexPath.section == 1){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    cell.nameL.text = @"约会时间";
                    cell.text_field.text = @"2016年7月18日 18 : 00";
                    cell.text_field.enabled = NO;
                    cell.text_field.placeholder = @"点击选择约会时间";
                    cell.text_field.text = self.textData;
                }else{
                    NSArray *arr = @[@"约会地点",@"联系人",@"联系电话"];
                    NSArray *placeText = @[@"点击设置约会地点",@"预置主播昵称",@"预置主播手机号"];
                    cell.text_field.placeholder = placeText[indexPath.row - 1];
                    cell.nameL.text = arr[indexPath.row - 1];
//                    cell.text_field.clearsOnBeginEditing = YES;
                    if (indexPath.row == 1) {
                        cell.text_field.enabled = NO;
                        if (_keyWordStr != nil && ![_keyWordStr isEqualToString:@""]) {
                            cell.text_field.text = _keyWordStr;
                            [self.shopDic setObject:cell.text_field.text forKey:@"place"];
                        }else{
                            if (self.fanweApp.locateName != nil && ![self.fanweApp.locateName isEqualToString:@""]) {
                                cell.text_field.text =  [NSString stringWithFormat:@"%@",self.fanweApp.locateName];
                                [self.shopDic setObject:cell.text_field.text forKey:@"place"];
                            }else{
                                cell.text_field.text = @"定位中。。。" ;
                                //                            [FanweMessage alert:@"请在设置->隐私->定位服务->本App下选择使用期间"];
                            }
                            
                        }
                    }else if (indexPath.row == 2){
                        cell.text_field.tag = 1;
                    }else{
                        cell.text_field.tag = 2;
                        cell.text_field.keyboardType = UIKeyboardTypeNumberPad;
                    }
                }
            }else {
                //                    NSArray *placeText = @[@"请输入起拍价",@"请输入保证金额度",@"请输入加价幅度"];
                NSArray *titleArr = @[@"起拍价",@"保证金",@"加价幅度"];
                //                    cell.text_field.placeholder = placeText[indexPath.row];
                cell.nameL.text = titleArr[indexPath.row];
                if (indexPath.row == 0) {
                    cell.text_field.tag = 3;
                    cell.text_field.text = @"100";
                    _qpPriceStr = cell.text_field.text;
                    [self.shopDic setObject:cell.text_field.text forKey:@"qp_diamonds"];
                }else if (indexPath.row == 1){
                    cell.text_field.tag = 4;
                    cell.text_field.text = @"100";
                    _bzStr = cell.text_field.text;
                    [self.shopDic setObject:cell.text_field.text forKey:@"bz_diamonds"];
                }else{
                    cell.text_field.tag = 5;
                    cell.text_field.text = @"30";
                    _addPriceStr = cell.text_field.text;
                    [self.shopDic setObject:cell.text_field.text forKey:@"jj_diamonds"];
                }
                cell.text_field.keyboardType = UIKeyboardTypeNumberPad;
                
            }
            
            return cell;
        }
    }
    else if ([self.shopType isEqualToString:@"EntityAuctionShopping"]) {
        if (indexPath.section==0) {
            BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.text_field.delegate = self;
            [cell.text_field addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
            //            NSArray *placeText = @[@"请输入保证金额度",@"请输入加价幅度"];
            NSArray *titleArr = @[@"保证金",@"加价幅度"];
            //            cell.text_field.placeholder = placeText[indexPath.row];
            cell.nameL.text = titleArr[indexPath.row];
            if (indexPath.row == 0) {
                cell.text_field.tag = 14;
                //                cell.text_field.placeholder = @"100";
                //                if ([cell.text_field.text isEqualToString:@""]) {
                //                    _bzStr = cell.text_field.placeholder;
                //                    [self.shopDic setObject:_bzStr forKey:@"bz_diamonds"];
                //                }
                if (self.entityAuctionModel.bz_diamonds != nil) {
                    cell.text_field.text = self.entityAuctionModel.bz_diamonds;
                    cell.text_field.enabled = NO;
                    if (![cell.text_field.text isEqualToString:@""]) {
                        _bzStr = cell.text_field.text;
                        [self.shopDic setObject:_bzStr forKey:@"bz_diamonds"];
                    }
                    
                }
            }else if (indexPath.row == 1){
                cell.text_field.tag = 15;
                //                cell.text_field.placeholder = @"30";
                //                if ([cell.text_field.text isEqualToString:@""]) {
                //                    _addPriceStr = cell.text_field.placeholder;
                //                    [self.shopDic setObject:_addPriceStr forKey:@"jj_diamonds"];
                //                }
                if (self.entityAuctionModel.jj_diamonds != nil) {
                    cell.text_field.text = self.entityAuctionModel.jj_diamonds;
                    cell.text_field.enabled = NO;
                    if (![cell.text_field.text isEqualToString:@""]) {
                        _addPriceStr = cell.text_field.text;
                        [self.shopDic setObject:_addPriceStr forKey:@"jj_diamonds"];
                    }
                }
            }
            cell.text_field.keyboardType = UIKeyboardTypeNumberPad;
            return cell;
        }
        else
        {
            NSArray *aTitle = @[@"竞拍时间",@"延时值",@"最大延时"];
            NSArray *timeN = @[@"小时",@"分钟",@"次"];
            TimeTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
            timeCell.textField.delegate = self;
            [timeCell.textField addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
            timeCell.nameLable.text = aTitle[indexPath.row];
            timeCell.twoLable.text = timeN[indexPath.row];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                timeCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                timeCell.textField.tag = 16;
                if (_fistTime) {
                    timeCell.textField.placeholder = @"0.3";
                    [self.shopDic setObject:timeCell.textField.placeholder forKey:@"pai_time"];
                }
                //                timeCell.textField.placeholder = @"1";
                if (self.entityAuctionModel.pai_time != nil) {
                    timeCell.textField.placeholder = self.entityAuctionModel.pai_time;
                    if(![timeCell.textField.placeholder isEqualToString:@""]){
                        _auctionTimeStr = timeCell.textField.placeholder;
                        [self.shopDic setObject:_auctionTimeStr forKey:@"pai_time"];
                    }
                }
            }else if (indexPath.row == 1){
                timeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                timeCell.textField.tag = 17;
                if (_fistDelay) {
                    
                    timeCell.textField.placeholder = @"3";
                    [self.shopDic setObject:timeCell.textField.placeholder forKey:@"pai_yanshi"];
                }
                //                timeCell.textField.placeholder = @"30";
                if (self.entityAuctionModel.pai_yanshi != nil) {
                    timeCell.textField.placeholder = self.entityAuctionModel.pai_yanshi;
                    if (![timeCell.textField.placeholder isEqualToString:@""]) {
                        _delayTimeStr = timeCell.textField.placeholder;
                        [self.shopDic setObject:_delayTimeStr forKey:@"pai_yanshi"];
                    }
                }
            }else{
                timeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                timeCell.textField.tag = 18;
                if (_fistMax) {
                    timeCell.textField.placeholder = @"3";
                    [self.shopDic setObject:timeCell.textField.placeholder forKey:@"max_yanshi"];
                }
                //                timeCell.textField.placeholder = @"3";
                if (self.entityAuctionModel.max_yanshi != nil) {
                    timeCell.textField.placeholder = self.entityAuctionModel.max_yanshi;
                    if (![timeCell.textField.placeholder isEqualToString:@""]) {
                        _maxDelayTimeStr = timeCell.textField.placeholder;
                        [self.shopDic setObject:_maxDelayTimeStr forKey:@"max_yanshi"];
                    }
                }
            }
            return timeCell;
        }
    }
    else{
#pragma mark ---  实体商品返回cell
        if (indexPath.section == 0) {
            BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.text_field.delegate = self;
            [cell.text_field addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
            NSArray *titleArr;
            if (self.fanweApp.appModel.open_podcast_goods == 1 && _isOTOShop) {
                titleArr = @[@"商品名称",@"商品价钱",@"商品链接"];
            }
            else
            {
                titleArr = @[@"商品名称",@"商品价钱",@"商品链接",@"快递费"];
            }
            if ([self.shopType isEqualToString:@"EditShopping"]){
                cell.nameL.text = titleArr[indexPath.row];
                cell.text_field.placeholder = self.editArr[indexPath.row];
                cell.text_field.text = self.editArr[indexPath.row];
            }else{
                NSArray *pholderArr = @[@"请输入商品名称",@"请输入商品价钱(最多两位小数)",@"请输入商品链接",@"请输入快递费"];
                cell.nameL.text = titleArr[indexPath.row];
                cell.text_field.placeholder = pholderArr[indexPath.row];
            }
            if (indexPath.row == 0) {
                cell.text_field.tag = 10;//商品名称
            }else if (indexPath.row == 1){
                cell.text_field.tag = 11;//商品价钱
                cell.text_field.keyboardType = UIKeyboardTypeDecimalPad;
            }else if (indexPath.row == 2){
                cell.text_field.tag = 12;//商品链接
                if ([self.shopType isEqualToString:@"EntityShopping"]) {
                    if (!_isOTOShop) {
                        cell.text_field.text = @"http://";
                    }
                }
                else if ([self.shopType isEqualToString:@"EditShopping"])
                {
                    cell.text_field.text = self.model.url;
                    _urlString = cell.text_field.text;
                }
            }else if (indexPath.row == 3){
                cell.text_field.keyboardType = UIKeyboardTypeDecimalPad;
                cell.text_field.tag = 13;//商品快递费
            }
            return cell;
        }else{
            //实体拍品描述
            CdescriptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"desCell" forIndexPath:indexPath];
            cell.shopCdescriptLable.text = @"商品描述";
            cell.desTextView.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([self.shopType isEqualToString:@"EditShopping"]){
                cell.desTextView.text = self.model.descrStr;
            }
            [cell.desTextView addSubview:self.placehoderLabel];
            return cell;
            
        }
    }
}

- (void)changeTextField:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
        {
            if (textField.text.length >= 30)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入小于30个字符的名称"];
                NSString *s = [textField.text substringToIndex:30];
                textField.text = s;
            }
            _nameStr = textField.text;
        }
            break;
        case 1:
        {
            _contactStr = textField.text;
        }
            break;
        case 2:
        {
            _mobileStr = textField.text;
        }
            break;
        case 3:
        {
            _qpPriceStr = textField.text;
        }
            break;
        case 4:
        {
            _bzStr = textField.text;
        }
            break;
        case 5:
        {
            _addPriceStr = textField.text;
        }
            break;
        case 6:
        {
            _auctionTimeStr = textField.text;
        }
            break;
        case 7:
        {
            _delayTimeStr = textField.text;
        }
            break;
        case 8:
        {
            _maxDelayTimeStr = textField.text;
        }
            break;
        case 9:
        {
            
        }
            break;
        case 10:
        {
            _nameStr = textField.text;
        }
            break;
        case 11:
        {
            _priceStr = textField.text;
        }
            break;
        case 12:
        {
            _urlStr = textField.text;
        }
            break;
        case 13:
        {
            _expressPriceStr = textField.text;
        }
            break;
        case 14:
        {
            _bzStr = textField.text;
        }
            break;
        case 15:
        {
            _addPriceStr = textField.text;
        }
            break;
        case 16:
        {
            _auctionTimeStr = textField.text;
        }
            break;
        case 17:
        {
            _delayTimeStr = textField.text;
        }
            break;
        case 18:
        {
            _maxDelayTimeStr = textField.text;
        }
            break;
        default:
            break;
    }
}

- (void)chooseAddress:(CLLocationCoordinate2D)location address:(NSString *)address andProvinceString:(NSString *)provinceString andCityString:(NSString *)cityString andAreaString:(NSString *)areaString
{
    self.keyWordStr = address;
    [self.releaseTabView reloadData];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _desStr = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length > 0) {
        _desStr = textView.text;
        if ([self.shopType isEqualToString:@"VirtualShopping"]) {
            [self.shopDic setObject:textView.text forKey:@"description"];
        }
        else{
            [self.entiShopDic setObject:textView.text forKey:@"description"];
            [self.editInfo setObject:textView.text forKey:@"description"];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
#pragma mark --- 虚拟商品输入框设置
    switch (textField.tag) {
        case 0:
        {
            if (textField.text.length >= 30)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入小于30个字符的名称"];
                NSString *s = [textField.text substringToIndex:30];
                textField.text = s;
            }
            [self.shopDic setObject:textField.text forKey:@"name"];
            _nameStr = textField.text;
        }
            break;
        case 1:
        {
            
            [self.shopDic setObject:textField.text forKey:@"contact"];
            _contactStr = textField.text;
        }
            break;
        case 2:
        {
            if (textField.text.length < 1)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入电话号码"];
                return;
            }
            
            if (![textField.text isTelephone]) {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入正确的电话号码"];
                return;
            }
            
            [self.shopDic setObject:textField.text forKey:@"mobile"];
            _mobileStr = textField.text;
        }
            break;
        case 3:
        {
            if (textField.text.length < 1 ||[textField.text integerValue]== 0)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"竞拍起拍价格不能为空或0"];
                return;
            }
            
            [self.shopDic setObject:textField.text forKey:@"qp_diamonds"];
            
            _qpPriceStr = textField.text;
        }
            break;
        case 4:
        {
            if (textField.text.length < 1||[textField.text integerValue]== 0)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"竞拍保证金不能为空或0"];
                return;
            }
            
            [self.shopDic setObject:textField.text forKey:@"bz_diamonds"];
            
            _bzStr = textField.text;
        }
            break;
        case 5:
        {
            if (textField.text.length < 1 || [textField.text integerValue]== 0)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"加价幅度不能为空或0"];
                return;
            }
            [self.shopDic setObject:textField.text forKey:@"jj_diamonds"];
            _addPriceStr = textField.text;
            
        }
            break;
        case 6:
        {
            _fistTime = NO;
            BOOL num = false ;
            if ([textField.text floatValue] >= 0.0) {
                num = YES;
            }
            if ([textField.text isEqualToString:@"0"] || [textField.text isEqualToString:@""] || num == false ||(textField.text.length  > 2 && [textField.text hasSuffix:@"."])||(textField.text.length  > 0 && [textField.text hasPrefix:@"."])) {
                textField.text =@"";
            }
            
            if (textField.text.floatValue < 24 && textField.text.floatValue >0) {
                
                [self.shopDic setObject:textField.text forKey:@"pai_time"];
            }else{
                textField.text =@"";
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入竞拍时间"];
            }
            _auctionTimeStr = textField.text;
        }
            break;
        case 7:
        {
            _fistDelay = NO;
            if ( [textField.text isEqualToString:@""] || ([textField.text integerValue] == 0 && textField.text.length > 1) ||(textField.text.length > 1 && [textField.text hasPrefix: @"0"])) {
                textField.text =@"";
            }
            
            if (textField.text.integerValue < 60 && textField.text.integerValue >0) {
                
                [self.shopDic setObject:textField.text forKey:@"pai_yanshi"];
                
            }else{
                textField.text =@"";
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入最大延时时间"];
            }
            _delayTimeStr = textField.text;
            
        }
            break;
        case 8:
        {
            _fistMax = NO;
            if ( [textField.text isEqualToString:@""] || ([textField.text integerValue] == 0 && textField.text.length > 1)
                || (textField.text.length  > 2 && [textField.text hasPrefix: @"0"])) {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"最大延时不超过9次合法字符"];
                textField.text =@"";
            }
            if (textField.text.integerValue < 10 && textField.text.integerValue >=0) {
                
                [self.shopDic setObject:textField.text forKey:@"max_yanshi"];
            }else{
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"最大延时不超过9次合法字符"];
                textField.text =@"";
            }
            _maxDelayTimeStr = textField.text;
        }
            break;
        case 10:
        {
            if (textField.text.length < 1)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入商品名称"];
                return;
            }
            if ([self.shopType isEqualToString:@"EditShopping"]){
                
                [self.editInfo setObject:textField.text forKey:@"name"];
            }else{
                
                [self.entiShopDic setObject:textField.text forKey:@"name"];
            }
            _nameStr = textField.text;
        }
            break;
        case 11:
        {
            if (textField.text.length < 1)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入商品价格"];
                _priceStr = @"";
                return;
            }
            NSString *priceRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
            NSPredicate *priceTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",priceRegex];
            if (![priceTest evaluateWithObject:textField.text]) {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请保证输入的商品价格小数点最多两位"];
                return;
            }
            if ([self.shopType isEqualToString:@"EditShopping"]){
                
                [self.editInfo setObject:textField.text forKey:@"price"];
            }else{
                
                [self.entiShopDic setObject:textField.text forKey:@"price"];
            }
            _priceStr = textField.text;
        }
            break;
        case 12:
        {
            if ([self.shopType isEqualToString:@"EditShopping"]){
                [self.editInfo setObject:textField.text forKey:@"url"];
            }else{
                [self.entiShopDic setObject:textField.text forKey:@"url"];
            }
            _urlStr = textField.text;
        }
            break;
        case 13:
        {
            if (self.fanweApp.appModel.open_podcast_goods == 1 && _isOTOShop) {
                return;
            }
            _expressPriceStr = textField.text;
            if (textField.text.length < 1)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入快递费"];
                return;
            }
            if ([self.shopType isEqualToString:@"EditShopping"]){
                
                [self.editInfo setObject:textField.text forKey:@"kd_cost"];
            }else{
                
                [self.entiShopDic setObject:textField.text forKey:@"kd_cost"];
            }
            _expressPriceStr = textField.text;
        }
            break;
        case 14:
        {
            if (textField.text.length < 1||[textField.text integerValue]== 0)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"竞拍保证金不能为空或0"];
                
                textField.text=@"";
            }
            else
            {
                [self.shopDic setObject:textField.text forKey:@"bz_diamonds"];
            }
            _bzStr = textField.text;
        }
            break;
        case 15:
        {
            if (textField.text.length < 1 || [textField.text integerValue]== 0)
            {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"加价幅度不能为空或0"];
                textField.text=@"";
            }
            else
            {
                [self.shopDic setObject:textField.text forKey:@"jj_diamonds"];
            }
            _addPriceStr = textField.text;
        }
            break;
        case 16:
        {
            BOOL num = false ;
            if ([textField.text floatValue] >= 0.0) {
                num = YES;
            }
            if ([textField.text isEqualToString:@"0"] || [textField.text isEqualToString:@""] || num == false ||(textField.text.length  > 2 && [textField.text hasSuffix:@"."])||(textField.text.length  > 0 && [textField.text hasPrefix:@"."])) {
                //[[FWHUDHelper sharedInstance] tipMessage:@"请输入小于24的合法字符"];
                textField.text =@"";
            }
            
            if (textField.text.floatValue < 24 && textField.text.floatValue >0) {
                
                [self.shopDic setObject:textField.text forKey:@"pai_time"];
            }else{
                [self.view endEditing:YES];
                textField.text =@"";
                //[[FWHUDHelper sharedInstance] tipMessage:@"请输入小于24的合法字符"];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入竞拍时间"];
            }
            _auctionTimeStr = textField.text;
        }
            break;
        case 17:
        {
            if ( [textField.text isEqualToString:@""] || ([textField.text integerValue] == 0 && textField.text.length > 1) ||(textField.text.length > 1 && [textField.text hasPrefix: @"0"])) {
                //[[FWHUDHelper sharedInstance] tipMessage:@"请输入延时时间"];
                textField.text =@"";
            }
            
            if (textField.text.integerValue < 60 && textField.text.integerValue >0) {
                
                [self.shopDic setObject:textField.text forKey:@"pai_yanshi"];
            }else{
                [self.view endEditing:YES];
                textField.text =@"";
                //[[FWHUDHelper sharedInstance] tipMessage:@"请输入小于60的合法字符"];
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入延时时间"];
            }
            _delayTimeStr = textField.text;
        }
            break;
        case 18:
        {
            if ( [textField.text isEqualToString:@""] || ([textField.text integerValue] == 0 && textField.text.length > 1)
                || (textField.text.length  > 2 && [textField.text hasPrefix: @"0"])) {
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"最大延时不超过9次合法字符"];
                textField.text =@"";
            }
            if (textField.text.integerValue < 10 && textField.text.integerValue >=0) {
                
                [self.shopDic setObject:textField.text forKey:@"max_yanshi"];
            }else{
                [self.view endEditing:YES];
                [[FWHUDHelper sharedInstance] tipMessage:@"最大延时不超过9次合法字符"];
                textField.text =@"";
            }
            _maxDelayTimeStr = textField.text;
        }
            break;
        default:
            break;
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.placeholder = nil;
    if ([self.shopType isEqualToString:@"VirtualShopping"]) {
        
        [UIView animateWithDuration:0.5 animations:^{
//            dateView.frame = CGRectMake(0, kScreenH + 260, kScreenW, 260);
            self.dateView.frame = CGRectMake(0, kScreenH-64, kScreenW, kScreenH-64);
        } completion:^(BOOL finished) {
        }];
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.shopType isEqualToString:@"VirtualShopping"]) {
        
        [UIView animateWithDuration:0.5 animations:^{
//            dateView.frame = CGRectMake(0, kScreenH + 260, kScreenW, 260);
            self.dateView.frame = CGRectMake(0, kScreenH-64, kScreenW, kScreenH-64);
        } completion:^(BOOL finished) {
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 0) {
        NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger caninputlen = 30 - comcatstr.length;
        
        if (caninputlen >= 0)
        {
            return YES;
        }
        else
        {
            NSInteger len = string.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = [string substringWithRange:rg];
                
                [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
        
        
    }else if (textField.tag==2) {
        if (![string isNumber]) {
            return NO;
        }
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    else if (textField.tag == 3 || textField.tag == 4 || textField.tag == 5  || textField.tag == 11 || textField.tag == 13 || textField.tag == 14 || textField.tag == 15)
    {
        if (string.length == 0)
            return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        NSInteger number = 7;
        if (textField.tag == 4 || textField.tag == 5 || textField.tag == 13 || textField.tag == 14 || textField.tag == 15) {
            //设置竞拍保证金，加价幅度和快递费的最大金额限制
            number = 5;
        }
        if (existedLength - selectedLength + replaceLength >number) {
            [self.view endEditing:YES];
            [[FWHUDHelper sharedInstance] tipMessage:@"你输入的金额超过当前限制"];
            return NO;
        }
    }
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        self.placehoderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        self.placehoderLabel.hidden = NO;
    }
    
    if (self.fanweApp.appModel.open_podcast_goods == 1 && _isOTOShop)
    {
        if (text.length == 0)
        {
            return YES;
        }
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 25)
        {
            [self.view endEditing:YES];
            [[FWHUDHelper sharedInstance] tipMessage:@"商品描述不能超过25字"];
            return NO;
        }
    }
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField.tag==2) {
//        if (![string isNumber]) {
//            return NO;
//        }
//        if (string.length == 0)
//            return YES;
//
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 11) {
//            return NO;
//        }
//    }
//    return YES;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark --- 虚拟商品返回行高
    if ([self.shopType isEqualToString:@"VirtualShopping"]) {
        if (indexPath.section == 4) {
            return 150.0f;
        }else{
            return 44.0f;
        }
        
    }
    else if ([self.shopType isEqualToString:@"EntityAuctionShopping"])
    {
        return 44.0f;
    }
    else{
        
        if (indexPath.section == 0) {
            return 44.0f;
        }else{
            return 150.0f;
        }
    }
#pragma mark --- 实体商品返回行高
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.shopType isEqualToString:@"VirtualShopping"]) {
        //虚拟商品
#pragma mark --- 虚拟商品点击cell
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //日记日期
                [self.shopDic setObject:self.datePicker.timeLable.text forKey:@"date_time"];
                [UIView animateWithDuration:0.5 animations:^{
//                    dateView.frame = CGRectMake(0, kScreenH - 260, kScreenW, 260);
                    self.dateView.frame = CGRectMake(0, 0, kScreenW, kScreenH-64);
                } completion:^(BOOL finished) {
                    
                }];
                [self.view endEditing:YES];
            }else if (indexPath.row == 1){
                [self.view endEditing:YES];
                //腾讯地图
                MapViewController *mapVc = [[MapViewController alloc]init];
                mapVc.hidesBottomBarWhenPushed = YES;
                mapVc.fromType = 0;
                mapVc.delegate = self;
                [self.navigationController pushViewController:mapVc animated:YES];
            }
            
        }
}
    
}
#pragma mark -- 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
}
#pragma mark -- 创建日期/获取当前时间点
- (void)creatPickView{
    if (!self.dateView)
    {
//        dateView  = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenH + 260,kScreenW,260)];
//        dateView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:dateView];
        self.dateView  = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenH-64 ,kScreenW,kScreenH-64)];
        self.dateView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.view addSubview:self.dateView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.dateView addGestureRecognizer:tap];
        
        self.datePicker = [[[NSBundle mainBundle]loadNibNamed:@"DatePickerOfView" owner:self options:nil]lastObject];
        self.datePicker.frame = CGRectMake(0, kScreenH-260-64, kScreenW, 260);
        [self.dateView addSubview:self.datePicker];
        [self.datePicker.CBtn addTarget:self action:@selector(handleToSelectTime:) forControlEvents:UIControlEventTouchUpInside];
        [self.datePicker.Qbtn addTarget:self action:@selector(handleToSelectTime:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark -- 日历确定按钮点击事件
- (void)handleToSelectTime:(UIButton *)button
{
    if (button == self.datePicker.Qbtn)
    {
        self.textData = self.datePicker.timeLable.text;
        [self.shopDic setObject:self.textData forKey:@"date_time"];
    }
    self.dateView.frame = CGRectMake(0, kScreenH-64,kScreenW,kScreenH-64);
    [_releaseTabView reloadData];
}

- (void)tap
{
   self.dateView.frame = CGRectMake(0, kScreenH-64,kScreenW,kScreenH-64);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
