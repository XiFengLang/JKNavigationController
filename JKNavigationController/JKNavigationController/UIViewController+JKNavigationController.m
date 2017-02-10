//
//  UIViewController+JKNavigationController.m
//  TransparentNavgationBar
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import "UIViewController+JKNavigationController.h"
#import <objc/runtime.h>

@implementation UIViewController (JKNavigationController)

static char * kFullScreenPopGestrueEnabledKey = "JKFullScreenPopGestrueEnabled";
static char * kPackageNavigationController = "JKPackageNavigationController";

- (void)setJk_packNavigationController:(JKPackageNavigationController *)jk_packNavigationController {
    objc_setAssociatedObject(self, kPackageNavigationController, jk_packNavigationController, OBJC_ASSOCIATION_ASSIGN);
}

- (JKPackageNavigationController *)jk_packNavigationController {
    return objc_getAssociatedObject(self, kPackageNavigationController);
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
