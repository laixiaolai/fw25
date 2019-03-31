//
//  STTableSearchCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableSearchCell.h"

@implementation STTableSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.secrchBar.tintColor = kAppMainColor;
    self.secrchBar.delegate = self;
}

//当搜索框开始编辑时候调用
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //影藏 searchBar
    [searchBar setShowsCancelButton:YES
                           animated:YES];
    //tableView 设置
    self.tableView.allowsSelection=NO;
    self.tableView.scrollEnabled=NO;
}
//当搜索框将要将要结束使用时调用
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    //tableView 设置
    self.tableView.allowsSelection= YES;
    self.tableView.scrollEnabled= YES;
    return YES;
}

//当搜索框结束编辑时候调用
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

//当field里面内容改变时候就开始掉用
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

//在field里面输入时掉用，询问是否允许输入，yes表示允许，默认为yes，否则无法输入
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"shouldChange");
    return YES;
}
//点击CancelButton调用
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //清空
    searchBar.text = @"";
    //显示取消 按钮
        [searchBar setShowsCancelButton:NO
                               animated:YES];
    // 退出编辑
      [searchBar resignFirstResponder];
    //tableView 设置
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    
}
//关键字搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
       //显示取消 按钮
     [searchBar setShowsCancelButton:NO
                            animated:YES];
    // 退出编辑
    [searchBar resignFirstResponder];
    //tableView 设置
    self.tableView.allowsSelection= YES;
    self.tableView.scrollEnabled= YES;
    if (_delegate &&[_delegate respondsToSelector:@selector(showSTTableSearchCell:)]) {
        [_delegate showSTTableSearchCell:self];
    }
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
