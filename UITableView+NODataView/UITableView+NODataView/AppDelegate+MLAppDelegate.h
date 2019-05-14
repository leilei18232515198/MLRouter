//
//  AppDelegate+MLAppDelegate.h
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (MLAppDelegate)


- (void)setRootViewController;
- (void)routeURL:(NSURL *)URL param:(NSDictionary *)param;
@end

NS_ASSUME_NONNULL_END
