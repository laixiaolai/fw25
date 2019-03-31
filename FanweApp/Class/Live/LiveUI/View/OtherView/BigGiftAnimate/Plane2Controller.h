//
//  Plane2Controller.h
//  animatedemo
//
//  Created by 7yword on 16/7/11.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Plane2ControllerDelegate <NSObject>
@required

- (void)plane2AnimationFinished;

@end

@interface Plane2Controller : UIViewController<CAAnimationDelegate>

@property (nonatomic, weak) id<Plane2ControllerDelegate>    delegate;
@property (nonatomic, copy) NSString                        *senderNameStr;

@property (weak, nonatomic) IBOutlet UIView                 *contrainerView;
@property (weak, nonatomic) IBOutlet UILabel                *senderNameLabel;

@end

