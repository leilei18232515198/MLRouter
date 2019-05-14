//
//  MLTestViewController.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLTestViewController.h"
#import "MLComment.h"
#import "AppDelegate.h"
#import "AppDelegate+MLAppDelegate.h"
@interface MLTestViewController ()

@end

@implementation MLTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = [NSString stringWithFormat:@"测试%@",self.index];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((width -100)/2, 100, 100, 100);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"点我啊" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.block) {
        self.block();
    }
}


- (void)clickAction:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"MLHttp://Push/MLTestViewController?userId=10&index=%ld",[self.index integerValue]+1];
    ROUTERTOURL(url);
}

@end
