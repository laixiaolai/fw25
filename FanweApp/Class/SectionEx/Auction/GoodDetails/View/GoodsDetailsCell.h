//
//  GoodsDetailsCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/10/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol CellHeightDelegate <NSObject>

#pragma mark 通过这个方法来获取cell的高度

- (void)getCellHeightWithCount:(int)count;

@end

@interface GoodsDetailsCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, weak) id<CellHeightDelegate>delegate;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *downUpImgView;//向下或者向上的箭头
@property (nonatomic, strong) UIButton *clickButton;//收起或者展开的控件
@property (nonatomic, assign)int buttonCount;//cell改变高度的count
//@property (nonatomic, strong) UIWebView *cellWebView;//实物竞拍加载详情(有图片或者文字)
//@property (nonatomic, assign)float webViewHeight;//webView的高度
//@property (nonatomic, assign)int Height;//虚拟竞拍展开
//@property (nonatomic, strong) GlobalVariables *fanweApp;

//- (CGFloat)setCellWithString:(NSString *)string withTypeCount:(int)typeCount andButtonCount:(int)buttonCount;
//- (void)loadWebViewWithString:(NSString *)string;//实物竞拍的加载
- (void)setCellWitCount:(int)count;

@end
