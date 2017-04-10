//
//  JKAlertManager.h
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/8/10.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//  https://github.com/溪枫狼/JKAlertManager



/**    代码块
 JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:<#title#> message:<#nil#>];
 [manager configueCancelTitle:<#@"取消"#> destructiveIndex:JKAlertDestructiveIndexNone otherTitles:<#array#>];
 [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
 if (actionIndex != tempAlertManager.cancelIndex) {
 <#doSomething#>
 }
 }];
 
 
 JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:<#title#> message:<#nil#>];
 [manager configueCancelTitle:<#@"取消"#> destructiveIndex:<#JKAlertDestructiveIndexNone#> otherTitle:<#@"确定"#>, nil];
 [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
 if (actionIndex != tempAlertManager.cancelIndex) {
 <#doSomething#>
 }
 }];
 
 
 
 JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:<#nil#> message:<#nil#>];
 [manager configueCancelTitle:<#@"取消"#> destructiveIndex:JKAlertDestructiveIndexNone otherTitle:<#@""#>, nil];
 [manager configuePopoverControllerForActionSheetStyleWithSourceView:<#view#> sourceRect:<#view#>.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
 [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
 if (actionIndex != tempAlertManager.cancelIndex) {
    
 }
 }];
 */




#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


UIKIT_EXTERN const NSInteger JKAlertDestructiveIndexNone;/**<  默认-2,没有destructiveTitle时设置  */


@class JKAlertManager;
typedef void(^JKAlertActionBlock)(JKAlertManager * __nullable tempAlertManager, NSInteger actionIndex, NSString * __nullable actionTitle);
typedef void(^JKAlertTextFieldTextChangedBlock)(UITextField * __nullable textField);



NS_CLASS_AVAILABLE_IOS(8_0) @interface JKAlertManager : NSObject
- (instancetype)init NS_UNAVAILABLE;                //NS_DESIGNATED_INITIALIZER
- (instancetype)initWithCoder:(NSCoder *)aDecoder   NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame         NS_UNAVAILABLE;


@property (nonatomic, copy) NSString * __nullable title NS_AVAILABLE_IOS(8_0);

@property (nonatomic, copy) NSString * __nullable message NS_AVAILABLE_IOS(8_0);

/**
 默认-1
 */
@property (nonatomic, assign, readonly)NSInteger cancelIndex NS_AVAILABLE_IOS(8_0);

/**
 默认-2
 */
@property (nonatomic, assign, readonly)NSInteger destructiveIndex NS_AVAILABLE_IOS(8_0);

/**
 textFields
 */
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields NS_AVAILABLE_IOS(8_0);




/**
 *  初始化方法JKAlertManager实例对象
 *
 *  @param style   UIAlertControllerStyle
 *  @param title   标题
 *  @param message 提示内容
 *
 *  @return JKAlertManager
 */
- (instancetype)initWithPreferredStyle:(UIAlertControllerStyle)style title:(NSString *__nullable)title message:(NSString *__nullable)message NS_AVAILABLE_IOS(8_0);



/**
 *  设置CancelButtonTitle/DestructiveTitle/otherTitle,没有DestructiveTitle时设置destructiveIndex = JKAlertDestructiveIndexNone（或-2）,destructiveIndex对应DestructiveTitle在otherTitles中的index。
 *
 *  @param cancelTitle      CancelButtonTitle
 *  @param destructiveIndex destructiveIndex对应DestructiveTitle在otherTitles中的index
 *  @param otherTitle       otherTitles
 */
- (void)configueCancelTitle:(NSString *__nullable)cancelTitle destructiveIndex:(NSInteger)destructiveIndex otherTitle:(NSString * __nullable)otherTitle,...NS_REQUIRES_NIL_TERMINATION NS_AVAILABLE_IOS(8_0);




/**    传数组    */
- (void)configueCancelTitle:(NSString *__nullable)cancelTitle destructiveIndex:(NSInteger)destructiveIndex otherTitles:(NSArray <NSString *>* __nullable)otherTitles NS_AVAILABLE_IOS(8_0);




/**    1.兼容iPad时需调用,APP只支持iPhone的话可忽略  2.必须使用UIAlertControllerStyleActionSheet    */
- (void)configuePopoverControllerForActionSheetStyleWithSourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect popoverArrowDirection:(UIPopoverArrowDirection)popoverArrowDirection NS_AVAILABLE_IOS(8_0);


/**
 *  需要用到textField时调用,2个Block ConfigurationHandler/textFieldTextChanged都可为nil
 *
 *  @param placeholder          占位字符
 *  @param secureTextEntry      是否使用密文输入
 *  @param configurationHandler TextField配置Block，可nil
 *  @param textFieldTextChanged TextField内容变化的Block，可nil
 */
- (void)addTextFieldWithPlaceholder:(NSString *__nullable)placeholder secureTextEntry:(BOOL)secureTextEntry ConfigurationHandler:(void (^__nullable)(UITextField *textField))configurationHandler textFieldTextChanged:(JKAlertTextFieldTextChangedBlock __nullable)textFieldTextChanged NS_AVAILABLE_IOS(8_0);


/**  不用担心self和JKAlertManager产生循环引用，方法内部会解除Block循环引用
 *
 *
 *  @param controller  用来跳转的控制器
 *  @param actionBlock 处理回调
 */
- (void)showAlertFromController:(UIViewController *)controller actionBlock:(JKAlertActionBlock __nullable)actionBlock NS_AVAILABLE_IOS(8_0);


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated NS_AVAILABLE_IOS(8_0);

@end
NS_ASSUME_NONNULL_END
