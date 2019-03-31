//
//  PlaybackTableViewCell.h
//  FanweApp
//
//  Created by GuoMs on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMHotItemModel;

@protocol playToMainDelegate <NSObject>

- (void)handleWithPlayBackMainPage:(UITapGestureRecognizer *)sender index:(NSInteger)tag;

@end

@interface PlaybackTableViewCell : UITableViewCell

@property (weak,   nonatomic) id <playToMainDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *userIMg;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UILabel *watchNamber;
@property (strong, nonatomic) IBOutlet UILabel *SayLable;//话题
@property (strong, nonatomic) IBOutlet UIImageView *levelImg;
@property (strong, nonatomic) IBOutlet UILabel *backPlay;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setValueForCell:(HMHotItemModel *)model index:(NSInteger)row;

@end
