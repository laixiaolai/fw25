//
//  STTableTextCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableTextCell.h"

@implementation STTableTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _textField.delegate  =self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -delegate
-(void)setDelegate:(id<STTableTextCellDelegate>)delegate{
    _delegate = delegate;
}
#pragma mark - 开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //微信价格
    if (textField.tag == STTableTextTypeNum) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    //微信账号
    if (textField.tag == STTableTextTypeText ) {
        textField.keyboardType = UIKeyboardTypeDefault;
    }
    
}
#pragma mark - 结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(_delegate &&[_delegate respondsToSelector:@selector(showSTTableTextCell:)]){
        [_delegate showSTTableTextCell:self];
    }
}
#pragma mark -
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //
    if (textField.tag == 2) {
        
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if(textField.text.length>=4){
            textField.text = [textField.text substringToIndex:4];
            return NO;
        }
    }
    
    return YES;
}
 */
@end
