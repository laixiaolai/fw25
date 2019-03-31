//
//  FiveSectionTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol acutionButtonDelegate <NSObject>

- (void)buttonClickWithTag:(int)tag;

@end

@interface FiveSectionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<acutionButtonDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *auctionLabel;
@property (weak, nonatomic) IBOutlet UIButton *depositButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *auctionMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goldView;

@end
