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

- (void)setJk_barBackgroundColor:(UIColor *)jk_barBackgroundColor {
    objc_setAssociatedObject(self, kBarBackgroundColorKey, jk_barBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (jk_barBackgroundColor)  {
        [self jk_setNavigationBarBackgroundColor:jk_barBackgroundColor];
    }
}

- (UIColor *)jk_barBackgroundColor {
    return objc_getAssociatedObject(self, kBarBackgroundColorKey);
}


/// 为iOS11写的方法
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
            if (![obj isKindOfClass:NSClassFromString(@"_UIButtonBarStackView")]) {
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



- (UINavigationBar *)jk_navigationBar {
    UINavigationBar * contentView = self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0 && [UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        contentView = [self valueForKey:@"contentView"];
    }
    return contentView;
}

- (void)jk_setNavigationBarBackgroundColor:(UIColor *)backgroundColor {
    UIImage * image = JKGraphicsImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.bounds), 64), ^{
        [backgroundColor setFill];
        UIRectFill(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 64));
    });
    
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    if ([self jk_systemBarContentView].backgroundColor != [UIColor clearColor]) {
        [self setShadowImage:[UIImage new]];
        [self jk_systemBarContentView].backgroundColor = [UIColor clearColor];
        [self jk_navigationBar].backgroundColor = [UIColor clearColor];
    }
}

- (void)jk_setNavigationBarSubViewsAlpha:(CGFloat)alpha {
    [[self jk_leftViews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self jk_rightViews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [self jk_titleView].alpha = alpha;
    
    
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


/// 2.1.3版暂时废弃
//- (void)jk_setNavigationBarVerticalOffsetY:(CGFloat)offsetY {
//    [self jk_systemBarContentView].transform = CGAffineTransformMakeTranslation(0, offsetY);
//    self.subviews.firstObject.transform = [self jk_systemBarContentView].transform;
//
//
//    offsetY = MIN(offsetY, 0);
//    offsetY = MAX(-44, offsetY);
//    [self jk_setNavigationBarSubViewsAlpha:(44.0 + offsetY) / 44.0];
//}

- (void)jk_resetNavigationBar {
    //    [self.jk_backgroundView removeFromSuperview];
    //    self.jk_backgroundView = nil;
    
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    
    UINavigationBar * contentView = [self jk_navigationBar];
    contentView.transform = CGAffineTransformMakeTranslation(0, 0);
    contentView.transform = CGAffineTransformIdentity;
    
    [self jk_setNavigationBarSubViewsAlpha:1.0];
}



@end

