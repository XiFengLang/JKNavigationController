//
//  ViewController.m
//  JKNavigationController
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "HomeViewController.h"
#import "JKNavigationController.h"
#import "ZhiHuViewController.h"


@interface HomeViewController ()
{
    CGRect HeaderFrame;
}

@property (nonatomic, assign)CGFloat marginTop;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"首页";
    HeaderFrame = [self.tableView rectForHeaderInSection:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAction)];
    
    /// 全局效果
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    /// 会设置所有子控制器navigationBar的颜色，并且决定下一个Push的控制器默认的jk_barBackgroundColor，全局效果
    self.navigationController.navigationBar.jk_barBackgroundColor = [UIColor orangeColor];
    
    
    /// 只会设置当前控制器的navigationBar的颜色
    [self.navigationController.navigationBar jk_setNavigationBarBackgroundColor:[UIColor orangeColor]];
    
    
    ///  会设置所有子控制器的全屏手势使能状态，全局效果
    self.jk_rootNavigationController.jk_fullScreenPopGestrueEnabled = YES;
    
    
    /// 影响当前控制器的侧滑返回，jk_fullScreenPopGestrueEnabled = NO时会使用系统原生的侧滑效果。
//    self.jk_fullScreenPopGestrueEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    HeaderFrame = [self.tableView rectForHeaderInSection:1];
}


- (void)pushAction {
    ZhiHuViewController * zhiHuVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ZhiHuViewController"];
    
    
    zhiHuVC.hidesBottomBarWhenPushed = YES;
    /// self.automaticallyAdjustsScrollViewInsets = NO;
    
    /* 
        如果下一个控制器在SB中创建，并且设置了TableView的约束，如果要隐藏TabBar，即toVC.hidesBottomBarWhenPushed = YES;
        那么TableView的Bottom约束要以SuperView为参考，并且设置toVC.automaticallyAdjustsScrollViewInsets = NO。
        不然会出现闪烁或者留白
     */
    
    [self.navigationController pushViewController:zhiHuVC animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    

    if (newoffsetY >= 0 && newoffsetY <= 150) {
        [self.navigationController.navigationBar jk_setNavigationBarBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:1- newoffsetY/150]];
        
    }else if (newoffsetY > 150){
        [self.navigationController.navigationBar jk_setNavigationBarBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:0]];

    }else{
        [self.navigationController.navigationBar jk_setNavigationBarBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:1]];
    }
    
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



@end
