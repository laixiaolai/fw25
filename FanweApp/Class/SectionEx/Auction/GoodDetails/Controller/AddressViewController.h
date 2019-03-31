//
//  AddressViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/10/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressViewController : FWBaseViewController

@property (nonatomic, assign) int        type;            //0代表新增地址，1代表修改地址
@property (nonatomic, copy) NSString     *user_id;        //联系人的user_id
@property (nonatomic, copy) NSString     *address_id;     //地址的id
@property (nonatomic, copy) NSString     *personName;     //联系人
@property (nonatomic, copy) NSString     *personPhone;    //联系方式
@property (nonatomic, copy) NSString     *area;           //省市区
@property (nonatomic, copy) NSString     *detailArea;     //详细地址
@property (nonatomic, copy) NSString     *provinceStr;    //省
@property (nonatomic, copy) NSString     *cityStr;        //市
@property (nonatomic, copy) NSString     *areaStr;        //区

@property (nonatomic, assign) BOOL       *isDefault;      //是否默认

@end
