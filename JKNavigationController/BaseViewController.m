//
//  BaseViewController.m
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "BaseViewController.h"
#import "JPTableViewCell.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    

    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
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
        label.backgroundColor = [UIColor purpleColor];
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
