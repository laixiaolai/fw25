//
//  HeaderView.m
//  FanweApp
//
//  Created by GuoMs on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "HeaderView.h"
#import "UIImageView+WebCache.h"
#import "AuctionTagCell.h"

#define BtnW 60
#define BtnX 8
#define BtnY 12
#define BtnH 30
#define Space 8
#define imagW 90
#define imagH 90

@implementation HeaderView

- (NSMutableArray *)cellcount
{
    if (!_cellcount)
    {
        self.cellcount = [NSMutableArray new];
    }
    return _cellcount;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = kAppSpaceColor3;
    self.getBtnTypeScrollow.backgroundColor = kAppSpaceColor3;
    self.getBtnTypeScrollow.layer.borderWidth = 0.5f;
    self.getBtnTypeScrollow.layer.borderColor = [kAppGrayColor4 CGColor];
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(imagW + 10, imagH + 10);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    self.flowLayout.minimumLineSpacing = 2;
    self.flowLayout.minimumInteritemSpacing = 2;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.getPhotoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.bounds.size.height - 56) collectionViewLayout:self.flowLayout];
    self.getPhotoCollection.backgroundColor = kAppSpaceColor3;
    self.getPhotoCollection.showsVerticalScrollIndicator = NO;
    self.getPhotoCollection.showsHorizontalScrollIndicator = NO;
    self.getPhotoCollection.delegate = self;
    self.getPhotoCollection.dataSource = self;
    [self.getPhotoCollection registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    [self addSubview:self.getPhotoCollection];
}

- (void)setTagsArr:(NSArray *)tagsArr
{
    _tagsArr = tagsArr;
    if (tagsArr.count > 0)
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init] ;
        flow.minimumLineSpacing = 8;
        flow.minimumInteritemSpacing = 8;
        flow.sectionInset = UIEdgeInsetsMake(BtnY, 10, BtnY, 10);
        flow.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        self.tagsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.height-54, kScreenW, 54) collectionViewLayout:flow];
        self.tagsCollectionView.delegate = self;
        self.tagsCollectionView.dataSource = self;
        self.tagsCollectionView.backgroundColor = kAppSpaceColor3;
        self.tagsCollectionView.showsHorizontalScrollIndicator = NO;
        self.tagsCollectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.tagsCollectionView];
        [self.tagsCollectionView registerNib:[UINib nibWithNibName:@"AuctionTagCell" bundle:nil] forCellWithReuseIdentifier:@"AuctionTagCell"];
    }
}

- (void)getPicturearr:(NSMutableArray *)arr block:(void (^)())block
{
    self.cellcount = arr;
    [self.getPhotoCollection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.getPhotoCollection)
    {
        if (self.isOTOShop)
        {
            return 1;
        }
        else if (self.cellcount.count < 5)
        {
            return self.cellcount.count;
        }
        else
        {
            return 5;
        }
    }
    return self.tagsArr.count;
}

#pragma mark Falow LayOut Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.getPhotoCollection)
    {
        return CGSizeMake( kScreenW / 4 + 10,kScreenW/4 + 10);
    }
    else if(collectionView == self.tagsCollectionView)
    {
        if (self.tagsArr.count > indexPath.item)
        {
            TagsModel * model = self.tagsArr[indexPath.item];
            CGSize titleSize = [model.name boundingRectWithSize:CGSizeMake(MAXFLOAT, BtnH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAppSmallTextFont} context:nil].size;
            return CGSizeMake(titleSize.width+20, BtnH) ;
        }
    }
    return CGSizeMake( 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.getPhotoCollection )
    {
        PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
        if (self.isOTOShop)
        {
            if (self.cellcount.count - 1 == indexPath.row)
            {
                //判断最后一张是否显示为增加图片的本地图片
                if ([self.cellcount.lastObject isEqual:@"me_addPhoto"])
                {
                    cell.photoIMG.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]];
                }
                else
                {
                    [cell.photoIMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]] placeholderImage:nil];
                }
            }
            else
            {
                [cell.photoIMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]] placeholderImage:nil];
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                //判断最后一张是否显示为增加图片的本地图片
                if ([self.cellcount.firstObject isEqual:@"me_addPhoto"])
                {
                    cell.photoIMG.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]];
                }
                else
                {
                    [cell.photoIMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]] placeholderImage:nil];
                }
            }
            else
            {
                [cell.photoIMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]] placeholderImage:nil];
            }
        }
        //    if (self.cellcount.count - 1 == indexPath.row)
        //    {
        //        //判断最后一张是否显示为增加图片的本地图片
        //        if ([self.cellcount.lastObject isEqual:@"me_addPhoto"])
        //        {
        //            cell.photoIMG.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]];
        //        }
        //        else
        //        {
        //            [cell.photoIMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]] placeholderImage:nil];
        //        }
        //    }
        //    else
        //    {
        //        [cell.photoIMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cellcount[indexPath.row]]] placeholderImage:nil];
        //    }
        //    UILongPressGestureRecognizer* longgs=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
        //    [cell addGestureRecognizer:longgs];//为cell添加手势
        //    longgs.minimumPressDuration = 1.0;//定义长按识别时长
        //    longgs.view.tag = indexPath.row;//将手势和cell的序号绑定
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleToTap:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tap];
        UITapGestureRecognizer *tapcancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleToTaptapcancel:)];
        cell.cancelIMG.tag = indexPath.row;
        [cell.cancelIMG addGestureRecognizer:tapcancel];
        if (!_isOTOShop)
        {
            if (indexPath.row != 0 || ![self.cellcount.firstObject isEqual:@"me_addPhoto"])
            {
                cell.cancelIMG.hidden = NO;
            }
            else
            {
                cell.cancelIMG.hidden = YES;
            }
        }
        else
        {
            cell.cancelIMG.hidden = YES;
        }
        return cell;
    }
    else
    {
        AuctionTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AuctionTagCell" forIndexPath:indexPath];
        if (self.tagsArr.count > indexPath.item)
        {
            cell.model = self.tagsArr[indexPath.item];
        }
        return cell;
    }
}

- (void)longpress:(UILongPressGestureRecognizer*)ges
{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)ges.view;
    NSInteger row = ges.view.tag;
    if(ges.state==UIGestureRecognizerStateBegan && !_isOTOShop)
    {
//        if (self.cellcount.count - 1 != row)
//        {
//            cell.cancelIMG.hidden = NO;
//        }
        if (row != 0 || ![self.cellcount.firstObject isEqual:@"me_addPhoto"])
        {
            cell.cancelIMG.hidden = NO;
        }
    }
}

- (void)handleToTaptapcancel:(UITapGestureRecognizer *)tap
{
    if (self.cellcount.count > 1)
    {
        NSInteger row = tap.view.tag;
        if (self.cellcount.count == 5 && ![self.cellcount.firstObject isEqual:@"me_addPhoto"])
        {
            [self.cellcount removeObjectAtIndex:row];
            [self.cellcount insertObject:@"me_addPhoto" atIndex:0];
            self.getPhotoCollection.contentOffset = CGPointMake(0, 0);
        }
        else
        {
            [self.cellcount removeObjectAtIndex:row];
        }
        [self.getPhotoCollection reloadData];
    }
}

#pragma mark -- 照片的点击事件
- (void)handleToTap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(handleToTapPhoto:)])
    {
        [self.delegate handleToTapPhoto:tap];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tagsCollectionView == collectionView)
    {
        for (TagsModel * model in self.tagsArr)
        {
            model.isSelected = NO;
        }
        if (self.tagsArr.count > indexPath.item)
        {
            TagsModel * selectModle = self.tagsArr[indexPath.item];
            selectModle.isSelected = YES;
            if ([self.delegate respondsToSelector:@selector(handleWithGoodsTag:)])
            {
                [self.delegate handleWithGoodsTag:selectModle.name];
            }
        }
        [self.tagsCollectionView reloadData];
    }
}

@end
