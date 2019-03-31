//
//  VideoCoverView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoCoverView.h"
#import "STCollectionPhotoCell.h"
@implementation VideoCoverView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self showRegistCell];
    self.selectIndexRow = 0;
}
-(void)showRegistCell{
    [self.collectionView registerNib:[UINib nibWithNibName:@"STCollectionPhotoCell" bundle:nil]
          forCellWithReuseIdentifier:@"STCollectionPhotoCell"];
}
//STCollectionPhotoCell
#pragma mark -cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    STCollectionPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STCollectionPhotoCell" forIndexPath:indexPath];
    [cell.bgImgView setImage:self.dataSourceMArray[indexPath.row]];
    cell.bgImgView.hidden = NO;
    if (  self.selectIndexRow == indexPath.row) {
        cell.isSelectedState = YES;
    }else{
        cell.isSelectedState = NO;
    }
    if (cell.isSelectedState) {
        cell.layer.borderWidth = 2;
        cell.layer.borderColor = [kAppMainColor CGColor];
        
    }else{
        cell.layer.borderWidth = 0;
    }
    return cell;
}
@end
