//
//  ExchangeView.m
//  FanweApp
//
//  Created by 王珂 on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ExchangeView.h"

@interface ExchangeView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView        *headerView;
@property (nonatomic, strong) UIButton      *rechargeBtn; //充值按钮
@property (nonatomic, strong) UIButton      *exchangeBtn; //兑换按钮
@property (nonatomic, strong) UIButton      *closeBtn;    //关闭按钮
@property (nonatomic, strong) UIView        *lineView;       //充值与兑换之间的分割线
@property (nonatomic, strong) UILabel       *diamondsLabel; //钻石余额
@property (nonatomic, strong) UILabel       *rateLabel; //兑换比例
@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) UILabel       *gameCoinLabel;
@property (nonatomic, strong) UIView        *separeLineView;
@property (nonatomic, strong) UIView        *verticalLineView;
@property (nonatomic, strong) UIButton      *cancaleBtn; //取消按钮
@property (nonatomic, strong) UIButton      *makeSureBtn; //确定按钮
@property (nonatomic, strong) UIView        *selectLineView; //选中的分割线
@end

@implementation ExchangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat  bthOrignx = (self.width/2-80)/2;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 54)];
        _headerView.backgroundColor = kAppRechargeSelectColor;
        [self addSubview:_headerView];
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeBtn.titleLabel.font = kAppLargeTextFont;
        _rechargeBtn.frame = CGRectMake(bthOrignx, 30, 80, 18);
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rechargeBtn];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-0.5, 30, 1, 18)];
        _lineView.backgroundColor = kAppSpaceColor;
        [self addSubview:_lineView];
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeBtn.titleLabel.font = kAppLargeTextFont;
        _exchangeBtn.frame = CGRectMake(self.width/2+bthOrignx, 30, 80, 18);
        [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [_exchangeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_exchangeBtn];
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(self.width-30, 10, 20, 20);
        [_closeBtn setImage:[UIImage imageNamed:@"com_close_2"] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        _selectLineView= [[UIView alloc] initWithFrame:CGRectMake(self.width/2+(self.width/2-50)/2, CGRectGetMaxY(_rechargeBtn.frame)+10, 50, 2)];
        _selectLineView.backgroundColor = kAppGrayColor1;
        [self addSubview:_selectLineView];
        
        _diamondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_selectLineView.frame)+24, self.width, 15)];
        _diamondsLabel.text = [NSString stringWithFormat:@"%@余额:1239398",self.fanweApp.appModel.diamond_name];
        _diamondsLabel.font = kAppSmallTextFont;
        _diamondsLabel.textColor = kAppGrayColor3;
        _diamondsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_diamondsLabel];
        _rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_diamondsLabel.frame)+24, self.width-20, 14)];
        _rateLabel.font = kAppSmallTextFont;
        _rateLabel.textColor = kAppGrayColor3;
        _rateLabel.text = @"兑换比例:20";
        [self addSubview:_rateLabel];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_rateLabel.frame)+10, self.width-30, 25)];
//        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"请输入金额";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        _textField.font = kAppSmallTextFont;
        [self addSubview:_textField];
        [_textField addTarget:self action:@selector(changeGameCoinLabel) forControlEvents:UIControlEventEditingChanged];
        UIView * linView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textField.frame), self.width-20, 0.5)];
        linView.backgroundColor = kAppSpaceColor;
        [self addSubview:linView];
        _gameCoinLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textField.frame)+15, self.width-20, 15)];
        _gameCoinLabel.text = @"0游戏币";
        _gameCoinLabel.textColor = kAppGrayColor3;
        _gameCoinLabel.font = kAppSmallTextFont;
        _gameCoinLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_gameCoinLabel];
        _separeLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-45.5, self.width, 0.5)];
        _separeLineView.alpha = 0.5;
        _separeLineView.backgroundColor = kAppSpaceColor;
        [self addSubview:_separeLineView];
//        _verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-0.25, self.height-45, 0.5, 45)];
//        _verticalLineView.alpha = 0.5;
//        _verticalLineView.backgroundColor = kAppSpaceColor;
//        [self addSubview:_verticalLineView];
        CGFloat marginX = (self.width-200)/3;
        _cancaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancaleBtn.frame = CGRectMake(marginX, self.height-35, 100, 25);
        _cancaleBtn.layer.cornerRadius = 12.5;
        _cancaleBtn.layer.masksToBounds = YES;
        _cancaleBtn.layer.borderWidth = 0.5;
        _cancaleBtn.layer.borderColor = kAppGrayColor1.CGColor;
        _cancaleBtn.titleLabel.font = kAppSmallTextFont;
        [_cancaleBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [_cancaleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancaleBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancaleBtn];
        _makeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeSureBtn.frame = CGRectMake(CGRectGetMaxX(_cancaleBtn.frame)+marginX, self.height-35, 100, 25);
        _makeSureBtn.layer.cornerRadius = 12.5;
        _makeSureBtn.layer.masksToBounds = YES;
        _makeSureBtn.backgroundColor = kAppGrayColor1;
        _makeSureBtn.titleLabel.font = kAppSmallTextFont;
        [_makeSureBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_makeSureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_makeSureBtn];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)changeGameCoinLabel
{
    if (_textField.text.length>8)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"单次兑换超过上限"];
        return;
    }
    NSInteger  rateCoin = [_textField.text integerValue];
    rateCoin = rateCoin*[self.model.exchange_rate floatValue];
    _gameCoinLabel.text = [NSString stringWithFormat:@"%zd游戏币",rateCoin];
}

- (void)clickBtn:(UIButton *)button
{
    if (button==_rechargeBtn)
    {
        [self endEditing:YES];
        self.hidden = YES;
        //self.frame =CGRectMake(10,kScreenH, kScreenW-20, 230);
        self.transform = CGAffineTransformIdentity;
        if (_delegate && [_delegate respondsToSelector:@selector(choseRecharge:orExchange:)])
        {
            [_delegate choseRecharge:YES orExchange:NO];
        }
    }
    else if (button==_exchangeBtn)
    {
        
    }
    else if (button == _closeBtn || button == _cancaleBtn)
    {
        [self cancleExchange];
    }
    else if (button == _makeSureBtn)
    {
        [self exchangeCoin];
    }
}

- (void)exchangeCoin
{
    if (_textField.text.length == 0 || [_textField.text integerValue] == 0)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入有效金额"];
        return;
    }
    if ([[IMAPlatform sharedInstance].host getDiamonds] < [_textField.text integerValue])
    {
        [FanweMessage alertTWMessage:[NSString stringWithFormat:@"当前%@不足",self.fanweApp.appModel.diamond_name]];
        return;
    }
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"exchangeCoin" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",_textField.text] forKey:@"diamonds"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]==1)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCoin" object:nil];
             [self endEditing:YES];
             NSInteger diamonds = self.model.diamonds -[self.textField.text integerValue];
             self.model.diamonds = diamonds;
             self.diamondsLabel.text = [NSString stringWithFormat:@"%@余额:%zd",self.fanweApp.appModel.diamond_name,self.model.diamonds];
             [UIView animateWithDuration:0.5 animations:^{
                 self.frame =CGRectMake(10,kScreenH, kScreenW-20, 230);
             } completion:^(BOOL finished) {
                 self.hidden = YES;
                 self.textField.text = nil;
                 self.gameCoinLabel.text = @"0游戏币";
             }];
         }
         
     } FailureBlock:^(NSError *error)
     {
     }];
}

- (void)setModel:(AccountRechargeModel *)model
{
    _model = model;
    self.rateLabel.text = [NSString stringWithFormat:@"兑换比例: %@",model.exchange_rate];
    self.diamondsLabel.text = [NSString stringWithFormat:@"%@余额:%zd",self.fanweApp.appModel.diamond_name,model.diamonds];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _textField)
    {
        if (![string isNumber])
        {
            return NO;
        }
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            [[FWHUDHelper sharedInstance] tipMessage:@"单次兑换超过上限"];
            return NO;
        }
    }
    return YES;
}

- (void)cancleExchange
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        //self.frame =CGRectMake(10,kScreenH, kScreenW-20, 230);
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _textField.text = nil;
        _gameCoinLabel.text = @"0游戏币";
    }];
}

@end
