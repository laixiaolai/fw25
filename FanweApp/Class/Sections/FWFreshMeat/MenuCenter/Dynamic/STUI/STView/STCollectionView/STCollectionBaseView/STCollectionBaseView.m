//
//  STCollectionBaseView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STCollectionBaseView.h"

@implementation STCollectionBaseView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self showSubView];
}

-(void)showSubView{
    _dataSourceMArray = @[].mutableCopy;
    [self collectionView];
}

#pragma mark --------------------------- delegate of collectionView----------------
#pragma mark - <UICollectionViewDataSource>
#pragma mark -行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceMArray.count;
}
#pragma mark -cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark -didSelect
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_baseDelegate &&[_baseDelegate respondsToSelector:@selector(showSTCollectionView:andCollectionView:didSelectItemAtIndexPath:)]) {
        [_baseDelegate showSTCollectionView:self andCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
}
#pragma mark ************************ Getter *************************
#pragma mark ----- collectionView

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView =[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        //_collectionView = [[UICollectionView alloc]initWithFrame:self.bounds];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
                           
#pragma mark ************************ Setter *************************
#pragma mark -----_baseDelegate
-(void)setBaseDelegate:(id<STCollectionBaseViewDelegate>)baseDelegate{
    _baseDelegate = baseDelegate;
}
#pragma mark -----_dataSourceMArray

@end
