//
//  TranslationNavigationBarVC.m
//  TransparentNavgationBar
//
//  Created by apple on 16/1/19.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import "TranslationNavigationBarVC.h"
#import "JPRefreshTitleView.h"
#import "JPTableViewCell.h"
#import "UINavigationBar+JPExtension.h"

#define NAVGATIONBAR self.navigationController.navigationBar
@interface TranslationNavigationBarVC ()<UIGestureRecognizerDelegate>
{
    CGRect HeaderFrame;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)JPRefreshTitleView * refrshView;
@property (nonatomic, assign)CGFloat marginTop;
@end

@implementation TranslationNavigationBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 50;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    HeaderFrame = [self.tableView rectForHeaderInSection:1];
    

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 测试leftBarButtonItem和侧滑返回手势冲突
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];
    
    WeakSelf;
    self.refrshView = [JPRefreshTitleView showRefreshViewInViewController:self
                                                     observableScrollView:self.tableView
                                                                    title:@"上移渐变隐藏"
                                                                     font:[UIFont systemFontOfSize:17]
                                                                textColor:[UIColor whiteColor]
                                                          refreshingBlock:^{
                                                              StrongSelf;
                                                              [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)] withRowAnimation:UITableViewRowAnimationBottom];
                                                              NSLog(@"*****");
                                                          }];
    
    [self.refrshView setActivityIndicatorColor:[UIColor whiteColor]];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 方式1：插入1个高度为64的view充当背景View
    [self.navigationController.navigationBar jp_setNavigationBarBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:1]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    HeaderFrame = [self.tableView rectForHeaderInSection:1];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:(BOOL)animated];
    [self.navigationController.navigationBar jp_restoreNavigationBar];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    if (newoffsetY >= 0 && newoffsetY <= 100) {
        [self.navigationController.navigationBar jp_translationNavigationBarVerticalWithOffsetY:- newoffsetY/100.0*44];
        self.refrshView.alpha = 1-newoffsetY/100;
        self.navigationController.navigationBar.tintColor = [[UIColor whiteColor]colorWithAlphaComponent:1-newoffsetY/100];
        
    }else if (newoffsetY < 0){
        [self.navigationController.navigationBar jp_translationNavigationBarVerticalWithOffsetY:0];
        self.refrshView.alpha = 1;
        self.navigationController.navigationBar.tintColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
        
    }else{
        [self.navigationController.navigationBar jp_translationNavigationBarVerticalWithOffsetY:-44];
        self.refrshView.alpha = 0;
        self.navigationController.navigationBar.tintColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JPTableViewCell class])];
    cell.label.text = [NSString stringWithFormat:@"%d", arc4random_uniform(100)];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UITableViewHeaderFooterView * header=  [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        }
        header.contentView.backgroundColor = [UIColor purpleColor];
        [header.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"header%ld",section];
        [header.contentView addSubview:label];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        return 44;
    }
}


- (void)viewDidLayoutSubviews{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


@end
