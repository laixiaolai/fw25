//
//  VideoDynamicView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoDynamicView.h"
#import "UIImage+STCommon.h"
@implementation VideoDynamicView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self  showSetSubView];
}
-(void)showSetSubView
{
    if (!self.tableView)
    {
        [self tableView];
        
    }
    [self registerCell];
    
    self.dataSoureMArray = @[].mutableCopy;
}



-(void)registerCell{
    // 视频封面显示cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableShowVideoCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableShowVideoCell"];
    // 动态文本显示cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableTextViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableTextViewCell"];
    //地理坐标 显示cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableLeftRightLabCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableLeftRightLabCell"];
    //提交功能 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableCommitBtnCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableCommitBtnCell"];
}
#pragma mark --  Row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSoureMArray.count == 0)
    {
        return 0;
    }
    return 1;
}
#pragma mark -- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0  && indexPath.row == 0)
    {
        STTableShowVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableShowVideoCell"
                                                                     forIndexPath:indexPath];
        //[cell setDelegate:self];
        //[cell.bgImgView setImage:[UIImage boxblurImage:self.dataSoureMArray[_recordSelectIndex] withBlurNumber:1]];
        cell.bgImgView.hidden = NO;
        [cell.videoCoverImgView setImage:self.dataSoureMArray[_recordSelectIndex]];
        cell.videoCoverImgView.hidden = NO;
        cell.separatorView.hidden = NO;
        cell.changeCoverBtn.hidden = NO;
        cell.changeVideoBtn.hidden = NO;
        cell.changeVideoLab.hidden = NO;
        cell.changeVideoIconImgeView.hidden = NO;
        [cell.changeVideoIconImgeView setImage:[UIImage imageNamed:@"st_videoDynamic_changeVideo"]];
        cell.promptLab.hidden = NO;
        cell.promptLab.text = @"编辑封面";
        [cell setDelegate:self];
        return cell;
    }
    if(indexPath.section == 1  && indexPath.row == 0)
    {
        STTableTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableTextViewCell"
                                                                    forIndexPath:indexPath];
        cell.separatorView.hidden = NO;
        [cell setDelegate:self];
        return cell;
    }
    if(indexPath.section == 2  && indexPath.row == 0)
    {
        STTableLeftRightLabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableLeftRightLabCell"
                                                                        forIndexPath:indexPath];
        cell.separatorView.hidden = NO;
        STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
        cell.rightLab.hidden = NO;
        cell.leftLab.hidden = NO;
        cell.leftLab.text = @"所在位置";
        if (!stBMKCenter.districtStr ||stBMKCenter.districtStr.length<2) {
            cell.rightLab.text = @"不显示";
        }else{
            cell.rightLab.text = stBMKCenter.districtStr;
        }
        cell.separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return cell;
    }
    if(indexPath.section == 3  && indexPath.row == 0)
    {
        STTableCommitBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableCommitBtnCell"
                                                                     forIndexPath:indexPath];
        cell.commitBtn.backgroundColor = kAppMainColor;
        cell.commitBtn.layer.cornerRadius = 3;
        cell.commitBtn.layer.masksToBounds = YES;
        [cell.commitBtn setTitle:@"发布" forState:UIControlStateNormal];
        [cell.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        return cell;
    }
    return nil;
}
#pragma mark ---section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
#pragma mark -- row height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
    {
        return 210;
    }
    if(indexPath.section == 1)
    {
        return 150;
    }
    if(indexPath.section == 2)
    {
        return 45;
    }
    if(indexPath.section == 3)
    {
        return 55;
    }
    return 0;
}
#pragma mark *********************** Deleagte 协议方法  *****************************
#pragma mark ---------- STTableTextViewCellDeleagte 协议方法
-(void)showSTTableTextViewCell:(STTableTextViewCell *)stTableTextViewCell
{
    _recordTextViewStr = stTableTextViewCell.textView.text;
    
    NSLog(@"-----text view  text ---- %@--------",_recordTextViewStr);
}
//STTableShowVideoCell
#pragma mark ---------- STTableShowVideoCell
-(void)showSystemIPC:(BOOL)isSystemIPC andMaxSelectNum:(int)maxSelectNum
{
    if (_delegate &&[_delegate respondsToSelector:@selector(showMyVideoView)])
    {
        [_delegate showMyVideoView];
    }
}
#pragma mark -------- 去封面选择页面
-(void)showSTTableShowVideoCell:(STTableShowVideoCell *)stTableShowVideoCell andChangeVideoCoverClick:(UIButton *)changeVideoCoverClick
{
    if (_delegate &&[_delegate respondsToSelector:@selector(showOnVideoDynamicView:STTableShowVideoCell:andChangeVideoCoverClick:)])
    {
        [_delegate showOnVideoDynamicView:self
                     STTableShowVideoCell:stTableShowVideoCell
                 andChangeVideoCoverClick:changeVideoCoverClick];
    }
}

-(void)setDelegate:(id<VideoDynamicViewDelegate>)delegate
{
    _delegate = delegate;
}
@end













