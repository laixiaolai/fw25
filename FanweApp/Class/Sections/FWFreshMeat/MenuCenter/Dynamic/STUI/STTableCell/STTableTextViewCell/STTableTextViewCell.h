//
//  STTableTextViewCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@class STTableTextViewCell;
#define MAX_LIMIT_NUMS 100

@protocol STTableTextViewCellDeleagte <NSObject>
@optional
-(void)showSTTableTextViewCell:(STTableTextViewCell*)stTableTextViewCell;
@end
@interface STTableTextViewCell : STTableBaseCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;  //
@property (weak, nonatomic) IBOutlet UILabel    *showWordsNumLab; // 显示可输入字数
@property (weak, nonatomic) IBOutlet UIView     *separatorView;
@property(weak,nonatomic)id<STTableTextViewCellDeleagte>delegate;
@end
