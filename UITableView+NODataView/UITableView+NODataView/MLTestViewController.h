//
//  MLTestViewController.h
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLTestViewController : UIViewController

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *index;
@property (nonatomic,copy)void(^ block)(void);

@end

NS_ASSUME_NONNULL_END
