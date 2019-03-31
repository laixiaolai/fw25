//
//  STCollectionPhotoCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollectionPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectStateImgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectCoverImgView;
@property (nonatomic,assign) BOOL                isSelectedState; //选择了cell
@end
