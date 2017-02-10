//
//  JKViewController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/9.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import "JKViewController.h"
#import "JKNavigationController.h"

@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    /// 关闭全屏侧滑返回手势效果，会使用原生的侧滑效果
    self.jk_fullScreenPopGestrueEnabled = NO;
    
    
    self.navigationItem.title = @"测试";
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    /// 修改navigationBar的tintColor需要重绘返回按钮JKBackIndicatorButton的背景图，所以风中起来了。
    
    [self.navigationController.navigationBar jk_setTintColor:[UIColor purpleColor]];
    
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor]}];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
