//
//  GamelistCollectionViewCell.h
//  FanweApp
//
//  Created by yy on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"

@protocol gameCellDelegate <NSObject>

- (void)gameCellWithRow:(int)row;

@end

@interface GamelistCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<gameCellDelegate>gameDelegate;

@property (strong, nonatomic) IBOutlet UILabel *gamePlaying_L;//正在游戏中显示

@property (weak, nonatomic) IBOutlet UIImageView *gameImg;

@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (nonatomic, assign)int rowCount;

- (void)creatCellWithModel:(GameModel *)model withRow:(int)row;

@end
