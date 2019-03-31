//
//  MoreToolsView.m
//  FanweApp
//
//  Created by 王珂 on 17/4/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MoreToolsView.h"
#import "MoreToolsCell.h"

@interface MoreToolsView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    GlobalVariables *_fanweApp;
}
@property(nonatomic, strong) UIView * backGroundView;
@property(nonatomic, strong) NSMutableArray * toolsArray;
@property (nonatomic, strong) UICollectionView  *toolsCollectionView;

@end

@implementation MoreToolsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _fanweApp = [GlobalVariables sharedInstance];
        [self loadToolsArr];
        [self createToolCollection];
    }
    return self;
}

- (NSMutableArray *) toolsArray
{
    if (_toolsArray == nil)
    {
        _toolsArray = [NSMutableArray array];
    }
    return _toolsArray;
}

- (void)loadToolsArr
{
    [self.toolsArray removeAllObjects];
    if ([_fanweApp.appModel.shopping_goods integerValue]== 1)
    {
        ToolsModel * model = [[ToolsModel alloc] init];
        model.imageStr = @"lr_starShop_normal";
        model.selectedImageStr = @"lr_starShop_selected";
        model.title = @"星店";
        [self.toolsArray addObject:model];
    }
    if (_fanweApp.appModel.open_podcast_goods == 1)
    {
        ToolsModel * model = [[ToolsModel alloc] init];
        model.imageStr = @"lr_myShop_normal";
        model.selectedImageStr = @"lr_myShop_selected";
        model.title = @"小店";
        [self.toolsArray addObject:model];
    }
}

- (void)createToolCollection
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.width, kScreenH-120)];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-120-kDefaultMargin, self.width, 120)];
    self.backGroundView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.2];
    self.backGroundView.alpha = 0.5;
    [self addSubview:_backGroundView];
    self.backGroundView.layer.cornerRadius = kCornerRadius;
    self.backGroundView.layer.masksToBounds = YES;
    //毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0,kScreenH-120-kDefaultMargin, self.width, 120);
    [self addSubview:effectView];
    effectView.layer.cornerRadius = kCornerRadius;
    effectView.layer.masksToBounds = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(74, 110);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _toolsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenH-120-kDefaultMargin, self.width, 120) collectionViewLayout:layout];
    _toolsCollectionView.backgroundColor = [UIColor clearColor];
    _toolsCollectionView.delegate = self;
    _toolsCollectionView.dataSource = self;
    _toolsCollectionView.showsHorizontalScrollIndicator = NO;   //关闭滚动线
    _toolsCollectionView.alwaysBounceHorizontal = YES;          //总是允许横向滚动
    [_toolsCollectionView registerNib:[UINib nibWithNibName:@"MoreToolsCell" bundle:nil] forCellWithReuseIdentifier:@"MoreToolsCell"];
    [self addSubview:_toolsCollectionView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenView)];
    [view addGestureRecognizer:tap];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.toolsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreToolsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreToolsCell" forIndexPath:indexPath];
    cell.model = self.toolsArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolsModel * model = self.toolsArray[indexPath.item];
    self.title = model.title;
    [self collectionView:_toolsCollectionView didHighlightItemAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(clickMoreToolsView:andToolsModel:)])
    {
        [_delegate clickMoreToolsView:self andToolsModel:model];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self collectionView:_toolsCollectionView didUnhighlightItemAtIndexPath:indexPath];
    }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreToolsCell * cell = (MoreToolsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ToolsModel * model = self.toolsArray[indexPath.item];
    cell.toolsImageView.image = [UIImage imageNamed:model.selectedImageStr];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreToolsCell * cell = (MoreToolsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ToolsModel * model = self.toolsArray[indexPath.item];
    cell.toolsImageView.image = [UIImage imageNamed:model.imageStr];
}

- (void)hidenView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(clickCancleWithMoreToolsView:)])
        {
            [_delegate clickCancleWithMoreToolsView:self];
        }
    }];
}

@end
