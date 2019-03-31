//
//  STTableDoubleLabCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTableDoubleLabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet UIView  *separatorView;

@end
