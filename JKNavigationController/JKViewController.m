//
//  JKViewController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/9.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import "JKViewController.h"
#import "JKNavigationController.h"
#import "TestViewController.h"
#import "JKAlertManager.h"


@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    /// 关闭全屏侧滑返回手势效果，会使用原生的侧滑效果
    
    self.jk_fullScreenPopGestrueEnabled = NO;
    
    
    self.navigationItem.title = @"测试";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAction)];
}


/**
 拦截返回按钮的点击事件实现JKNavigationControllerDelegate协议即视为拦截
 如果有拦截，会关闭全屏侧滑返回手势以及自带的侧滑返回手势
 */
//- (BOOL)jk_navigationController:(JKRootNavigationController *)navigationController
//                  shouldPopItem:(UINavigationItem *)item {
//    
//    JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:@"已拦截点击事件" message:@"是否继续返回"];
//    [manager configueCancelTitle:@"否" destructiveIndex:JKAlertDestructiveIndexNone otherTitles:@[@"返回"]];
//    [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//        
//        /// 手动跳转
//        if (actionIndex != tempAlertManager.cancelIndex) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
//    
//    return NO;/// 禁止跳转
//}



- (void)pushAction {
    [self.navigationController pushViewController:[TestViewController
                                                   new] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
