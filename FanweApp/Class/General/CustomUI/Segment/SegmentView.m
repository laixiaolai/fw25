//
//  SegmentView.m
//  live
//
//  Created by hysd on 15/8/19.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "SegmentView.h"

@interface SegmentView()
{
    int _itemCount;
}

@end


@implementation SegmentView

- (id)initWithFrame:(CGRect)frame andItems:(NSArray*)items andSize:(NSInteger)size border:(BOOL)border isrankingRist:(BOOL)isrankingRist
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _itemCount = (int)items.count;
        self.segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        for(int index = 0; index < items.count; index++)
        {
            [self.segmentControl insertSegmentWithTitle:items[index] atIndex:index animated:NO];
        }
        self.segmentControl.selectedSegmentIndex = 1;
        self.segmentControl.tintColor = kWhiteColor;
        self.segmentControl.backgroundColor = kClearColor;
        [self.segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        if (isrankingRist)
        {
            NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: kAppMainColor};
            [self.segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
            NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: kGrayColor};
            [self.segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        }
        else
        {
            NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: kAppMainColor};
            [self.segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
            NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: kGrayColor};
            [self.segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
            _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/(4*items.count), frame.size.height-3, frame.size.width/(2*items.count), 3)];
            _indicatorView.backgroundColor = kAppMainColor;
        }
        
        [self addSubview:self.segmentControl];
        if(border)
        {
            UIView* sep = [[UIView alloc] initWithFrame:CGRectMake(0, self.segmentControl.frame.size.height-1, self.segmentControl.frame.size.width, 1)];
            sep.backgroundColor = kWhiteColor;
            [self.segmentControl addSubview:sep];
        }
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)segmentChanged:(id)sender
{
    
    NSInteger newX = self.segmentControl.selectedSegmentIndex *_indicatorView.frame.size.width*2+_indicatorView.frame.size.width/2;
    [UIView animateWithDuration:0.2f animations:^{
        _indicatorView.frame = CGRectMake(newX, _indicatorView.frame.origin.y, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
    }];
    
    if(self.delegate)
    {
        [self.delegate segmentView:self selectIndex:self.segmentControl.selectedSegmentIndex];
    }
}

- (void)setSelectIndex:(NSInteger)index
{
    self.segmentControl.selectedSegmentIndex = index;
    // NSInteger newX = segmentControl.selectedSegmentIndex * indicatorView.frame.size.width;
    NSInteger newX = self.segmentControl.selectedSegmentIndex *_indicatorView.frame.size.width*2+_indicatorView.frame.size.width/2;
    [UIView animateWithDuration:0.2f animations:^{
        _indicatorView.frame = CGRectMake(newX, _indicatorView.frame.origin.y, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
    }];
}

- (NSInteger)getSelectIndex
{
    return self.segmentControl.selectedSegmentIndex;
}

- (void)changeIndex
{
    self.segmentControl.selectedSegmentIndex = 1;
    [self segmentChanged:self.segmentControl];
}

@end
