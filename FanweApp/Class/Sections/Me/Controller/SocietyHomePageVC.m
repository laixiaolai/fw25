//
//  SocietyHomePageVC.m
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SocietyHomePageVC.h"
#import "SociatyHomePageCell.h"

@interface SocietyHomePageVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *societyHPCollectionView;
@property (nonatomic, strong) NSMutableArray *sociatyListArray;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int has_next;

@end

static NSString *const societyHPFlag = @"societyHomePage";

@implementation SocietyHomePageVC

- (NSMutableArray *)sociatyListArray
{
    if (!_sociatyListArray)
    {
        _sociatyListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _sociatyListArray;
}

- (void)initFWUI
{
    [super initFWUI];
    CGFloat width = (kScreenW - betButtonInterval) / 2.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = betButtonInterval;
    layout.minimumLineSpacing = 5;
    self.societyHPCollectionView = [[UICollectionView alloc] initWithFrame:self.societyFrame collectionViewLayout:layout];
    self.societyHPCollectionView.backgroundColor = kAppGrayColor8;
    self.societyHPCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.societyHPCollectionView];
    self.societyHPCollectionView.delegate = self;
    self.societyHPCollectionView.dataSource = self;
    
    [self.societyHPCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SociatyHomePageCell class]) bundle:nil] forCellWithReuseIdentifier:societyHPFlag];
    [FWMJRefreshManager refresh:self.societyHPCollectionView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
}

- (void)refreshHeader
{
    [self loadDataWithPage:1];
}

- (void)refreshFooter
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadDataWithPage:_currentPage];
    }
    else
    {
        [self.societyHPCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark -------------------------------------  加载数据  ------------------------------------------
- (void)loadDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"society" forKey:@"act"];
    [parmDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (page == 1)
            {
                [self hideNoContentView];
                [self.sociatyListArray removeAllObjects];
            }
            NSDictionary *pageDict = responseJson[@"page"];
            NSArray *array = responseJson[@"list"];
            self.currentPage = [pageDict toInt:@"page"];
            self.has_next = [pageDict toInt:@"has_next"];
            for (NSDictionary *dict in array)
            {
                SociatyListModel *listModel = [SociatyListModel mj_objectWithKeyValues:dict];
                [self.sociatyListArray addObject:listModel];
            }
            if (!self.sociatyListArray.count)
            {
                [self showNoContentView];
            }
            
            [self.societyHPCollectionView reloadData];
            [FWMJRefreshManager endRefresh:self.societyHPCollectionView];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [FWMJRefreshManager endRefresh:self.societyHPCollectionView];
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sociatyListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SociatyHomePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:societyHPFlag forIndexPath:indexPath];
    SociatyListModel *listModel = self.sociatyListArray[indexPath.row];
    [cell.tianTuanImg sd_setImageWithURL:[NSURL URLWithString:listModel.society_image] placeholderImage:kDefaultPreloadImgSquare];
    cell.tianTuanNameLbl.text = listModel.society_name;
    cell.presidentLbl.text = [NSString stringWithFormat:@"会长：%@",listModel.society_chairman];
    cell.numberLbl.text = [NSString stringWithFormat:@"人数：%@",listModel.society_user_count];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SociatyListModel *listModel = self.sociatyListArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushSocietyDetail:)])
    {
        [self.delegate pushSocietyDetail:listModel];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(betButtonInterval, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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
