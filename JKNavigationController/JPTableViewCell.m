//
//  JPTableViewCell.m
//  JPRefresh
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "JPTableViewCell.h"

@implementation JPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 50;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.position = CGPointMake(screenWidth/2.0, height-1);
    lineLayer.anchorPoint = CGPointMake(0.5, 0);
    lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    lineLayer.bounds = CGRectMake(0, 0, screenWidth, 1);
    [self.contentView.layer addSublayer:lineLayer];
    
//    UIView * redView = [[UIView alloc]init];
//    redView.backgroundColor = [UIColor whiteColor];
//    self.selectedBackgroundView = redView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    if (selected) {
//        self.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        self.accessoryType = UITableViewCellAccessoryNone;
//    }
}

@end
