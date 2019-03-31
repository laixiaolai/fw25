//
//  STTableBaseView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableBaseView.h"

@implementation STTableBaseView


-(NSMutableArray *)dataSoureMArray{
    if (!_dataSoureMArray) {
        _dataSoureMArray = @[].mutableCopy;
    }
    return _dataSoureMArray;
}
#pragma *************************** Getter ***************************

#pragma mark --- tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenW,kScreenH)
                                                 style:UITableViewStylePlain];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        //解决滑不到底部问题
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        [FWMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:nil];
//        [self showSTRefreshTableView:_tableView
//                    andSTRefreshType:STRefreshTypeDefault
//              andSTRefreshHeaderType:STRefreshHeaderTypeGif
//           andSTRefreshTimeLabHidden:YES
//          andSTRefreshStateLabHidden:YES];
    }
    return  _tableView;
}
#pragma *************************** Delegate ***************************
#pragma ----------------Delegate of <UITableViewDelegate>
#pragma ---- row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSoureMArray.count;
}
#pragma ---- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
#pragma ----------------Delegate of <UITableViewDataSource>
#pragma ---- rowHeight
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma ----section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma ----sectionHeaderView-Hight
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
#pragma ---sectionHeaderView-Color
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}
#pragma ---did Select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_baseDelegate &&[_baseDelegate respondsToSelector:@selector(showTableViewDidSelectIndexpath:andSTTableBaseView:)]) {
        [_baseDelegate showTableViewDidSelectIndexpath:indexPath
                                    andSTTableBaseView:self];
    }
}

- (void)headerReresh
{
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FWMJRefreshManager endRefresh:self.tableView];
    });
    
}


//#pragma mark ------- show Request API
//-(void)showAPIDataAndComplete:(void(^)(BOOL finished))block{
//    
//    [self.tableView reloadData];
//    // subview rewite
//    if ([_tableView.mj_header isRefreshing]) {
//        [_tableView.mj_header endRefreshing];
//    }
//    if ([_tableView.mj_footer isRefreshing]) {
//        [_tableView.mj_footer endRefreshing];
//    }
//}
//#pragma mark *******************Plublic Funcation 公有功能预设  ************************
//#pragma mark ------- STRefresh
//-(void)showSTRefreshTableView:(UITableView *)tableView
//             andSTRefreshType:(STRefreshType)stRefreshType
//       andSTRefreshHeaderType:(STRefreshHeaderType )stRefreshHeaderType
//    andSTRefreshTimeLabHidden:(BOOL)timeLabHidden
//   andSTRefreshStateLabHidden:(BOOL)stateLabHidden {
//    __weak typeof(self)weak_Self = self;
//    _stRefresh = [[STRefresh alloc]init];
//    [_stRefresh showSTRefreshTableView:tableView
//             andSTRefreshType:stRefreshType
//       andSTRefreshHeaderType:stRefreshHeaderType
//    andSTRefreshTimeLabHidden:timeLabHidden
//   andSTRefreshStateLabHidden:stateLabHidden
//             andDropDownBlock:^{
//                 weak_Self.hasNextPage = 1;
//                 [self showAPIDataAndComplete:^(BOOL finished) {
//                     [tableView.mj_header endRefreshing];
//                     [tableView.mj_footer endRefreshing];
//                 }];
//             }
//               andDropUpBlock:^{
//                   if (_hasNextPage == YES) {
//                       _recordCurrentPage++;
//                       [self showAPIDataAndComplete:^(BOOL finished) {
//                           if (finished) {
//                               
//                           }else{
//                               _recordCurrentPage--;
//                           }
//                           [tableView.mj_header endRefreshing];
//                           [tableView.mj_footer endRefreshing];
//                       }];
//                   }
//               }];
//}


@end
