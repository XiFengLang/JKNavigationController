//
//  UINavigationBar+JKTransparentize.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
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


/// 为iOS11写的方法，等同取高度为64的_backgroundView(iOS8/9) 或者 _barBackgroundView(iOS10)
- (UIView *)jk_systemBarContentView {
    __block UIView * barContentView = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
            barContentView = obj;
            *stop = YES;
        }
    }];
    return barContentView;
}


- (UIView *)jk_titleView {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        __block UIView * titleView = [self valueForKey:@"titleView"];
        
        /// 自定义titleView的时候，用KVC取出来可能是nil，可以遍历子视图取出来
        if (!titleView) {
            [[self jk_navigationBar].subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
                    titleView = obj;
                    *stop = YES;
                }
            }];
        }
        return titleView;
    } else {
        UIView * barContentView = [self jk_systemBarContentView];
        __block UIView * titleView = nil;
        [barContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"_UIButtonBarStackView")]) {
                titleView = obj;
                *stop = YES;
            }
        }];
        return titleView;
    }
}

- (NSArray <UIView *>*)jk_leftViews {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        return [self valueForKey:@"leftViews"];
    } else {
        UIView * barContentView = [self jk_systemBarContentView];
        __block UIView * leftStackView = nil;
        CGFloat navigationBarWidth = self.frame.size.width;
        [barContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"_UIButtonBarStackView")]) {
                if (obj.frame.origin.x < navigationBarWidth * 0.5) {
                    leftStackView = obj;
                    *stop = YES;
                }
            }
        }];
        return leftStackView.subviews;
    }
}

- (NSArray <UIView *>*)jk_rightViews {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        return [self valueForKey:@"rightViews"];
    } else {
        UIView * barContentView = [self jk_systemBarContentView];
        __block UIView * leftStackView = nil;
        CGFloat navigationBarWidth = self.frame.size.width;
        [barContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"_UIButtonBarStackView")]) {
                if (obj.frame.origin.x > navigationBarWidth * 0.5) {
                    leftStackView = obj;
                    *stop = YES;
                }
            }
        }];
        return leftStackView.subviews;
    }
}


- (void)jk_setTintColor:(UIColor *)tintColor {
    self.tintColor = tintColor;
    
    /// JKBackIndicatorButton需要重绘背景图
    [[self jk_leftViews] enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JKBackIndicatorButton class]]) {
            [(JKBackIndicatorButton *)obj jk_resetBackIndicatorWithTintColor:tintColor];
            *stop = YES;
        }
    }];
}

- (void)setJk_backgroundView:(UIView *)jk_backgroundView {
    objc_setAssociatedObject(self, kBarBackgroundViewKey, jk_backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)jk_backgroundView {
    return objc_getAssociatedObject(self, kBarBackgroundViewKey);
}

- (UINavigationBar *)jk_navigationBar {
    UINavigationBar * contentView = self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0 && [UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        contentView = [self valueForKey:@"contentView"];
    }
    return contentView;
}

- (void)jk_setNavigationBarBackgroundColor:(UIColor *)backgroundColor {
    if (nil == self.jk_backgroundView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        
        self.jk_backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.frame.size.width, 64)];
        self.jk_backgroundView.userInteractionEnabled = NO;
        
        /// 创建一个高度为64的jk_backgroundView放在navigationBar上
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            [[self jk_navigationBar] insertSubview:self.jk_backgroundView atIndex:0];
        } else {
            self.jk_backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, 64);
            [[self jk_navigationBar].superview insertSubview:self.jk_backgroundView belowSubview:[self jk_navigationBar]];
        }
    }
    self.jk_backgroundView.backgroundColor = backgroundColor;
}

- (void)jk_setNavigationBarSubViewsAlpha:(CGFloat)alpha {
    [[self jk_leftViews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self jk_rightViews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [self jk_titleView].alpha = alpha;
    NSLog(@"%@",[self jk_titleView]);
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        UIView * backIndicatorView = [self valueForKey:@"backIndicatorView"];
        
        /// navigationController.viewControllers.count == 1时，返回箭头图标是隐藏的
        UINavigationController * navigationController = [self valueForKey:@"delegate"];
        if (navigationController.viewControllers.count == 1) {
            backIndicatorView.alpha = 0;
        } else {
            backIndicatorView.alpha = alpha;
        }
    }
    
}

- (void)jk_setNavigationBarVerticalOffsetY:(CGFloat)offsetY {
    [self jk_navigationBar].transform = CGAffineTransformMakeTranslation(0, offsetY);
    
    offsetY = MIN(offsetY, 0);
    offsetY = MAX(-44, offsetY);
    [self jk_setNavigationBarSubViewsAlpha:(44.0 + offsetY) / 44.0];
}

- (void)jk_resetNavigationBar {
    [self.jk_backgroundView removeFromSuperview];
    self.jk_backgroundView = nil;
    
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    
    UINavigationBar * contentView = [self jk_navigationBar];
    contentView.transform = CGAffineTransformMakeTranslation(0, 0);
    contentView.transform = CGAffineTransformIdentity;
    
    [self jk_setNavigationBarSubViewsAlpha:1.0];
}


/**
 用Runtime取了UINavigationBar的所有成员变量
 
 "_itemStack",
 "_delegate",
 "_rightMargin",
 "_state",
 "_barBackgroundView",     iOS10
 _backgroundView           iOS8/9  iOS11  y:-20  height:64
 
 "_customBackgroundView",
 "_titleView",
 "_leftViews",
 "_rightViews",
 "_prompt",
 "_accessoryView",
 "_contentView",        iOS10  navigationBar
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
