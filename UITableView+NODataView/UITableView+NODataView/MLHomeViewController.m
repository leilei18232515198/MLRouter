//
//  MLHomeViewController.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLComment.h"
@interface MLHomeViewController ()

@end

@implementation MLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((width -100)/2, 100, 100, 100);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"点我啊" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clickAction:(UIButton *)sender{
//    NSString *url = @"MLHttp://Push/MLTestViewController";
//    ROUTERTOURL(url);
    void (^ testBlock)(void) = ^(void){
        NSLog(@"=============回调了");
    };

    
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:testBlock forKey:@"block"];
    NSString *url = @"MLHttp://Push/MLTestViewController";
    [MLAppDelegate routeURL:MLUrl(url) param:dict];
   

}

@end
