//
//  NewFeatureController.h
//  FanweApp
//
//  Created by xfg on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "NewFeatureController.h"

#define  AdVCount 60    // AdVCount秒后客户未点击自动进入登入界面

@interface NewFeatureController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *page;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat imageW;   // 图片宽度
@property (assign, nonatomic) CGFloat imageH;   // 图片高度
@property (assign, nonatomic) NSInteger NewFeaturePhotosCount;   // 告诉我显示图片的数量
@property (copy, nonatomic) void(^myBlock)();

@end

@implementation NewFeatureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _count = AdVCount;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    //告诉控制器显示多少张图片
    if ([self.Datasourse respondsToSelector:@selector(NewFeatureControllerPhotosNumber)])
    {
        _NewFeaturePhotosCount=[self.Datasourse NewFeatureControllerPhotosNumber];
    }

    [self showNewFeaturePhotos];
}

#pragma mark 定时器
- (void)timeGo
{
    _count--;
    if (_count == 0)
    {
        [_timer invalidate];
        self.myBlock();
    }
}

#pragma mark 初始化UIScrollView和UIPageControl
- (void)InitScrollViewAndPageControl
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //设置弹簧属性为NO；
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    _imageW = scrollView.frame.size.width;
    _imageH = scrollView.frame.size.height;
    //成为scrollView的代理
    scrollView.delegate=self;
    scrollView.pagingEnabled=YES;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    //初始化UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    CGPoint center = CGPointMake(scrollView.frame.size.width*0.5, scrollView.frame.size.height*0.85);
    pageControl.center = center;
    pageControl.pageIndicatorTintColor = RGB(198, 198, 198);
    pageControl.currentPageIndicatorTintColor = RGB(253, 98, 42);
    self.page = pageControl;
    [self.view addSubview:pageControl];
}

#pragma mark 显示图片
- (void)showNewFeaturePhotos
{
    [self InitScrollViewAndPageControl];
    //UIPageControl 可以不设置尺寸，但是要设置numberOfPages；
    _page.numberOfPages=self.self.NewFeaturePhotosCount;;
    //contentSize是scrollview可以滚动的区域
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width*self.NewFeaturePhotosCount, 0);
    for (int i=1; i<=self.NewFeaturePhotosCount; i++)
    {
        UIImageView *imageView;
        if ([self.Datasourse respondsToSelector:@selector(NewFeatureControllerImageViewIndex:)])
        {
            imageView = [self.Datasourse NewFeatureControllerImageViewIndex:i];
            imageView.frame = CGRectMake(_imageW*(i-1), 0, _imageW, _imageH);
            [_scrollView addSubview:imageView];
        }
       
        if(i == self.NewFeaturePhotosCount)
        {
            //如果是最后一张设置最后一张的图片
            [self setLastImageView:imageView];
        }
    }
}

/**
 设置最后一张图片的立即体验

 @param imageView 新特性的最后一张图片
 */
- (void)setLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled=YES;

    // 开始体验
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = (CGRect){{0.0},CGSizeMake(100, 35)};
    CGPoint center = CGPointMake(imageView.frame.size.width*0.5, ExpBtnBackY);
    startBtn.center = center;
    startBtn.layer.cornerRadius = kCornerRadius;
    startBtn.layer.borderWidth = kBorderWidth;
    startBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [startBtn setBackgroundColor:ExpBtnBackGroundColor];
    startBtn.clipsToBounds = YES;
    [startBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}

#pragma mark 最后一页立即体验按钮点击执行此方法
- (void)startClick
{
    [self removeFromParentViewController];
    if ([self.delegate respondsToSelector:@selector(startAppClick)])
    {
        [self.delegate startAppClick];
    }
    else
    {
        self.myBlock();
    }
}

#pragma mark 监听scrollView的滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     double width=[UIScreen mainScreen].bounds.size.width;
    CGPoint point=scrollView.contentOffset;
    self.page.currentPage=(int)point.x/width+0.5;
}

#pragma mark 设置开始进入APP的Block
- (void)setStartAppBlock:(void(^)())blockHangler
{
    self.myBlock=blockHangler;
}

@end
