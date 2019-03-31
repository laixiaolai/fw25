//
//  FWDynamicCell.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWDynamicCell.h"

#define kPicDiv 5.0f

@implementation FWDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.bounds = [UIScreen mainScreen].bounds;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self ;
}

-(void)setData:(PersonCenterListModel *)data andRow:(int)row
{
    _data = data;
    _row = row;
    for(UIView *view in [self.contentView subviews])
    {
        [view removeFromSuperview];
    }
    [self setHeadView];
    [self setBodyView];
    [self setZanReplyBar];
}

#pragma mark 头部
-(void)setHeadView
{
    //头像
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 42, 42)];
    _headView.userInteractionEnabled = YES;
    [self.contentView addSubview:_headView];
    _headView.layer.cornerRadius = 21;
    _headView.layer.masksToBounds = YES;
    _headView.tag = 100*_row+21;
    [_headView sd_setImageWithURL:[NSURL URLWithString:_data.head_image] placeholderImage:kDefaultPreloadHeadImg];
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headTap:)];
    [self.headView addGestureRecognizer:headTap];
    
    //认证
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(42, 42, 9, 9)];
    [self.contentView addSubview:self.iconView];
    if ([_data.is_authentication intValue] == 2)
    {
        self.iconView.hidden = NO;
        self.iconView.image = [UIImage imageNamed:@"fw_SCell_vip"];
    }else
    {
        self.iconView.hidden = YES;
    }
    
    
    //名字
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 10, kScreenW-42-80-70, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.textColor = kAppGrayColor1;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.attributedText = [[NSAttributedString alloc]initWithString:_data.nick_name];
    
    
    //顶置
    self.topView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-42-80, 13, 42, 14)];
    self.topView.image = [UIImage imageNamed:@"fw_personCenter_hadTop"];
    [self.contentView addSubview:self.topView];
    
    if ([_data.is_top intValue] == 1)
    {
        if ([_data.is_show_top intValue] == 1)
        {
            self.topView.userInteractionEnabled = YES;
            self.topView.hidden = NO;
        }else
        {
            self.topView.userInteractionEnabled = NO;
            self.topView.hidden = YES;
        }
    }else
    {
        self.topView.userInteractionEnabled = NO;
        self.topView.hidden = YES;
    }
    
    self.topView.tag =100*_row+20;
    UITapGestureRecognizer*tapGesture6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
    [self.topView addGestureRecognizer:tapGesture6];
    
    //时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-80, 10, 70, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = RGB(153, 153, 153);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.text = _data.left_time;
    
}

#pragma mark 中间部分
- (void)setBodyView
{
    //内容
    CGFloat bodyViewWidth = kScreenW - 60 - 32;
    CGFloat bodyViewAddHight = 0;
    NSString *content = _data.content;
    
    TTTAttributedLabel * contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, bodyViewWidth, 0)];
    contentLabel.textColor = RGB(153, 153, 153);
    contentLabel.numberOfLines = 0;
    //contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    contentLabel.delegate = self;
    
    if (content != nil && content.length > 0)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.maximumLineHeight = 18.0f;
        paragraphStyle.minimumLineHeight = 16.0f;
        paragraphStyle.firstLineHeadIndent = 0.0f;
        paragraphStyle.lineSpacing = 6.0f;
        paragraphStyle.firstLineHeadIndent = 0.0f;
        paragraphStyle.headIndent = 0.0f;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        UIFont *font = [UIFont systemFontOfSize:14];
        NSDictionary *attributes = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:RGB(153, 153, 153)};
        contentLabel.attributedText = [[NSAttributedString alloc]initWithString:content attributes:attributes];
        contentLabel.textColor = RGB(153, 153, 153);
        CGSize size = CGSizeMake(bodyViewWidth, 1000.0f);
        CGSize finalSize = [contentLabel sizeThatFits:size];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        
        //利用富文本实现URL的点击事件http://blog.csdn.net/liyunxiangrxm/article/details/53410919
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],
                                        (NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        
        //contentLabel.highlightedTextColor = [UIColor whiteColor];
        contentLabel.highlightedTextColor = RGB(153, 153, 153);
        contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        // end modify by huangyibiao
        
        // reasion: handle links in chat content, ananylizing each link
        // 提取出文本中的超链接
        NSError *error;
        NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:content
                                                    options:0
                                                      range:NSMakeRange(0, [content length])];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:content];
        for (NSTextCheckingResult *match in arrayOfAllMatches) {
            NSString *substringForMatch = [content substringWithRange:match.range];
            [attribute addAttribute:(NSString *)kCTFontAttributeName value:(id)contentLabel.font range:match.range];
            [attribute addAttribute:(NSString*)kCTForegroundColorAttributeName
                              value:(id)[[UIColor blueColor] CGColor]
                              range:match.range];
            [contentLabel addLinkToURL:[NSURL URLWithString:substringForMatch] withRange:match.range];
        }
        
        //文本增加长按手势
        contentLabel.userInteractionEnabled = YES;
        contentLabel.textColor = RGB(153, 153, 153);
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressText:)];
        [contentLabel addGestureRecognizer:longTap];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        bodyViewAddHight = 0;
    
    }
    
    //图片
    if (_imgArray == nil) {
        _imgArray = [[NSMutableArray alloc]init];
    }
    [_imgArray removeAllObjects];
    
    if ([_data.type isEqualToString:@"imagetext"] || [_data.type isEqualToString:@"red_photo"])
    {
       [_imgArray addObjectsFromArray:_data.images];
    }else
    {
        if (_data.photo_image)
        {
          [_imgArray addObject:_data.photo_image];
        }
    }
    
    if (_imgViewArray == nil) {
        _imgViewArray = [[NSMutableArray alloc]init];
    }
    [_imgViewArray removeAllObjects];
    
    CGFloat fromY = contentLabel == nil?0:contentLabel.frame.size.height+10;
    if ([_data.type isEqualToString:@"imagetext"] || [_data.type isEqualToString:@"red_photo"])
    {
        if ([_imgArray count] == 1) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fromY, 200, 200)];
            imageView.tag =100*_row+0;
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[_imgArray[0] objectForKey:@"url"]]];
            
            [_imgViewArray addObject:imageView];
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView addGestureRecognizer:tapGesture];
            
        }else if([_imgArray count] == 2){
            CGFloat imgWidth = (bodyViewWidth - 2 * kPicDiv)/3;
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, fromY, imgWidth, imgWidth)];
            
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:[_imgArray[0] objectForKey:@"url"]]];
            
            imageView1.tag =100*_row+0;
            imageView1.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView1 addGestureRecognizer:tapGesture];
            [_imgViewArray addObject:imageView1];
            
            UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imgWidth+kPicDiv,fromY, imgWidth, imgWidth)];
            
            
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:[_imgArray[1] objectForKey:@"url"]]];
            [_imgViewArray addObject:imageView2];
            imageView2.tag =100*_row+1;
            imageView2.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView2 addGestureRecognizer:tapGesture2];
        }else if([_imgArray count] == 4){
            CGFloat imgWidth = (bodyViewWidth - 2 * kPicDiv)/3;
            for (int i=0; i<[_imgArray count]; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%2)*(imgWidth+kPicDiv), (i/2)*(imgWidth+kPicDiv) + fromY, imgWidth, imgWidth)];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:[_imgArray[i] objectForKey:@"url"]]];
                imageView.backgroundColor = [UIColor redColor];
                imageView.tag =100*_row+i;
                imageView.userInteractionEnabled = YES;
                [_imgViewArray addObject:imageView];
                UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
                [imageView addGestureRecognizer:tapGesture];
            }
        }
        else{
            CGFloat imgWidth = (bodyViewWidth - 2 * kPicDiv)/3;
            for (int i=0; i<[_imgArray count]; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%3)*(imgWidth+kPicDiv), (i/3)*(imgWidth+kPicDiv) + fromY, imgWidth, imgWidth)];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:[_imgArray[i] objectForKey:@"url"]]];
                imageView.tag = 100*_row+i;
                [_imgViewArray addObject:imageView];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
                [imageView addGestureRecognizer:tapGesture];
                
            }
        }
    }else if ([_data.type isEqualToString:@"goods"] || [_data.type isEqualToString:@"photo"])
    {
        if ([_imgArray count])
        {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fromY, 200, 200)];
            imageView.tag =100*_row+0;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imgArray[0]]];
            if ([_data.type isEqualToString:@"photo"])
            {
                //写真图
                UIImageView *topImgView =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
                topImgView.userInteractionEnabled = YES;
                topImgView.image = [UIImage imageNamed:@"fw_personCenter_photoAlbum"];
                [imageView addSubview:topImgView];
                
                //写真的张数
                UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 6, 44, 20)];
                numLabel.backgroundColor = kBlackColor;
                numLabel.layer.cornerRadius = 10;
                numLabel.layer.masksToBounds = YES;
                numLabel.alpha = 0.5;
                numLabel.textColor = kWhiteColor;
                numLabel.font = [UIFont systemFontOfSize:11];
                numLabel.text = _data.images_count;
                numLabel.textAlignment = NSTextAlignmentCenter;
                [imageView addSubview:numLabel];
                
                UIImageView *rimView1 = [[UIImageView alloc]initWithFrame:CGRectMake(6, fromY-6, 200, 200)];
                rimView1.layer.borderWidth = 1;
                rimView1.layer.borderColor = kAppSpaceColor2.CGColor;
                rimView1.backgroundColor = kWhiteColor;
                
                UIImageView *rimView2 = [[UIImageView alloc]initWithFrame:CGRectMake(3, fromY-3, 200, 200)];
                rimView2.layer.borderWidth = 1;
                rimView2.layer.borderColor = kAppSpaceColor2.CGColor;
                rimView2.backgroundColor = kWhiteColor;
                
                [_imgViewArray addObject:rimView1];
                [_imgViewArray addObject:rimView2];
            }
            [_imgViewArray addObject:imageView];
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView addGestureRecognizer:tapGesture];
        }
    }else if ([_data.type isEqualToString:@"video"])//视频动态
    {
        if ([_imgArray count])
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fromY, kScreenW-130, ((kScreenW-130)*14)/25)];
            //UIImageView *imageView = [[UIImageView alloc]init];
            imageView.tag = 100*_row+0;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imgArray[0]]];
            [_imgViewArray addObject:imageView];
            //UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            //[imageView addGestureRecognizer:tapGesture];
            
            UIImageView *playImgView = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.size.width/2 -20, imageView.size.height/2 -20, 40, 40)];
            playImgView.userInteractionEnabled = YES;
            playImgView.tag = 100*_row+0;
            playImgView.image = [UIImage imageNamed:@"fw_personCenter_play"];
            [imageView addSubview:playImgView];
            
            UITapGestureRecognizer*playGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playPressImage:)];
            [imageView addGestureRecognizer:playGesture];
  
        }
    }
    CGFloat lastViewHight;
    if (_imgViewArray.count)
    {
        UIImageView *lastView = [_imgViewArray objectAtIndex:([_imgViewArray count]-1) ];
        lastViewHight = lastView.frame.size.height + lastView.frame.origin.y;
    }else
    {
       lastViewHight = contentLabel.frame.size.height + contentLabel.frame.origin.y;
    }
    
    //地址
    self.placeLabel = [[UILabel alloc]init];
    self.placeLabel.textColor = RGB(153, 153, 153);
    self.placeLabel.font = [UIFont systemFontOfSize:11];
    if ([_data.weibo_place length])
    {
        self.placeLabel.frame = CGRectMake(0, lastViewHight+5, kScreenW-75, 20);
        self.placeLabel.text = _data.weibo_place;
    }else
    {
        self.placeLabel.frame = CGRectMake(0, lastViewHight, kScreenW-75, 0);
    }
   
    //红包
    self.redbagLabel = [[UILabel alloc]init];
    self.redbagLabel.textColor = kAppGrayColor1;
    self.redbagLabel.font = [UIFont systemFontOfSize:11];
    if ([_data.type isEqualToString:@"red_photo"])
    {
        self.redbagLabel.frame = CGRectMake(0, CGRectGetMaxY(self.placeLabel.frame)+5, kScreenW-75, 20);
        self.redbagLabel.text = [NSString stringWithFormat:@"%d人看了照片，共收入%.2f元",[_data.red_count intValue],[_data.red_count floatValue]*[_data.price floatValue]];
    }else
    {
        self.redbagLabel.frame = CGRectMake(0,  CGRectGetMaxY(self.placeLabel.frame), kScreenW-75, 0);
    }
    
    CGFloat bodyHight = self.redbagLabel.frame.size.height + self.redbagLabel.frame.origin.y;
    self.bodyView = nil;
    self.bodyView = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10, bodyViewWidth, bodyHight)];
    [self.contentView addSubview:self.bodyView];
    
    if(contentLabel != nil){
        [self.bodyView addSubview:contentLabel];
        
    }
    for (UIImageView *iv in _imgViewArray) {
        
        [self.bodyView addSubview:iv];
    }
    if(self.placeLabel != nil){
        [self.bodyView addSubview:self.placeLabel];
        
    }
    if(self.redbagLabel != nil){
        [self.bodyView addSubview:self.redbagLabel];
        
    }
}

#pragma  mark 底部
- (void)setZanReplyBar
{

    _zanBarView =  [[UIView alloc]initWithFrame:CGRectMake(0, _bodyView.frame.size.height + _bodyView.frame.origin.y, kScreenW, 46)];
    
    #pragma mark 点赞
    UIImageView *zanImgView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 18, 12, 10)];
    zanImgView.image = [UIImage imageNamed:@"fw_personCenter_noZan"];
    [_zanBarView addSubview:zanImgView];
    UILabel *zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(zanImgView.frame.size.width+zanImgView.origin.x+5, 13, 50, 20)];
    zanLabel.textColor = RGB(153, 153, 153);
    zanLabel.font = [UIFont systemFontOfSize:12];
    [_zanBarView addSubview:zanLabel];
    
    if ([_data.type isEqualToString:@"goods"])
    {
        zanLabel.text = @"我要购买";
        zanImgView.image = [UIImage imageNamed:@"fw_personCenter_buyCar"];
        zanLabel.textColor = kAppGrayColor1;
        UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.frame = CGRectMake(65, 0, 60, 46);
        buyBtn.backgroundColor = kClearColor;
        buyBtn.tag = _row*100+4;
        [buyBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //[_zanBarView addSubview:buyBtn];
        [self.contentView addSubview:_zanBarView];
    }else
    {
        zanLabel.text = _data.digg_count;
        UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zanBtn.frame = CGRectMake(65, 0, 60, 46);
        zanBtn.backgroundColor = kClearColor;
        zanBtn.tag = _row*100+0;
        [zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_zanBarView addSubview:zanBtn];
        [self.contentView addSubview:_zanBarView];
        
        if (_data.has_digg == 1)//已经点赞过了显示红色
        {
          zanImgView.image = [UIImage imageNamed:@"fw_personCenter_zan"];
          zanLabel.textColor = kAppGrayColor1;
        }

    }
    
#pragma mark 评论
    UIImageView *commentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(zanLabel.frame.size.width+zanLabel.origin.x, 18, 13, 10)];
    commentImgView.image = [UIImage imageNamed:@"fw_personCenter_comment"];
    [_zanBarView addSubview:commentImgView];
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentImgView.frame.size.width+commentImgView.origin.x+5, 13, 50, 20)];
    commentLabel.textColor = RGB(153, 153, 153);
    commentLabel.font = [UIFont systemFontOfSize:12];
    commentLabel.text = _data.comment_count;
    [_zanBarView addSubview:commentLabel];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(zanLabel.frame.size.width+zanLabel.origin.x, 0, 50, 46);
    commentBtn.backgroundColor = kClearColor;
    commentBtn.tag = _row*100+1;
    [commentBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_zanBarView addSubview:commentBtn];
    commentBtn.hidden = YES;
    

#pragma mark 播放
    UIImageView *playImgView = [[UIImageView alloc]initWithFrame:CGRectMake(commentLabel.frame.size.width+commentLabel.origin.x, 18, 13, 10)];
    playImgView.image = [UIImage imageNamed:@"fw_personCenter_playNum"];
    [_zanBarView addSubview:playImgView];
    UILabel *playLabel = [[UILabel alloc]initWithFrame:CGRectMake(playImgView.frame.size.width+playImgView.origin.x+5, 13, 50, 20)];
    playLabel.textColor = RGB(153, 153, 153);
    playLabel.font = [UIFont systemFontOfSize:12];
    playLabel.text = _data.video_count;
    [_zanBarView addSubview:playLabel];
    
    UIButton *playBtn;
    if ([_data.type isEqualToString:@"red_photo"])
    {
     playLabel.text = _data.red_count;
     playLabel.textColor = kAppGrayColor1;
     playImgView.image = [UIImage imageNamed:@"fw_personCenter_redBag"];
      
     UIButton *redBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     redBagBtn.frame = CGRectMake(commentLabel.frame.size.width+commentLabel.origin.x, 0,40, 46);
     redBagBtn.backgroundColor = kClearColor;
     redBagBtn.tag = _row*100+5;
     [redBagBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     [_zanBarView addSubview:redBagBtn];
     redBagBtn.hidden = YES;
        
    }else
    {
      playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      playBtn.frame = CGRectMake(commentLabel.frame.size.width+commentLabel.origin.x, 0,40, 46);
      playBtn.backgroundColor = kClearColor;
      playBtn.tag = _row*100+2;
      [playBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
      [_zanBarView addSubview:playBtn];
      playBtn.hidden = YES;
    }

    
    if ([_data.type isEqualToString:@"goods"] )
    {
        commentImgView.hidden = YES;
        commentLabel.hidden = YES;
        commentBtn.hidden = YES;
        
        playImgView.hidden = YES;
        playLabel.hidden = YES;
        playBtn.hidden = YES;
        
    }
    
    if ([_data.type isEqualToString:@"photo"] || [_data.type isEqualToString:@"imagetext"])
    {
        playImgView.hidden = YES;
        playLabel.hidden = YES;
        playBtn.hidden = YES;
    }
    
#pragma mark 更多
    UIImageView *moreImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-37, 20, 22, 5)];
    moreImgView.image = [UIImage imageNamed:@"fw_personCenter_more"];
    [_zanBarView addSubview:moreImgView];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(kScreenW-40, 0, 40, 46);
    moreBtn.backgroundColor = kClearColor;
    moreBtn.tag = _row*100+3;
    [moreBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_zanBarView addSubview:moreBtn];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, kScreenW, 1)];
    lineView.backgroundColor = kAppSpaceColor2;
    [_zanBarView addSubview:lineView];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(kScreenW, _zanBarView.frame.size.height +  _zanBarView.frame.origin.y+10);
}

#pragma mark 点赞之类的操作
- (void)zanBtnClick:(UIButton *)button
{
    NSLog(@"tag==%d",(int)button.tag);
    if (self.DDelegate && [self.DDelegate respondsToSelector:@selector(onPressZanBtnOnDynamicCell:andTag:)])
    {
        [self.DDelegate onPressZanBtnOnDynamicCell:self andTag:(int)button.tag];
    }
}


#pragma mark 图片的点击事件
- (void)onPressImage:(UITapGestureRecognizer *)tap
{
    if (self.DDelegate && [self.DDelegate respondsToSelector:@selector(onPressImageView:andTag:)])
    {
        [self.DDelegate onPressImageView:self andTag:(int)tap.view.tag ];
    }
}
#pragma mark 播放视频的点击事件
- (void)playPressImage:(UITapGestureRecognizer *)tap
{
    if (self.DDelegate && [self.DDelegate respondsToSelector:@selector(onPressImageView:andTag:)])
    {
        [self.DDelegate onPressImageView:self andTag:(int)tap.view.tag];
    }
}

- (void)headTap:(UITapGestureRecognizer *)tap
{
    if (self.DDelegate && [self.DDelegate respondsToSelector:@selector(onPressImageView:andTag:)])
    {
        [self.DDelegate onPressImageView:self andTag:(int)tap.view.tag];
    }
}
#pragma mark 文字的复制事件
- (void)longPressText:(UILongPressGestureRecognizer *)tap
{
    
}

@end
