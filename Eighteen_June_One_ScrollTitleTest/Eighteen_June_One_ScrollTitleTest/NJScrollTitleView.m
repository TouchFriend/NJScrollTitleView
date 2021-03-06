//
//  ScrollTitleView.m
//  Eighteen_June_One_ScrollTitleTest
//
//  Created by TouchWorld on 2018/6/1.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJScrollTitleView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NJScrollTitleView () <UIScrollViewDelegate>
/********* 数据 *********/
@property(nonatomic,strong)NSArray<NSString *> * dataArr;

/********* scrollView *********/
@property(nonatomic,weak)UIScrollView * scrollView;

/********* 定时器 *********/
@property(nonatomic,weak)NSTimer * timer;

/********* <#注释#> *********/
@property(nonatomic,assign)NSInteger viewCount;

@end
@implementation NJScrollTitleView

+ (instancetype)scrollTitleViewWithFrame:(CGRect)frame delegate:(id<NJScrollTitleViewDelegate>)delegate
{
    NJScrollTitleView * scrollTitleView = [[self alloc] initWithFrame:frame];
    scrollTitleView.delegate = delegate;
    
    return scrollTitleView;
}

+ (instancetype)scrollTitleViewWithFrame:(CGRect)frame delegate:(id<NJScrollTitleViewDelegate>)delegate dataSource:(id<NJScrollTitleViewDataSource>)dataSource
{
    NJScrollTitleView * scrollTitleView = [self scrollTitleViewWithFrame:frame delegate:delegate];
    scrollTitleView.dataSource = dataSource;
    return scrollTitleView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
        
        
    }
    return self;
}


//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if(!newSuperview)
    {
        [self invaditeTimer];
    }
}



#pragma mark - 设置初始化
- (void)setupInit
{
    [self setupScrollView];
    
    [self initSetting];
}

#pragma mark - scrollView
- (void)setupScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = self.bounds;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    scrollView.backgroundColor = [UIColor orangeColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    scrollView.scrollEnabled = NO;
}

#pragma mark - 配置
- (void)initSetting
{
    self.textFont = [UIFont systemFontOfSize:16.0];
    
    self.textColor = [UIColor blackColor];
    
    self.textAlignment = NSTextAlignmentCenter;
}

- (void)setupTimer
{
    [self invaditeTimer];// 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerSelecter) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timerSelecter
{
    CGPoint offset = self.scrollView.contentOffset;
    offset = CGPointMake(offset.x, offset.y + self.scrollView.bounds.size.height);
//    NSLog(@"%@", NSStringFromCGPoint(offset));
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint offset = scrollView.contentOffset;
    
    CGFloat scrollViewHeight = scrollView.bounds.size.height;
    
    if((NSInteger)offset.y % (NSInteger)scrollViewHeight != 0)
    {
        return;
    }
    
//    NSLog(@"%@", NSStringFromCGPoint(offset));
    
    if(offset.y == 0)
    {
        scrollView.contentOffset = CGPointMake(offset.x, scrollViewHeight * (self.viewCount - 2));
    }
    
    if(offset.y == scrollViewHeight * (self.viewCount - 1))
    {
        scrollView.contentOffset = CGPointMake(offset.x, scrollViewHeight);
    }
    
    if([self.delegate respondsToSelector:@selector(scrollTitleView:didScrollToIndex:)])
    {
        [self.delegate scrollTitleView:self didScrollToIndex:[self currentIndex]];
    }
    
//    NSLog(@"currentIndex:%ld", [self currentIndex]);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invaditeTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self setupTimer];
}

#pragma mark - 事件
- (void)tempViewClick:(UIView *)tempView
{
    NSLog(@"%s", __func__);
    if([self.delegate respondsToSelector:@selector(scrollTitleView:didSelectItemAtIndex:)])
    {
        [self.delegate scrollTitleView:self didSelectItemAtIndex:[self currentIndex]];
    }
}

#pragma mark - 自定义view
- (void)setDataSource:(id<NJScrollTitleViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self loadCustomViews];
}

//加载定义views
- (void)loadCustomViews
{
    if([self isImplementDataSourceMethod])
    {
        [self invaditeTimer];
        
        //定时器无效
        [self invaditeTimer];
        
        //清除scrollView子view
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSInteger count = [self.dataSource numberOfViewsInScrollTitleView:self];
        if(count == 0)
        {
            NSLog(@"%s:无数据", __func__);
            return;
        }
        
        
        NSMutableArray<UIView *> * tempViewArrM = [NSMutableArray array];
        
        for (NSInteger i = 0; i < count; i++) {
            
            UIView * tempView = [self.dataSource scrollTitleView:self viewForRowAtIndex:i];
            
            [tempViewArrM addObject:tempView];
            
        }
        
        UIView * firstTempView = [self.dataSource scrollTitleView:self viewForRowAtIndex:0];
        
        UIView * lastTempView = [self.dataSource scrollTitleView:self viewForRowAtIndex:count - 1];
        
        [tempViewArrM insertObject:lastTempView atIndex:0];
        [tempViewArrM addObject:firstTempView];
        
        self.viewCount = tempViewArrM.count;
        
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        
        CGFloat tempViewWidth = scrollViewSize.width;
        CGFloat tempViewHeight = scrollViewSize.height;
        [tempViewArrM enumerateObjectsUsingBlock:^(UIView * _Nonnull tempView, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat tempViewY = idx * tempViewHeight;
            tempView.frame = CGRectMake(0, tempViewY, tempViewWidth, tempViewHeight);
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tempViewClick:)];
            [tempView addGestureRecognizer:tapGesture];
            
            [self.scrollView addSubview:tempView];
            
        }];
        
        self.scrollView.contentSize = CGSizeMake(scrollViewSize.width, scrollViewSize.height * tempViewArrM.count);
        self.scrollView.contentOffset = CGPointMake(0, scrollViewSize.height);
        
        //设置定时器
        [self setupTimer];
        
    }
}

//是否实现dataSource方法
- (BOOL)isImplementDataSourceMethod
{
    if(self.dataSource == nil)
    {
        return NO;
    }
    
    return ([self.dataSource respondsToSelector:@selector(numberOfViewsInScrollTitleView:)] && [self.dataSource respondsToSelector:@selector(scrollTitleView:viewForRowAtIndex:)]);
}

- (void)reloadData
{
    [self loadCustomViews];
}

#pragma mark - 其他

- (NSInteger)currentIndex
{
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    if(scrollViewSize.width == 0 || scrollViewSize.height == 0)
    {
        return 0;
    }
    
    NSInteger index = 0;
    
    index = (self.scrollView.contentOffset.y + scrollViewSize.height * 0.5) / scrollViewSize.height;
    
    index = MAX(0, index - 1);
    index = MIN(index, self.viewCount - 3);
    return MAX(0, index);
}

- (void)setTitleArr:(NSArray<NSString *> *)titleArr
{
    _titleArr = titleArr;

    //定时器无效
    [self invaditeTimer];
    
    //清除scrollView子view
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    NSMutableArray<NSString *> * titleArrM = [NSMutableArray arrayWithArray:[titleArr copy]];
    
    if(titleArrM.count <= 0)
    {
        return ;
    }
    
    
    [titleArrM insertObject:titleArr.lastObject atIndex:0];
    [titleArrM addObject:titleArr.firstObject];
    
    self.dataArr = [NSArray arrayWithArray:titleArrM];
    
    self.viewCount = self.dataArr.count;
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    self.scrollView.contentSize = CGSizeMake(scrollViewSize.width, scrollViewSize.height * self.dataArr.count);
    self.scrollView.contentOffset = CGPointMake(0, scrollViewSize.height);
    
    
    CGFloat tempViewWidth = scrollViewSize.width;
    CGFloat tempViewHeight = scrollViewSize.height;
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        CGFloat tempViewY = i * tempViewHeight;
        UIView * tempView = [[UIView alloc] initWithFrame:CGRectMake(0, tempViewY, tempViewWidth, tempViewHeight)];
        
        UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tempView.bounds.size.width, tempView.bounds.size.height)];
        tempLabel.text = self.dataArr[i];
        tempLabel.textColor = self.textColor;
        tempLabel.font = self.textFont;
        tempLabel.textAlignment = self.textAlignment;
        [tempView addSubview:tempLabel];
        
        //点击手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tempViewClick:)];
        [tempView addGestureRecognizer:tapGesture];
        
        [self.scrollView addSubview:tempView];
    }
    
    //设置定时器
    [self setupTimer];
}

- (void)invaditeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}



- (void)dealloc
{
    //定时器无效
    [self.timer invalidate];
}
@end
