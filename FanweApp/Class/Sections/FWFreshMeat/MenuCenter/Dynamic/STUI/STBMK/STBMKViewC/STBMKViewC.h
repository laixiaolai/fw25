//
//  STBMKViewC.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseViewC.h"
#import "STBMKView.h"
#import "STSeachView.h"
@class STBMKViewC;
@protocol STBMKViewCDelegate <NSObject>

@optional
//给动态界面下发数据
-(void)showUpdateLoactionInfoOfIndexPath;

@end
@interface STBMKViewC : STBaseViewC              <STBMKViewDelegate,STTableViewBaseViewDelegate>
@property(nonatomic,strong)STBMKView              *stBMKView;
@property(nonatomic,strong)STSeachView            *stSeachView;
@property(nonatomic,strong)UIBarButtonItem        *rightBarButtonItem;
@property (nonatomic,weak) id<STBMKViewCDelegate> delegate;
@end
