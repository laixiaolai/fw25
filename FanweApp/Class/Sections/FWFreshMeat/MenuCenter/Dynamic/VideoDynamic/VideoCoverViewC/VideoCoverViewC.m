//
//  VideoCoverViewC.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoCoverViewC.h"
#import "STCollectionPhotoCell.h"
@interface VideoCoverViewC ()

@end

@implementation VideoCoverViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma **************************** Getter 区域 ***************************
#pragma mark -- VideoDynamicView
-(VideoCoverView *)videoCoverView{
    if (!_videoCoverView) {
        _videoCoverView = (VideoCoverView *)[VideoCoverView showSTBaseViewOnSuperView:self.view
                                                                            loadNibNamedStr:@"VideoCoverView"
                                                                               andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                                                andComplete:^(BOOL finished,
                                                                                              STBaseView *stBaseView) {
                                                                                    
                                                                                }];
        //[_videoCoverView setDelegate:self];
        [_videoCoverView setBaseDelegate:self];
    }
    return _videoCoverView;
}
#pragma *************************  Delegate 代理 ***************************
#pragma mark ---点击cell事件
-(void)showSTCollectionView:(STCollectionBaseView *)stCollectionView
          andCollectionView:(UICollectionView *)collectionView
   didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    STCollectionPhotoCell *cell = (STCollectionPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelectedState = YES;
    self.videoCoverView.selectIndexRow = indexPath.row;
    [collectionView reloadData];
    
    [self.videoCoverView.showSelectedImgView setImage:self.videoCoverView.dataSourceMArray[self.videoCoverView.selectIndexRow]];
    [self.videoCoverView.showSelectedImgView setNeedsDisplay];
    
    //回调
    if (_selectImgInMarrayblock) {
        _selectImgInMarrayblock(indexPath.row);
    }
}
@end
