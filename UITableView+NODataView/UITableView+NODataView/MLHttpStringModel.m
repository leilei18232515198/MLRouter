//
//  MLHttpStringModel.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/9.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLHttpStringModel.h"

@implementation MLHttpStringModel
static NSString *httpUrl = @"http://www.xiaopuzi.net/app/";

+ (NSString *)appIndexString{
    return [NSString stringWithFormat:@"%@%@",httpUrl,@"course/list"];
}
@end
