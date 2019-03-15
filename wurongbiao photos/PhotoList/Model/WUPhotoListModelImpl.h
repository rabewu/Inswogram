//
//  WUPhotoListModelImpl.h
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/13.
//  Copyright © 2019 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WUPhotoListInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface WUPhotoListModelImpl : NSObject  <WUPhotoListModelInterface>

@property (nonatomic, copy  ) NSArray *list;

@end

NS_ASSUME_NONNULL_END
