//
//  FWVideoMirrorCell.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWVideoMirrorCell.h"
#import "TTTAttributedLabel.h"

@implementation FWVideoMirrorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.bounds = [UIScreen mainScreen].bounds;
        
        [self creatMainView];
    }
    return self ;
}


- (void)creatMainView
{
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.headImgView.userInteractionEnabled = YES;
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.image = kDefaultPreloadHeadImg;
    self.headImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.headImgView.tag = 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTap:)];
    [self.headImgView addGestureRecognizer:tap];
    [self addSubview:self.headImgView];
    
    self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 10, 10)];
    [self addSubview:self.iconImgView];
    
    self.zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-50, 10, 40, 20)];
    self.zanLabel.textColor   = kAppGrayColor3;
    self.zanLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.zanLabel];
    
    self.zanImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-64, 14, 12, 11)];
    self.zanImgView.image = [UIImage imageNamed:@"fw_personCenter_noZan"];
    [self addSubview:self.zanImgView];
    
    self.ZanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ZanBtn.frame =CGRectMake(kScreenW-65, 10, 65, 22);
    self.ZanBtn.backgroundColor = kClearColor;
    [self.ZanBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ZanBtn];
    
    self.videoLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-108, 10, 40, 20)];
    self.videoLabel.textColor = RGB(153, 153, 153);
    self.videoLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.videoLabel];
    
    self.videoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-122, 14, 12, 11)];
    self.videoImgView.image = [UIImage imageNamed:@"fw_personCenter_playNum"];
    [self addSubview:self.videoImgView];
    
    self.videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoBtn.frame =CGRectMake(kScreenW-116, 10, 65, 22);
    self.videoBtn.tag = 1;
    self.videoBtn.backgroundColor = kClearColor;
    [self.videoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.videoBtn];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, kScreenW-185, 20)];
    self.nameLabel.textColor = kAppGrayColor1;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.nameLabel];
    
    
    self.abstractLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(70,CGRectGetMaxY(self.nameLabel.frame)+5, kScreenW-70, 0)];
    self.abstractLabel.textColor = RGB(153, 153, 153);
    self.abstractLabel.textAlignment = NSTextAlignmentLeft;
    self.abstractLabel.font = [UIFont systemFontOfSize:11];
    self.abstractLabel.numberOfLines = 0;
    [self addSubview:self.abstractLabel];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = kAppSpaceColor2;
    [self addSubview:self.lineView];
    
    
}

- (CGFloat)creatCellWithModel:(PersonCenterListModel *)model andRow:(int)row isVideo:(BOOL)isVideo
{
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.headImgView.tag = row;
    if ([model.is_authentication intValue] != 2)
    {
        self.iconImgView.hidden = YES;
    }
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.v_icon] placeholderImage:kDefaultPreloadHeadImg];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.nick_name];
    self.nameLabel.attributedText = attr;
    
    NSString *nameString;
    if (isVideo)
    {
        nameString = [NSString stringWithFormat:@"视频简介:%@",model.content];
        
    }else
    {
        self.videoLabel.hidden = YES;
        self.videoBtn.hidden = YES;
        self.videoImgView.hidden = YES;
        nameString = [NSString stringWithFormat:@"写真简介:%@",model.content];
    }
    
    if (model.has_digg ==1)
    {
        self.zanImgView.image = [UIImage imageNamed:@"fw_personCenter_zan"];
        self.zanLabel.textColor = kAppGrayColor1;
    }
    
    self.zanLabel.text = model.digg_count;
    self.videoLabel.text = model.video_count;
    
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:nameString];
    self.abstractLabel.attributedText = attr1;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.maximumLineHeight = 18.0f;
    paragraphStyle.minimumLineHeight = 16.0f;
    paragraphStyle.firstLineHeadIndent = 0.0f;
    paragraphStyle.lineSpacing = 6.0f;
    paragraphStyle.firstLineHeadIndent = 0.0f;
    paragraphStyle.headIndent = 0.0f;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    UIFont *font = [UIFont systemFontOfSize:11];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:RGB(153, 153, 153)};
    self.abstractLabel.attributedText = [[NSAttributedString alloc]initWithString:nameString attributes:attributes];
    CGSize size = CGSizeMake(self.abstractLabel.frame.size.width, 1000.0f);
    CGFloat height = [self.abstractLabel sizeThatFits:size].height;
    self.abstractLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    
    if (height < 21)
    {
        height = 21;
    }
    self.abstractLabel.frame = CGRectMake(60, CGRectGetMaxY(self.nameLabel.frame)+5, kScreenW-70, height);
    self.lineView.frame = CGRectMake(10, CGRectGetMaxY(self.abstractLabel.frame)+12, kScreenW-10, 1);
    return self.lineView.frame.size.height+self.lineView.frame.origin.y;
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.ZVDelegate && [self.ZVDelegate respondsToSelector:@selector(zanOrVideoClickWithTag:)])
    {
        [self.ZVDelegate zanOrVideoClickWithTag:(int)sender.tag];
    }
}

- (void)imgViewTap:(UITapGestureRecognizer *)tap
{
    if (self.ZVDelegate && [self.ZVDelegate respondsToSelector:@selector(zanOrVideoClickWithTag:)])
    {
        [self.ZVDelegate zanOrVideoClickWithTag:2];
    }
}


@end
