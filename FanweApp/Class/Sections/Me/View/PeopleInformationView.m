//
//  PeopleInformationView.m
//  FanweApp
//
//  Created by ycp on 16/10/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "PeopleInformationView.h"

@implementation PeopleInformationView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _nameLabel =[[UILabel alloc] init];
        _vipImageView = [[UIImageView alloc]init];
        _sexImageView =[[UIImageView alloc] init];
        _levelImageView =[[UIImageView alloc] init];
        _editButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _nameLabel.font =[UIFont systemFontOfSize:14];
        _nameLabel.textColor =RGB(74, 75, 76);
        [_editButton setImage:[UIImage imageNamed:@"fw_me_bianji"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editClickButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nameLabel];
        [self addSubview:_sexImageView];
        [self addSubview:_vipImageView];
        [self addSubview:_levelImageView];
        [self addSubview:_editButton];
    }
    return self;
}
- (void)editClickButton{
    if ([_delegate respondsToSelector:@selector(editClickButton)]) {
        [_delegate editClickButton];
    }
}
@end
