//
//  InterfaceTemplate.h
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - enum

#pragma mark - model interface

@protocol WUPhotoListModelInterface <NSObject>
@required
@property (nonatomic, copy  ) NSArray *list;

@end

#pragma mark - viewModel interface

@protocol WUPhotoListViewModelInterface <NSObject>

@optional
@property (nonatomic, strong) id<WUPhotoListModelInterface> model;
@property (nonatomic, assign) NSInteger page;

- (void)fetchCacheWithCompletion:(void (^)(void))completion;
- (void)fetchPhotoListWithCompletion:(void (^)(void))completion;

@end

#pragma mark - operator interface

@protocol WUPhotoListOperatorInterface <NSObject>

- (void)loadFirstPage;
- (void)loadNextPage;
- (void)onTapPhoto:(UIImageView *)sourceImageView url:(NSURL *)url;

@end

#pragma mark - view interface

@protocol WUPhotoListViewInterface <NSObject>

@property (nonatomic, weak) id<WUPhotoListViewModelInterface> photolistViewModel;
@property (nonatomic, weak) id<WUPhotoListOperatorInterface> photolistOperator;

@end
