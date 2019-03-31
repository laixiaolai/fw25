//
//  STTablePhotoCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
#import "STCollectionPhotoFlowLayout.h"
@class STTablePhotoCell;
#pragma mark - Transition Type
typedef NS_ENUM(NSUInteger, STTablePhotoCellType) {
    STTablePhotoDefault         = 0,  // 默认格式  就是一个+ 而已
    STTablePhotoDelete          = 1,  // 有个cell有一个+图标  其余右上角有删除标志
    STTablePhotoUnSelected      = 2,  //
    STTablePhotoSelectCover     = 3,  // 选择封面
    STTablePhotoShow            = 4,  // 正常显示数据源里照片
};
@protocol STTablePhotoCellDelegate <NSObject>
@optional
-(void)showSTTablePhotoCell:(STTablePhotoCell *)stTablePhotoCell;
-(void)showSTTablePhotoCell:(STTablePhotoCell *)stTablePhotoCell andDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface STTablePhotoCell : STTableBaseCell <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic ) IBOutlet UICollectionView   *collectionView;
@property (nonatomic,strong) NSMutableArray              *dataSoureMArray;
@property (nonatomic,strong) STCollectionPhotoFlowLayout *layout;
@property (nonatomic,weak  ) id<STTablePhotoCellDelegate>delegate;
@property (nonatomic,assign) STTablePhotoCellType        stTablePhotoCellType;
@property (weak, nonatomic) IBOutlet UIView              *separatorView;
@property(nonatomic,strong)NSMutableArray                *selectedMArray;
@property(nonatomic,assign)NSInteger                     recordIndexRow;
@end
