//
//  NJCommonUseVC.m
//  Eighteen_June_One_ScrollTitleTest
//
//  Created by TouchWorld on 2018/6/2.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJCommonUseVC.h"
#import "NJScrollTitleView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NJCommonUseVC () <NJScrollTitleViewDelegate>
/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NSString *> * titleArr;
@end

@implementation NJCommonUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NJScrollTitleView * scrollTitleView = [NJScrollTitleView scrollTitleViewWithFrame:CGRectMake(0, 100, ScreenWidth, 200) delegate:self];
    scrollTitleView.titleArr = self.titleArr;
    [self.view addSubview:scrollTitleView];
    
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
