//
//  STCollectionPhotoFlowLayout.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STCollectionPhotoFlowLayout.h"

@implementation STCollectionPhotoFlowLayout
//因为每次重新给出layout时都会调用prepareLayout，这样在以后如果有collectionView大小变化的需求时也可以自动适应变化
- (void)prepareLayout
{
    [super prepareLayout];
    [self setupLayout];
}
- (void)setupLayout
{
    
    //    CGFloat inset  = self.collectionView.bounds.size.width * (6/64.0f);
    //    inset = floor(inset);
    //
    //    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width - (2 *inset), self.collectionView.bounds.size.height * 3/4);
    //    self.sectionInset = UIEdgeInsetsMake(0,inset, 0,inset);
    //滚动方向
    //self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if(_numberItem == 0){
        _numberItem = 3;
    }
    if (_numberItem == 3) {
        // 设置大小
        self.itemSize =CGSizeMake((kScreenW-4*10)/3,(kScreenW-4*10)/3);
        self.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        self.minimumInteritemSpacing=1;
    }
    
    //4个
    self.itemSize =CGSizeMake((kScreenW-_numberItem*10-10)/_numberItem,(kScreenW-_numberItem*10-10)/_numberItem);
    self.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    
}
@end
