//
//  BaseViewController.h
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UITableView * tableView;

@end
