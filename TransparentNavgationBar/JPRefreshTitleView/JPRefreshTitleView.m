//
//  JPRefreshTitleView.m
//  JPRefresh
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import "JPRefreshTitleView.h"
#define JKACTIVITY_HEIGHT 20
#define JKSPACE 2

@interface JPRefreshTitleView  ()

@property (nonatomic, strong)UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)CAShapeLayer * foregroundLayer;
@property (nonatomic, strong)CAShapeLayer * backgroundLayer;
@property (nonatomic, copy)JPrefreshingBlock refreshingBlock;

@property (nonatomic, assign)CGFloat viewWidth;
@property (nonatomic, assign)CGFloat viewHeight;
@property (nonatomic, assign)CGFloat progress;

// 刷新的临界点,具体见KVO方法里的计算，重点理解这句话：向下拖动的滑动偏移【绝对值/距离】超过77就刷新
@property (nonatomic, assign)CGFloat threshold;

//通过scrollView/tableView/collectionView的contentInset.top偏移量计算临界点的大小
//系统优化机制viewController.automaticallyAdjustsScrollViewInsets及手动设置contentInset都会改变距离顶部的偏移量
@property (nonatomic, assign)CGFloat marginTop;


// 用于移除KVO监听，以及监测contenInset.top
@property (nonatomic, strong)UIScrollView * scrollView;


@end

@implementation JPRefreshTitleView

#pragma mark - 计算布局并显示视图
+ (JPRefreshTitleView *)showRefreshViewInViewController:(UIViewController *)viewController
                                  observableScrollView:(UIScrollView *)scrollView
                                                 title:(NSString *)title
                                                  font:(UIFont *)font
                                             textColor:(UIColor *)textColor
                                        refreshingBlock:(JPrefreshingBlock)refreshingBlock{

    viewController.navigationController.navigationBarHidden = NO;
    
    JPRefreshTitleView * contenView = [[JPRefreshTitleView alloc]init];
    if (refreshingBlock) contenView.refreshingBlock = refreshingBlock;
    if (scrollView) contenView.scrollView = scrollView;
    contenView.threshold = -77; // 刷新临界点
    
    contenView.titleLabel = [[UILabel alloc]init];
    contenView.titleLabel.text = title;
    contenView.titleLabel.textColor = textColor ? textColor : [UIColor blackColor];
    contenView.titleLabel.font = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 40)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:contenView.titleLabel.font}
                                      context:nil].size;
    
    
    CGSize newSize = [contenView.titleLabel sizeThatFits:size];
    contenView.viewHeight = newSize.height < JKACTIVITY_HEIGHT ? JKACTIVITY_HEIGHT : newSize.height;
    // 传title时，会将title居中，传入nil时，将activityIndicator居中。
    contenView.viewWidth  = size.width ? newSize.width + (2 * JKSPACE + JKACTIVITY_HEIGHT) * 2 : newSize.width + 2 * JKSPACE + JKACTIVITY_HEIGHT;
    
    CGPoint labelCenter = CGPointMake(JKACTIVITY_HEIGHT + 2 * JKSPACE + newSize.width/2, contenView.viewHeight/2.0);
    CGRect labelBounds = CGRectMake(0, 0, newSize.width, newSize.height);
    contenView.titleLabel.center = labelCenter;
    contenView.titleLabel.bounds = labelBounds;

    //    宽高20  JKACTIVITY_HEIGHT
    contenView.activityIndicator = [[UIActivityIndicatorView alloc]init];
    contenView.activityIndicator.hidesWhenStopped = YES;
    contenView.activityIndicator.hidden = YES;
    contenView.activityIndicator.bounds = CGRectMake(0, 0, JKACTIVITY_HEIGHT, JKACTIVITY_HEIGHT);
    contenView.activityIndicator.center = CGPointMake(JKSPACE + JKACTIVITY_HEIGHT/2, contenView.viewHeight/2.0);
    contenView.activityIndicator.activityIndicatorViewStyle = UIActionSheetStyleBlackTranslucent;
    
    contenView.bounds = CGRectMake(0, 0, contenView.viewWidth, contenView.viewHeight);
    [contenView addSubview:contenView.titleLabel];
    [contenView addSubview:contenView.activityIndicator];
    
    viewController.navigationItem.titleView = contenView;

    [contenView addCircleLayers];
    if (scrollView) [scrollView addObserver:contenView forKeyPath:@"contentOffset"
                                    options:NSKeyValueObservingOptionNew
                                    context:nil];
    return contenView;
}



#pragma mark - 进度条
- (void)addCircleLayers{
    
    self.backgroundLayer = [CAShapeLayer layer];
    self.backgroundLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundLayer.strokeColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    self.backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    self.backgroundLayer.position  = self.activityIndicator.center;
    self.backgroundLayer.lineWidth = 1;
    self.backgroundLayer.strokeStart = 0;
    self.backgroundLayer.strokeEnd = 1.0;
    
    CGRect bounds = self.activityIndicator.bounds;
    //bounds.size.height -= 2;
    //bounds.size.width -= 2;   //对应cornerRadius:JKACTIVITY_HEIGHT/2.0-1
    self.backgroundLayer.bounds = bounds;
    
    UIBezierPath * backPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:JKACTIVITY_HEIGHT/2.0];
    self.backgroundLayer.path = backPath.CGPath;
    
    self.foregroundLayer = [CAShapeLayer layer];
    self.foregroundLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.foregroundLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    self.foregroundLayer.fillColor = [UIColor clearColor].CGColor;
    self.foregroundLayer.position  = self.activityIndicator.center;
    self.foregroundLayer.lineWidth = 2;
    self.foregroundLayer.strokeStart = 0;
    self.foregroundLayer.strokeEnd = 0;
    self.foregroundLayer.bounds = bounds;
    self.foregroundLayer.path = backPath.CGPath;
    self.foregroundLayer.lineCap = @"round";
    
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.foregroundLayer];
    
    [self hideCircleLayer];
}

#pragma mark - KVO 核心代码
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        // 实时监测scrollView.contentInset.top，存在系统优化机制时为-64，关闭后为0（不包括手动设置的情况）
        if (self.marginTop != self.scrollView.contentInset.top) {
            self.marginTop = self.scrollView.contentInset.top;
        }
        if (self.isRefreshing) return;
        
        CGFloat offsetY = [change[@"new"] CGPointValue].y;
        
        // 栗子：存在系统优化机制时scrollView.contentInset.top = 64，而scrollView.contenOffset.y= -64
        // 相加之和--newoffsetY便是我们要算的实际偏移，最开始等于0（向下拖时，newoffsetY < 0）
        CGFloat newoffsetY = offsetY + self.marginTop;
        
        // -77<newoffsetY<0 即拖动距离大于0，小于77,重写progress的setter方法触发进度条
        if (newoffsetY > 0){
            self.progress = 0;
            
        }else if (newoffsetY >= self.threshold && newoffsetY <= 0) {
            self.progress = newoffsetY/self.threshold;
            
        }else if (newoffsetY < self.threshold && !self.scrollView.isDragging){ // 临界点，开始刷新
            [self startRefresh];
            self.progress = 0;
        }else{
            if (self.progress > 0 && self.progress < 1) {
                self.progress = 1;  // KVO延迟，防止拖拽过快，进度不等于1
            }
        }
        
        
    }else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - 重写setter方法

// 进度条的逻辑处理
- (void)setProgress:(CGFloat)progress{
    if (_progress == progress) {
        return;
    }
    _progress = progress;
    if (progress == 0) {
        [self hideCircleLayer];
    } else if (progress == 1 && !self.scrollView.isDragging){
        [self hideCircleLayer];
    }else{
        [self displayCircleLayer];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    if (self.scrollView.isDragging) {
        [CATransaction setAnimationDuration:0.15];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    }else{
        [CATransaction setAnimationDuration:0.25];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    }
    self.foregroundLayer.strokeEnd = MIN(progress, 1);
    [CATransaction commit];
}


- (void)resetNavigationItemTitle:(NSString *)title{
    self.titleLabel.text = title;
}


- (void)setActivityIndicatorColor:(UIColor *)activityIndicatorColor{
    _activityIndicatorColor = activityIndicatorColor;
    self.activityIndicator.color = activityIndicatorColor;
    self.foregroundLayer.strokeColor = activityIndicatorColor.CGColor;
}

//  再次处理大小
- (void)setRightView:(UIView *)rightView{
    if (_rightView) {
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
    rightView.bounds = CGRectMake(0, 0, JKACTIVITY_HEIGHT, JKACTIVITY_HEIGHT);
    rightView.center = CGPointMake(self.viewWidth - JKACTIVITY_HEIGHT/2.0 + JKSPACE, self.viewHeight/2.0);
    _rightView = rightView;
    [self addSubview:_rightView];
}


- (void)hideCircleLayer{
    if (!self.backgroundLayer.hidden) {
        self.backgroundLayer.hidden = YES;
        self.foregroundLayer.hidden = YES;
    }
}

- (void)displayCircleLayer{
    if (self.backgroundLayer.hidden) {
        self.backgroundLayer.hidden = NO;
        self.foregroundLayer.hidden = NO;
    }
}

- (void)startRefresh{
    if (self.isRefreshing == NO) {
        [self.activityIndicator startAnimating];
        if (self.refreshingBlock)  self.refreshingBlock();
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];
    }
}

- (void)stopRefresh{
    if (self.isRefreshing) {
        [self.activityIndicator stopAnimating];
    }
}

- (BOOL)isRefreshing{
    return self.activityIndicator.isAnimating;
}

- (void)dealloc{
    [self removeJPRefreshTitleView];
    JKLog(@"%@被释放",[self class]);
}

// 避免内存泄露
- (void)removeJPRefreshTitleView{
    [self stopRefresh];
    if(self.scrollView) [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollView = nil;
    
    if (self.rightView) self.rightView = nil;
    
    //self.viewController.navigationItem.title = self.titleLabel.text;
    //[self.viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:self.titleLabel.textColor,NSFontAttributeName:self.titleLabel.font}];
}





@end
