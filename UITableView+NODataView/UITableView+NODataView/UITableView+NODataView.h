//
//  UITableView+NODataView.h
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/5.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLRequestModel;
NS_ASSUME_NONNULL_BEGIN

@interface UITableView (NODataView)

@property (nonatomic,copy)void(^reloadBlock)(void);

- (void)setHeadReload:(void(^)(void))reloadBlock;
- (void)setFooterReload:(void(^)(void))reloadBlock;
- (void)endRefresh;
- (void)requestModel:(MLRequestModel *)model success:(void(^)(id response)) success error:(void(^)(id error)) error;
@end

NS_ASSUME_NONNULL_END
