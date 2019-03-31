//
//  FerrariController.h
//  animatedemo
//
//  Created by 7yword on 16/7/13.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FerrariControllerDelegate <NSObject>
@required

- (void)ferrariAnimationFinished;

@end


@interface FerrariController : UIViewController<CAAnimationDelegate>

@property (nonatomic, weak) id<FerrariControllerDelegate> delegate;
@property (nonatomic, copy) NSString *senderNameStr1;
@property (nonatomic, copy) NSString *senderNameStr2;

@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel2;

@end
