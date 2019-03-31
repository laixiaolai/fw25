//
//  OneSectionCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneSectionCell : UICollectionViewCell

@property (nonatomic, copy) void (^block) (int tag);

- (CGFloat)creatCellWithArray:(NSMutableArray *)array;
@end
