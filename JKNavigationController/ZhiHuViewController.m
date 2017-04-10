//
//  ZhiHuViewController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/9.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ZhiHuViewController.h"
#import "JKNavigationController.h"
#import "JKViewController.h"
#import "JKAlertManager.h"
@interface ZhiHuViewController ()
{
    CGRect HeaderFrame;
}
@property (nonatomic, assign)CGFloat marginTop;
@end

@implementation ZhiHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.title = @"知乎日报";
    
    /// 后面的控制器会取用上一控制器的jk_barBackgroundColor，所以会影响下一控制器的jk_barBackgroundColor。
//    self.navigationController.navigationBar.jk_barBackgroundColor = [UIColor purpleColor];
    
    
    /// 不影响下一控制器的jk_barBackgroundColor，所以JKViewController的jk_barBackgroundColor颜色和主页相同
    [self.navigationController.navigationBar jk_setNavigationBarBackgroundColor:[UIColor purpleColor]];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAction)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

/**    
 拦截返回按钮的点击事件实现JKNavigationControllerDelegate协议即视为拦截
 如果有拦截，会关闭全屏侧滑返回手势以及自带的侧滑返回手势
 */
- (BOOL)jk_navigationController:(JKRootNavigationController *)navigationController
                  shouldPopItem:(UINavigationItem *)item {
    
    JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:@"已拦截点击事件" message:@"是否继续返回"];
    [manager configueCancelTitle:@"否" destructiveIndex:JKAlertDestructiveIndexNone otherTitles:@[@"返回"]];
    [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
        
        /// 手动跳转
        if (actionIndex != tempAlertManager.cancelIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    return NO;/// 禁止跳转
}



- (void)pushAction {
    [self.navigationController pushViewController:[JKViewController 
                                                   new] animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    HeaderFrame = [self.tableView rectForHeaderInSection:1];
    [self scrollViewDidScroll:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    if (newoffsetY >= 0 && newoffsetY <= 100) {
        
        /// 偏移范围0-44（绝对值），并且自动设置子视图控件的透明度
        
        [self.navigationController.navigationBar jk_setNavigationBarVerticalOffsetY:- newoffsetY/100.0*44];
        
    }else if (newoffsetY < 0){
        [self.navigationController.navigationBar jk_setNavigationBarVerticalOffsetY:0];
        
    }else{
        [self.navigationController.navigationBar jk_setNavigationBarVerticalOffsetY:-44];
    }
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
