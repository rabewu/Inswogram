//
//  WUHttpClient.h
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/13.
//  Copyright © 2019 WU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WUHttpClientCompletion)(NSURLSessionDataTask *task, id responseObject, NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface WUHttpClient : NSObject

+ (void)getWithMethod:(NSString *)method parameters:(NSDictionary *)parameters completion:(WUHttpClientCompletion)completion;

@end

NS_ASSUME_NONNULL_END
