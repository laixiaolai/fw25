//
//  FWReplyCell.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;

@protocol commentDeleGate <NSObject>
//点击cell的代理事件
- (void)commentNewsWithTag:(int)tag;
//点击回复的名字的点击事件
-(void)clickNameStringWithTag:(int)tag;
@end

@interface FWReplyCell : UITableViewCell
@property (nonatomic,weak)id<commentDeleGate>CDelegate;
@property (nonatomic,strong)UIImageView *headImgView;
@property (nonatomic,strong)UIImageView *iconImgView;
@property (nonatomic,strong)UILabel     *nameLabel;
@property (nonatomic,strong)UILabel     *replyLabel;
@property (nonatomic,strong)UILabel     *timeLabel;
@property (nonatomic,strong)UIButton    *nameBtn;
@property (nonatomic,strong)UIView      *lineView;
@property (nonatomic,strong)UIButton    *clearBtn;

- (CGFloat)creatCellWithModel:(CommentModel *)model andRow:(int)row;

@end
