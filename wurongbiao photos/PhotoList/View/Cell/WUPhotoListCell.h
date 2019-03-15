//
//  WUPhotoListCell.h
//  wurongbiao photos
//
//  Created by wurongbiao on 2019/3/13.
//  Copyright © 2019 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WUPhotoListCellDelegate <NSObject>

- (void)onTapPhoto:(UIImageView *)sourceImageView url:(NSURL *)url;

@end

@interface WUPhotoListCell : UITableViewCell

@property (nonatomic, weak) id<WUPhotoListCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
