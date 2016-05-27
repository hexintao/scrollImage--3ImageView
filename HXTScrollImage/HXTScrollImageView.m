//
//  HXTScrollImageView.m
//  HXTScrollImage
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HXTScrollImageView.h"

#define IMG_VIEW_NUM 3

@interface HXTScrollImageView () <UIScrollViewDelegate>
@property (assign,nonatomic) CGFloat screenWidth;
@property (assign,nonatomic) CGFloat screenHeight;

@property (strong,nonatomic) UIScrollView *rootScrollView;
@property (assign,nonatomic) CGRect scrollViewFrame;

@property (copy,nonatomic) NSArray *imageNames;
@property (assign,nonatomic) NSInteger imageNum;
@property (strong,nonatomic) NSTimer *timer_2s;
@property (assign,nonatomic) NSInteger currentPage;
@property (strong,nonatomic) UIPageControl *imagePage;
@end

@implementation HXTScrollImageView

#pragma mark- 懒加载
- (CGRect)scrollViewFrame
{
    if (!_scrollViewFrame.size.width && !_scrollViewFrame.size.height)
    {
        _scrollViewFrame = self.rootScrollView.frame;
    }
    return _scrollViewFrame;
}

- (CGFloat)screenWidth
{
    if (!_screenWidth)
    {
        _screenWidth = [[UIScreen mainScreen]bounds].size.width;
    }
    return _screenWidth;
}

- (CGFloat)screenHeight
{
    if (!_screenHeight)
    {
        _screenHeight = [[UIScreen mainScreen]bounds].size.height;
    }
    return _screenHeight;
}

#pragma mark- 类方法加载图片循环视图
+ (instancetype)viewWithImgNameArr:(NSArray *)nameArr frame:(CGRect)frame
{
    return [[self alloc]initWithImgNameArr:nameArr frame:frame];
}

#pragma mark- 实例方法加载图片循环视图
- (instancetype)initWithImgNameArr:(NSArray *)nameArr frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageNum = [nameArr count];
        self.imageNames = nameArr;
        self.rootScrollView = [[UIScrollView alloc]initWithFrame:frame];
        self.rootScrollView.pagingEnabled = YES;
        self.rootScrollView.contentSize = CGSizeMake(self.screenWidth * IMG_VIEW_NUM, 0);
        self.rootScrollView.showsHorizontalScrollIndicator = NO;
        self.rootScrollView.delegate = self;
        [self addSubview:self.rootScrollView];
        
        for(int i = 0; i < IMG_VIEW_NUM; i++)
        {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(i * self.screenWidth, 0, self.scrollViewFrame.size.width, self.scrollViewFrame.size.height);
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapImageGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
            [imageView addGestureRecognizer:tapImageGesture];
            
            [self.rootScrollView addSubview:imageView];
        }
        
        //指向中间
        self.rootScrollView.contentOffset = CGPointMake(self.screenWidth, 0);
        
        self.imagePage = [[UIPageControl alloc]initWithFrame:CGRectMake(0,self.scrollViewFrame.size.height - 37,self.scrollViewFrame.size.width, 37)];
        
        self.imagePage.numberOfPages = self.imageNum;
        self.imagePage.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.imagePage.pageIndicatorTintColor = [UIColor blackColor];
        self.imagePage.currentPage = 0;
        [self addSubview:self.imagePage];
        [self addTimer];
        
        self.currentPage = 0;
        [self updateImage];
    }
    return self;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(HXTScrollImageView:didTapImageIndex:)])
    {
        [self.delegate HXTScrollImageView:self didTapImageIndex:self.imagePage.currentPage];
    }
}

- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(autoNextPage) userInfo:nil repeats:YES];
    self.timer_2s = timer;
    [[NSRunLoop mainRunLoop]addTimer:self.timer_2s forMode:UITrackingRunLoopMode];
}

- (void)invalidTimer
{
    [self.timer_2s invalidate];
    self.timer_2s = nil;
}

- (void)autoNextPage
{
    //首先应设置到显示leftImageView，否则下边的动画效果出不来，执行很快速，所以并不会真的显示出来
    self.rootScrollView.contentOffset = CGPointMake(0, 0);
    self.currentPage++;
    
    //到最后一张之后切换到第一张
    if (self.currentPage >= self.imageNum)
    {
        self.currentPage = 0;
    }
    [self updateImage];
    
    //动画切换到middleImageView
    [self.rootScrollView setContentOffset:CGPointMake(self.screenWidth, 0) animated:YES];
}

- (void)updateImage
{
    UIImageView *leftImageView = self.rootScrollView.subviews[0];
    UIImageView *middleImageView = self.rootScrollView.subviews[1];
    UIImageView *rightImageView = self.rootScrollView.subviews[2];
    
    NSInteger leftIndex, rightIndex;
    
    NSInteger currentPage = self.currentPage;
    
    //如果当前显示第一张图片，设置leftImageView显示最后一张
    if (currentPage == 0)
    {
        leftIndex = self.imageNum-1;
        rightIndex = currentPage + 1;
    }
    //如果当前显示最后一张图片，设置rightImageView显示第一张
    else if (currentPage == (self.imageNum-1))
    {
        leftIndex = currentPage - 1;
        rightIndex = 0;
    }
    //正常情况下的左、右显示设置
    else
    {
        rightIndex = currentPage + 1;
        leftIndex = currentPage - 1;
    }
    
    leftImageView.image = [UIImage imageNamed:self.imageNames[leftIndex]];
    middleImageView.image = [UIImage imageNamed:self.imageNames[currentPage]];
    rightImageView.image = [UIImage imageNamed:self.imageNames[rightIndex]];
    
    //设置页码
    self.imagePage.currentPage = currentPage;
}

#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //始终显示中间，所以超过一个屏幕则为向右滑动
    if(offsetX > self.screenWidth)
    {
        self.currentPage++;
        //滑动到最后一张之后切换到第一张
        if (self.currentPage >= self.imageNum)
        {
            self.currentPage = 0;
        }
    }
    //始终显示中间，所以不超过一个屏幕则为向左滑动
    else if(offsetX < self.screenWidth)
    {
        self.currentPage--;
        //向左滑动到第一张之后进入最后一张
        if (self.currentPage < 0)
        {
            self.currentPage = self.imageNum - 1;
        }
    }
    //更新图片
    [self updateImage];
    
    //无动画切换到middleImageView
    self.rootScrollView.contentOffset = CGPointMake(self.screenWidth, 0);
}

@end
