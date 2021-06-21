//
//  NSString+Dir.h
//  12期微博
//
//  Created by apple on 15-2-1.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Dir)

/**
 *  追加文档目录
 */
- (NSString *)appendDocumentDir;

/**
 *  追加缓存目录
 */
- (NSString *)appendCacheDir;

/**
 *  追加临时目录
 */
- (NSString *)appendTempDir;

@end
