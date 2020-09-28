//
//  BrandService.h
//  Laike
//
//  Created by xiaobu on 2020/9/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "BrandModel.h"
#import "QHWItemPageModel.h"
#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrandService : QHWBaseService

@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, strong) BrandModel *detailModel;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSArray <QHWMainBusinessDetailBaseModel *>*productList;

- (void)getBrandListRequestComplete:(void(^)(void))complete;
- (void)getBrandDetailRequestComplete:(void(^)(void))complete;
- (void)getBrandProductListRequestComplete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
