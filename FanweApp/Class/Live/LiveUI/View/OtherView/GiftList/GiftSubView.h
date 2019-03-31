//
//  GiftSubView.h
//  FanweApp
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftSubViewDelegate <NSObject>
@required

- (void)cateBtn:(int)indexTag;

@end

@interface GiftSubView : UIView

@property (nonatomic, weak) id<GiftSubViewDelegate>delegate;

@property (nonatomic, strong) UIButton              *bottomBtn;
@property (nonatomic, strong) FLAnimatedImageView   *imgView;
@property (nonatomic, strong) UIImageView           *diamondsImgView;
@property (nonatomic, strong) UILabel               *diamondsLabel;     //需要钻石数量
@property (nonatomic, strong) UILabel               *txtLabel;
@property (nonatomic, strong) UIImageView           *continueImgView;   //连

- (void)resetDiamondsFrame;

@end
