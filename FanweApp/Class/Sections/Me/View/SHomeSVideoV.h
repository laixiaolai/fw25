//
//  SHomeSVideoV.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHomeSVideoV;
@protocol videoDeleGate <NSObject>

- (void)pushToVideoDetailWithWeiboId:(NSString *)weiboId andView:(SHomeSVideoV *)homeSVideoV;

@end

@interface SHomeSVideoV : FWBaseView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property ( nonatomic,strong) UICollectionView                 *videoCollectionV;
@property ( nonatomic,strong) UICollectionViewFlowLayout       *myCollectionLayout;
@property ( nonatomic,strong) NSMutableArray                   *dataArray;
@property ( nonatomic,assign) int                              currentPage;
@property ( nonatomic,assign) int                              has_next;
@property ( nonatomic,copy) NSString                           *user_id;
@property ( nonatomic,weak) id<videoDeleGate>                  VDelegate;

- (instancetype)initWithFrame:(CGRect)frame andUserId:(NSString *)userId;

@end
