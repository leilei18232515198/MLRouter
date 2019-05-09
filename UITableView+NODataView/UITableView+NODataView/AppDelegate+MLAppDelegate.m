//
//  AppDelegate+MLAppDelegate.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "AppDelegate+MLAppDelegate.h"
#import "MLTabBarViewController.h"
#import "JLRoutes.h"
#import "MLNavigationViewController.h"
#import <objc/runtime.h>
@implementation AppDelegate (MLAppDelegate)

- (void)setRootViewController{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[MLTabBarViewController alloc] init];
    [self.window makeKeyAndVisible];
    
//    配置push信息
    [[JLRoutes globalRoutes] addRoute:@"/Push/:controller" handler:^BOOL(NSDictionary<NSString *,NSString *> * _Nonnull parameters) {
        
        UIViewController *v = [[NSClassFromString(parameters[@"controller"]) alloc] init];
        [self paramToVc:v param:parameters];
        [[self currentViewController] pushViewController:v animated:YES];
        return YES;
    }];
    
//    配置present信息
    [[JLRoutes globalRoutes] addRoute:@"/Present/:controller" handler:^BOOL(NSDictionary<NSString *,NSString *> * _Nonnull parameters) {
        
        UIViewController *v = [[NSClassFromString(parameters[@"controller"]) alloc] init];
        [self paramToVc:v param:parameters];
        [[self currentViewController].visibleViewController  presentViewController:v animated:YES completion:nil];
        return YES;
    }];


}


/**
  将传过来的参数赋值给相应的控制器
 */
-(void)paramToVc:(UIViewController *) v param:(NSDictionary<NSString *,NSString *> *)parameters{
    //        runtime将参数传递至需要跳转的控制器
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList(v.class , &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        NSString *param = parameters[key];
        if (param != nil) {
            [v setValue:param forKey:key];
        }
    }
}



/**
 @return 获取选中控制器的导航栏
 */
- (MLNavigationViewController *)currentViewController{
    MLTabBarViewController *tabbarController = (MLTabBarViewController *)self.window.rootViewController;
    return tabbarController.selectedViewController;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    return [[JLRoutes globalRoutes] routeURL:url];
}

@end
