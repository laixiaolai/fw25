//
//  STCollectionBaseView.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseView.h"
@class STCollectionBaseView;
@protocol STCollectionBaseViewDelegate <NSObject>

@optional
-(void)showSTCollectionView:(STCollectionBaseView *)stCollectionView
          andCollectionView:(UICollectionView *)collectionView
   didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface STCollectionBaseView : STBaseView <UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray   *dataSourceMArray;
@property(nonatomic,weak)id<STCollectionBaseViewDelegate>baseDelegate;
#pragma mark ----- collectionView
-(UICollectionView *)showCollectionViewWithFrame:(CGRect)collectionRect andUICollectionViewFlowLayout:(UICollectionViewFlowLayout *)layout;
@end
