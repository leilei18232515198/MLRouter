//
//  MLNavigationViewController.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLNavigationViewController.h"

@interface MLNavigationViewController ()

@end

@implementation MLNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 拦截每一个push的控制器, 进行统一设置
    // 过滤第一个根控制器
    if (self.childViewControllers.count > 0) {
        //        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem customBackItemWithTarget:self action:@selector(back)];
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    
    // 千万不要忘记写
    [super pushViewController:viewController animated:animated];    
}

@end
