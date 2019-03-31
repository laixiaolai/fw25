//
//  FWDynamicCell.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/15.
//  Copyright © 2017年 xfg. All rights reserved.  nameLabel
//

#import <UIKit/UIKit.h>
#import "PersonCenterListModel.h"

@class FWDynamicCell;
@protocol DynamicCellDelegate <NSObject>

- (void)onPressZanBtnOnDynamicCell:(FWDynamicCell *)cell andTag:(int)tag;
- (void)onPressImageView:(FWDynamicCell *)cell andTag:(int )tag;

@end

@interface FWDynamicCell : UITableViewCell<TTTAttributedLabelDelegate>

@property(nonatomic,strong)UIImageView *headView;

@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIView *bodyView;
@property(nonatomic,strong)UIView *zanBarView;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)UILabel *fromName;
@property(nonatomic,strong)PersonCenterListModel *data;

@property(nonatomic,strong)UIImageView *zanBtn;
@property(nonatomic,strong)UIImageView *replyBtn;
@property(nonatomic,strong)NSDictionary *dynamicPower;

@property(nonatomic,weak)id<DynamicCellDelegate> DDelegate;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *imgViewArray;

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *topView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *placeLabel;
@property(nonatomic,strong)UILabel *redbagLabel;
@property (nonatomic,assign)int row;

-(void)setData:(PersonCenterListModel *)data andRow:(int)row;
@end
