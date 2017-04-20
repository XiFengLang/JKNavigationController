//
//  JKRootNavigationController.h
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//  https://github.com/XiFengLang/JKNavigationController

#import <UIKit/UIKit.h>

@interface JKRootNavigationController : UINavigationController



/**
 取所有的普通控制器，即外部显示的控制器，rootNavigationController.viewControllers则会取出所有的“外壳或者容器”控制器JKInterlayerViewController
 
 */
@property (nonatomic, strong, readonly) NSArray <UIViewController *> * jk_viewControllers;



/**
 不推荐使用，这里取出来的都是JKInterlayerViewController类型，即内部封装的“外壳或者容器”控制器,如果要取外部显示的普通控制器VC，请使用 @selector(jk_viewControllers)

 @return JKInterlayerViewController类型
 */
- (NSArray<UIViewController *> *)viewControllers;


@end
