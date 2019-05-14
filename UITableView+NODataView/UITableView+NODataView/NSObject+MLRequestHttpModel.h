//
//  NSObject+MLRequestHttpModel.h
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/10.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MLRequestModel;
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MLRequestHttpModel)

+ (void)originRequestHttpModel:(MLRequestModel *)model success:(void(^)(id response)) success error:(void(^)(id errorResult)) error;


@end

NS_ASSUME_NONNULL_END
