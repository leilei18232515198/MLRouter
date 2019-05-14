//
//  MLCacheModel.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/10.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLCacheModel.h"
#import "MLRequestModel.h"
#import<CommonCrypto/CommonDigest.h>

@implementation MLCacheModel

+ (void)saveResponseObject:(id)responseObject model:(MLRequestModel *)model{
    if (responseObject != nil) {
     NSString *path = [self requestCachePath:model];
     NSLog(@"===============%@",path);
     BOOL state =[NSKeyedArchiver archiveRootObject:responseObject toFile:path];
     if (state) NSLog(@"缓存数据成功");
    }
}

+ (id)unarchiveModel:(MLRequestModel *)model{
    NSString *path = [self requestCachePath:model];
    id cacheJson;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil] == YES) {
    cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    return cacheJson;
}

+ (NSString *)requestCachePath:(MLRequestModel *)model{
    NSString *urlPath = [self md5StringFromString:[self requestUrl:model]];
    return [NSString stringWithFormat:@"%@%@",[self cacheBasePath:cachePath()],urlPath];
}

static inline NSString *cachePath(){
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"MLRequestCache"];
}

+ (NSString *)cacheBasePath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
    return path;

}

//创建文件夹
+(void)createBaseDirectoryAtPath:(NSString *)path{
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
}


//拼接请求字符串
+ (NSString *)requestUrl:(MLRequestModel *)model{
    
    NSDictionary *tempDict = model.param;
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@", model.url];
    [url appendString:@"?"];

    for (NSString *key in tempDict.allKeys) {
        [url appendString:[NSString stringWithFormat:@"%@=%@&",key,tempDict[key]]];
    }
//    去掉最后一个符号
    return [url substringWithRange:NSMakeRange(0, url.length-1)];
}

+ (NSString *)md5StringFromString:(NSString *)string {
    NSLog(@"打印接口：%@",string);
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
     return outputString;
}

//获取文件夹创建时间
+ (NSDate *)getFileCreateTime:(MLRequestModel *)model{
    NSString *path = [self requestCachePath:model];
    NSError * error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //通过文件管理器来获得属性
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
    NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
    return fileCreateDate;
}

//获取当前时间
+ (NSDate *)getCurrentTime:(MLRequestModel *)model{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    NSTimeInterval time = (model.cacheTime == 0 ? 3 * 60 : model.cacheTime * 60);
    NSDate *currentTime = [date dateByAddingTimeInterval:-time];
    return currentTime;
}

//如果没达到指定日期返回-1，刚好是这一时间，返回0，否则返回1
+ (NSInteger)compareCurrentTime:(NSDate *)currentTime withFileCreatTime:(NSDate *)fileCreatTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *currentStr = [dateFormatter stringFromDate:currentTime];
    NSString *fileStr = [dateFormatter stringFromDate:fileCreatTime];
    NSDate *currentDate = [dateFormatter dateFromString:currentStr];
    NSDate *fileDate = [dateFormatter dateFromString:fileStr];
    NSComparisonResult result = [currentDate compare:fileDate];
    NSInteger aa = 0;
    if (result == NSOrderedDescending) {
        //文件创建时间超过当前时间,刷新数据
        aa = 1;
    }else if (result == NSOrderedAscending){
        //文件创建时间小于当前时间,返回缓存数据
        aa = -1;
    }
    return aa;
}

@end
