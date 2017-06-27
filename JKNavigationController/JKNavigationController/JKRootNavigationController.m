//
//  JKRootNavigationController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKRootNavigationController.h"
#import "JKBackIndicatorButton.h"
#import "UINavigationBar+JKTransparentize.m"
#import "UIViewController+JKNavigationController.h"





#pragma mark - *******************************************************************
#pragma mark - JKInterLayerViewController外壳(容器)控制器 <声明>

/**
 用于包装customViewController的包裹层控制器，形成JKInterLayerViewController  ->   JKInterLayerNavigationController ->  customViewController的结构
 */
@interface JKInterlayerViewController : UIViewController


/**<  取最外层的customViewController  */
@property (nonatomic, weak, readonly) UIViewController * jk_rootViewController;


/**
 构造方法
 
 @param rootViewController 外层显示的自定义控制器customViewController
 @return 包装后的控制器
 */
+ (JKInterlayerViewController *)jk_interlayerViewControllerWithRootViewController:(UIViewController *)rootViewController;


@end







#pragma mark - *******************************************************************
#pragma mark - JKInterLayerNavigationController外壳导航控制器


/**
 外层customViewController的导航控制器，和customViewController是一一对应的。
 可以理解为：每个控制器都定制了一个专属的导航控制器，导航栏navigationBar也是专属的
 
 重写Push/Pop/Dismiss，转由根导航控制器jk_rootNavigationController调用ush/Pop/Dismiss
 */
@interface JKInterLayerNavigationController : UINavigationController

/**<  根导航控制器  */
@property (nonatomic, weak, readonly) JKRootNavigationController * jk_coverNavigationController;

@end

@implementation JKInterLayerNavigationController

- (JKRootNavigationController *)jk_coverNavigationController {
    return (JKRootNavigationController *)self.parentViewController.navigationController;
}


/**<  重写，由根导航控制器jk_rootNavigationController操作Push/Pop/Dismiss  */

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.jk_rootNavigationController = self.jk_coverNavigationController;
    UIViewController * fromViewController = self.jk_coverNavigationController.jk_viewControllers.lastObject;
    
    /// 取Title
    NSString * title = fromViewController.navigationItem.title;
    title = fromViewController.navigationItem.title ? : title;
    title = fromViewController.navigationItem.backBarButtonItem.title ? : title;
    if (nil == title || [title isEqualToString:@"Back"]) {
        title = @"返回";
    }
    
    
    /// 用容器控制器包装
    JKInterlayerViewController * interlayerViewController = [JKInterlayerViewController jk_interlayerViewControllerWithRootViewController:viewController];
    
    /// 全局设置全屏侧滑返回手势
    viewController.jk_fullScreenPopGestrueEnabled = self.jk_coverNavigationController.jk_fullScreenPopGestrueEnabled;
    
    
    /// 自定义返回按钮
    JKBackIndicatorButton * backIndicator = [JKBackIndicatorButton jk_backIndicatorWithTitle:title tintColor:fromViewController.navigationController.navigationBar.tintColor target:interlayerViewController.childViewControllers.firstObject action:@selector(jk_handleBackIndicatorTapEvent:)];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backIndicator];
    
    /// 由jk_rootNavigationController管理interlayerViewController的入栈出栈
    [self.jk_coverNavigationController pushViewController:interlayerViewController animated:YES];
    
    /// 实现全局效果
    viewController.navigationController.navigationBar.tintColor = fromViewController.navigationController.navigationBar.tintColor;
    viewController.navigationController.navigationBar.titleTextAttributes = fromViewController.navigationController.navigationBar.titleTextAttributes;
    
    /// 全局设置每个控制器的jk_barBackgroundColor
    viewController.navigationController.navigationBar.jk_barBackgroundColor = fromViewController.navigationController.navigationBar.jk_barBackgroundColor;
}




/**
 响应自定义返回按钮的点击事件
 
 @param button JKBackIndicatorButton
 */
- (void)jk_handleBackIndicatorTapEvent:(JKBackIndicatorButton *)button {
    BOOL shouldPop = YES;
    JKInterlayerViewController * layerViewController = (JKInterlayerViewController *)self.parentViewController;
    
    /// 判断customViewController是否有拦截，如果有拦截（实现了JKNavigationControllerDelegate中的方法），则调用customViewController中实现的（jk_navigationController: shouldPopItem:）方法。
    if ([layerViewController.jk_rootViewController respondsToSelector:@selector(jk_navigationController:shouldPopItem:)]) {
        shouldPop = [layerViewController.jk_rootViewController jk_navigationController:self.jk_coverNavigationController shouldPopItem:layerViewController.jk_rootViewController.navigationItem];
    }
    
    if (shouldPop) {
        [self.jk_coverNavigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Push/Pop/Dismiss全都由JKRootNavigationController管理、操作

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.jk_coverNavigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSInteger index = [self.jk_coverNavigationController.jk_viewControllers indexOfObject:viewController];
    return [self.jk_coverNavigationController popToViewController:self.jk_coverNavigationController.viewControllers[index] animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.jk_coverNavigationController popToRootViewControllerAnimated:animated];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self.jk_coverNavigationController dismissViewControllerAnimated:flag completion:completion];
}

@end








#pragma mark - *******************************************************************
#pragma mark - JKInterLayerViewController外壳(容器)控制器 <实现>


@implementation JKInterlayerViewController



/**
 包装容器控制器，JKInterLayerViewController  ->   JKInterLayerNavigationController ->  customViewController
 
 @param rootViewController 外层显示的自定义控制器customViewController
 @return 容器控制器
 */
+ (JKInterlayerViewController *)jk_interlayerViewControllerWithRootViewController:(UIViewController *)rootViewController {
    
    /// 初始化用来包装的导航控制器，包装（管理）customViewController
    JKInterLayerNavigationController * interlayerNavigationController = [[JKInterLayerNavigationController alloc] init];
    interlayerNavigationController.viewControllers = @[rootViewController];
    
    
    /// 再实例一个interlayerViewController管理导航控制器interlayerNavigationController
    JKInterlayerViewController * interlayerViewController = [[JKInterlayerViewController alloc] init];
    
    
    /// BUG 1.0.1: 会提前触发viewDidLoad，但是控制器所在的界面并没有显示。特别是tabBarController.viewControllers，全部会提前走viewDidLoad，影响体验。
    /// 已将此处代码移至下面的viewWillAppear中，这样就能做到界面显示才走viewDidLoad
    //    [interlayerViewController.view addSubview:interlayerNavigationController.view];
    
    [interlayerViewController addChildViewController:interlayerNavigationController];
    return interlayerViewController;
}


/// 针对BUG 1.0.1做的优化
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.childViewControllers.count && self.view.subviews.count == 0) {
        [self.view addSubview:self.childViewControllers.firstObject.view];
        self.childViewControllers.firstObject.view.frame = [UIScreen mainScreen].bounds;
    }
}


/**
 返回外层显示的自定义控制器customViewController
 
 @return customViewController
 */
- (UIViewController *)jk_rootViewController {
    JKInterLayerNavigationController * interlayerNavigationController = self.childViewControllers.firstObject;
    return interlayerNavigationController.viewControllers.firstObject;
}


- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.jk_rootViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.jk_rootViewController;
}

- (NSString *)title {
    return self.jk_rootViewController.title;
}

- (UITabBarItem *)tabBarItem {
    return self.jk_rootViewController.tabBarItem;
}

- (UINavigationItem *)navigationItem {
    return self.jk_rootViewController.navigationItem;
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.jk_rootViewController.hidesBottomBarWhenPushed;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return self.jk_rootViewController.automaticallyAdjustsScrollViewInsets;
}

- (BOOL)jk_fullScreenPopGestrueEnabled {
    return self.jk_rootViewController.jk_fullScreenPopGestrueEnabled;
}

@end






#pragma mark - *******************************************************************
#pragma mark - JKRootNavigationController最底层的总导航控制器


@interface JKRootNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>


/**
 全屏侧滑手势
 */
@property (nonatomic, strong) UIPanGestureRecognizer * jk_popGestuer;
@property (nonatomic, weak) id jk_popGestureDelegate;

@end

@implementation JKRootNavigationController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        /// 要在设置ViewControllers之前隐藏总导航控制器的navigationBar
        [self setNavigationBarHidden:YES];
        [self setViewControllers:self.viewControllers];
    }return self;
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        /// 要在设置ViewControllers之前隐藏总导航控制器的navigationBar
        [self setNavigationBarHidden:YES];
        [self setViewControllers:@[rootViewController]];
    }return self;
}


/**<
 通用接口，对customViewController进行统一包装，以应对外部调用[nav setViewControllers:]和[nav setViewControllers: animated:]。
 
 */
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray * tempViewControllers = [NSMutableArray array];
    
    [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JKInterlayerViewController class]]) {
            [tempViewControllers addObject:obj];
        } else {
            obj.jk_rootNavigationController = self;
            
            /// 包装
            JKInterlayerViewController * interlayerViewController = [JKInterlayerViewController jk_interlayerViewControllerWithRootViewController:obj];
            [tempViewControllers addObject:interlayerViewController];
        }
    }];
    [super setViewControllers:tempViewControllers.copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    
    
    /// 用KVC取出系统侧滑手势的Target和响应事件，PS: 已有2个线上项目使用，不会影响App上架。
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    self.jk_popGestureDelegate = internalTarget;
    
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    self.jk_popGestuer = [[UIPanGestureRecognizer alloc] initWithTarget:internalTarget action:internalAction];
    self.jk_popGestuer.maximumNumberOfTouches = 1.0;
}


/**
 遍历取外部显示的自定义控制器customViewController
 
 @return customViewController
 */
- (NSArray<UIViewController *> *)jk_viewControllers {
    NSMutableArray * tempViewControllers = [NSMutableArray array];
    for (NSInteger index = 0; index < self.viewControllers.count; index ++) {
        JKInterlayerViewController * interlayerViewController = (JKInterlayerViewController *)self.viewControllers[index];
        [tempViewControllers addObject:interlayerViewController.jk_rootViewController];
    }
    return tempViewControllers.copy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@ 收到内存警告⚠️",self);
}



#pragma mark - UINavigationControllerDelegate 修改侧滑手势效果

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(JKInterlayerViewController *)viewController
                    animated:(BOOL)animated {
    
    /// rootVC不响应自定义的（全屏）侧滑手势
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    
    /// 是否拦截返回按钮的点击事件，实现JKNavigationControllerDelegate协议即视为拦截
    /// 如果有拦截，会关闭全屏侧滑返回手势以及自带的侧滑返回手势
    BOOL interceptPopAction = [viewController.jk_rootViewController respondsToSelector:@selector(jk_navigationController:shouldPopItem:)];
    
    if (viewController.jk_fullScreenPopGestrueEnabled) {
        if (isRootVC) {
            [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.jk_popGestuer];
        } else {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.jk_popGestuer];
            self.jk_popGestuer.enabled = !interceptPopAction;
        }
        self.interactivePopGestureRecognizer.delegate = self.jk_popGestureDelegate;
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.jk_popGestuer];
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = isRootVC ? NO : !interceptPopAction;
    }
}

#pragma mark - UIGestureRecognizerDelegate 设置手势的优先级或异步响应

/// 不同的手势能在同一时间被响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/// UIScreenEdgePanGestureRecognizer 优先
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}


@end

