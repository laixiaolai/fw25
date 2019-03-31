//
//  SFeeRecordV.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"

@interface SFeeRecordV : FWBaseView<UITableViewDelegate,UITableViewDataSource>

@property ( nonatomic,assign) int               myFeeType;                       //直播收费类型 0按时，1按场
@property ( nonatomic,assign) int               myRecordType;                    //0付费记录 1收费记录
@property ( nonatomic,assign) int               page;                            //页数
@property ( nonatomic,assign) int               has_next;                        //是否还有下一页
@property ( nonatomic,strong) UITableView       *listTableView;                  //tableView
@property ( nonatomic,strong) NSMutableArray    *dataArray;                      //数据源
@property ( nonatomic, strong)FWNoContentView   *noContentView;                  //没有数据时页面的图片提示

@property ( nonatomic,copy) void    (^feeRecordBlock)(NSString *userId);

- (instancetype)initWithFrame:(CGRect)frame andfeeType:(int)feeType andRecordType:(int)recordType;

@end
