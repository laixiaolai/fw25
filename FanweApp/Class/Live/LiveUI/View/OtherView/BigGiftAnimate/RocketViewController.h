//
//  RocketViewController.h
//  animatedemo
//
//  Created by 7yword on 16/7/13.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RocketViewControllerDelegate <NSObject>
@required

- (void)rocketAnimationFinished;

@end


@interface RocketViewController : UIViewController<CAAnimationDelegate>

@property (nonatomic, weak) id<RocketViewControllerDelegate>    delegate;
@property (nonatomic, copy) NSString                            *senderNameStr;
@property (weak, nonatomic) IBOutlet UILabel                    *senderNameLabel;

@end
