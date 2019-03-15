//
//  WUHttpClient.m
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/13.
//  Copyright © 2019 WU. All rights reserved.
//

#import "WUHttpClient.h"
#import <AFNetworking/AFHTTPSessionManager.h>

NSString *const WUHTTP_BASE_URL = @"https://api.unsplash.com/";
NSString *const WUHTTP_APP_KEY = @"520fb2a4b5ff890c11fa79a7e67cae872bf265c3e1fabfdb9589536157fa077c";

@implementation WUHttpClient

+ (void)getWithMethod:(NSString *)method parameters:(NSDictionary *)parameters completion:(WUHttpClientCompletion)completion
{
    NSString *url = [NSString stringWithFormat:@"%@%@/?client_id=%@", WUHTTP_BASE_URL, method, WUHTTP_APP_KEY];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"application/javascript", @"text/plain", @"text/json", @"application/x-javascript", nil];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(task, nil, error);
        }
    }];
}

@end
