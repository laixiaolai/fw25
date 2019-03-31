//
//  MePTableViewCell.m
//  FanweApp
//
//  Created by ycp on 16/10/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "MePTableViewCell.h"

@implementation MePTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  photoWidth:(CGFloat)width phototHeight:(CGFloat)height{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.photoImageView =[[UIImageView alloc] init];
        self.labelText =[[UILabel alloc] init];
        self.detailLabel =[[UILabel alloc] init];
        if (kScreenW==375)
        {
            self.photoImageView.frame =CGRectMake(10, (50-height)/2, width, height);
            self.labelText.center =self.photoImageView.center;
            CGRect newFrame =self.photoImageView.frame;
            newFrame.origin.x =self.photoImageView.frame.origin.x+self.photoImageView.frame.size.width+10;
            newFrame.size.width =100;
            self.labelText.frame=newFrame;
            
            self.detailLabel.center =self.photoImageView.center;
            CGRect Frame =self.photoImageView.frame;
            Frame.origin.x =150;
            Frame.size.width =kScreenW-150-35;
            self.detailLabel.frame=Frame;
            
            self.labelText.font = kAppMiddleTextFont;
            self.detailLabel.font = kAppSmallTextFont;
        }else if(kScreenW>375)
        {
            self.photoImageView.frame =CGRectMake(10, (55-height)/2, width, height);
            self.labelText.center =self.photoImageView.center;
            CGRect newFrame =self.photoImageView.frame;
            newFrame.origin.x =self.photoImageView.frame.origin.x+self.photoImageView.frame.size.width+10;
            newFrame.size.width =100;
            self.labelText.frame=newFrame;
            
            self.detailLabel.center =self.photoImageView.center;
            CGRect Frame =self.photoImageView.frame;
            Frame.origin.x =150;
            Frame.size.width =kScreenW-150-35;
            self.detailLabel.frame=Frame;
            
            self.labelText.font =kAppMiddleTextFont;
            self.detailLabel.font = kAppMiddleTextFont;
        }else
        {
            self.photoImageView.frame =CGRectMake(10, (44-height)/2, width, height);
            self.labelText.center =self.photoImageView.center;
            CGRect newFrame =self.photoImageView.frame;
            newFrame.origin.x =self.photoImageView.frame.origin.x+self.photoImageView.frame.size.width+10;
            newFrame.size.width =100;
            self.labelText.frame=newFrame;
            
            
            self.detailLabel.center =self.photoImageView.center;
            CGRect Frame =self.photoImageView.frame;
            Frame.origin.x =150;
            Frame.size.width =kScreenW-150-35;
            self.detailLabel.frame=Frame;
            
            self.labelText.font =kAppMiddleTextFont;
            self.detailLabel.font = kAppSmallTextFont;
        }
        
        self.labelText.textColor=RGB(75, 76, 77);
        self.detailLabel.textColor =kAppSecondaryColor;
        self.detailLabel.textAlignment =NSTextAlignmentRight;
        [self.contentView addSubview:self.photoImageView];
        [self.contentView addSubview:self.labelText];
        [self.contentView addSubview:self.detailLabel];
    
    }
    return self;
}


@end
