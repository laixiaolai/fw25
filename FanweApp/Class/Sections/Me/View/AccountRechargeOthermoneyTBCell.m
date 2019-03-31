//
//  AccountRechargeOthermoneyTBCell.m
//  FanweApp
//
//  Created by hym on 2016/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AccountRechargeOthermoneyTBCell.h"

static NSString *const ID = @"AccountRechargeOthermoneyTBCell";

@interface AccountRechargeOthermoneyTBCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *otherLabel;

@end

@implementation AccountRechargeOthermoneyTBCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor =[UIColor whiteColor];
    self.lbOtherMoney.textColor =kAppGrayColor2;
    
    [self.btnOperation setTintColor:kAppGrayColor1];
    self.btnOperation.layer.borderColor = kAppGrayColor1.CGColor;
    self.btnOperation.layer.borderWidth = kBorderWidth;
    self.btnOperation.layer.cornerRadius = 15;
    self.btnOperation.titleLabel.textColor = kAppGrayColor1;
    
    self.otherLabel.textColor =kAppGrayColor1;

    self.lbOtherMoney.textAlignment = NSTextAlignmentLeft;
    self.tfOtherMoney.delegate = self;
   [self.tfOtherMoney addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventEditingChanged];
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview
{
    AccountRechargeOthermoneyTBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountRechargeOthermoneyTBCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma marlk textfieldDelegate代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.tfOtherMoney)
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
        if (existedLength - selectedLength + replaceLength > 6)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"单次兑换超过上限"];
            return NO;
        }
    }
    return YES;
}

- (void)valueChanged
{
    NSInteger  rateCoin = [self.tfOtherMoney.text integerValue];
    rateCoin = rateCoin*[self.rate floatValue];
    self.lbOtherMoney.text = [NSString stringWithFormat:@"%zd",rateCoin];
}

- (IBAction)onClickOperation:(id)sender
{
    if (_tfOtherMoney.text.length == 0)
    {
        [FanweMessage alert:@"请输入兑换金额"];
        return;
    }
    else if([_tfOtherMoney.text doubleValue] == 0)
    {
        [FanweMessage alert:@"兑换金额有误"];
        return;
    }
    if (self.block)
    {
        self.block(self.tfOtherMoney.text);
    }
}

@end
