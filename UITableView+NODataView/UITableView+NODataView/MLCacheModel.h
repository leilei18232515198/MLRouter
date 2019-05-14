//
//  MLCacheModel.h
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/10.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MLRequestModel;
NS_ASSUME_NONNULL_BEGIN

@interface MLCacheModel : NSObject

+ (void)saveResponseObject:(id)responseObject model:(MLRequestModel *)model;
+ (id)unarchiveModel:(MLRequestModel *)model;
+ (NSDate *)getFileCreateTime:(MLRequestModel *)model;
+ (NSDate *)getCurrentTime:(MLRequestModel *)model;
+ (NSInteger)compareCurrentTime:(NSDate *)currentTime withFileCreatTime:(NSDate *)fileCreatTime;
@end

NS_ASSUME_NONNULL_END
