//
//  MLRefreshHead.m
//  TableViewReload
//
//  Created by 268Edu on 2018/12/19.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import "MLRefreshHead.h"

@implementation MLRefreshHead

- (void)prepare{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"run%zd", i]];
        [idleImages addObject:image];
    }
   
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"run%zd", i]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:idleImages forState:MJRefreshStateIdle];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
//    self.stateLabel.text = YES;
}


@end
