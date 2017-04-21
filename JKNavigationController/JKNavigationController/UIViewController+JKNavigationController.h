//
//  UIViewController+JKNavigationController.h
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//  https://github.com/XiFengLang/JKNavigationController

#import <UIKit/UIKit.h>
#import "JKRootNavigationController.h"


@protocol JKNavigationControllerDelegate <NSObject>

/**
 实现JKNavigationControllerDelegate协议即视为拦截返回按钮的点击事件
 如果有拦截，会关闭响应控制器的全屏侧滑返回手势以及自带的侧滑返回手势
 */
@optional
- (BOOL)jk_navigationController:(JKRootNavigationController *)navigationController
                  shouldPopItem:(UINavigationItem *)item;

@end



@interface UIViewController (JKNavigationController) <JKNavigationControllerDelegate>


/**
 全屏侧滑返回开关
 */
@property (nonatomic, assign) BOOL jk_fullScreenPopGestrueEnabled;



/**
 最底层的总导航控制器
 */
@property (nonatomic, weak) JKRootNavigationController * jk_rootNavigationController;

@end
