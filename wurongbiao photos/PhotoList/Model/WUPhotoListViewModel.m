//
//  ViewModelTemplate.m
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import "WUPhotoListViewModel.h"
#import "WUPhotoListModel.h"
#import "WUMacros.h"
#import <AFNetworking/AFURLSessionManager.h>
#import "WUHttpClient.h"
#import "WUPhotoListModel.h"
#import <YYKit/NSObject+YYModel.h>
#import "WUPhotoListModelImpl.h"
#import "WUCache.h"

NSString *const PHOTO_LIST_FILE_NAME = @"PHOTO_LIST_FILE_NAME";

@interface WUPhotoListViewModel ()

@end

@implementation WUPhotoListViewModel
@synthesize model = _model;

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super init]) {
        _page = 1;
    }
    return self;
}

#pragma mark - public

#pragma mark - delegate

#pragma mark WUPhotoListViewModelInterface

- (void)fetchCacheWithCompletion:(void (^)(void))completion
{
    id responseObject = [WUCache getCachedObjectForFile:PHOTO_LIST_FILE_NAME];
    if (responseObject) {
        self.model.list = [NSArray modelArrayWithClass:WUPhotoListModel.class json:responseObject];
        self.page = self.model.list.count / 10;
    }
    if (completion) {
        completion();
    }
}

- (void)fetchPhotoListWithCompletion:(void (^)(void))completion
{
    @weakify(self);
    [WUHttpClient getWithMethod:@"photos" parameters:@{@"page": @(_page)} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        if (!error && responseObject) {
            NSArray *list = [NSArray modelArrayWithClass:WUPhotoListModel.class json:responseObject];
            if (self.page == 1) {
                self.model.list = list;
            } else {
                NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.model.list];
                [mArr addObjectsFromArray:list];
                self.model.list = mArr.copy;
            }
            [WUCache cacheObject:[self.model.list modelToJSONString] toFile:PHOTO_LIST_FILE_NAME];
        } else {
            self.page--;
        }
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - action

#pragma mark - private

#pragma mark - property

- (WUPhotoListModelImpl *)model
{
    if ( !_model ) {
        _model = [WUPhotoListModelImpl new];
    }
    return _model;
}

@end
