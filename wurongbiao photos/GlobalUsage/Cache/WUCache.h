//
//  WUCache.h
//  YYW
//
//  Created by Rabe on 16/8/9.
//  Copyright © 2016年 YYW. All rights reserved.
//  缓存模块  此类不可有子类！

#import <Foundation/Foundation.h>

@interface WUCache : NSObject

/**
 写入缓存

 @param obj 必须遵循<NSCoding>协议
 @param fileName 文件名，默认自带.archive后缀，调用者不用管后缀
 */
+ (void)cacheObject:(id)obj toFile:(NSString *)fileName;

/**
 读取缓存

 @param fileName fileName 文件名，默认自带.archive后缀，调用者不用管后缀
 @return 缓存对象
 */
+ (id)getCachedObjectForFile:(NSString *)fileName;

/**
 删除闪存&内存数据

 @param fileName 文件名，默认自带.archive后缀，调用者不用管后缀
 */
+ (void)removeCacheFile:(NSString *)filename;

@end
