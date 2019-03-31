//
//  STTableShowPhotosCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableShowPhotosCell.h"
#import "UIImage+STCommon.h"
@implementation STTableShowPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _selectIndexNum = 0;
    self.photoBgView.layer.borderWidth = 2;
    self.photoBgView.layer.borderColor = [kAppMainColor CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changePhotoShowClick:(UIButton *)sender {
    if (sender.tag == 1) {
        _selectIndexNum--;
        if (_selectIndexNum<0) {
            _selectIndexNum = 0;
            sender.hidden = YES;
        }
    }else{
        _selectIndexNum++;
        if (_selectIndexNum+1>_dataSoureArray.count) {
            _selectIndexNum = (int)_dataSoureArray.count-1;
            sender.hidden = YES;
        }
    }
    if (_selectIndexNum<_dataSoureArray.count-1) {
        [self.photosImgView setImage:[UIImage boxblurImage:_dataSoureArray[_selectIndexNum] withBlurNumber:1]];
        [self.photosImgView setNeedsDisplay];
    }
    
    if (_dataSoureArray.count>1) {
        if (_selectIndexNum == 0) {
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
        }
        if (_selectIndexNum == _dataSoureArray.count-1) {
            _leftBtn.hidden = NO;
            _rightBtn.hidden = YES;
        }
    }
    //主要修改 导航上那个 不爽的设计！
    if (_delegate &&[_delegate respondsToSelector:@selector(showSTTableShowPhotosCell:)]) {
        [_delegate showSTTableShowPhotosCell:self];
    }
}
-(void)setDelegate:(id<STTableShowPhotosCellDelegate>)delegate{
    _delegate = delegate;
}
@end
