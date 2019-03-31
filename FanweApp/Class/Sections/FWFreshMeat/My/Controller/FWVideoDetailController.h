//
//  FWVideoDetailController.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWVideoDetailController : FWBaseViewController

@property (nonatomic,strong)UITableView               *tableView;                   //tableView
@property (nonatomic,strong)NSMutableArray            *dataArray;                   //动态评论
@property (nonatomic,strong)NSMutableArray            *shareArray;                  //分享的数组
@property (nonatomic,copy)NSString                    *weibo_id;                    //用户id
@property (nonatomic,assign)int                       lastView;                     //上一个页面,通过这个来判断刷新上一个页面的点赞书，评论数，观看视频数 0代表个人中心这个页面 1代表推荐页面

@end
