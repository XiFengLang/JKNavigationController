//
//  UIViewController+JKNavigationController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import "UIViewController+JKNavigationController.h"
#import <objc/runtime.h>

@implementation UIViewController (JKNavigationController)

static char * kFullScreenPopGestrueEnabledKey = "JKFullScreenPopGestrueEnabled";
static char * kRootNavigationController = "JKRootNavigationController";

- (void)setJk_rootNavigationController:(JKRootNavigationController *)jk_rootNavigationController {
    objc_setAssociatedObject(self, kRootNavigationController, jk_rootNavigationController, OBJC_ASSOCIATION_ASSIGN);
}

- (JKRootNavigationController *)jk_rootNavigationController {
    return objc_getAssociatedObject(self, kRootNavigationController);
}

- (void)setJk_fullScreenPopGestrueEnabled:(BOOL)jk_fullScreenPopGestrueEnabled {
    NSNumber * value = [NSNumber numberWithBool:jk_fullScreenPopGestrueEnabled];
    objc_setAssociatedObject(self, kFullScreenPopGestrueEnabledKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)jk_fullScreenPopGestrueEnabled {
    NSNumber * value = objc_getAssociatedObject(self, kFullScreenPopGestrueEnabledKey);
    return value.boolValue;
}

@end
