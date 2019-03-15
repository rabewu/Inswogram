//
//  ModelTemplate.h
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WUPhotoListInterface.h"
#import "WUPhotoUrlModel.h"
#import "WUUserModel.h"

@interface WUPhotoListModel: NSObject <WUPhotoListModelInterface>

@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, copy  ) NSString *updated_at;
@property (nonatomic, strong) WUPhotoUrlModel *urls;
@property (nonatomic, strong) WUUserModel *user;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;

@end
