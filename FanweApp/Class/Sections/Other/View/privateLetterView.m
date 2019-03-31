//
//  privateLetterView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "privateLetterView.h"

@interface privateLetterView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
}

@end

@implementation privateLetterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _dataArray = [[NSMutableArray alloc]init];
    self.goodFriendButton.frame = CGRectMake(kScreenW/2-60, 0, 60, 40);
    self.notConcernButton.frame = CGRectMake(kScreenW/2+60, 0, 60, 40);
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

- (IBAction)goodFriendClick:(UIButton *)sender
{
    
}
- (IBAction)notConcernClick:(UIButton *)sender
{
    
}
- (IBAction)notReadingClick:(UIButton *)sender
{
    
}

@end
