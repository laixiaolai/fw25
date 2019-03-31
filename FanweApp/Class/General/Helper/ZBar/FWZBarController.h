//
//  FWZBarController.h
//  managemall
//
//  Created by GuoMS on 14-8-9.
//  Copyright (c) 2014年 GuoMs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@protocol FWZBarControllerDelegate <NSObject>
@optional

- (void)getQRCodeResult:(NSString *)qr_result;

@end

@interface FWZBarController : FWBaseViewController <ZBarReaderViewDelegate>

@property (nonatomic, weak) id<FWZBarControllerDelegate>delegate;

@property (strong, nonatomic)  UIImageView *imagefr;
@property (strong, nonatomic) ZBarReaderView *readerView;
@property (strong, nonatomic) UIView *readLine;
@property (strong, nonatomic) UIView *bottom;
@property (strong, nonatomic) UIView *top;
@property (strong, nonatomic) UIView *right;
@property (strong, nonatomic) UIView *left;

@end
