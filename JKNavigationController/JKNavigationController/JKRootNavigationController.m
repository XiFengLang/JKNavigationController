//
//  JKRootNavigationController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import "JKRootNavigationController.h"
#import "JKBackIndicatorButton.h"
#import "UINavigationBar+JKTransparentize.m"
#import "UIViewController+JKNavigationController.h"

#pragma mark - JKInterLayerViewController外壳(容器)控制器 <声明>

@interface JKInterLayerViewController : UIViewController

@property (nonatomic, weak, readonly) UIViewController * jk_rootViewController;

+ (JKInterLayerViewController *)jk_interlayerViewControllerWithRootViewController:(UIViewController *)rootViewController;


@end

#pragma mark - JKInterLayerNavigationController外壳导航控制器

@interface JKInterLayerNavigationController : UINavigationController

@property (nonatomic, weak, readonly) JKRootNavigationController * jk_coverNavigationController;

@end

@implementation JKInterLayerNavigationController

- (JKRootNavigationController *)jk_coverNavigationController {
    return (JKRootNavigationController *)self.parentViewController.navigationController;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.jk_rootNavigationController = self.jk_coverNavigationController;
    UIViewController * fromViewController = self.jk_coverNavigationController.jk_viewControllers.lastObject;

    /// 取Title
    NSString * title = fromViewController.navigationItem.title;
    title = fromViewController.navigationItem.title ? : title;
    title = fromViewController.navigationItem.backBarButtonItem.title ? : title;
    if (nil == title || title.length == 0 || [title isEqualToString:@"Back"]) {
        title = @"返回";
    }
    
    
    /// 用容器控制器包装
    JKInterLayerViewController * interlayerViewController = [JKInterLayerViewController jk_interlayerViewControllerWithRootViewController:viewController];
    
    /// 全局设置全屏侧滑返回手势
    viewController.jk_fullScreenPopGestrueEnabled = self.jk_coverNavigationController.jk_fullScreenPopGestrueEnabled;
    
    
    /// 自定义返回按钮
    JKBackIndicatorButton * backIndicator = [JKBackIndicatorButton jk_backIndicatorWithTitle:title tintColor:fromViewController.navigationController.navigationBar.tintColor target:interlayerViewController.childViewControllers.firstObject action:@selector(jk_handleBackIndicatorTapEvent:)];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backIndicator];
    
    
    [self.jk_coverNavigationController pushViewController:interlayerViewController animated:YES];
    
    /// 实现全局效果
    viewController.navigationController.navigationBar.tintColor = fromViewController.navigationController.navigationBar.tintColor;
    viewController.navigationController.navigationBar.titleTextAttributes = fromViewController.navigationController.navigationBar.titleTextAttributes;
    
    /// 全局设置每个控制器的jk_barBackgroundColor
    viewController.navigationController.navigationBar.jk_barBackgroundColor = fromViewController.navigationController.navigationBar.jk_barBackgroundColor;
}


- (void)jk_handleBackIndicatorTapEvent:(JKBackIndicatorButton *)button {
    BOOL shouldPop = YES;
    JKInterLayerViewController * layerViewController = (JKInterLayerViewController *)self.parentViewController;

    if ([layerViewController.jk_rootViewController respondsToSelector:@selector(jk_navigationController:shouldPopItem:)]) {
        shouldPop = [layerViewController.jk_rootViewController jk_navigationController:self.jk_coverNavigationController shouldPopItem:layerViewController.jk_rootViewController.navigationItem];
    }
    
    if (shouldPop) {
        [self.jk_coverNavigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Push/Pop全都由JKRootNavigationController管理


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


#pragma mark - JKInterLayerViewController外壳(容器)控制器 <实现>


@implementation JKInterLayerViewController



/**
 包装容器控制器，JKInterLayerViewController  ->   JKInterLayerNavigationController ->  UIViewController

 @param rootViewController 外层显示的控制器
 @return 容器控制器
 */
+ (JKInterLayerViewController *)jk_interlayerViewControllerWithRootViewController:(UIViewController *)rootViewController {
    JKInterLayerNavigationController * interlayerNavigationController = [[JKInterLayerNavigationController alloc] init];
    interlayerNavigationController.viewControllers = @[rootViewController];
    
    
    JKInterLayerViewController * interlayerViewController = [[JKInterLayerViewController alloc] init];

    [interlayerViewController.view addSubview:interlayerNavigationController.view];
    [interlayerViewController addChildViewController:interlayerNavigationController];
    return interlayerViewController;
}

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

- (BOOL)jk_fullScreenPopGestrueEnabled {
    return self.jk_rootViewController.jk_fullScreenPopGestrueEnabled;
}

@end


#pragma mark - JKRootNavigationController最底层的总导航控制器


@interface JKRootNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

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

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray * tempViewControllers = [NSMutableArray array];
    
    [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JKInterLayerViewController class]]) {
            [tempViewControllers addObject:obj];
        } else {
            obj.jk_rootNavigationController = self;
            JKInterLayerViewController * interlayerViewController = [JKInterLayerViewController jk_interlayerViewControllerWithRootViewController:obj];
            [tempViewControllers addObject:interlayerViewController];
        }
    }];
    [super setViewControllers:tempViewControllers.copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    
    
    /// 用KVO取出原生侧滑手势的Target和响应事件
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    self.jk_popGestureDelegate = internalTarget;
    
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    self.jk_popGestuer = [[UIPanGestureRecognizer alloc] initWithTarget:internalTarget action:internalAction];
    self.jk_popGestuer.maximumNumberOfTouches = 1.0;
}


- (NSArray<UIViewController *> *)jk_viewControllers {
    NSMutableArray * tempViewControllers = [NSMutableArray array];
    for (NSInteger index = 0; index < self.viewControllers.count; index ++) {
        JKInterLayerViewController * interlayerViewController = (JKInterLayerViewController *)self.viewControllers[index];
        [tempViewControllers addObject:interlayerViewController.jk_rootViewController];
    }
    return tempViewControllers.copy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - UINavigationControllerDelegate 修改侧滑手势效果

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(JKInterLayerViewController *)viewController animated:(BOOL)animated {
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}


@end
