//
//  TabBarController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "JKNavigationController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray * vcs = self.viewControllers;
    
    HomeViewController * home = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    JKRootNavigationController * nav = [[JKRootNavigationController alloc] initWithRootViewController:home];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    
    self.viewControllers = @[vcs.firstObject,nav];
}



@end
