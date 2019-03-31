//
//  GiftView.m
//  FanweApp
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GiftView.h"
#import "SDCycleScrollView2.h"
#import "GiftSubView.h"
#import "UIImageView+WebCache.h"

#define kGiftHorizontalNum              4   // 礼物横向的个数
#define kContinueContainerViewWidth     80  // 连发按钮宽、高度

@interface GiftView()<GiftSubViewDelegate>

@property (nonatomic, strong) NSMutableArray        *bottomViewArray;
@property (nonatomic, assign) NSInteger             giftVerticalNum;            //礼物纵向的个数
@property (nonatomic, strong) NSMutableArray        *giftMArray;
@property (nonatomic, strong) NSMutableArray        *itemArray;                 //保存GiftSubView的数组
@property (nonatomic, strong) GiftModel             *currentGiftModel;          //当前选中的GiftModel
@property (nonatomic, strong) UIView                *rechargeContainerView;     //充值容器视图
@property (nonatomic, strong) UILabel               *diamondsLabel;             //账户剩余钻石
@property (nonatomic, strong) UIImageView           *rechargeImgView;           //充值图标
@property (nonatomic, strong) UIButton              *continueBtn;               //连发按钮
@property (nonatomic, strong) UICountingLabel       *sendedTimeLabel;           //发送次数
@property (nonatomic, assign) NSInteger             sendedTime;                 //发送次数
@property (nonatomic, assign) NSInteger             sendedTimeCopy;             //发送次数
@property (nonatomic, assign) int                   upSelectedIndex;            //上一次选中的index

@end

@implementation GiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = kGrayTransparentColor1;
        
        // 毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:effectView];
        
        _bottomViewArray = [NSMutableArray array];
        _itemArray = [NSMutableArray array];
        
        UIView *bottomContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-kSendGiftContrainerHeight, frame.size.width, kSendGiftContrainerHeight)];
        bottomContainerView.backgroundColor = kGrayTransparentColor3_1;
        [self addSubview:bottomContainerView];
        
        _rechargeContainerView = [[UIView alloc]initWithFrame:CGRectMake(kDefaultMargin, kDefaultMargin, 150, kSendGiftContrainerHeight-kDefaultMargin*2)];
        _rechargeContainerView.backgroundColor = kGrayTransparentColor5;
        _rechargeContainerView.layer.cornerRadius = CGRectGetHeight(_rechargeContainerView.frame)/2;
        [bottomContainerView addSubview:_rechargeContainerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRechargeAction)];
        [_rechargeContainerView addGestureRecognizer:tap];
        
        UIImageView *diamondsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kDefaultMargin,(CGRectGetHeight(_rechargeContainerView.frame)-15)/2, 15, 15)];
        diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
        [diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];
        [_rechargeContainerView addSubview:diamondsImgView];
        
        _diamondsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(diamondsImgView.frame)+kDefaultMargin, 0, 50, CGRectGetHeight(_rechargeContainerView.frame))];
        _diamondsLabel.font = [UIFont systemFontOfSize:15.0];
        _diamondsLabel.textAlignment = NSTextAlignmentRight;
        _diamondsLabel.textColor = [UIColor whiteColor];
        _diamondsLabel.text = @"0";
        [_rechargeContainerView addSubview:_diamondsLabel];
        
        _rechargeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsLabel.frame)+kDefaultMargin,(CGRectGetHeight(_rechargeContainerView.frame)-16)/2, 16, 16)];
        _rechargeImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_rechargeImgView setImage:[UIImage imageNamed:@"lr_gift_list_recharge"]];
        [_rechargeContainerView addSubview:_rechargeImgView];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _sendBtn.frame = CGRectMake(frame.size.width-60-kDefaultMargin, kDefaultMargin, 60, kSendGiftContrainerHeight-kDefaultMargin*2);
        [_sendBtn setTitle:@"送礼" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor lightGrayColor]];
        _sendBtn.layer.cornerRadius = CGRectGetHeight(_sendBtn.frame)/2;
        _sendBtn.titleLabel.font = kAppSmallTextFont;
        [_sendBtn addTarget:self action:@selector(senGiftAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomContainerView addSubview:_sendBtn];
        
        _continueContainerView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-kContinueContainerViewWidth-kDefaultMargin*2, frame.size.height-kContinueContainerViewWidth-kDefaultMargin*2-20, kContinueContainerViewWidth, kContinueContainerViewWidth+20)];
        _continueContainerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_continueContainerView];
        _continueContainerView.hidden = YES;
        
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.frame = CGRectMake(0, 0, kContinueContainerViewWidth, kContinueContainerViewWidth);
        [_continueBtn setImage:[UIImage imageNamed:@"lr_send_gift_normal"] forState:UIControlStateNormal];
        [_continueBtn setImage:[UIImage imageNamed:@"lr_send_gift_selected"] forState:UIControlStateHighlighted];
        [_continueBtn setBackgroundColor:[UIColor clearColor]];
        [_continueBtn addTarget:self action:@selector(senGiftAction:) forControlEvents:UIControlEventTouchUpInside];
        [_continueContainerView addSubview:_continueBtn];
        
        UILabel *continueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kContinueContainerViewWidth/2-21, kContinueContainerViewWidth, 21)];
        continueLabel.font = [UIFont systemFontOfSize:15.0];
        continueLabel.textAlignment = NSTextAlignmentCenter;
        continueLabel.textColor = [UIColor whiteColor];
        continueLabel.text = @"连发";
        [_continueContainerView addSubview:continueLabel];
        
        _decTimeCLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, kContinueContainerViewWidth/2, kContinueContainerViewWidth, 21)];
        _decTimeCLabel.method = UILabelCountingMethodLinear;
        _decTimeCLabel.textAlignment = NSTextAlignmentCenter;
        _decTimeCLabel.textColor = [UIColor whiteColor];
        [_continueContainerView addSubview:_decTimeCLabel];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterDecimalStyle;
        _decTimeCLabel.formatBlock = ^NSString* (CGFloat value)
        {
            NSString* formatted = [formatter stringFromNumber:@((int)value)];
            return formatted;
        };
        _decTimeCLabel.method = UILabelCountingMethodLinear;
        
        _sendedTimeLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, kContinueContainerViewWidth, kContinueContainerViewWidth, 21)];
        _sendedTimeLabel.method = UILabelCountingMethodEaseOut;
        _sendedTimeLabel.textAlignment = NSTextAlignmentCenter;
        _sendedTimeLabel.textColor = kWhiteColor;
        [_continueContainerView addSubview:_sendedTimeLabel];
        _sendedTimeLabel.formatBlock = ^NSString* (CGFloat value)
        {
            NSString* formatted = [formatter stringFromNumber:@((int)value)];
            return formatted;
        };
        _sendedTimeLabel.method = UILabelCountingMethodLinear;
        
    }
    return self;
}

#pragma mark 结束连发
- (void)finishContinue
{
    _sendBtn.hidden = NO;
    _continueContainerView.hidden = YES;
}

#pragma mark 点击充值
- (void)clickRechargeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(showRechargeView:)])
    {
        [_delegate showRechargeView:self];
    }
}

#pragma mark 设置当前钻石数量
- (void)setDiamondsLabelTxt:(NSString *)txt
{
    _diamondsLabel.text = txt;
    CGSize titleSize = [txt boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _diamondsLabel.frame = CGRectMake(_diamondsLabel.frame.origin.x, _diamondsLabel.frame.origin.y, titleSize.width, _diamondsLabel.frame.size.height);
    _rechargeImgView.frame = CGRectMake(CGRectGetMaxX(_diamondsLabel.frame)+kDefaultMargin,_rechargeImgView.frame.origin.y, _rechargeImgView.frame.size.width, _rechargeImgView.frame.size.height);
    _rechargeContainerView.frame = CGRectMake(CGRectGetMinX(_rechargeContainerView.frame), CGRectGetMinY(_rechargeContainerView.frame), CGRectGetMaxX(_rechargeImgView.frame)+kDefaultMargin, CGRectGetHeight(_rechargeContainerView.frame));
}

#pragma mark
- (void)setGiftView:(NSMutableArray *)giftMArray
{
    [_itemArray removeAllObjects];
    [_bottomViewArray removeAllObjects];
    
    _giftMArray = giftMArray;
    [self createGiftSubView:giftMArray];
}

#pragma mark 创建每一项
- (void)createGiftSubView:(NSMutableArray *)arrayList
{
    NSUInteger num = [arrayList count]/8;
    if ([arrayList count]%8)
    {
        num ++;
    }
    int i = 0;
    for (int k=0; k<num; k++)
    {
        CGFloat btn_x_2 = -1;
        CGFloat btn_y_2 = -1;
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kSendGiftContrainerHeight)];
        bottomView.backgroundColor = [UIColor clearColor];
        
        UIView *giftListContrainerView = [[UIView alloc]initWithFrame:CGRectMake(0, kDefaultMargin*1.5, bottomView.frame.size.width, bottomView.frame.size.height-kDefaultMargin*4)];
        giftListContrainerView.backgroundColor = [UIColor clearColor];
        giftListContrainerView.clipsToBounds = YES;
        [bottomView addSubview:giftListContrainerView];
        
        if ([arrayList count]>4)
        {
            _giftVerticalNum = 2;
        }
        else if([arrayList count]>0 && [arrayList count]<5)
        {
            _giftVerticalNum = 1;
        }
        
        NSUInteger counttag = 0;
        if (num == 1)
        {
            counttag = [arrayList count];
        }
        else if (k<num-1)
        {
            counttag = k*8+8;
        }
        else
        {
            counttag = [arrayList count];
        }
        for(; i < counttag; i ++)
        {
            GiftModel * giftModel = [arrayList objectAtIndex:i];
            
            GiftSubView *giftSubView = [[GiftSubView alloc]initWithFrame:CGRectMake(btn_x_2, btn_y_2, (giftListContrainerView.frame.size.width+2)/kGiftHorizontalNum, (giftListContrainerView.frame.size.height+2)/_giftVerticalNum)];
            giftSubView.delegate = self;
            giftSubView.tag = i;
            giftSubView.txtLabel.text = giftModel.name;
            giftSubView.diamondsLabel.text = [NSString stringWithFormat:@"%ld",(long)giftModel.diamonds];
            [giftSubView.imgView sd_setImageWithURL:[NSURL URLWithString:giftModel.icon] placeholderImage:kDefaultPreloadImgSquare];
            [giftSubView resetDiamondsFrame];
            
            if (giftModel.is_much == 1)
            {
                [giftSubView.continueImgView setImage:[UIImage imageNamed:@"lr_gift_list_continue"]];
            }
            else
            {
                [giftSubView.continueImgView setImage:[UIImage imageNamed:@""]];
            }
            
            [giftListContrainerView addSubview:giftSubView];
            [_itemArray addObject:giftSubView];
            
            //计算下一个按钮的位置
            if (i < [arrayList count]-1)
            { //判断是否有下一个按钮
                //列
                if (giftSubView.frame.origin.x + giftSubView.frame.size.width >= self.frame.size.width)
                {
                    //换行
                    btn_x_2 = -1;
                    btn_y_2 = giftSubView.frame.origin.y + giftSubView.frame.size.height;
                }
                else
                {
                    btn_x_2 = giftSubView.frame.origin.x + giftSubView.frame.size.width;
                }
            }
        }
        if (num == 1)
        {
            [self addSubview:bottomView];
        }
        else
        {
            [_bottomViewArray addObject:bottomView];
        }
    }
    
    if ([_bottomViewArray count]>0)
    {
        SDCycleScrollView2 *cycleScrollView = [SDCycleScrollView2 cycleScrollViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kSendGiftContrainerHeight) imagesGroup:_bottomViewArray];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.pageControlDotSize = CGSizeMake(kAdvsPageWidth, kAdvsPageWidth);
        cycleScrollView.autoScrollTimeInterval = 0;
        cycleScrollView.dotColor = kWhiteColor;
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [self addSubview:cycleScrollView];
    }
}

#pragma mark GiftSubViewDelegate
- (void)cateBtn:(int)indexTag
{
    GiftModel *giftModel = [_giftMArray objectAtIndex:indexTag];
    for (int i=0; i<[_itemArray count]; i++)
    {
        UIView *view = [_itemArray objectAtIndex:i];
        
        if ([view isKindOfClass:[GiftSubView class]])
        {
            if (view.tag == indexTag)
            {
                GiftSubView *giftSubView = (GiftSubView *)view;
                if (giftModel.isSelected)
                {
                    [_sendBtn setBackgroundColor:[UIColor lightGrayColor]];
                    giftModel.isSelected = NO;
                    giftSubView.bottomBtn.layer.borderColor = kClearColor.CGColor;
                }
                else
                {
                    [_sendBtn setBackgroundColor:kAppSecondaryColor];
                    giftModel.isSelected = YES;
                    giftSubView.bottomBtn.layer.borderColor = kAppSecondaryColor.CGColor;
                }
            }
            else
            {
                GiftSubView *giftSubView2 = (GiftSubView *)view;
                
                GiftModel *giftModel2 = [_giftMArray objectAtIndex:giftSubView2.tag];
                if (giftModel2.isSelected)
                {
                    giftModel2.isSelected = NO;
                    giftSubView2.bottomBtn.layer.borderColor = kClearColor.CGColor;
                }
            }
        }
    }
    if (_upSelectedIndex != indexTag) {
        _sendedTime = 0;
    }
    _upSelectedIndex = indexTag;
}

- (void)senBtnEnabled:(UIButton *)btn
{
    if (btn == _sendBtn)
    {
        _sendBtn.userInteractionEnabled = YES;
    }
    else if(btn == _continueBtn)
    {
        _continueBtn.userInteractionEnabled = YES;
    }
}

#pragma mark 点击发送按钮
- (void)senGiftAction:(id)sender
{
    UIButton *sendBtn = (UIButton *)sender;
    if (sendBtn == _sendBtn)
    {
        _sendBtn.userInteractionEnabled = NO;
    }
    else if(sendBtn == _continueBtn)
    {
        _continueBtn.userInteractionEnabled = NO;
    }
    [self performSelector:@selector(senBtnEnabled:) withObject:sendBtn afterDelay:0.3];
    
    _selectedGiftTime = [_decTimeCLabel.text integerValue];
    if (_selectedGiftTime == 0)
    {
        _sendedTime = 0;
    }
    
    [self bringSubviewToFront:_continueContainerView];
    
    BOOL haveSelected = NO;
    for (int i=0; i<[_itemArray count]; i++)
    {
        GiftModel *giftModel = [_giftMArray objectAtIndex:i];
        
        if (giftModel.isSelected)
        {
            if ([[IMAPlatform sharedInstance].host getDiamonds] < giftModel.diamonds)
            {
                [FanweMessage alertTWMessage:[NSString stringWithFormat:@"当前%@不足",self.fanweApp.appModel.diamond_name]];
                [[IMAPlatform sharedInstance].host getMyInfo:nil];
                return;
            }
            
            haveSelected = YES;
            if (_delegate && [_delegate respondsToSelector:@selector(senGift:AndGiftModel:)])
            {
                if (_currentGiftModel == giftModel)
                {
                    // 判断这个礼物是否可以连发
                    if (giftModel.is_much && _selectedGiftTime>0)
                    {
                        giftModel.is_plus = 1;
                    }
                    else
                    {
                        giftModel.is_plus = 0;
                    }
                }
                else
                {
                    giftModel.is_plus = 0;
                    _currentGiftModel = giftModel;
                }
                if (giftModel.is_much)
                {
                    _sendBtn.hidden = YES;
                    _continueContainerView.hidden = NO;
                    [_decTimeCLabel countFrom:(NSInteger)kGiftViewSendedDescTime*10 to:0 withDuration:(NSInteger)kGiftViewSendedDescTime];
                    __weak GiftView* blockSelf = self;
                    _decTimeCLabel.completionBlock = ^{
                        [blockSelf finishContinue];
                    };
                    _sendedTime ++;
                    _sendedTimeLabel.text = [NSString stringWithFormat:@"X%ld",(long)_sendedTime];
                }
                else
                {
                    _sendBtn.hidden = NO;
                    _continueContainerView.hidden = YES;
                }
                [_delegate senGift:self AndGiftModel:giftModel];
            }
        }
    }
    if (!haveSelected)
    {
        [FanweMessage alertTWMessage:@"还没选择礼物哦"];
    }
}

@end
