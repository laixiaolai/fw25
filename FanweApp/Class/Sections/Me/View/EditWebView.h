//
//  EditWebView.h
//  FanweApp
//
//  Created by yy on 16/9/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditWebViewDelegate <NSObject>

- (void)viewDown:(UIButton *)sender;

@end

@interface EditWebView : UIView

@property (nonatomic, weak) id<EditWebViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

+ (instancetype)EditNibFromXib;

@end
