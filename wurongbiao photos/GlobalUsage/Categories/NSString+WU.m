//
//  NSString+WU.m
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/14.
//  Copyright © 2019 WU. All rights reserved.
//

#import "NSString+WU.h"

@implementation NSString (WU)

- (NSString *)stringByTrimmingEndCharactersInSet:(NSCharacterSet *)characterSet
{
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer range:NSMakeRange(0, length)];

    NSUInteger subLength = 0;
    for (NSInteger i = length; i > 0; i--) {
        if (![characterSet characterIsMember:charBuffer[i - 1]]) {
            subLength = i;
            break;
        }
    }

    return [self substringWithRange:NSMakeRange(0, subLength)];
}

@end
