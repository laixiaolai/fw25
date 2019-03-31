//
//  baseNav.m
//  switchPicChat
//
//  Created by zzl on 16/4/26.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import "baseNav.h"

@interface baseNav ()

@end

@implementation baseNav

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint* h = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64.0f];
    [self.view addConstraint:h];
}

@end
