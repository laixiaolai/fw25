//
//  ImgTableViewCell.m
//  FanweApp
//
//  Created by lxt2016 on 16/11/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ImgTableViewCell.h"
#import "AcutionHistoryModel.h"

@implementation ImgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.pImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        self.pImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.pImgView];
        
        //        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        //        self.lineView.backgroundColor = kGrayTransparentColor1;
        //        self.lineView.hidden = YES;
        //        [self addSubview:self.lineView];
    }
    return self ;
}

- (void)setCellWithModel:(AcutionHistoryModel *)mdeol
{
    CGRect rect = self.pImgView.frame;
    if (mdeol.image_height == 0 || mdeol.image_width == 0)
    {
        rect.size.height = kScreenW;
    }else
    {
        rect.size.height = (mdeol.image_height*kScreenW/mdeol.image_width);
    }
    self.pImgView.frame = rect;
    //[imageV sd_setImageWithURL:_picturesArr[i]];
    //[self.pImgView sd_setImageWithURL:[NSURL URLWithString:mdeol.image_url]];
    [self.pImgView sd_setImageWithURL:[NSURL URLWithString:mdeol.image_url] placeholderImage:nil];
    //    CGRect rect1 = self.lineView.frame;
    //    rect1.origin.y = rect.size.height+1;
    //    self.lineView.frame = rect1;
    //    NSLog(@"mdeol.image_url========%@,mdeol.image_width====%d,mdeol.image_height====%d",mdeol.image_url,mdeol.image_width,mdeol.image_height);
    
}


@end
