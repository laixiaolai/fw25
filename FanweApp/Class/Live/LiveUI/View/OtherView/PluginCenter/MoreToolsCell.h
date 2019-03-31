//
//  MoreToolsCell.h
//  FanweApp
//
//  Created by 王珂 on 17/4/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToolsModel;

@interface MoreToolsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *toolsImageView;
@property (weak, nonatomic) IBOutlet UILabel *toolsLabel;
@property (nonatomic, strong) ToolsModel * model;

@end
