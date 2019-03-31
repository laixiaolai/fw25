//
//  HeaderView.h
//  FanweApp
//
//  Created by GuoMs on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h"

@protocol AddPhotoDelegate <NSObject>

- (void)handleToTapPhoto:(UITapGestureRecognizer * )tap;
- (void)handleWithGoodsTag:(NSString *)goodsTag;

@end


@interface HeaderView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,weak)id <AddPhotoDelegate> delegate;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *cellcount;
@property (strong, nonatomic) IBOutlet UICollectionView *getPhotoCollection;
@property (strong, nonatomic) IBOutlet UIScrollView *getPhotoScrollow;
@property (strong, nonatomic) IBOutlet UIScrollView *getBtnTypeScrollow;
@property (nonatomic, assign) BOOL  isOTOShop;
@property (nonatomic, strong) NSArray * tagsArr;//标签数组
@property (nonatomic, strong) UICollectionView * tagsCollectionView;
- (void)getPicturearr:(NSMutableArray *)arr block:(void (^)())block;

@end
