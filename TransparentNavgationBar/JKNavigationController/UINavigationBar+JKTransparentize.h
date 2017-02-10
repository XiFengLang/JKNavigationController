//
//  UINavigationBar+JKTransparentize.h
//  TransparentNavgationBar
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationBar (JKTransparentize)


@property (nonatomic, strong) UIColor * jk_barBackgroundColor;

@property (nonatomic, strong, readonly) UIView * jk_backgroundView;



/**
 设置NavigationBar的tintColor，并且重绘JKBackIndicatorButton的图片

 @param tintColor tintColor
 */
- (void)jk_setTintColor:(UIColor *)tintColor;


/**
 设置自定义的背景颜色

 @param backgroundColor 背景颜色
 */
- (void)jk_setNavigationBarBackgroundColor:(UIColor *)backgroundColor;


/**
 设置NavigationBar的垂直方向偏移，并调用jk_setNavigationBarSubViewsAlpha：

 @param offsetY offsetY
 */
- (void)jk_setNavigationBarVerticalOffsetY:(CGFloat)offsetY;


/**
 设置主要子控件的透明度（按钮、TitleView啥的）

 */
- (void)jk_setNavigationBarSubViewsAlpha:(CGFloat)alpha;


/**
 重置还原NavigationBar
 */
- (void)jk_resetNavigationBar;
@end
