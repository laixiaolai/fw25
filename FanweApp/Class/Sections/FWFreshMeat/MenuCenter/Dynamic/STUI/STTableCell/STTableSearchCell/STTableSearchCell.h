//
//  STTableSearchCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"
@class STTableSearchCell;
@protocol STTableSearchCellDelegate <NSObject>

@optional
//STTableSearchCel外传，解决cell自身m文件做不了的事
//关键字搜索，需要API
-(void)showSTTableSearchCell:(STTableSearchCell *)stTableSearchCell;
@end
@interface STTableSearchCell : STTableBaseCell <UISearchBarDelegate>
@property (strong,nonatomic) UITableView                 *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar         *secrchBar;
@property (weak, nonatomic) id<STTableSearchCellDelegate>delegate;
@end
