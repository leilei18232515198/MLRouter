//
//  MLComment.h
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#ifndef MLComment_h
#define MLComment_h
#import <AFNetworking.h>
#import "AppDelegate+MLAppDelegate.h"
#import "AppDelegate.h"
#define ROUTERTOURL(url) [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil]

#define MLAppDelegate ((AppDelegate*)([[UIApplication sharedApplication] delegate]))
#define MLUrl(url) [NSURL URLWithString:url]

#endif /* MLComment_h */
