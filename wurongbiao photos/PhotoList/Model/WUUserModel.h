//
//  WUUserModel.h
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/13.
//  Copyright © 2019 WU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WUUserProfileImageModel : NSObject

@property (nonatomic, copy  ) NSString *large;
@property (nonatomic, copy  ) NSString *medium;
@property (nonatomic, copy  ) NSString *small;

@end

@interface WUUserModel : NSObject

@property (nonatomic, copy  ) NSString *username;
@property (nonatomic, copy  ) NSString *bio;
@property (nonatomic, strong) WUUserProfileImageModel *profile_image;

@end



