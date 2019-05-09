//
//  MLTabBarViewController.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLTabBarViewController.h"
#import "MLNavigationViewController.h"
@interface MLTabBarViewController ()

@end

@implementation MLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureTabbarController];
}

- (void)configureTabbarController{
    UIViewController *home = [NSClassFromString(@"MLHomeViewController") new];
    [self addChildVC:home title:@"首页" image:@"tabHomeGray" selectedImage:@"tabHomeGreen"];
    
    UIViewController *announce = [NSClassFromString(@"MLAnnounceViewController") new];
    [self addChildVC:announce title:@"公告" image:@"tabAnnouceGray" selectedImage:@"tabAnnouceGreen"];
    
    UIViewController *message = [NSClassFromString(@"MLMessageViewController") new];
    [self addChildVC:message title:@"消息" image:@"tabMessegeGray" selectedImage:@"tabMessegeGreeen"];
    
    UIViewController *contact = [NSClassFromString(@"MLContactViewController") new];
    [self addChildVC:contact title:@"联系人" image:@"tabConnectGray" selectedImage:@"tabConnectGreen"];

}


#pragma mark ===============封装添加控制器的方法================
- (void)addChildVC:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    viewController.tabBarItem.title = title;
    
    ///    但是我在每个viewcontroller 这样设置
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    ///同时设置tabbar  和 navigationBar 的文字
    viewController.tabBarItem.title = title;
    /// 设置子控制器的图片
    viewController.tabBarItem.image = [UIImage imageNamed:image];
    ///    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    ///设置tabBarItem 的 imageWithRenderingMode 才能显示自定义的图片
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ///设置文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor magentaColor];
    selectTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    [viewController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    ///    childVc.view.backgroundColor = HWRandomColor;///在这里会加载控制器的view
    MLNavigationViewController *mainNavi = [[MLNavigationViewController alloc] initWithRootViewController:viewController];
    mainNavi.navigationBar.translucent = NO;
    [self addChildViewController:mainNavi];
}
@end
