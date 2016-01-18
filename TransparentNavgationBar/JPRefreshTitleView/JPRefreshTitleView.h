//
//  JPRefreshTitleView.h
//  JPRefresh
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef  DEBUG
#define JKLog(...) NSLog(__VA_ARGS__)
#else
#define JKLog(...)
#endif


#ifndef    weak_self
#if __has_feature(objc_arc)
#define WeakSelf __weak __typeof__(self) weakself = self;
#else
#define WeakSelf autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif
#ifndef    strong_self
#if __has_feature(objc_arc)
#define StrongSelf  __typeof__(weakself) self = weakself;
#else
#define StrongSelf try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif



#ifndef    Weak
#if __has_feature(objc_arc)
#define Weak(object) __weak __typeof__(object) weak##object = object;
#else
#define Weak(object) autoreleasepool{} __block __typeof__(object) block##object = object;
#endif
#endif
#ifndef    Strong
#if __has_feature(objc_arc)
#define Strong(object) __typeof__(object) object = weak##object;
#else
#define Strong(object) try{} @finally{} __typeof__(object) object = block##object;
#endif
#endif




typedef void (^JPrefreshingBlock)(void);

@interface JPRefreshTitleView : UIView

@property (nonatomic, assign, getter=isRefreshing)BOOL refreshing;

/**
 *  可自定义拓展
 */
@property (nonatomic, strong)UIView * rightView;

/**
 *  菊花以及进度条的颜色,默认灰色
 */
@property (nonatomic, strong)UIColor * activityIndicatorColor;



/**
 *  初始化及添加到导航条，不能隐藏当前viewController的navigationBar（可透明）
 *
 *  @param viewController         必须传值
 *  @param scrollView             可为nil,即不监测滚动
 *  @param title                  可为nil,
 *  @param font                   可为nil,默认系统字体大小
 *  @param textColor              可为nil,默认黑色
 *
 *  @return JPRefreshTitleView object
 */
+ (JPRefreshTitleView *)showRefreshViewInViewController:(UIViewController *)viewController
                                  observableScrollView:(UIScrollView *)scrollView
                                                 title:(NSString *)title
                                                  font:(UIFont *)font
                                             textColor:(UIColor *)textColor
                                      refreshingBlock:(JPrefreshingBlock)refreshingBlock;


- (void)resetNavigationItemTitle:(NSString *)title;
- (void)stopRefresh;
- (void)startRefresh;

@end
