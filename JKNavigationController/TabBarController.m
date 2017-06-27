//
//  TabBarController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "JKNavigationController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    HomeViewController * home_0 = [[HomeViewController alloc] init];
    JKRootNavigationController * nav_0 = [[JKRootNavigationController alloc] initWithRootViewController:home_0];
    nav_0.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    
    
    HomeViewController * home = [[HomeViewController alloc] init];
    JKRootNavigationController * nav = [[JKRootNavigationController alloc] initWithRootViewController:home];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    
    self.viewControllers = @[nav_0,nav];
}



@end
