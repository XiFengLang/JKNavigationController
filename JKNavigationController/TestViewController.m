//
//  TestViewController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/10.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "TestViewController.h"
#import "JKNavigationController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    self.jk_fullScreenPopGestrueEnabled = YES;
    self.navigationController.navigationBar.jk_barBackgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

