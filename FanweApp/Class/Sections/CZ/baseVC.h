//
//  baseVC.h
//  switchPicChat
//
//  Created by zzl on 16/3/30.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseNav.h"
#import "dataModel.h"

#define DEVICE_Width                    ([[UIScreen mainScreen] bounds].size.width)
#define DEVICE_Height                   ([[UIScreen mainScreen] bounds].size.height)

@interface baseVC : UIViewController

@property (nonatomic, strong) baseNav* mItNav;

@property (nonatomic, strong)   NSString*   mPageName;
@property (nonatomic, strong)   NSString*   mTitle;

@property (nonatomic, assign) BOOL        mHidNarBar;

- (void)addEmptView;

- (void)addEmptView:(NSString*)strInfo img:(UIImage*)img;

- (void)removeEmptView;

//控制流程
- (void)hidBackBt;

- (void)backBtClicked:(UIButton*)sender;
- (void)presentDismissCompletion;

- (void)setRightTxt:(NSString*)str;
- (void)setRightSecondeTxt:(NSString*)str;
- (void)rightBtClicked:(UIButton*)sender;
- (void)rightSecBtClicked:(UIButton*)sender;

- (void)delayBackClicked;

- (void)pushToVC:(UIViewController*)vc;

//基类列表方面的

@property (nonatomic, assign) BOOL            mHaveHeader;
@property (nonatomic, assign) BOOL            mHaveFooter;

@property (nonatomic, strong)   UITableView*    mTableView;
@property (nonatomic, strong)   NSMutableArray* mDataArr;
@property (nonatomic, assign) int             mPage;//0  1 2 3

//edg 表明 上下左右的距离 和父,
- (void)createTableViewWithEdg:(UIEdgeInsets)edg;//调用这个函数就好创建好上面的

- (void)createJustTableView;//普通的列表,就是64开始,全部大小

- (void)forcesHeaderReFresh;
- (void)headerStartRefreshWithBlock:(void(^)(NSArray* all,SResBase* resb))block;
- (void)headerStartRefresh;//子类需要实现,否则就直接调用了headerEndRefresh
- (void)headerEndRefresh;

- (void)footerStartRefreshWithBlock:(void(^)(NSArray* all,SResBase* resb))block;
- (void)footerStartRefresh;//子类需要实现,否则就直接调用了footerEndRefresh
- (void)footerEndRefresh;

@end


@interface MyUIAlertView : UIAlertView

@property (nonnull,strong) id       mrefObj;

@end


@interface MyUIActionSheet : UIActionSheet

@property (nonnull,strong) id       mrefObj;

@end
