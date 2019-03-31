//
//  FWPhotoManager.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWPhotoManager.h"
#import "PersonCenterListModel.h"
#import "CommentModel.h"

@implementation FWPhotoManager

- (void)goToPhotoWithVC:(UIViewController *)myVC withTag:(int)itemTag withModel:(PersonCenterListModel *)itemModel
{
  
    NSMutableArray *photoArray = [[NSMutableArray alloc]init];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[itemModel.images[itemTag] toString:@"orginal_url"]] placeholderImage:kDefaultPreloadHeadImg];
    for (int i=0; i<[itemModel.images count]; i++)
    {
        NSString * FileUrl = [itemModel.images[i] toString:@"orginal_url"];
        NSURL * url = [NSURL URLWithString:FileUrl];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photoArray addObject:photo];
    }
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc]initWithPhotos:photoArray animatedFromView:imageView];
    browser.doneButtonImage = [UIImage imageNamed:@"fw_personCenter_whiteMore"];
    [browser setInitialPageIndex:itemTag];
    browser.displayActionButton = YES;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
    [myVC presentViewController:browser animated:YES completion:nil ];
}

- (void)goToPhotoWithVC:(UIViewController *)myVC withMyTag:(int)MyTag withModel:(CommentModel *)commentModel withMArr:(NSMutableArray *)MArr
{
    NSMutableArray *photoArray = [[NSMutableArray alloc]init];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:commentModel.orginal_url] placeholderImage:kDefaultPreloadHeadImg];
    for (int i=0; i<[MArr count]; i++)
    {
        CommentModel *CModel =MArr[i];
        NSString * FileUrl = CModel.orginal_url;
        NSURL * url = [NSURL URLWithString:FileUrl];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photoArray addObject:photo];
    }
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc]initWithPhotos:photoArray animatedFromView:imageView];
    browser.doneButtonImage = [UIImage imageNamed:@"fw_personCenter_whiteMore"];
    [browser setInitialPageIndex:MyTag];
    //browser.delegate = self;
    browser.displayActionButton = YES;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
    [myVC presentViewController:browser animated:YES completion:nil ];
}

- (void)goToPhotoWithVC:(UIViewController *)myVC withMyTag:(int)MyTag withMArr:(NSMutableArray *)MArr withDelegate:(id<IDMPhotoBrowserDelegate>)deleagte
{
    NSMutableArray *photoArray = [[NSMutableArray alloc]init];
    UIImageView *imageView = [[UIImageView alloc]init];
    NSDictionary *item = MArr[MyTag-1];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[item objectForKey:@"orginal_url"]] placeholderImage:kDefaultPreloadHeadImg];
    for (int i=0; i<[MArr count]; i++) {
        NSDictionary *imgDict = MArr[i];
        NSString * FileUrl = [imgDict objectForKey:@"orginal_url"];
        NSURL * url = [NSURL URLWithString:FileUrl];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photoArray addObject:photo];
    }
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc]initWithPhotos:photoArray animatedFromView:imageView];
    browser.doneButtonImage = [UIImage imageNamed:@"fw_personCenter_whiteMore"];
    [browser setInitialPageIndex:MyTag-1];
    browser.delegate = deleagte;
    browser.displayActionButton = YES;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
    [myVC presentViewController:browser animated:YES completion:nil];
}

@end
