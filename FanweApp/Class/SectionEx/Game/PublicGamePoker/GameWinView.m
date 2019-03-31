//
//  GameWinView.m
//  FanweApp
//
//  Created by yy on 16/12/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GameWinView.h"
#import "GameGiftCell.h"
@implementation GameWinView

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.giftCollectionView.delegate = self;
    self.giftCollectionView.dataSource = self;
    self.giftView.hidden = YES;
    self.gratuityBtn.layer.cornerRadius = 15;
    self.gratuityBtn.layer.masksToBounds = YES;
    self.gratuityBtn.backgroundColor = kAppMainColor;
    self.giftCollectionView.backgroundColor = [UIColor whiteColor];
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"GameGiftCell" bundle:nil] forCellWithReuseIdentifier:@"GameGiftCell"];
    if ([GlobalVariables sharedInstance].appModel.open_diamond_game_module == 1)
    {
        self.gameCoinImageView.image = [UIImage imageNamed:@"com_diamond_1"];
    }
    else
    {
        self.gameCoinImageView.image = [UIImage imageNamed:@"gm_coin"];
    }
    self.closeView.userInteractionEnabled = YES;
    UITapGestureRecognizer * gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCloseView)];
    [self.closeView addGestureRecognizer:gester];
}

-(void)setModel:(GameGainModel *)model
{
    _model = model;
    [self.giftCollectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.gift_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameGiftCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GameGiftCell" forIndexPath:indexPath] ;
    cell.model = self.model.gift_list[indexPath.item];
    return cell ;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //选中之后礼物图标改变
    for (GiftModel * giftModel in self.model.gift_list) {
        giftModel.isSelected = NO;
    }
    GiftModel * selectModel = self.model.gift_list[indexPath.item];
    selectModel.isSelected = YES;
    self.model.gift_list[indexPath.item] = selectModel;
    [self.giftCollectionView reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

//点击打赏按钮
- (IBAction)clickGratuityBtn:(id)sender {
    BOOL haveSelected = NO;
    for (int i=0; i<self.model.gift_list.count; i++) {
        GiftModel *giftModel = self.model.gift_list[i];
        
        if (giftModel.isSelected) {
            
            if ([[IMAPlatform sharedInstance].host getDiamonds] < giftModel.diamonds) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"用户%@不足",self.fanweApp.appModel.diamond_name]];
               
                return;
            }
            //刷新用户信息
            haveSelected = YES;
            if (_delegate && [_delegate respondsToSelector:@selector(senGift:AndGiftModel:)]) {
                [_delegate senGift:nil AndGiftModel:giftModel];
            }
        }
    }
    if (!haveSelected) {
        [FanweMessage alertTWMessage:@"还没选择礼物哦"];
    }
}

-(void)clickCloseView
{
    if (_delegate && [_delegate respondsToSelector:@selector(gameWinViewDown)]) {
        [_delegate gameWinViewDown];
    }
}

@end
