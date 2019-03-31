//
//  STBMKView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBMKView.h"
@implementation STBMKView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self registerCell];
}
-(void)setDelegate:(id<STBMKViewDelegate>)delegate{
    _delegate = delegate;
}
-(void)registerCell{
    //文本cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableDoubleLabCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableDoubleLabCell"];
    //含有搜索Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableSearchCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableSearchCell"];
    //STTableLeftRightLabCell  只用左侧部分，lab
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableLeftRightLabCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableLeftRightLabCell"];
}
#pragma mark--- row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return  self.dataSoureMArray.count;
    }
    return 0;
}
#pragma mark -- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //0 区  显示 搜搜
    if (indexPath.section == 0) {
        STTableSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableSearchCell"
                                                                  forIndexPath:indexPath];
        [cell setDelegate:self];
        cell.tableView = self.tableView;
        return cell;
    }
    //1 区
    if(indexPath.section == 1){
        STTableLeftRightLabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableLeftRightLabCell"
                                                                        forIndexPath:indexPath];
        cell.leftLab.hidden  = NO;
        cell.rightLab.hidden = YES;
        cell.separatorView.hidden = NO;
        cell.separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (indexPath.row == 0) {
            cell.leftLab.text = @"不显示";
        }else{
            cell.leftLab.text = [STBMKCenter shareManager].cityNameStr;
        }
        [cell.leftLab setFont:[UIFont systemFontOfSize:18]];
        [cell.leftLab setTextColor:[UIColor blackColor]];
        return cell;
        
        
    }
    
    if(indexPath.section == 2){
        BMKPoiInfo *bmkPoiInfo = self.dataSoureMArray[indexPath.row];
        STTableDoubleLabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableDoubleLabCell"
                                                                     forIndexPath:indexPath];
        cell.topLab.text = bmkPoiInfo.name;
        cell.topLab.hidden = NO;
        cell.bottomLab.text = bmkPoiInfo.address;
        cell.bottomLab.hidden = NO;
        cell.separatorView.hidden = NO;
        cell.separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return cell;
    }
    
    return nil;
}
#pragma mark ----- height For Row
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 40;
    }
    return 50;
}
#pragma mark ----- section Num
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma ************************** Deleagte协议方法 区域 *********************
#pragma mark ----------------- <STTableSearchCellDeleagte>
#pragma mark ----- 拿到cell
-(void)showSTTableSearchCell:(STTableSearchCell *)stTableSearchCell{
    STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
    [[FWHUDHelper sharedInstance]syncLoading];
    __weak typeof(self)weak_Self = self;
    [stBMKCenter showSearchByKeyWords:stTableSearchCell.secrchBar.text
                             latitude:stBMKCenter.latitudeValue
                            longitude:stBMKCenter.longitudeValue
                          andComplete:^(BMKPoiSearch *search,
                                        BMKPoiResult *poiResult,
                                        BMKSearchErrorCode error) {
                              [[FWHUDHelper sharedInstance]syncStopLoading];
                              
                              if(poiResult.poiInfoList.count>0){
                                  for (BMKPoiInfo *info in poiResult.poiInfoList) {
                                      NSLog(@"info.name ===  %@",info.name);
                                      NSLog(@"info.name ===  %@",info.address);
                                  }
                                  weak_Self.dataSoureMArray = poiResult.poiInfoList.mutableCopy;
                                  stTableSearchCell.secrchBar.text=@"";
                                  [weak_Self.tableView reloadData];
                              }else{
                                  [[FWHUDHelper sharedInstance]tipMessage:@"输入恰当的关键字"];
                              }
                              
                          }];
}
@end
