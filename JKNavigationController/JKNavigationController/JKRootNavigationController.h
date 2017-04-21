//
//  JKRootNavigationController.h
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//  https://github.com/XiFengLang/JKNavigationController


#pragma mark - jk_Description



/**
 JKRootNavigationController不直接管理CustomViewController，而是管理经过包装后的JKInterlayerViewController。在这个包装的结构层中CustomViewController和JKInterLayerNavigationController是一一对应的，这样也就为每个控制器定制了一个导航栏，navigationBar的颜色也就可以随便设置了。
 
 
 
 JKRootNavigationController  根导航控制器（操作Push/Pop/Dismiss）
        ↓     隐藏navigationBar
        ↓
 --------------------------------------------------------------------->>> 以此类推...
        ↓                                                  ↓
        ↓                                                  ↓
 JKInterlayerViewControllerA 包裹层/夹层控制器          JKInterlayerViewControllerB
        ↓     起包装作用                                     ↓
        ↓                                                  ↓
 JKInterLayerNavigationController 包裹层/夹层导航控制器  JKInterLayerNavigationControllerB
        ↓     管理外层显示的navigationBar                     ↓
        ↓                                                   ↓
 CustomViewControllerA 外层显示的自定义控制器             CustomViewControllerB
 
 
 */



#pragma mark - jk_Define


#import <UIKit/UIKit.h>

@interface JKRootNavigationController : UINavigationController



/**
 取所有的普通控制器，即外部显示的自定义控制器customViewController；
 rootNavigationController.viewControllers取出来的控制器都是JKInterlayerViewController类型，即内部封装的“外壳或容器”控制器，不推荐使用。
 
 */
@property (nonatomic, strong, readonly) NSArray <UIViewController *> * jk_viewControllers;



@end


