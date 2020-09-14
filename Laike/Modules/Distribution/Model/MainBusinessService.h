//
//  MainBusinessService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "MainBusinessCountryModel.h"
#import "QHWFilterModel.h"
#import "QHWItemPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainBusinessService : QHWBaseService

///业务类型  1-房产；2-游学；3-移民；4-留学 102001-医疗
@property (nonatomic, assign) NSInteger businessType;
//@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, strong) NSArray <MainBusinessCountryModel *>*countryArray;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSArray <FilterCellModel *>*priceFilterArray;
@property (nonatomic, strong) NSMutableDictionary *conditionDic;
///留学模块的 产品类型
@property (nonatomic, copy) NSString *produceTypeCode;
@property (nonatomic, strong) NSDictionary *studyabroadFilterDic;//留学用 筛选框的内容
@property (nonatomic, strong) NSMutableArray *studyabroadFilterArray;//每个留学产品类型下的筛选数组
@property (nonatomic, strong) NSArray *studyabroadProductTypeArray;//留学产品类型数组
@property (nonatomic, strong) NSArray *studyabroadCountryArray;//留学国家数组
- (void)configStudyabroadFilterData;

- (void)getHotCountryRequest:(void (^)(void))complete;
- (void)getFilterCountryRequest:(void (^)(void))complete;
- (void)getListFilterDataRequest:(void (^)(void))complete;
- (void)getDistributionListRequestWithIdentifier:(NSString *)identifier Complete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
