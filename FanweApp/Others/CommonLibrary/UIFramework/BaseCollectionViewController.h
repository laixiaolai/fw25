//
//  BaseCollectionViewController.h
//  CommonLibrary
//
//  Created by Alexi on 3/12/14.
//  Copyright (c) 2014 CommonLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewController : UICollectionViewController

- (UICollectionViewLayout *)collectionLayout;

- (NSString *)cellIdentifier;

- (void)configCollectionView;

@end
