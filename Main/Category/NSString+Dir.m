//
//  NSString+Dir.m
//  12期微博
//
//  Created by apple on 15-2-1.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "NSString+Dir.h"

@implementation NSString (Dir)

/**
 *  追加文档目录
 */
- (NSString *)appendDocumentDir
{
    return [self appendDir:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
}

/**
 *  追加缓存目录
 */
- (NSString *)appendCacheDir
{
    return [self appendDir:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
}

/**
 *  追加临时目录
 */
- (NSString *)appendTempDir
{
    return [self appendDir:NSTemporaryDirectory()];
}

/**
 *  将当前字符串拼接到指定目录后面
 *
 *  @param dir 指定目录
 *
 *  @return 拼接好的路径
 */
- (NSString *)appendDir:(NSString *)dir // docpath
{
    return [dir stringByAppendingPathComponent:self];
}


@end
