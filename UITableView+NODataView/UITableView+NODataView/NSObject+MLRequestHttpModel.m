//
//  NSObject+MLRequestHttpModel.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/10.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "NSObject+MLRequestHttpModel.h"
#import "MLRequestModel.h"
#import <AFNetworking.h>
#import "MLCacheModel.h"
@implementation NSObject (MLRequestHttpModel)

+ (void)originRequestHttpModel:(MLRequestModel *)model success:(void(^)(id response)) success error:(void(^)(id errorResult)) error{
    
    AFHTTPSessionManager *manager = [self manager];
    if (model.isCache&&model.cacheTime>0) {
    NSInteger state = [MLCacheModel compareCurrentTime:[MLCacheModel getCurrentTime:model] withFileCreatTime:[MLCacheModel getFileCreateTime:model]];
    if (state > 0) {
     id json = [MLCacheModel unarchiveModel:model];
     success(json);
     return;
    }
    }else if (model.isCache&&model.cacheTime == 0){
        id json = [MLCacheModel unarchiveModel:model];
        success(json);
    }
//    获取网络请求
    [self requestWithManager:manager requestModel:model success:success error:error];
}

+ (void)requestWithManager:(AFHTTPSessionManager *)manager requestModel:(MLRequestModel *)model success:(void(^)(id response)) success error:(void(^)(id error)) errorBlock{
    
    [manager POST:model.url parameters:model.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        model.originalJeson = responseObject;
        success(responseObject);
        if (model.isCache) {
//            创建缓存文件
            [MLCacheModel saveResponseObject:responseObject model:model];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}


+ (AFHTTPSessionManager *)manager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:10.f];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    //添加证书
//    [self configureCertification:manager];
    return manager;
}

+ (void)configureCertification:(AFHTTPSessionManager *)manager{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxxxxxx" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:NO];
    //设置证书
    [securityPolicy setValidatesDomainName:YES];
    [securityPolicy setPinnedCertificates:certSet];
    manager.securityPolicy = securityPolicy;
}
@end
