//
//  choseMuiscVC.h
//  FanweApp
//
//  Created by zzl on 16/6/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "baseVC.h"

@interface choseMuiscVC : baseVC

@property (weak, nonatomic) IBOutlet UISearchBar *msearchbar;

@property (weak, nonatomic) IBOutlet UITableView *mtableview;//下载列表
@property (weak, nonatomic) IBOutlet UITableView *msearchtableview;//搜索列表
@property (weak, nonatomic) IBOutlet UITableView *mhistorytableview;//历史记录列表

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mtopconsth;


@property (nonatomic, strong)   void(^mitblock)(musiceModel* chosemusic);

/**
 加载新的 音乐选择

 @param superViewController 父控制器
 @param superView 父视图
 @param frame frame
 @param block 回调
 @return choseMuiscVC
 */
+ (choseMuiscVC *)showMuisChoseVCOnSuperVC:(UIViewController *)superViewController inSuperView:(UIView *)superView frame:(CGRect)frame completion:(void(^)(BOOL finished))block;

@end
