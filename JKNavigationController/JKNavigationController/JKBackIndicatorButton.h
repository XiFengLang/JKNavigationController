//
//  JKBackIndicatorButton.h
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKBackIndicatorButton : UIButton

@property (nonatomic, copy, readonly) NSString * jk_title;


/**
 重新修改TintColor,会调用jk_resetBackIndicatorWithTintColor:(UIColor *)tintColor title:(NSString *)title

 @param tintColor tintColor description
 */
- (void)jk_resetBackIndicatorWithTintColor:(UIColor *)tintColor;



- (void)jk_resetBackIndicatorWithTintColor:(UIColor *)tintColor title:(NSString *)title;


/**
 自定义的返回按钮

 @param title title description
 @param tintColor tintColor description
 @param target target description
 @param action action description
 @return 自定义的返回按钮
 */
+ (JKBackIndicatorButton *)jk_backIndicatorWithTitle:(NSString *)title
                                           tintColor:(UIColor *)tintColor
                                              target:(id)target
                                              action:(SEL)action;
@end
