//
//  SChooseAreaView.h
//  
//
//  Created by 丁凯 on 2017/8/21.


#import <UIKit/UIKit.h>

@interface SChooseAreaView : FWBaseView<UITableViewDelegate,UITableViewDataSource>

@property ( nonatomic, strong) NSMutableArray    *imageArray;        //性别头像
@property ( nonatomic, strong) NSMutableArray    *nameArray;         //性别
@property ( nonatomic, strong) UIButton          *bottomBtn;         //性别下面的黄色view
@property ( nonatomic, strong) NSMutableArray    *dataArray;         //数据源
@property ( nonatomic, strong) UITableView       *myTableView;       //tableView
@property ( nonatomic, assign) int               sexType;            //性别类型
@property ( nonatomic, assign) int               selectRow;          //选择的row
@property ( nonatomic, strong) UIButton          *finishBtn;         //完成
@property ( nonatomic, copy) NSString            *chooseAreaStr;     //选择的城市
//@property ( nonatomic, strong) FWNoContentView   *noContentView;     //无内容视图

@property ( nonatomic, copy) void (^areaBlock)(NSString *areStr, int sexType);

- (id)initWithFrame:(CGRect)frame andChooseType:(int)areaType andAreaStr:(NSString *)areaStr;

@end
