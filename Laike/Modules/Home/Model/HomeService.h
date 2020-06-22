//
//  HomeService.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeService : QHWBaseService

@property (nonatomic, strong) QHWItemPageModel *itemPageModel;

@end

NS_ASSUME_NONNULL_END
