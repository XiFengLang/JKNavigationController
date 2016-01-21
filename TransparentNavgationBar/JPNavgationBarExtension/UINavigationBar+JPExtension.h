//
//  UINavigationBar+JPExtension.h
//  TransparentNavgationBar
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NavigationBar self.navigationController.navigationBar

@interface UINavigationBar (JPExtension)
/**
 *  背景颜色(方式1，同一界面不能2种方式混用)
 *
 *  @param color
 */
- (void)jp_setNavigationBarBackgroundColor:(UIColor *)color;

/**
 *  透明度(方式1，同一界面不能2种方式混用)
 *
 *  @param alpha
 */
- (void)jp_setNavigationBarBackgroundAlpha:(CGFloat)alpha;


/**
 *  背景颜色(方式2，同一界面不能2种方式混用)
 *
 *  @param color color
 */
- (void)jp_setStatusBarBackgroundViewColor:(UIColor *)color;

/**
 *  透明度(方式2，同一界面不能2种方式混用)
 *
 *  @param alpha
 */
- (void)jp_setStatusBarBackgroundViewAlpha:(CGFloat)alpha;





/**
 *  整个都偏移
 *
 *  @param offsetY
 */
- (void)jp_translationNavigationBarVerticalWithOffsetY:(CGFloat)offsetY;

/**
 *  只偏移背景视图，不移动按钮
 *
 *  @param offsetY
 */
- (void)jp_translationBarBackgroundVerticalWithOffsetY:(CGFloat)offsetY;


/**
 *  重置还原
 */
- (void)jp_restoreNavigationBar;
@end
