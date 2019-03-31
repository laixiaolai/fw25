//
//  FWReplyCell.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWReplyCell.h"
#import "CommentModel.h"

@implementation FWReplyCell
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTap:)];
    [self.headImgView addGestureRecognizer:tap];
    [self addSubview:self.headImgView];
    
    self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 10, 10)];
    [self addSubview:self.iconImgView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, kScreenW-200, 20)];
    self.nameLabel.textColor = kAppGrayColor1;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.nameLabel];
    
    self.replyLabel = [[UILabel alloc]init];
    self.replyLabel.textColor = RGB(153, 153, 153);
    self.replyLabel.font = [UIFont systemFontOfSize:11];
    self.replyLabel.numberOfLines = 0;
    [self addSubview:self.replyLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-110, 10, 100, 20)];
    self.timeLabel.textColor = RGB(153, 153, 153);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.timeLabel];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = kAppSpaceColor2;
    [self addSubview:self.lineView];
    
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearBtn.backgroundColor = kClearColor;
    [self.clearBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearBtn];
    
    self.nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nameBtn.backgroundColor = kClearColor;
    self.nameBtn.tag = -1;
    [self.nameBtn addTarget:self action:@selector(clickNameString:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nameBtn];
}

- (CGFloat)creatCellWithModel:(CommentModel *)model andRow:(int)row
{
    self.clearBtn.tag = row;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImgView.clipsToBounds = YES;
    self.headImgView.tag = row;
    if ([model.is_authentication intValue] != 2)
    {
        self.iconImgView.hidden = YES;
    }
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.v_icon] placeholderImage:kDefaultPreloadHeadImg];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.nick_name];
    self.nameLabel.attributedText = attr;
    self.timeLabel.text = model.left_time;
    
    NSString *nameString;
    if ([model.to_user_id intValue] > 0)
    {
        nameString = [NSString stringWithFormat:@"回复 %@: %@",model.to_nick_name,model.content];
    }else
    {
       nameString = [NSString stringWithFormat:@" %@",model.content];
    }
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:nameString];
    [attr1 setAttributes:@{NSForegroundColorAttributeName : kAppGrayColor1} range:[nameString rangeOfString:model.to_nick_name]];
    self.replyLabel.attributedText = attr1;
   
    CGFloat height = [nameString boundingRectWithSize:CGSizeMake(kScreenW-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]} context:nil].size.height;
    
    CGFloat nameWidth =[model.to_nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}].width;//蓝色名字的宽度
    
    if (height < 20)
    {
        height = 20;
    }
    
    self.replyLabel.frame = CGRectMake(60, CGRectGetMaxY(self.nameLabel.frame), kScreenW-70, height);
    
    self.lineView.frame = CGRectMake(60, CGRectGetMaxY(self.replyLabel.frame)+9, kScreenW-60, 1);
    
    self.clearBtn.frame = CGRectMake(60, 0, kScreenW-60, self.lineView.frame.size.height+self.lineView.frame.origin.y);
    
    if (nameWidth > 0)
    {
     self.nameBtn.frame = CGRectMake(80, CGRectGetMaxY(self.nameLabel.frame), nameWidth+5, 20);
     self.nameBtn.tag = row;
    }
    
    return self.lineView.frame.size.height+self.lineView.frame.origin.y;
    
}

#pragma mark 点击cell
- (void)buttonClick:(UIButton *)btn
{
    if (self.CDelegate && [self.CDelegate respondsToSelector:@selector(commentNewsWithTag:)])
    {
        [self.CDelegate commentNewsWithTag:(int)btn.tag];
    }
}

#pragma mark 点击名字
- (void)clickNameString:(UIButton *)btn
{
    if (self.CDelegate && [self.CDelegate respondsToSelector:@selector(clickNameStringWithTag:)])
    {
        [self.CDelegate clickNameStringWithTag:(int)btn.tag];
    }
}

#pragma mark 点击头像
- (void)imgViewTap:(UITapGestureRecognizer *)tap
{
    if (self.CDelegate && [self.CDelegate respondsToSelector:@selector(clickNameStringWithTag:)])
    {
        [self.CDelegate clickNameStringWithTag:(int)tap.view.tag];
    }
}


@end
