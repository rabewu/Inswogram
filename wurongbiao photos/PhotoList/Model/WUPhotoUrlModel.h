//
//  WUPhotoUrlModel.h
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/13.
//  Copyright © 2019 WU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WUPhotoUrlModel : NSObject

@property (nonatomic, copy  ) NSString *full;
@property (nonatomic, copy  ) NSString *raw;
@property (nonatomic, copy  ) NSString *regular;
@property (nonatomic, copy  ) NSString *small;
@property (nonatomic, copy  ) NSString *thumb;

@end

NS_ASSUME_NONNULL_END
