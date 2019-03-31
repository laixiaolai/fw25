//
//  SelectBankerView.h
//  FanweApp
//
//  Created by yy on 17/2/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectBankerTableViewCell.h"
#import "GameBankerModel.h"
@protocol SelectBankerViewDelegate <NSObject>

- (void)selectBankerViewDown;

@end

@interface SelectBankerView : FWBaseView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<SelectBankerViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;       //标题
@property (weak, nonatomic) IBOutlet UITableView *tableView;    //tableView
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;    //取消
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;   //确认
@property (weak, nonatomic) IBOutlet UILabel *horLabel;         //横线
@property (weak, nonatomic) IBOutlet UILabel *verLabel;         //竖线
@property (nonatomic, copy) NSString *banker_log_id;            //上庄id
@property (nonatomic, strong) NSMutableArray * dataArray;

+ (instancetype)EditNibFromXib;

- (void)createStyle;

@end
