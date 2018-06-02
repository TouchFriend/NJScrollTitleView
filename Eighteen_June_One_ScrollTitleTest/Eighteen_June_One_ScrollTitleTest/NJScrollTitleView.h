//
//  ScrollTitleView.h
//  Eighteen_June_One_ScrollTitleTest
//
//  Created by TouchWorld on 2018/6/1.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJScrollTitleView;
@protocol NJScrollTitleViewDelegate <NSObject>
@optional


/**
 点击了cell

 @param scrollTitleView scrollTitleView
 @param index cell的对应下标
 */
- (void)scrollTitleView:(NJScrollTitleView *)scrollTitleView didSelectItemAtIndex:(NSInteger)index;


/**
 scrollTitleView滚动，返回对应的下标

 @param scrollTitleView scrollTitleView
 @param index 下标
 */
- (void)scrollTitleView:(NJScrollTitleView *)scrollTitleView didScrollToIndex:(NSInteger)index;

@end

//如果想要自定义cell，实现下面代理
@protocol NJScrollTitleViewDataSource <NSObject>
@required

/**
 自定义cell的个数

 @param scrollTitleView scrollTitleView
 @return 个数
 */
- (NSInteger)numberOfViewsInScrollTitleView:(NJScrollTitleView *)scrollTitleView;


/**
 对应位置上的自定义cell

 @param scrollTitleView scrollTitleView
 @param index 下标
 @return 自定义cell
 */
- (nullable UIView *)scrollTitleView:(NJScrollTitleView *)scrollTitleView viewForRowAtIndex:(NSInteger)index;

@end

@interface NJScrollTitleView : UIView

+ (instancetype)scrollTitleViewWithFrame:(CGRect)frame delegate:(id<NJScrollTitleViewDelegate>)delegate;

+ (instancetype)scrollTitleViewWithFrame:(CGRect)frame delegate:(id<NJScrollTitleViewDelegate>)delegate dataSource:(id<NJScrollTitleViewDataSource>)dataSource;

/********* 标题数据 *********/
@property(nonatomic,strong)NSArray<NSString *> * titleArr;

/********* 代理 *********/
@property(nonatomic,weak)id<NJScrollTitleViewDelegate> delegate;

/********* 数据源 （自定义cell时实现） *********/
@property(nonatomic,weak)id<NJScrollTitleViewDataSource> dataSource;

/********* 文字字体大小 默认16 *********/
@property(nonatomic,strong)UIFont * textFont;

/********* 文字颜色 默认黑色 *********/
@property(nonatomic,strong)UIColor * textColor;

/********* 对齐方式 默认居中 *********/
@property(nonatomic,assign)NSTextAlignment textAlignment;


//当前坐标
- (NSInteger)currentIndex;

@end
