//
//  ViewModelTemplate.h
//  WUTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 JD All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WUPhotoListInterface.h"

@interface WUPhotoListViewModel: NSObject <WUPhotoListViewModelInterface>

@property (nonatomic, strong) id<WUPhotoListModelInterface> model;
@property (nonatomic, assign) NSInteger page;

@end
