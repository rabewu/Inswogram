//
//  WUCache.m
//  YYW
//
//  Created by Rabe on 16/8/9.
//  Copyright © 2016年 YYW. All rights reserved.
//

#import "WUCache.h"
#import "AppDelegate.h"

static NSString * const WUCACHE_VERSION = @"WUCACHE_VERSION";
static NSString * const WUCACHE_DEFAULT_DIRECTORY = @"WUCache";
static NSString * const WUCACHE_DEFAULT_PATH_EXTENSION = @"archive";

static NSMutableDictionary *memoryCache;
static NSMutableArray *recentlyAccessedKeys;
static NSInteger kCacheMemoryLimit = 10;

@implementation WUCache

#pragma mark - life cycle

// 类初始化
+ (void)load
{
    /**
     block 版本的通知注册会产生一个__NSObserver *对象用来给外部 remove 观察者
     block 对 observer 对象的捕获早于函数的返回，所以若不加__block，会捕获到 nil
     在 block 执行结束时移除 observer，无需其他清理工作
     这样，在模块内部就完成了在程序启动点代码的挂载
     */
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self initialization];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
}

// 缓存初始化，每次app启动时进行
+ (void)initialization
{
    memoryCache = [NSMutableDictionary dictionaryWithCapacity:kCacheMemoryLimit];
    recentlyAccessedKeys = [NSMutableArray arrayWithCapacity:kCacheMemoryLimit];
    
    NSString *cacheDirectory = [WUCache cacheDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) NSLog(@"\n\n【**WUCACHE-数据IO**】error: %@", error);
    }
    
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:WUCACHE_VERSION];
    double currentAppVersion = [[WUCache appVersion] doubleValue];
    
    // 缓存失效机制，版本为0或更新版本后使缓存失效
    if (lastSavedCacheVersion == 0.0f || lastSavedCacheVersion < currentAppVersion) {
        [WUCache clearCache];
        // 保存当前版本到userDefault，便于日后版本升级后对比
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:WUCACHE_VERSION];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    // 处理内存警告的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    // 处理应用结束的通知(以便离线访问)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationWillTerminateNotification object:nil];
    // 处理应用进入后台的通知(以便离线访问)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

// 获取缓存目录(NSCachesDirectory，因为该数据不是用户产生的)
+ (NSString *)cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = paths.firstObject;
    return [cachesDirectory stringByAppendingPathComponent:WUCACHE_DEFAULT_DIRECTORY];
}

#pragma mark - private

// 从info.plist获取app当前版本
+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

// 将所有内存缓存数据写入闪存
+ (void)saveMemoryCacheToDisk:(NSNotification *)notification
{
    for (NSString *filename in memoryCache.allKeys) {
        NSString *archivePath = [[WUCache cacheDirectory] stringByAppendingPathComponent:filename];
        if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:archivePath error:&error];
            if (error) NSLog(@"\n\n【**WUCACHE-数据IO**】error: %@", error);
        }
        NSData *cacheData = [memoryCache objectForKey:filename];
        [cacheData writeToFile:archivePath atomically:YES];
    }
    
    [memoryCache removeAllObjects];
}

#pragma mark - cache obj

// 写入缓存
+ (void)cacheObject:(id)obj toFile:(NSString *)fileName
{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:obj] toFile:[fileName stringByAppendingPathExtension:WUCACHE_DEFAULT_PATH_EXTENSION]];
}

+ (void)cacheData:(NSData *)data toFile:(NSString *)fileName
{
    // 将缓存写入内存
    [memoryCache setObject:data forKey:fileName];
    if ([recentlyAccessedKeys containsObject:fileName]) {
        [recentlyAccessedKeys removeObject:fileName];
    }
    
    // 将当前使用到的缓存序列移至第一位
    [recentlyAccessedKeys insertObject:fileName atIndex:0];
    
    // 当超过缓存限制数，将最不经常用到的缓存写入闪存
    if (recentlyAccessedKeys.count > kCacheMemoryLimit) {
        NSString *leastRecentlyUsedDataFilename = recentlyAccessedKeys.lastObject;
        NSData *leastRecentlyUsedCacheData = [memoryCache objectForKey:leastRecentlyUsedDataFilename];
        NSString *archivePath = [[WUCache cacheDirectory] stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:archivePath error:&error];
            if (error) NSLog(@"\n\n【**WUCACHE-数据IO**】error: %@", error);
        }
        [leastRecentlyUsedCacheData writeToFile:archivePath atomically:YES];
        
        [recentlyAccessedKeys removeLastObject];
        [memoryCache removeObjectForKey:leastRecentlyUsedDataFilename];
    }
}

#pragma mark - fetch cache

// 读取缓存
+ (id)getCachedObjectForFile:(NSString *)fileName
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:[fileName stringByAppendingPathExtension:WUCACHE_DEFAULT_PATH_EXTENSION]]];
}

+ (NSData *)dataForFile:(NSString *)fileName
{
    NSData *data = [memoryCache objectForKey:fileName];
    if (data) return data;    // 在内存缓存中，直接返回之
    
    // 在闪存中，需读取后返回
    NSString *archivePath = [[WUCache cacheDirectory] stringByAppendingPathComponent:fileName];
    data = [NSData dataWithContentsOfFile:archivePath];
    
    if (data) [self cacheData:data toFile:fileName];  // 将最近访问的数据写入内存中
    
    return data;
}

#pragma mark - delete cache

// 删除闪存&内存

+ (void)removeCacheFile:(NSString *)fileName
{
    fileName = [fileName stringByAppendingPathExtension:WUCACHE_DEFAULT_PATH_EXTENSION];
    if ([recentlyAccessedKeys containsObject:fileName]) {
        [recentlyAccessedKeys removeObject:fileName];
    }
    [memoryCache removeObjectForKey:fileName];
    [self clearCacheFile:fileName];
}

// 清空缓存目录内所有缓存文件
+ (void)clearCache
{
    NSError *error = nil;
    NSArray *cachedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[WUCache cacheDirectory] error:&error];
    if (error) NSLog(@"\n\n【**WUCACHE-数据IO**】error: %@", error);
    error = nil;
    for (NSString *path in cachedItems) {
        [self clearCacheFile:path];
    }
}

// 删除闪存文件
+ (void)clearCacheFile:(NSString *)fileName
{
    NSString *filePath = [[WUCache cacheDirectory] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) NSLog(@"\n\n【**WUCACHE-数据IO**】error: %@", error);
    }
}

// 清空所有内存&闪存缓存 该方法暂不暴露
+ (void)clearAllCache
{
    [memoryCache removeAllObjects];
    [recentlyAccessedKeys removeAllObjects];
    [WUCache clearCache];
}

@end
