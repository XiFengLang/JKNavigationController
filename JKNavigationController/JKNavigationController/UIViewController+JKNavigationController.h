//
//  UIViewController+JKNavigationController.h
//  TransparentNavgationBar
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPackageNavigationController.h"

@interface UIViewController (JKNavigationController)


/**
 全屏侧滑返回开关
 */
@property (nonatomic, assign) BOOL jk_fullScreenPopGestrueEnabled;



/**
 最底层的总导航控制器
 */
@property (nonatomic, weak) JKPackageNavigationController * jk_packNavigationController;

@end
