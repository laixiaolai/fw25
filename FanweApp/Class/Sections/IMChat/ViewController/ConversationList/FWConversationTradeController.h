//
//  FWConversationTradeController.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

@interface FWConversationTradeController : FWBaseViewController

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *conversationArr;

@property (nonatomic, strong) NSMutableArray *flagArr;

@property (nonatomic, assign) BOOL isHaveLive; //只有一半的情况

- (void)updateTableViewFrame;

@end
