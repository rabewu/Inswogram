//
//  PresenterTemplate.m
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import "WUPhotoListPresenter.h"
#import "IDMPhotoBrowser.h"

@interface WUPhotoListPresenter ()

@property (nonatomic, weak) id<WUPhotoListViewInterface> photolistView;
@property (nonatomic, weak) id<WUPhotoListViewModelInterface> photolistViewModel;

@end

@implementation WUPhotoListPresenter

#pragma mark - public

- (void)adapterWithPhotoListView:(id<WUPhotoListViewInterface>)photolistView photolistViewModel:(id<WUPhotoListViewModelInterface>)photolistViewModel
{
    _photolistView = photolistView;
    _photolistViewModel = photolistViewModel;
    
    __weak typeof(self) _weakself = self;
    __weak id<WUPhotoListViewModelInterface> __photolistViewModel = _photolistViewModel;
    [_photolistViewModel fetchCacheWithCompletion:^{
        _weakself.photolistView.photolistViewModel = __photolistViewModel;
        _weakself.photolistView.photolistOperator = _weakself;
        [_weakself loadFirstPage];
    }];
}

#pragma mark - WUPhotoListOperatorInterface

- (void)bindWithPhotoListView:(id<WUPhotoListViewInterface>)photolistView photolistViewModel:(id<WUPhotoListViewModelInterface>)photolistViewModel
{
    _photolistView = photolistView;
    _photolistViewModel = photolistViewModel;

    __weak typeof(self) _weakself = self;
    __weak id<WUPhotoListViewModelInterface> __photolistViewModel = _photolistViewModel;
    [_photolistViewModel fetchPhotoListWithCompletion:^{
        _weakself.photolistView.photolistViewModel = __photolistViewModel;
        _weakself.photolistView.photolistOperator = _weakself;
    }];
}

- (void)loadFirstPage
{
    _photolistViewModel.page = 1;
    [self bindWithPhotoListView:self.photolistView photolistViewModel:self.photolistViewModel];
}

- (void)loadNextPage
{
    _photolistViewModel.page++;
    [self bindWithPhotoListView:self.photolistView photolistViewModel:self.photolistViewModel];
}

- (void)onTapPhoto:(UIImageView *)sourceImageView url:(NSURL *)url
{
    NSArray *photos = [IDMPhoto photosWithURLs:@[url]];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:sourceImageView];
    browser.scaleImage = sourceImageView.image;
    [_vc presentViewController:browser animated:YES completion:nil];
}

@end




