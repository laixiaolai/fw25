//
//  SLeaderHeadView.h
//  FanweApp
//
//  Created by 丁凯 on 2017/9/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"

@interface SLeaderHeadView : FWBaseView

@property ( nonatomic,strong)UIImageView      *bottomImgView;

//左边
@property ( nonatomic,strong)UILabel           *LTicketLabel;          //影票
@property ( nonatomic,strong)UIView            *LNSRView;              //印票
@property ( nonatomic,strong)UILabel           *LNameLabel;            //名字
@property ( nonatomic,strong)UIImageView       *LSexImgView;           //性别
@property ( nonatomic,strong)UIImageView       *LRankImgView;          //等级
@property ( nonatomic,strong)UIImageView       *LHeadImgView;          //头像
@property ( nonatomic,strong)UIImageView       *LGoldImgView;          //头像等级图

//中间
@property ( nonatomic,strong)UILabel           *MTicketLabel;          //影票
@property ( nonatomic,strong)UIView            *MNSRView;              //印票
@property ( nonatomic,strong)UILabel           *MNameLabel;            //名字
@property ( nonatomic,strong)UIImageView       *MSexImgView;           //性别
@property ( nonatomic,strong)UIImageView       *MRankImgView;          //等级
@property ( nonatomic,strong)UIImageView       *MHeadImgView;          //头像
@property ( nonatomic,strong)UIImageView       *MGoldImgView;          //头像等级图

//右边
@property ( nonatomic,strong)UILabel           *RTicketLabel;          //影票
@property ( nonatomic,strong)UIView            *RNSRView;              //印票
@property ( nonatomic,strong)UILabel           *RNameLabel;            //名字
@property ( nonatomic,strong)UIImageView       *RSexImgView;           //性别
@property ( nonatomic,strong)UIImageView       *RRankImgView;          //等级
@property ( nonatomic,strong)UIImageView       *RHeadImgView;          //头像
@property ( nonatomic,strong)UIImageView       *RGoldImgView;          //头像等级图

@property ( nonatomic,copy)void (^leadBlock)   (int imgaeIdnex);


/**
 排行榜和贡献榜表头

 @param mArr 数据源
 @param type 1表示贡献榜页面 0表示总榜页面，区分ticket 和use_ticket
 @param consumeType 用于区分是收入榜还是消费榜
 */
- (void)setMyViewWithMArr:(NSMutableArray *)mArr andType:(int)type consumeType:(int)consumeType;

@end
