//
//  NSObject+Runtime.h
//  JKNavigationController
//
//  Created by 蒋鹏 on 2017/6/11.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

+ (NSArray *)jk_declaredInstanceVariables;

+ (NSArray <NSString *>*)jk_properties;


@end
