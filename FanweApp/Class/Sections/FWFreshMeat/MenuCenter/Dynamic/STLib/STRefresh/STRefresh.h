//
//  STRefresh.h
//  STImgPickerC
//
//  Created by 岳克奎 on 17/3/25.
//  Copyright © 2017年 SlienceTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@class STTableBaseView;
typedef NS_ENUM(NSInteger, STRefreshType) {
     STRefreshTypeDefault        = 0 ,     //default support Drop down and up
    STRefreshTypeDropDown        = 1 ,     //Only support the drop-down
    STRefreshTypeDropUp          = 2 ,     //Only support on the pull
   
};
typedef NS_ENUM(NSInteger, STRefreshHeaderType) {
    STRefreshHeaderTypeNormal    = 0 ,     //header Normal

    STRefreshHeaderTypeGif       = 1 ,     //header have Gif animation
    
};

@interface STRefresh : NSObject
@property (nonatomic ,strong) NSMutableArray            <UIImage *>*idleImgMArray;
@property (nonatomic ,strong) NSMutableArray            <UIImage *>*pullingImgMArray;
@property (nonatomic ,strong) NSMutableArray            <UIImage *>*refreshingImgMArray;
@property (nonatomic, strong) MJRefreshNormalHeader     *normalheader;                          //MJRefresh Normal Header
@property (nonatomic, strong) MJRefreshGifHeader        *gifHeader;                             //MJRefresh Gif Header
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;                                //MJRefreshAuto NormalFooter
@property (nonatomic, copy)   void(^stRefreshDropDownBlock)(void);                              //Drop Down block
@property (nonatomic, copy)   void(^stRefreshDropUpBlock)(void);                                //Drop Up block
@property (nonatomic,strong)STTableBaseView *stTableBaseView;

#pragma mark ********************* left cycle ********************
/*+ (STRefresh *)shareManager;*/
#pragma mark ********************* Public ************************
#pragma mark ------ load STRefresh
-(void)showSTRefreshTableView:(UITableView *)tableView
             andSTRefreshType:(STRefreshType)stRefreshType
       andSTRefreshHeaderType:(STRefreshHeaderType )stRefreshHeaderType
    andSTRefreshTimeLabHidden:(BOOL)timeLabHidden
   andSTRefreshStateLabHidden:(BOOL)stateLabHidden
             andDropDownBlock:(void(^)(void))dropDownBlock
               andDropUpBlock:(void(^)(void))dropUpBlock;
@end
