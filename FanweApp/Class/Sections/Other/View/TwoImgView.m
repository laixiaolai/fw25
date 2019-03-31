//
//  TwoImgView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "TwoImgView.h"

@implementation TwoImgView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self creatView];
    }
    return self;
}

- (void)creatView
{
    self.headView = [[UIImageView alloc]init];
    self.headView.frame = self.bounds;
    self.headView.layer.cornerRadius = self.headView.frame.size.width/2;
    [self addSubview:self.headView];
    
    self.iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.headView.frame.size.height*2/3, self.headView.frame.size.height*2/3,self.headView.frame.size.height/3,self.headView.frame.size.height/3)];
    self.iconImgView.layer.cornerRadius = self.iconImgView.frame.size.width/2;
    self.iconImgView.hidden = YES;
    [self.headView addSubview:self.iconImgView];
    
}

- (void)getImgViewWithHeadImgString:(NSString *)headImgString andIconImgView:(NSString *)iconImgView
{
    [self.headView sd_setImageWithURL:[NSURL URLWithString:headImgString] placeholderImage:kDefaultPreloadHeadImg];
    if (iconImgView.length)
    {
        self.iconImgView.hidden = NO;
        [self.headView sd_setImageWithURL:[NSURL URLWithString:iconImgView]];
    }

}
@end
