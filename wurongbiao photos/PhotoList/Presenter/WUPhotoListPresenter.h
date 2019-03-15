//
//  PresenterTemplate.h
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUPhotoListInterface.h"

@interface WUPhotoListPresenter: NSObject<WUPhotoListOperatorInterface>

@property (nonatomic, weak  ) UIViewController *vc;

- (void)adapterWithPhotoListView:(id<WUPhotoListViewInterface>)photolistView photolistViewModel:(id<WUPhotoListViewModelInterface>)photolistViewModel;

@end
