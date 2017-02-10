//
//  UINavigationBar+JKTransparentize.m
//  TransparentNavgationBar
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import "UINavigationBar+JKTransparentize.h"
#import <objc/runtime.h>
#import "JKBackIndicatorButton.h"




@implementation UINavigationBar (JKTransparentize)

static char * kBarBackgroundColorKey = "JKBarBackgroundColor";
static char * kBarBackgroundViewKey = "JKBarBackgroundView";

- (void)setJk_barBackgroundColor:(UIColor *)jk_barBackgroundColor {
    objc_setAssociatedObject(self, kBarBackgroundColorKey, jk_barBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (jk_barBackgroundColor)  {
        [self jk_setNavigationBarBackgroundColor:jk_barBackgroundColor];
    }
}

- (UIColor *)jk_barBackgroundColor {
    return objc_getAssociatedObject(self, kBarBackgroundColorKey);
}


- (void)jk_setTintColor:(UIColor *)tintColor {
    self.tintColor = tintColor;
    
    NSArray * leftViews = [self valueForKey:@"leftViews"];
    if ([leftViews.firstObject isKindOfClass:[JKBackIndicatorButton class]]) {
        [((JKBackIndicatorButton *) leftViews.firstObject) jk_resetBackIndicatorWithTintColor:tintColor];
    }
}

- (void)setJk_backgroundView:(UIView *)jk_backgroundView {
    objc_setAssociatedObject(self, kBarBackgroundViewKey, jk_backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)jk_backgroundView {
    return objc_getAssociatedObject(self, kBarBackgroundViewKey);
}

- (void)jk_setNavigationBarBackgroundColor:(UIColor *)backgroundColor {
    if (nil == self.jk_backgroundView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        
        self.jk_backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.frame.size.width, 64)];
        self.jk_backgroundView.userInteractionEnabled = NO;
        
        UINavigationBar * contentView = self;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
            contentView = [self valueForKey:@"contentView"];
        }
        [contentView insertSubview:self.jk_backgroundView atIndex:0];
    }
    self.jk_backgroundView.backgroundColor = backgroundColor;
}

- (void)jk_setNavigationBarSubViewsAlpha:(CGFloat)alpha {
    [[self valueForKey:@"leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView * backIndicatorView = [self valueForKey:@"backIndicatorView"];
    
    UINavigationController * navigationController = [self valueForKey:@"delegate"];
    if (navigationController.viewControllers.count == 1) {
        backIndicatorView.alpha = 0;
    } else {
        backIndicatorView.alpha = alpha;
    }
    
    UIView * titleView = [self valueForKey:@"titleView"];
    titleView.alpha = alpha;
    
    UINavigationBar * contentView = self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        contentView = [self valueForKey:@"contentView"];
    }
    
    [contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            if (titleView == nil) {
                obj.alpha = alpha;
            }
        }
    }];
}

- (void)jk_setNavigationBarVerticalOffsetY:(CGFloat)offsetY {
    UINavigationBar * contentView = self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        contentView = [self valueForKey:@"contentView"];
    }
    contentView.transform = CGAffineTransformMakeTranslation(0, offsetY);
    
    offsetY = MIN(offsetY, 0);
    offsetY = MAX(-44, offsetY);
    [self jk_setNavigationBarSubViewsAlpha:(44.0 + offsetY) / 44.0];
}

- (void)jk_resetNavigationBar {
    [self.jk_backgroundView removeFromSuperview];
    self.jk_backgroundView = nil;
    
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    
    UINavigationBar * contentView = self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        contentView = [self valueForKey:@"contentView"];
    }
    contentView.transform = CGAffineTransformMakeTranslation(0, 0);
    contentView.transform = CGAffineTransformIdentity;
    
    [self jk_setNavigationBarSubViewsAlpha:1.0];
}


/**    
 "_itemStack",
 "_delegate",
 "_rightMargin",
 "_state",
 "_barBackgroundView",     iOS10
 _backgroundView           iOS8.9
 
 "_customBackgroundView",
 "_titleView",
 "_leftViews",
 "_rightViews",
 "_prompt",
 "_accessoryView",
 "_contentView",        iOS10
 "_currentCanvasView",
 "_barTintColor",
 "_userContentGuide",
 "_userContentGuideLeading",
 "_userContentGuideTrailing",
 "_appearanceStorage",
 "_currentAlert",
 "_navbarFlags",
 "_popSwipeGestureRecognizer",
 "_backIndicatorView",
 "_slideTransitionClippingViews",
 "_navControllerAnimatingContext",
 "_leadingAffordanceView",
 "_trailingAffordanceView",
 "_transitionCoordinator",
 "_needsUpdateBackIndicatorImage",
 "_wantsLetterpressContent",
 "_barPosition",
 "_requestedMaxBackButtonWidth",
 "_accessibilityButtonBackgroundTintColor",
 "__animationIds",
 "_contentFocusContainerGuide"
 
 */


@end
