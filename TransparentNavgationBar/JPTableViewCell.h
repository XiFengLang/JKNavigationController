//
//  JPTableViewCell.h
//  JPRefresh
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;



/*
 
 
 //     全透明
 //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
 //     去掉黑线
 //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
 //     按钮的字体颜色
 //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
 //     去掉磨砂效果
  //    self.navigationController.navigationBar.translucent = YES;
 
 // 方法1：设置背景颜色，高度只有40，然后加个View放在状态栏下面，高度20，同时设置。并不影响状态栏的点击
 //    [self.navigationController.navigationBar setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]];
 //    UIView * statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
 //    statusBarView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
 //    [self.navigationController.navigationBar addSubview:statusBarView];
 

 
 // 方法2：可能涉及私有API,_UINavigationBarBackground决定Bar的背景颜色,firstObject取出来直接设置颜色(能否上架未知)
 //    UIView * firstView = [self.navigationController.navigationBar.subviews firstObject];
 //    firstView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.3];
 
 
 
 // 方法3：直接在navigationBar加一层高度为64的view,插入的index为0, 
 // 2会盖住leftBarButtonItem,3会盖住rightBarButtonItem
 // Push到下一页面后,所有BarButtonItem都无法点击，不能Back。
 // 特别之处：Index为1时，Push到下一界面后，系统会将view移动到index=3的位置,之后怎么移动层级也无法点击BarButtonItem。
 // 而且bringSubviewToFront:/sendSubviewToBack:的效果都是bringSubviewToFront的效果
 
 //    UIView * barBackgroundView = [[UIView alloc]init];
 //    barBackgroundView.tag = 100;
 //    barBackgroundView.frame = CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64);
 //    barBackgroundView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.3];
 //    [self.navigationController.navigationBar insertSubview:barBackgroundView atIndex:0];
 //    barBackgroundView.userInteractionEnabled = NO;  // 关键之处
 
 // 移动的时候用
 //    barBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

 
 
 
 // 方法4：https://github.com/ltebean/LTNavigationBar
 
 */



@end
