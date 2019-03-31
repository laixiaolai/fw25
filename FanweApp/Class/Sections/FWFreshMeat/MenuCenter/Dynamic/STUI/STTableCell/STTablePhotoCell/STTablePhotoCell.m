//
//  STTablePhotoCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTablePhotoCell.h"
#import "STCollectionPhotoCell.h"
@implementation STTablePhotoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"STCollectionPhotoCell"
                                                    bundle:nil]
          forCellWithReuseIdentifier:@"STCollectionPhotoCell"];
    self.collectionView.scrollEnabled = NO;
    self.selectedMArray = @[].mutableCopy;
    self.recordIndexRow = 1000000;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.stTablePhotoCellType == STTablePhotoUnSelected ||self.stTablePhotoCellType == STTablePhotoSelectCover||self.stTablePhotoCellType == STTablePhotoShow) {
            return _dataSoureMArray.count;
    }
    if (_dataSoureMArray.count>8) {
        return 9;
    }
    return _dataSoureMArray.count;
}
#pragma mark ---- cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    STCollectionPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STCollectionPhotoCell"
                                                                            forIndexPath:indexPath];
    [cell.bgImgView setImage:_dataSoureMArray[indexPath.row]];
    //带删除的
    if (self.stTablePhotoCellType == STTablePhotoDelete) {
        if (indexPath.row+1 == self.dataSoureMArray.count ) {
            cell.selectStateImgView.hidden = YES;
        }else{
            cell.selectStateImgView.hidden = NO;
        }
        [cell.selectStateImgView setImage:[UIImage imageNamed:@"st_delete_photo"]];
        if (indexPath.row+1 == self.dataSoureMArray.count ) {
            cell.selectStateImgView.hidden = YES;
        }else{
            cell.selectStateImgView.hidden = NO;
        }
    }
    if (self.stTablePhotoCellType == STTablePhotoUnSelected) {
        cell.selectStateImgView.hidden = NO;
        [cell.selectStateImgView setImage:[UIImage imageNamed:@"st_photosDynamic_unselect"]];
    }
    //设置封面cell
    if (self.stTablePhotoCellType == STTablePhotoSelectCover) {
        cell.bgImgView.hidden = NO;
        [cell.bgImgView setImage:_dataSoureMArray[indexPath.row]];
        cell.selectCoverImgView.hidden = NO;
        [cell.selectCoverImgView setImage:[UIImage imageNamed:@"st_photosDynamic_cover_unselect"]];
    }
    return cell;
}

//点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //选择类型cell
    if (self.stTablePhotoCellType == STTablePhotoUnSelected) {
        UIImage *image = self.dataSoureMArray[indexPath.row];
        //把数据传走
        STCollectionPhotoCell *cell =(STCollectionPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.isSelectedState = !cell.isSelectedState;
        [cell.selectStateImgView setImage:[UIImage imageNamed:cell.isSelectedState?@"st_photosDynamic_select":@"st_photosDynamic_unselect"]];
        
        //选择
        if ( cell.isSelectedState) {
            //放入数组
            if ([self.selectedMArray containsObject:image]) {
                return;
            }else{
                [self.selectedMArray addObject:image];
            }
            
        }
        //未选择
        else{
            if ([self.selectedMArray containsObject:image]) {
                [self.selectedMArray removeObject:image];
            }else{
                return;
            }
        }
        [cell setNeedsDisplay];
    }
    if (self.stTablePhotoCellType == STTablePhotoSelectCover) {
        if (self.recordIndexRow> _dataSoureMArray.count) {
            
        }else{
            NSIndexPath *oldIndexPath=[NSIndexPath indexPathForRow:_recordIndexRow inSection:0];
            STCollectionPhotoCell *oldCell =(STCollectionPhotoCell *)[collectionView cellForItemAtIndexPath:oldIndexPath];
            [oldCell.selectCoverImgView setImage:[UIImage imageNamed:@"st_photosDynamic_cover_unselect"]];
            [oldCell setNeedsDisplay];
        }
        STCollectionPhotoCell *cell =(STCollectionPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.selectCoverImgView setImage:[UIImage imageNamed:@"st_photosDynamic_cover_select"]];
        [cell setNeedsDisplay];
        self.recordIndexRow = indexPath.row;
    }

    //代理传数据走
    if(_delegate &&[_delegate respondsToSelector:@selector(showSTTablePhotoCell:andDidSelectItemAtIndexPath:)]){
        [_delegate showSTTablePhotoCell:self
            andDidSelectItemAtIndexPath:indexPath];
    }
    
    
    
}
-(void)setDelegate:(id<STTablePhotoCellDelegate>)delegate{
    _delegate = delegate;
}
-(void)setDataSoureMArray:(NSMutableArray *)dataSoureMArray{
    if (_dataSoureMArray.count>0) {
        [_dataSoureMArray removeAllObjects];
    }
    _dataSoureMArray = dataSoureMArray.mutableCopy;
    
    [_collectionView reloadData];
}
@end
