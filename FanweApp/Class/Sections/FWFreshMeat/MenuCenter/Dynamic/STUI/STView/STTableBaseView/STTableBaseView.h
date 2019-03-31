//
//  STTableBaseView.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseView.h"
#import "STNavView.h"
@class STTableBaseView;

@protocol STTableViewBaseViewDelegate <NSObject>
@optional
-(void)showTableViewDidSelectIndexpath:(NSIndexPath *)indexPath andSTTableBaseView:(STTableBaseView *)stTableBaseView;
@end

@interface STTableBaseView : STBaseView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView                    *tableView;
@property (nonatomic,strong)NSMutableArray                 *dataSoureMArray;
@property (nonatomic,assign) BOOL                          hasNextPage;
@property (nonatomic,assign) NSInteger                     recordCurrentPage;
@property (nonatomic,weak)  id<STTableViewBaseViewDelegate>baseDelegate;
@property(nonatomic,strong)STNavView *stNavView;   //custom stNavView
@property(nonatomic,strong)STRefresh *stRefresh;
//#pragma mark ------- STRefresh
//-(void)showSTRefreshTableView:(UITableView *)tableView
//             andSTRefreshType:(STRefreshType)stRefreshType
//       andSTRefreshHeaderType:(STRefreshHeaderType )stRefreshHeaderType
//    andSTRefreshTimeLabHidden:(BOOL)timeLabHidden
//   andSTRefreshStateLabHidden:(BOOL)stateLabHidden;
//#pragma mark ------- show Request API
//-(void)showAPIDataAndComplete:(void(^)(BOOL finished))block;
@end
