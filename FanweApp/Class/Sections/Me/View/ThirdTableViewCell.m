//
//  ThirdTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ThirdTableViewCell.h"

@interface ThirdTableViewCell ()<UITextFieldDelegate>

@end
@implementation ThirdTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.identificationType.textColor = self.identificationName.textColor = self.contactWay.textColor             = self.identificationNumLabel.textColor = kAppGrayColor1;
    
    self.identificationButton.layer.borderWidth = 0;
    self.identificationButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.typeTextFiled.layer.borderWidth = 0;
    self.typeTextFiled.layer.borderColor = [UIColor clearColor].CGColor;
    self.typeTextFiled.textColor = self.nameTextFiled.textColor = self.contactTextFiled.textColor = self.identificationNumFiled.textColor = kAppGrayColor4;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)creatCellWithAuthentication:(int)authentication andIdTypeStr:(NSString *)idTypeStr andIdNameStr:(NSString *)idNameStr andIdContactStr:(NSString *)idContactStr andIdNumStr:(NSString *)idNumStr andShowIdNum:(int)idNum
{
    if (idNum == 1)
    {
        self.identificationNumLabel.hidden = NO;
        self.idStartLabel.hidden = NO;
        self.identificationNumFiled.hidden = NO;
    }else
    {
        self.identificationNumLabel.hidden = YES;
        self.idStartLabel.hidden = YES;
        self.identificationNumFiled.hidden = YES;
    }
    
    if (authentication == 1 || authentication == 2 || authentication == 3)
    {
        if (authentication == 3)
        {
            self.typeTextFiled.userInteractionEnabled          = YES;
            self.nameTextFiled.userInteractionEnabled          = YES;
            self.contactTextFiled.userInteractionEnabled       = YES;
            self.identificationButton.userInteractionEnabled   = YES;
            self.identificationNumFiled.userInteractionEnabled = YES;
        }else
        {
            self.typeTextFiled.userInteractionEnabled          = NO;
            self.nameTextFiled.userInteractionEnabled          = NO;
            self.contactTextFiled.userInteractionEnabled       = NO;
            self.identificationButton.userInteractionEnabled   = NO;
            self.identificationNumFiled.userInteractionEnabled = NO;
        }
      
        self.typeTextFiled.text = idTypeStr;
        self.nameTextFiled.text = idNameStr;
        self.contactTextFiled.text = idContactStr;
        self.identificationNumFiled.text = idNumStr;
        
    }else
    {
        self.typeTextFiled.userInteractionEnabled          = YES;
        self.nameTextFiled.userInteractionEnabled          = YES;
        self.contactTextFiled.userInteractionEnabled       = YES;
        self.identificationButton.userInteractionEnabled   = YES;
        self.identificationNumFiled.userInteractionEnabled = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

//认证类型的点击事件
- (IBAction)buttonClick:(UIButton *)sender
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(getIdentificationWithCell:)])
        {
            [self.delegate getIdentificationWithCell:self];
        }
    }
}

@end
