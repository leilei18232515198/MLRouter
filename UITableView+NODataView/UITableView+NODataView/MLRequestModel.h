//
//  MLRequestModel.h
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/9.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLRequestModel : NSObject

@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSDictionary *param;
@property (nonatomic,assign) BOOL isCache;
@property (nonatomic,assign) float cacheTime;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,copy) NSString *pageName;
@property (nonatomic,strong) id originalJeson;
@property (nonatomic,copy) NSString *jsonAppropriate;
@end

NS_ASSUME_NONNULL_END
