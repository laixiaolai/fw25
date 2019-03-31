//
//  AuctionItemdetailsViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AutionTableView)
{
   zeroSection,                         //竞拍状态的cell
   firstSection,                        //竞拍名称的cell
   secondSection,                       //竞拍信息的cell
   thirdSection,                        //约会信息的cell
   fourthSection,                       //竞拍记录的cell
   fifthSection,                        //竞拍前三名信息的cell
   sixthSection,                        //竞拍详情(实物竞拍和虚拟竞拍)的cell
   seventhSection,                      //交保证金
   autionTablevCount
};

@interface AuctionItemdetailsViewController : FWBaseViewController

@property (nonatomic, assign) int         type;                     // 判断是主播还是观众，0是观众，1是主播
@property (nonatomic, copy) NSString      *productId;               // 商品id
@property (nonatomic, assign) BOOL        isFromWebView;            // 是否来自webView
@property (nonatomic, assign) int         liveType;                 // 视频类型，对应枚举FW_LIVE_TYPE

@end
