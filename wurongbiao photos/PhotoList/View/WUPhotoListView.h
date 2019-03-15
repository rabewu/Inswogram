//
//  ViewTemplate.h
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUPhotoListInterface.h"

@interface WUPhotoListView: UIView <WUPhotoListViewInterface>

@property (nonatomic, weak) id<WUPhotoListViewModelInterface> photolistViewModel;
@property (nonatomic, weak) id<WUPhotoListOperatorInterface> photolistOperator;

@end
