//
//  HostCheckMickAlertView.m
//  FanweApp
//
//  Created by xfg on 2017/9/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "HostCheckMickAlertView.h"

@interface HostCheckMickAlertView ()

@property (nonatomic, strong) UIView        *backView;
@property (nonatomic, strong) UIButton      *closeBtn;
@property (nonatomic, strong) UIImageView   *headerImgView;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UIButton      *closeMickBtn;
@property (nonatomic, copy) CloseMickBlock  closeMickBlock;
@property (nonatomic, strong) UserModel     *userModel;

@end

@implementation HostCheckMickAlertView

- (instancetype)initAlertView:(UserModel *)userModel closeMickBlock:(CloseMickBlock)closeMickBlock
{
    self = [super init];
    if ( self )
    {
        self.type = MMPopupTypeCustom;
        
        self.userModel = userModel;
        self.closeMickBlock = closeMickBlock;
        
        FWWeakify(self)
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280, 230));
        }];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            FWStrongify(self)
            make.top.equalTo(self.backView).with.offset(30);
            make.centerX.equalTo(self.backView);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            FWStrongify(self)
            make.top.equalTo(self.headerImgView.mas_bottom).with.offset(10);
            make.left.equalTo(self.backView).with.offset(10);
            make.right.equalTo(self.backView).with.offset(-10);
            make.height.offset(20);
        }];
        
        [self.closeMickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).with.offset(30);
            make.left.equalTo(self.backView).with.offset(10);
            make.right.equalTo(self.backView).with.offset(-10);
            make.height.offset(30);
        }];
        
        [self setupMessage:userModel.user_id];
    }
    return self;
}

- (void)setupMessage:(NSString *)podcast_id
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"userinfo" forKey:@"act"];
    if (podcast_id)
    {
        [mDict setObject:podcast_id forKey:@"to_user_id"];
    }
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        NSDictionary *tmpDict = [responseJson objectForKey:@"user"];
        self.nameLabel.text = [tmpDict toString:@"nick_name"];
        [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[tmpDict toString:@"head_image"]]];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)actionClose
{
    [self hide];
}

- (void)closeMickAction
{
    if (self.closeMickBlock)
    {
        self.closeMickBlock(self.userModel);
    }
    [self actionClose];
}


#pragma mark - ----------------------- GET -----------------------
- (UIView *)backView
{
    if (!_backView)
    {
        _backView = [[UIView alloc] init];
        [self addSubview:_backView];
        _backView.layer.cornerRadius = 5.0f;
        _backView.clipsToBounds = YES;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [UIButton mm_buttonWithTarget:self action:@selector(actionClose)];
        [self.backView addSubview:_closeBtn];
        [_closeBtn setImage:[UIImage imageNamed:@"com_close_1"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIImageView *)headerImgView
{
    if (!_headerImgView)
    {
        _headerImgView = [[UIImageView alloc] init];
        [self addSubview:_headerImgView];
        _headerImgView.layer.cornerRadius = 40;
        _headerImgView.clipsToBounds = YES;
        [_headerImgView setImage:[UIImage imageNamed:@"com_preload_head_img"]];
    }
    return _headerImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        [self addSubview:_nameLabel];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = kAppMiddleTextFont;
        _nameLabel.textColor = kAppGrayColor2;
    }
    return _nameLabel;
}

- (UIButton *)closeMickBtn
{
    if (!_closeMickBtn)
    {
        _closeMickBtn = [UIButton mm_buttonWithTarget:self action:@selector(closeMickAction)];
        [self.backView addSubview:_closeMickBtn];
        [_closeMickBtn setTitle:@"关闭连麦" forState:UIControlStateNormal];
        [_closeMickBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        _closeMickBtn.titleLabel.font = kAppLargeTextFont;
    }
    return _closeMickBtn;
}

@end
