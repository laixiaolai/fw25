//
//  OtherChangeView.m
//  FanweApp
//
//  Created by 王珂 on 17/3/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "OtherChangeView.h"

@interface OtherChangeView()<RechargeWayViewDelegate,UITextFieldDelegate>

@end

@implementation OtherChangeView

- (instancetype)initWithFrame:(CGRect)frame andUIViewController:(UIViewController *)viewController
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = kAppRechargeSelectColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        CGFloat  bthOrignx = (self.width/2-80)/2;
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeBtn.titleLabel.font = kAppLargeTextFont;
        _rechargeBtn.frame = CGRectMake(bthOrignx, 30, 80, 18);
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rechargeBtn];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-0.25, 30, 0.5, 18)];
        //_lineView.backgroundColor = [FWUtils colorWithHexString:@"4dffffff"];
        _lineView.backgroundColor = kAppSpaceColor;
        [self addSubview:_lineView];
        
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeBtn.titleLabel.font = kAppLargeTextFont;
        _exchangeBtn.frame = CGRectMake(self.width/2+bthOrignx, 30, 80, 18);
        [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        //[_exchangeBtn setTitleColor:[FWUtils colorWithHexString:@"4dffffff"] forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
        [_exchangeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_exchangeBtn];
        
        _selectLineView = [[UIView alloc] initWithFrame:CGRectMake((self.width/2-50)/2, CGRectGetMaxY(_rechargeBtn.frame)+10, 50, 2)];
        _selectLineView.backgroundColor = kAppGrayColor1;
        [self addSubview:_selectLineView];
        if ([GlobalVariables sharedInstance].appModel.open_game_module == 0 || [GlobalVariables sharedInstance].appModel.open_diamond_game_module == 1)
        {
            _rechargeBtn.frame = CGRectMake(self.width/2-40, 30, 80, 18);
            _lineView.hidden = YES;
            _exchangeBtn.hidden = YES;
            _selectLineView.hidden = YES;
        }
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(self.width-30, 10, 20, 20);
        [_closeBtn setImage:[UIImage imageNamed:@"com_close_2"] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        _rechargeWayView = [[RechargeWayView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_selectLineView.frame), self.width, 75)];
        _rechargeWayView.delegate = self;
        [self addSubview:_rechargeWayView];
        _separateView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_rechargeWayView.frame), self.width-20, 0.5)];
        _separateView.backgroundColor = kAppSpaceColor;
        [self addSubview:_separateView];
        _rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_rechargeWayView.frame)+24, self.width-20, 14)];
        _rateLabel.font = kAppSmallTextFont;
        _rateLabel.textColor = kAppGrayColor3;
        _rateLabel.text = @"兑换比例:20";
        [self addSubview:_rateLabel];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_rateLabel.frame)+15, self.width-30, 25)];
        //_textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"请输入金额";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        _textField.font = kAppSmallTextFont;
        [self addSubview:_textField];
        [_textField addTarget:self action:@selector(changeDiamondsLabel) forControlEvents:UIControlEventEditingChanged];
        UIView * linView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textField.frame), self.width-20, 0.5)];
        linView.backgroundColor = kAppSpaceColor;
        [self addSubview:linView];
        _diamondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textField.frame)+15, self.width-20, 15)];
        _diamondsLabel.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
        _diamondsLabel.textColor = kAppGrayColor3;
        _diamondsLabel.font = kAppSmallTextFont;
        _diamondsLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_diamondsLabel];
        _separeLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-45, self.width, 0.5)];
        _separeLineView.backgroundColor = kAppSpaceColor;
        [self addSubview:_separeLineView];
        //        _verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-1, self.height-45, 1, 45)];
        //        _verticalLineView.backgroundColor = kAppRechargeBtnColor;
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
    }
    return self;
}

//其它支付
- (void)setOtherPayArr:(NSArray *)otherPayArr
{
    _otherPayArr = otherPayArr;
    NSMutableArray * arr = [NSMutableArray arrayWithArray:otherPayArr];
    for (int i=0; i<otherPayArr.count; ++i)
    {
        PayTypeModel *model = otherPayArr[i];
        if ([model.class_name isEqual:@"Iappay"])
        {
            [arr removeObjectAtIndex:i];
        }
    }
    _rechargeWayView.rechargeWayArr = arr;
    _rechargeWayView.selectIndex = _selectIndex;
}

- (void)setModel:(AccountRechargeModel *)model
{
    _model = model;
    _rateLabel.text = [NSString stringWithFormat:@"兑换比例:%@",model.rate];
}

- (void)choseRechargeWayWithWayName:(NSString *)wayName
{
    for (int i=0; i<self.otherPayArr.count; ++i)
    {
        PayTypeModel * model = self.otherPayArr[i];
        if ([model.class_name isEqual:wayName])
        {
            _selectIndex = i;
        }
    }
}

- (void)clickBtn:(UIButton *)button
{
    if (button==_makeSureBtn)
    {
        if (_textField.text.length == 0 || [_textField.text integerValue] == 0)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入有效的兑换金额"];
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(clickOtherRechergeWithView:)])
        {
            [_delegate clickOtherRechergeWithView:self];
        }
    }
    else if (button == _closeBtn || button == _cancaleBtn)
    {
        [self disChangeText];
    }
    else if (button == _exchangeBtn)
    {
        self.transform = CGAffineTransformIdentity;
        [self endEditing:YES];
        if (_delegate && [_delegate respondsToSelector:@selector(clickExchangeWithView:)])
        {
            [_delegate clickExchangeWithView:self];
        }
    }
}

- (void)changeDiamondsLabel
{
    NSInteger  rateCoin = [_textField.text integerValue];
    rateCoin = rateCoin*[self.model.rate floatValue];
    _diamondsLabel.text = [NSString stringWithFormat:@"%zd%@",rateCoin,self.fanweApp.appModel.diamond_name];
}

- (void)disChangeText
{
    [self endEditing:YES];
    
    FWWeakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        
        FWStrongify(self)
        //self.frame =CGRectMake(10,kScreenH, kScreenW-20, 260);
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        self.hidden = YES;
        self.textField.text = nil;
        self.diamondsLabel.text = [NSString stringWithFormat:@"0%@",self.fanweApp.appModel.diamond_name];
        
    }];
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
        {
            return YES;
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"单次兑换超过上限"];
            return NO;
        }
    }
    return YES;
}

@end
