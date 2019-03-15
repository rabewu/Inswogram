//
//  WUMacros.h
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/13.
//  Copyright © 2019 WU. All rights reserved.
//

#ifndef WUMacros_h
#define WUMacros_h

#define weakify( x ) autoreleasepool{} __weak typeof(x) weak##x = x
#define strongify( x ) autoreleasepool{} __strong typeof(weak##x) x = weak##x
#define onExit(deferBlock) \
autoreleasepool{} __strong nob_defer_block_t nob_macro_concat(__nob_stack_defer_block_, __LINE__) __attribute__((cleanup(nob_deferFunc), unused)) = deferBlock


#endif /* WUMacros_h */
