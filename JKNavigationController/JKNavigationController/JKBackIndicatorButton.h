//
//  JKBackIndicatorButton.h
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//  https://github.com/XiFengLang/JKNavigationController

#import <UIKit/UIKit.h>


/**
 绘图函数
 
 @param size size description
 @param block block description
 @return return value description
 */
static inline UIImage * JKGraphicsImageContextWithOptions(CGSize size,void(^block)(void)){
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    block();
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


/**
 JKNavigationController通用的自定义按钮
 */
@interface JKBackIndicatorButton : UIButton

@property (nonatomic, copy, readonly) NSString * jk_title;


/**
 重新修改TintColor,内部会调用jk_resetBackIndicatorWithTintColor:(UIColor *)tintColor title:(NSString *)title
 
 @param tintColor tintColor description
 */
- (void)jk_resetBackIndicatorWithTintColor:(UIColor *)tintColor;



/**
 重新修改TintColor和Title
 
 @param tintColor tintColor description
 @param title title description
 */
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

