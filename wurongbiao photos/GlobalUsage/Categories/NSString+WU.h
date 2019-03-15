//
//  NSString+WU.h
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/14.
//  Copyright © 2019 WU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WU)

- (NSString *)stringByTrimmingEndCharactersInSet:(NSCharacterSet *)characterSet;

@end

NS_ASSUME_NONNULL_END
