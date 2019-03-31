//
//  Plane1Controller.h
//  animatedemo
//
//  Created by 7yword on 16/7/11.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Plane1ControllerDelegate <NSObject>
@required

- (void)plane1AnimationFinished;

@end

@interface Plane1Controller : UIViewController<CAAnimationDelegate>

@property (nonatomic, weak) id<Plane1ControllerDelegate>    delegate;
@property (nonatomic, copy) NSString                        *senderNameStr;
@property (weak, nonatomic) IBOutlet UILabel                *senderNameLabel;

@end

