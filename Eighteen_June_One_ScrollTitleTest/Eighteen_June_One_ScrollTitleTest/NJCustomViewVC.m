//
//  NJCustomViewVC.m
//  Eighteen_June_One_ScrollTitleTest
//
//  Created by TouchWorld on 2018/6/2.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJCustomViewVC.h"
#import "NJScrollTitleView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NJCustomViewVC () <NJScrollTitleViewDelegate, NJScrollTitleViewDataSource>

/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NSString *> * titleArr;

@end

@implementation NJCustomViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NJScrollTitleView * scrollTitleView = [NJScrollTitleView scrollTitleViewWithFrame:CGRectMake(0, 100, ScreenWidth, 200) delegate:self dataSource:self];

    
    [self.view addSubview:scrollTitleView];
}

#pragma mark - NJScrollTitleViewDataSource方法
- (NSInteger)numberOfViewsInScrollTitleView:(NJScrollTitleView *)scrollTitleView
{
    return self.titleArr.count;
}

- (UIView *)scrollTitleView:(NJScrollTitleView *)scrollTitleView viewForRowAtIndex:(NSInteger)index
{
    UIView * tempView = [[UIView alloc] init];
    tempView.backgroundColor = [UIColor blueColor];
    
    UILabel * textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    textlabel.text = self.titleArr[index];
    textlabel.textColor = [UIColor blueColor];
    textlabel.font = [UIFont systemFontOfSize:21];
    textlabel.backgroundColor = [UIColor yellowColor];
    [tempView addSubview:textlabel];
    
    UIImageView * iconImageV = [[UIImageView alloc] init];
    iconImageV.image = [UIImage imageNamed:@"side"];
    iconImageV.frame = CGRectMake((ScreenWidth - 50) * 0.5, 50, 100, 50);
    [tempView addSubview:iconImageV];
    
    return tempView;
}

#pragma mark - NJScrollTitleViewDelegate方法
- (void)scrollTitleView:(NJScrollTitleView *)scrollTitleView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%s-%ld", __func__, index);
}

- (void)scrollTitleView:(NJScrollTitleView *)scrollTitleView didScrollToIndex:(NSInteger)index
{
    NSLog(@"%s-%ld", __func__, index);
}


#pragma mark - 懒加载
- (NSArray<NSString *> *)titleArr
{
    if(_titleArr == nil)
    {
        _titleArr = @[
                      @"111",
                      @"222",
                      @"333",
                      @"444",
                      ];
    }
    return _titleArr;
}
@end
