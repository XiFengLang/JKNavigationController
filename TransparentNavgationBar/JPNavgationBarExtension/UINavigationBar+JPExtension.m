//
//  UINavigationBar+JPExtension.m
//  TransparentNavgationBar
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import "UINavigationBar+JPExtension.h"
#import <objc/runtime.h>

@interface UINavigationBar ()
@property (nonatomic, strong)UIView * backgroundView;
@property (nonatomic, strong)UIView * statusBarView;
@end



@implementation UINavigationBar (JPExtension)

static char * backgroundViewRuntimeKey;
static char * statusBarViewRuntimeKey;

- (void)setBackgroundView:(UIView *)backgroundView{
    objc_setAssociatedObject(self, backgroundViewRuntimeKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)backgroundView{
    return objc_getAssociatedObject(self, backgroundViewRuntimeKey);
}

- (void)setStatusBarView:(UIView *)statusBarView{
    objc_setAssociatedObject(self, statusBarViewRuntimeKey, statusBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)statusBarView{
    return objc_getAssociatedObject(self, backgroundViewRuntimeKey);
}


- (void)jp_setNavigationBarBackgroundColor:(UIColor *)color{
    [self restoreStatusBarView];
    if (!self.backgroundView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIApplication sharedApplication].keyWindow.bounds.size.width, 64)];
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.backgroundView atIndex:0];
    }
    self.backgroundView.backgroundColor = color;
}


- (void)jp_setNavigationBarBackgroundAlpha:(CGFloat)alpha{
    self.backgroundView.backgroundColor = [self.backgroundView.backgroundColor colorWithAlphaComponent:alpha];
}


- (void)jp_setStatusBarBackgroundViewColor:(UIColor *)color{
    [self restoreBackgroundView];
    if (!self.statusBarView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        self.statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIApplication sharedApplication].keyWindow.bounds.size.width, 20)];
        self.statusBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.statusBarView];
    }
    self.statusBarView.backgroundColor = color;
    [self setBackgroundColor:color];
}


- (void)jp_setStatusBarBackgroundViewAlpha:(CGFloat)alpha{
    [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:alpha]];
    self.statusBarView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:alpha];
}



- (void)jp_translationNavigationBarVerticalWithOffsetY:(CGFloat)offsetY{
    self.transform = CGAffineTransformMakeTranslation(0, offsetY);
}


- (void)jp_translationBarBackgroundVerticalWithOffsetY:(CGFloat)offsetY{
    self.backgroundView.transform = CGAffineTransformMakeTranslation(0, offsetY);
}

- (void)jp_restoreNavigationBar{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    self.transform = CGAffineTransformIdentity;
    self.tintColor = [self.tintColor colorWithAlphaComponent:1];
    [self restoreBackgroundView];
    [self restoreStatusBarView];
}

- (void)restoreStatusBarView{
    if (self.statusBarView) {
        [self.statusBarView removeFromSuperview];
        self.statusBarView = nil;
    }
}


- (void)restoreBackgroundView{
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
    }
}
@end
