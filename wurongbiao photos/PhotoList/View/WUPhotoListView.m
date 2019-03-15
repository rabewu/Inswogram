//
//  ViewTemplate.m
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import "WUPhotoListView.h"
#import <Masonry/Masonry.h>
#import "WUPhotoListCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <MJRefresh/MJRefresh.h>
#import "WUMacros.h"

@interface WUPhotoListView () <UITableViewDataSource, UITableViewDelegate, WUPhotoListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WUPhotoListView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIView *bgView = [UIView new];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    CGFloat topOffset = 0;
    CGFloat barHeight = 64;
    if (@available(iOS 11.0, *)) {
        topOffset = [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;
    }
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(barHeight + topOffset);
    }];

    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"Inswogram";
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bgView);
        make.height.mas_equalTo(barHeight);
    }];

    [self addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - delegate

#pragma mark WUPhotoListCellDelegate

- (void)onTapPhoto:(UIImageView *)sourceImageView url:(NSURL *)url
{
    [_photolistOperator onTapPhoto:sourceImageView url:url];
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photolistViewModel.model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WUPhotoListCell *cell = [WUPhotoListCell cellWithTableView:tableView];
    [cell updateWithCellData:self.photolistViewModel.model.list[indexPath.row] atIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"WUPhotoListCell"
                                    cacheByIndexPath:indexPath
                                       configuration:^(WUPhotoListCell *cell) {
                                           [cell updateWithCellData:self.photolistViewModel.model.list[indexPath.row] atIndexPath:indexPath];
                                       }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - public

#pragma mark - action

#pragma mark - private

#pragma mark - property

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 300;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGFloat bottomOffset = 0;
        if (@available(iOS 11.0, *)) {
            bottomOffset = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableHeaderView = nil;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, bottomOffset)];
        [_tableView registerNib:[UINib nibWithNibName:@"WUPhotoListCell" bundle:nil] forCellReuseIdentifier:@"WUPhotoListCell"];
        @weakify(self);
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.photolistOperator loadFirstPage];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _tableView.mj_header = header;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.photolistOperator loadNextPage];
        }];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (void)setPhotolistViewModel:(id<WUPhotoListViewModelInterface>)photolistViewModel
{
    _photolistViewModel = photolistViewModel;
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    [_tableView reloadData];
}

- (void)setPhotolistOperator:(id<WUPhotoListOperatorInterface>)photolistOperator
{
    _photolistOperator = photolistOperator;
}

@end
