//
//  JKBackIndicatorButton.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import "JKBackIndicatorButton.h"

@interface JKBackIndicatorButton ()

@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, strong) UIFont * font;


@end

@implementation JKBackIndicatorButton

UIImage * JK_GraphicsImageContext(CGSize size,void(^block)()){
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
        block();
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

+ (JKBackIndicatorButton *)jk_backIndicatorWithTitle:(NSString *)title tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action {
    
    JKBackIndicatorButton * backIndicator = [JKBackIndicatorButton buttonWithType:UIButtonTypeCustom];
    
    /// 分别设置iOS8.9.10对应的字体
    NSString * fontName = @".HelveticaNeueInterface-Regular";
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if (systemVersion >= 10.0) {
        fontName = @".SFUIText";
    } else if (systemVersion >= 9.0) {
        fontName = @".SFUIText-Regular";
    }
    backIndicator.font = [UIFont fontWithName:fontName size:17.0];

    
    [backIndicator jk_resetBackIndicatorWithTintColor:tintColor title:title];
    backIndicator.transform = CGAffineTransformMakeTranslation(-4, 0);
    [backIndicator addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return backIndicator;
}


- (void)jk_resetBackIndicatorWithTintColor:(UIColor *)tintColor {
    [self jk_resetBackIndicatorWithTintColor:tintColor title:self.jk_title];
}

- (void)jk_resetBackIndicatorWithTintColor:(UIColor *)tintColor title:(NSString *)title {
    [self jk_adjustFrameWithTitle:title];
    
    
    UIImage * normal = [self jk_drawBackgroundImageWithTitle:self.jk_title tintColor:tintColor];
    UIImage * highlighted = [self jk_redrawImage:normal size:self.frame.size withTintColor:[tintColor colorWithAlphaComponent:0.5]];
    
    [self setImage:normal forState:UIControlStateNormal];
    [self setImage:highlighted forState:UIControlStateHighlighted];
}


- (void)jk_adjustFrameWithTitle:(NSString *)title {
    title = title ? : @"";
    _jk_title = title;
    CGSize newSize = [title boundingRectWithSize:CGSizeMake(120, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:self.font} context:nil].size;
    self.titleSize = CGSizeMake(ceil(newSize.width), ceil(newSize.height));
    self.frame = CGRectMake(12, 6, 19 + self.titleSize.width, 30);
}


- (UIImage *)jk_drawBackgroundImageWithTitle:(NSString *)title tintColor:(UIColor *)tintColor {
    title = title ? : @"";
    UIImage * icon = [UIImage imageNamed:@"jk_icon_system_backIndicator"];
    
    UIImage * tintIcon = [self jk_redrawImage:icon size:CGSizeMake(13, 21) withTintColor:tintColor];
    NSAttributedString * attributeStr = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:tintColor}];
    
    return JK_GraphicsImageContext(self.frame.size, ^{
        [tintIcon drawInRect:CGRectMake(0, 4.667, 13, 21)];
        [attributeStr drawInRect:CGRectMake(19, (30 - self.titleSize.height) / 2.0, self.titleSize.width, self.titleSize.height)];
    });
}

- (UIImage *)jk_redrawImage:(UIImage *)image size:(CGSize)size withTintColor:(UIColor *)tintColor {
    return JK_GraphicsImageContext(size, ^{
        [tintColor setFill];
        CGRect bounds = CGRectMake(0, 0, size.width, size.height);
        UIRectFill(bounds);
        [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    });
}

@end
