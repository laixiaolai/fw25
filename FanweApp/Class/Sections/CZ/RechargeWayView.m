//
//  RechargeWayView.m
//  FanweApp
//
//  Created by 王珂 on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RechargeWayView.h"
@implementation RechargeWayView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init] ;
        CGFloat itemW = (self.width-40)/3.0;
        CGFloat itemH = 45;
        //设置cell的大小
        flow.itemSize = CGSizeMake(itemW, itemH) ;
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        flow.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10) ;
        flow.scrollDirection = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, 75) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        //    _collectionView.pagingEnabled = YES;
         _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"RechargeWayCell" bundle:nil] forCellWithReuseIdentifier:@"RechargeWayCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setRechargeWayArr:(NSArray *)rechargeWayArr
{
    _rechargeWayArr = rechargeWayArr;
    for (PayTypeModel * model in _rechargeWayArr) {
        NSString * string;
        if (model.name.length>0) {
            string = model.name;
        }
        else
        {
            if ([model.class_name isEqual:@"Aliapp"]) {
                string = @"支付宝";
            }
            else if ([model.class_name isEqual:@"Iappay"])
            {
                string = @"苹果内购";
            }
            else if ([model.class_name isEqual:@"WxApp"])
            {
                string = @"微信支付";
            }
        }
        model.name = string;
    }
    NSInteger count = rechargeWayArr.count;
    if (count>3) {
        self.selectIndex = 0;
        _collectionView.hidden = NO;
        //[self addSubview:_collectionView];
    }
    else
    {
        _collectionView.hidden = YES;
        [_collectionView removeFromSuperview];
        while (self.subviews.count<count) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = kAppRechargeBtnColor;
            button.layer.cornerRadius = 12.5;
            button.layer.masksToBounds = YES;
            button.titleLabel.font = kAppSmallTextFont;
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = kAppGrayColor1.CGColor;
            [self addSubview:button];
        }
        CGFloat width = count >3 ? (self.width-10*(count+1))/count:(self.width-40)/3;
        CGFloat height = 25;
        for (NSInteger i=0; i<self.subviews.count; ++i) {
            UIButton * button = self.subviews[i];
            PayTypeModel *model = rechargeWayArr[i];
            NSString * string;
            if (model.name.length>0) {
                string = model.name;
            }
            else
            {
                if ([model.class_name isEqual:@"Aliapp"]) {
                    string = @"支付宝";
                }
                else if ([model.class_name isEqual:@"Iappay"])
                {
                    string = @"苹果内购";
                }
                else if ([model.class_name isEqual:@"WxApp"])
                {
                    string = @"微信支付";
                }
            }
            if (i<count) {
                button.frame = CGRectMake((i+1)*10+i*width, 25, width, height);
                [button setTitle:string forState:UIControlStateNormal];
                [button setTitleColor:kAppRechargeSelectColor forState:UIControlStateNormal];
                [button addTarget:self action:@selector(choseWayBtn:) forControlEvents:UIControlEventTouchUpInside];
                if (i==_selectIndex) {
                    button.backgroundColor = kAppGrayColor1;
                    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
                }
                else
                {
                    button.backgroundColor = kWhiteColor;
                    [button setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
                }
            }
            else
            {
                button.hidden = YES;
            }
        }
        if (count<3) {
            if (count == 1) {
                UIButton * button = self.subviews[0];
                button.frame = CGRectMake((self.width-width)/2, 25, width, height);
            }
            else if (count == 2)
            {
                UIButton * oneButton = self.subviews[0];
                oneButton.frame = CGRectMake((self.width-width*2)/3, 25, width, height);
                UIButton * twoButton = self.subviews[1];
                twoButton.frame = CGRectMake(width+(self.width-width*2)/3*2, 25, width, height);
            }
        }

    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    for (int i=0; i<self.rechargeWayArr.count; ++i) {
         PayTypeModel *model = _rechargeWayArr[i];
        if (i != selectIndex) {
            model.isSelect = NO;
        }
        else
        {
            model.isSelect = YES;
        }
    }
    if (self.rechargeWayArr.count>3) {
        //self.collectionView.contentOffset = CGPointMake(self.width*(selectIndex/3), 0);
        [self.collectionView reloadData];
    }
    else
    {
        if (self.subviews.count>_selectIndex) {
            for (UIButton * button in self.subviews) {
                button.backgroundColor = kWhiteColor;
                [button setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
            }
            _selectIndex = selectIndex;
            UIButton * selectButton = self.subviews[_selectIndex];
            selectButton.backgroundColor = kAppGrayColor1;
            [selectButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        }
    }
}

- (void)choseWayBtn:(UIButton *) button
{
    for (int i=0; i<self.subviews.count; ++i) {
        if ([self.subviews[i] isEqual:button]) {
            _nowIndex = i;
        }
    }
    for (UIButton * button in self.subviews) {
        button.backgroundColor = kWhiteColor;
        [button setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    }
    _selectIndex = _nowIndex;
    button.backgroundColor = kAppGrayColor1;
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(choseRechargeWayWithIndex:)]) {
        [_delegate choseRechargeWayWithIndex:_selectIndex];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(choseRechargeWayWithWayName:)]) {
        PayTypeModel *model = self.rechargeWayArr[_selectIndex];
        [_delegate choseRechargeWayWithWayName:model.class_name];
    }
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.rechargeWayArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeWayCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RechargeWayCell" forIndexPath:indexPath] ;
    cell.model = self.rechargeWayArr[indexPath.item];
    cell.delegate = self;
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self clickCellWith:indexPath];
}

- (void)clickWithRechargeWayCell:(RechargeWayCell *)cell
{
    NSIndexPath * indexPath = [_collectionView indexPathForCell:cell];
    [self clickCellWith:indexPath];
}

- (void)clickCellWith:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.selectIndex) {
        return;
    }
    else
    {
        self.selectIndex = indexPath.item;
        if (_delegate && [_delegate respondsToSelector:@selector(choseRechargeWayWithIndex:)]) {
            [_delegate choseRechargeWayWithIndex:_selectIndex];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(choseRechargeWayWithWayName:)]) {
            PayTypeModel *model = self.rechargeWayArr[_selectIndex];
            [_delegate choseRechargeWayWithWayName:model.class_name];
        }
    }

}

@end
