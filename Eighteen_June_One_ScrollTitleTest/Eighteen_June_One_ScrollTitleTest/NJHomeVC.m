//
//  NJHomeVC.m
//  Eighteen_June_One_ScrollTitleTest
//
//  Created by TouchWorld on 2018/6/2.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJHomeVC.h"
#import "NJCommonUseVC.h"
#import "NJCustomViewVC.h"

@interface NJHomeVC ()
- (IBAction)btnClick:(UIButton *)sender;
@end

@implementation NJHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 10://常用使用
        {
            NJCommonUseVC * commonUseVC = [[NJCommonUseVC alloc] init];
            [self.navigationController pushViewController:commonUseVC animated:YES];
        
            
        }
            break;
        case 11://自定义view
        {
            NJCustomViewVC * customViewVC = [[NJCustomViewVC alloc] init];
            [self.navigationController pushViewController:customViewVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
