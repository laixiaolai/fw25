//
//  ToolsView.h
//  FanweApp
//
//  Created by yy on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolsCollectionViewCell.h"
#import "PluginToolsModel.h"

@class ToolsView;

@protocol ToolsViewDelegate <NSObject>
@required

- (void)selectToolsItemWith:(ToolsView *)toolsView selectIndex:(NSInteger)index isSelected:(BOOL)isSelected;

@end

@protocol ToolsViewDelegate2 <NSObject>
@required

//关闭插件中心
- (void)closeSelfView:(ToolsView *)toolsView;

@end

@interface ToolsView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    GlobalVariables *_fanweApp;
}

@property (nonatomic, weak) id<ToolsViewDelegate> toSDKdelegate;
@property (nonatomic, weak) id<ToolsViewDelegate2> toPCVdelegate;

@property (nonatomic, strong) UICollectionView  *toolsCollectionView;
@property (nonatomic, strong) NSMutableArray    *toolsSelArray;         // 选中工具图片列表
@property (nonatomic, strong) NSMutableArray    *toolsUnselArray;       // 未选中工具图片列表
@property (nonatomic, strong) NSMutableArray    *toolsNameArray;        // 工具名称列表
@property (nonatomic, strong) NSMutableArray    *cellArray;             // 保存cell的数组
@property (nonatomic, assign) BOOL              isRearCamera;           // 是否后置摄像头
@property (nonatomic, assign) BOOL              isClick;                // 可否点击闪光灯
@property (nonatomic, assign) BOOL              isOpenMirror;           // 是否开启镜像

@end
