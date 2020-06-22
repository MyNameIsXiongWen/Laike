//
//  QHWItemPageModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/20.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class QHWPaginationModel;
@interface QHWItemPageModel : NSObject

@property (nonatomic, strong) QHWPaginationModel *pagination;
@property (nonatomic, strong) NSArray *list;

@end

@interface QHWPaginationModel : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
