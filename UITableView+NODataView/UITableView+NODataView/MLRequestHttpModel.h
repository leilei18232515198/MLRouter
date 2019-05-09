//
//  MLRequestHttpModel.h
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/9.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MLRequestModel;
NS_ASSUME_NONNULL_BEGIN

@interface MLRequestHttpModel : NSObject

+ (void)requestHttpModel:(MLRequestModel *)model success:(void(^)(id response)) success error:(void(^)(id error)) error;
@end

NS_ASSUME_NONNULL_END
