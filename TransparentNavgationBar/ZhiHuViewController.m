//
//  ZhiHuViewController.m
//  TransparentNavgationBar
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import "ZhiHuViewController.h"
#import "JPRefreshTitleView.h"
#import "JPTableViewCell.h"
#import "UINavigationBar+JPExtension.h"

@interface ZhiHuViewController ()

{
    CGRect HeaderFrame;
}
@property (nonatomic, strong)JPRefreshTitleView * refrshView;
@property (nonatomic, assign)CGFloat marginTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZhiHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.tableHeaderView = headerView;
    
    
    
    self.tableView.rowHeight = 50;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [self.navigationController.navigationBar jp_setStatusBarBackgroundViewColor:[[UIColor purpleColor] colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    WeakSelf;
    self.refrshView = [JPRefreshTitleView showRefreshViewInViewController:self
                                                     observableScrollView:self.tableView
                                                                    title:@"仿知乎日报"
                                                                     font:[UIFont systemFontOfSize:17]
                                                                textColor:[UIColor whiteColor]
                                                          refreshingBlock:^{
                                                              StrongSelf;
                                                              [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)] withRowAnimation:UITableViewRowAnimationBottom];
                                                              NSLog(@"*****");
                                                          }];
    [self.refrshView setActivityIndicatorColor:[UIColor whiteColor]];
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    HeaderFrame = [self.tableView rectForHeaderInSection:1];
    
    // 方式2：插入1个高度为20的view放在状态栏下面，同时设置navigationBar的背景颜色
    [self.navigationController.navigationBar jp_setStatusBarBackgroundViewColor:[[UIColor purpleColor] colorWithAlphaComponent:0]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    
    
    if (newoffsetY >= 0 && newoffsetY <= 150) {
        [self.navigationController.navigationBar jp_setStatusBarBackgroundViewAlpha:newoffsetY/150];
    }else if (newoffsetY > 150){
        [self.navigationController.navigationBar jp_setStatusBarBackgroundViewAlpha:1];
    }
    
    JKLog(@"%f",HeaderFrame.origin.y);
    if (newoffsetY >= HeaderFrame.origin.y) {
        self.refrshView.hidden = YES;
        JKLog(@"%f  %@",newoffsetY,NSStringFromCGRect([self.tableView rectForHeaderInSection:1]));
        [self.navigationController.navigationBar setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:0]];
        
    }else if (newoffsetY < HeaderFrame.origin.y){
        [self.refrshView resetNavigationItemTitle:@"仿知乎日报"];
        self.refrshView.hidden = NO;
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


- (void)dealloc{
    NSLog(@"%@实例对象被释放",[self class]);
}

@end
