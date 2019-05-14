//
//  MLRequestHttpModel.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/9.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLRequestHttpModel.h"
#import "MLRequestModel.h"
#import <AFNetworking.h>
#import "NSObject+MLRequestHttpModel.h"
@implementation MLRequestHttpModel

+ (void)requestHttpModel:(MLRequestModel *)model success:(void(^)(id response)) success error:(void(^)(id errorResult)) error{
    
    [self originRequestHttpModel:model success:^(id  _Nonnull response) {
      
        id result = response;
        NSArray *tempArray = [model.jsonAppropriate componentsSeparatedByString:@"/"];
        for (NSString *string in tempArray) {
            result = result[string];
        }
        success (result);
        
    } error:^(id  _Nonnull errorResult) {
        error(errorResult);
    }];
}
@end
