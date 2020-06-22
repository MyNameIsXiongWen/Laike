//
//  QHWItemPageModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/20.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWItemPageModel.h"

@implementation QHWItemPageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pagination": QHWPaginationModel.class,
             };
}

- (QHWPaginationModel *)pagination {
    if (!_pagination) {
        _pagination = QHWPaginationModel.new;
    }
    return _pagination;
}

@end

@implementation QHWPaginationModel

- (NSInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 1;
    }
    return _currentPage;
}

- (NSInteger)pageSize {
    if (!_pageSize) {
        _pageSize = 10;
    }
    return _pageSize;
}

@end
