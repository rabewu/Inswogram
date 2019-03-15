//
//  WUPhotoListCell.m
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/13.
//  Copyright © 2019 WU. All rights reserved.
//

#import "WUPhotoListCell.h"
#import <Masonry/Masonry.h>
#import "WUPhotoListModel.h"
#import <YYKit/UIImageView+YYWebImage.h>
#import "NSString+WU.h"

@interface WUPhotoListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descToDateSpaceConstraint;

@property (nonatomic, strong) WUPhotoListModel *model;

@end

@implementation WUPhotoListCell

#pragma mark - life cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self setup];
}

#pragma mark - delegate

#pragma mark - ui

- (void)setup
{
    self.selectionStyle = UITableViewCellSeparatorStyleNone;

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    _avatarImageView.layer.cornerRadius = 15;
    _avatarImageView.layer.masksToBounds = YES;

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvatar:)];
    [_avatarImageView addGestureRecognizer:tap1];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPhoto:)];
    [_photoImageView addGestureRecognizer:tap2];
}

#pragma mark - public

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifier = NSStringFromClass(WUPhotoListCell.class);
    WUPhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WUPhotoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath
{
    if ([aData isKindOfClass:WUPhotoListModel.class]) {
        _model = (WUPhotoListModel *) aData;
        [_avatarImageView setImageURL:[NSURL URLWithString:_model.user.profile_image.small]];
        [_photoImageView setImageURL:[NSURL URLWithString:_model.urls.thumb]];
        _userNameLabel.text = _model.user.username;
        NSString *desc = [_model.user.bio stringByTrimmingEndCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _descLabel.text = desc;
        _dateLabel.text = _model.updated_at;

        _descLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
        float ratio = _model.height.floatValue / _model.width.floatValue;
        float height = ratio * ([UIScreen mainScreen].bounds.size.width - 20);
        _imageHeightConstraint.constant = height;

        _descToDateSpaceConstraint.constant = desc.length ? 20 : 10;
    }
}

#pragma mark - action

- (void)onTapPhoto:(id)sender
{
    if ([_delegate respondsToSelector:@selector(onTapPhoto:url:)]) {
        [_delegate onTapPhoto:_photoImageView url:[NSURL URLWithString:_model.urls.regular]];
    }
}

- (void)onTapAvatar:(id)sender
{
    if ([_delegate respondsToSelector:@selector(onTapPhoto:url:)]) {
        [_delegate onTapPhoto:_avatarImageView url:[NSURL URLWithString:_model.user.profile_image.large]];
    }
}

#pragma mark - private

#pragma mark - property

@end
