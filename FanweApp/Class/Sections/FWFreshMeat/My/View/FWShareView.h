//
//  FWShareView.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol shareDeleGate <NSObject>

//点击分享
- (void)clickShareImgViewWithTag:(int)tag;
@end

@interface FWShareView : UIView
@property (nonatomic,weak)id<shareDeleGate>    SDeleGate;
@property (nonatomic,strong)GlobalVariables    *fanweApp;
@property (nonatomic,strong)NSMutableArray     *shareArray;   //装分享的数组
@property (nonatomic,strong)UIView             *buttomView;   //分享的底部白色view
@property (nonatomic,strong)UILabel            *shareLabel;   //分享的label

-(id)initWithFrame:(CGRect)frame Delegate:(id<shareDeleGate>)delegate;
@end
