//
//  STTableTextCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@class STTableTextCell;
typedef NS_ENUM(NSUInteger, STTableTextType) {
    STTableTextTypeDefault                  = 0,
    STTableTextTypeText                         = 1,  // 文本
    STTableTextTypeNum                          = 2,  // 数字
};
@protocol STTableTextCellDelegate <NSObject>

@optional
-(void)showSTTableTextCell:(STTableTextCell *)stTableTextCell;
@end
@interface STTableTextCell : STTableBaseCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView       *leftImgView;
@property (weak, nonatomic) IBOutlet UITextField       *textField;
@property (weak, nonatomic) IBOutlet UIView            *separatorView;
@property (weak, nonatomic)id<STTableTextCellDelegate> delegate;
@end
