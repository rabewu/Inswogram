//
//  ControllerTemplate.m
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import "WUPhotoListViewController.h"
#import "WUPhotoListPresenter.h"
#import "WUPhotoListViewModel.h"
#import "WUPhotoListView.h"

@interface WUPhotoListViewController ()

@property (nonatomic, strong) WUPhotoListPresenter *photolistPresenter;
@property (nonatomic, strong) WUPhotoListViewModel *photolistViewModel;
@property (nonatomic, strong) WUPhotoListView *photolistView;

@end

@implementation WUPhotoListViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self adapterView];
}

#pragma mark - action

#pragma mark - delegate

#pragma mark - notification

#pragma mark - ui

- (void)setupView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.photolistView];
}

#pragma mark - data

- (void)adapterView
{
    [self.photolistPresenter adapterWithPhotoListView:self.photolistView photolistViewModel:self.photolistViewModel];
}

#pragma mark - private

#pragma mark - property

- (WUPhotoListPresenter *)photolistPresenter
{
    if ( !_photolistPresenter ) {
        _photolistPresenter = [WUPhotoListPresenter new];
        _photolistPresenter.vc = self;
    }
    return _photolistPresenter;
}

- (WUPhotoListViewModel *)photolistViewModel
{
    if ( !_photolistViewModel ) {
        _photolistViewModel = [WUPhotoListViewModel new];
    }
    return _photolistViewModel;
}

- (WUPhotoListView *)photolistView
{
    if ( !_photolistView ) {
        _photolistView = [WUPhotoListView new];
        _photolistView.frame = self.view.bounds;
    }
    return _photolistView;
}

@end
