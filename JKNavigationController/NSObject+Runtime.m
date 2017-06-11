//
//  NSObject+Runtime.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 2017/6/11.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>
@implementation NSObject (Runtime)


+ (NSArray *)jk_declaredInstanceVariables {
    NSMutableArray * mutArray = [[NSMutableArray alloc] init];
    
    unsigned int propertiesCount = 0;
    Ivar * ivarList = class_copyIvarList(self, &propertiesCount);
    for (NSInteger index = 0; index < propertiesCount; index ++) {
        @autoreleasepool {
            Ivar ivar = ivarList[index];
            const char * ivarCName = ivar_getName(ivar);
            //            const char * ivarTypeEcoding = ivar_getTypeEncoding(ivar);
            
            NSString * ivarOCName = [NSString stringWithUTF8String:ivarCName];
            //            NSString * ivarTypeOCEcoding = [NSString stringWithUTF8String:ivarTypeEcoding];
            
            [mutArray addObject:ivarOCName];
        }
    }
    free(ivarList);
    return mutArray.copy;
}



+ (NSArray <NSString *>*)jk_properties {
//    if (self == [NSObject class]) {
//        return nil;
//    }
    NSMutableArray * mutArray = [[NSMutableArray alloc] init];
//    NSArray * superClassPropeties = [[self superclass] jk_properties];
//    if (superClassPropeties) {
//        [mutArray addObjectsFromArray:superClassPropeties];
//    }
    
    unsigned int propertiesCount = 0;
    objc_property_t * propertyList = class_copyPropertyList(self.class, &propertiesCount);
    for (NSInteger index = 0; index < propertiesCount; index ++) {
        @autoreleasepool {
            objc_property_t property = propertyList[index];
            const char * propertyCName = property_getName(property);
            
            NSString * propertyOCName = [NSString stringWithUTF8String:propertyCName];
            [mutArray addObject:propertyOCName];
        }
    }
    free(propertyList);
    return mutArray.copy;
}

@end
