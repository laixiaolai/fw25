//
//  FWZanCell.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;
@protocol ZanHeadImgDeleGate <NSObject>

- (void)ClickZanHeadImgViewWithTag:(int)tag;

@end

@interface FWZanCell : UITableViewCell

@property (nonatomic,weak)id<ZanHeadImgDeleGate>ZHIDeleGate;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (nonatomic,strong)UIView               *lineView;

- (void)creatCellWithModel:(CommentModel *)CModel andRow:(int)row;
@end
