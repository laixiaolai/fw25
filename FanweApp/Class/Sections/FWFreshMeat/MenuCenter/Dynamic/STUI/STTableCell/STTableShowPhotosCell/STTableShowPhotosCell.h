//
//  STTableShowPhotosCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@class STTableShowPhotosCell;
@protocol STTableShowPhotosCellDelegate <NSObject>
@optional
-(void)showSTTableShowPhotosCell:(STTableShowPhotosCell *)stTableShowPhotosCell;
@end
@interface STTableShowPhotosCell : STTableBaseCell
@property (weak, nonatomic) IBOutlet UIView      *photoBgView;
@property (weak, nonatomic) IBOutlet UIButton    *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton    *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photosImgView;
@property (weak, nonatomic) IBOutlet UILabel     *promptLab;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property(strong,nonatomic) NSMutableArray       *dataSoureArray;
@property(assign,nonatomic) int                  selectIndexNum;
@property(weak,nonatomic)id<STTableShowPhotosCellDelegate>delegate;
@end
