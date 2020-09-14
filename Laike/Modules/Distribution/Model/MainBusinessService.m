//
//  MainBusinessService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MainBusinessService.h"
#import "FilterBtnViewCellModel.h"
#import "QHWMainBusinessDetailBaseModel.h"

@implementation MainBusinessService


- (instancetype)init {
    if (self == [super init]) {
        self.tableViewCellArray = @[@{@"cell": @"QHWMainBusinessTableViewCell",
                                      @"identifier": @"house",
                                      @"model": @"QHWHouseModel",
                                      @"businessType": @"1",
                                      @"url": kHouseList
                                    },
                                    @{@"cell": @"QHWMainBusinessTableViewCell",
                                      @"identifier": @"study",
                                      @"model": @"QHWStudyModel",
                                      @"businessType": @"2",
                                      @"url": kStudyList
                                    },
                                    @{@"cell": @"QHWMainBusinessTableViewCell",
                                      @"identifier": @"migration",
                                      @"model": @"QHWMigrationModel",
                                      @"businessType": @"3",
                                      @"url": kMigrationList
                                    },
                                    @{@"cell": @"QHWMainBusinessTableViewCell",
                                      @"identifier": @"student",
                                      @"model": @"QHWStudentModel",
                                      @"businessType": @"4",
                                      @"url": kStudentList
                                    },
                                    @{@"cell": @"QHWMainBusinessTableViewCell",
                                      @"identifier": @"treatment",
                                      @"model": @"QHWTreatmentModel",
                                      @"businessType": @"102001",
                                      @"url": kTreatmentList
                                    }];
    }
    return self;
}

#pragma mark ------------热门国家-------------
- (void)getHotCountryRequest:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kHotIndustryCountry parameters:@{@"industryId": @(self.businessType)} success:^(id responseObject) {
        self.countryArray = [NSArray yy_modelArrayWithClass:MainBusinessCountryModel.class json:responseObject[@"data"][@"list"]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

#pragma mark ------------国家筛选条件-------------
- (void)getFilterCountryRequest:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kIndustryOverseasCountry parameters:@{@"industryId": @(self.businessType)} success:^(id responseObject) {
        self.studyabroadCountryArray = responseObject[@"data"][@"list"];
        [self handleCountryFilterDataWithArray:responseObject[@"data"][@"list"] TargetArray:self.filterArray];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

#pragma mark ------------筛选条件-------------
- (void)getListFilterDataRequest:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSString *urlStr;
    /*1-房产；2-游学；3-移民；4-留学；102001-医疗*/
    switch (self.businessType) {
        case 1:
            urlStr = kHouseFilter;
            break;
        case 2:
            urlStr = kStudyFilter;
            break;
        case 3:
            urlStr = kMigrationFilter;
            break;
        case 4:
            urlStr = kStudentFilter;
            break;
        default:
            urlStr = kTreatmentFilter;
            break;
    }
    [QHWHttpManager.sharedInstance QHW_POST:urlStr parameters:@{} success:^(id responseObject) {
        self.studyabroadFilterDic = responseObject[@"data"];
        [self handleMainBusinessFilterDataWithDic:responseObject[@"data"] TargetArray:self.filterArray];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

#pragma mark ------------列表-------------
- (void)getDistributionListRequestWithIdentifier:(NSString *)identifier Complete:(void (^)(void))complete {
    __block NSDictionary *dic;
    [self.tableViewCellArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"identifier"] isEqualToString:identifier]) {
            dic = obj;
            *stop = YES;
        }
    }];
    NSString *modelStr = dic[@"model"];
    NSInteger businessType = [dic[@"businessType"] integerValue];
    [QHWHttpLoading showWithMaskTypeBlack];
    NSMutableDictionary *params = @{@"businessType": @(businessType),
                                    @"currentPage": @(self.itemPageModel.pagination.currentPage),
                                    @"pageSize": @(self.itemPageModel.pagination.pageSize)}.mutableCopy;
    [self handleCondtionSelectedItem];
    [params addEntriesFromDictionary:self.conditionDic];
    
    [QHWHttpManager.sharedInstance QHW_POST:kDistributionList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        NSArray *tempArray = [NSArray yy_modelArrayWithClass:NSClassFromString(modelStr) json:self.itemPageModel.list];
        for (QHWMainBusinessDetailBaseModel *tempModel in tempArray) {
            tempModel.businessType = businessType;
            QHWBaseModel *baseModel = [[QHWBaseModel alloc] configModelIdentifier:@"QHWMainBusinessTableViewCell" Height:140 Data:@[tempModel, @(2)]];
            [self.tableViewDataArray addObject:baseModel];
        }
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)handleCondtionSelectedItem {
    for (FilterBtnViewCellModel *cellModel in [self getTargetArray]) {
        for (QHWFilterModel *filterModel in cellModel.dataArray) {
            if ([filterModel.key isEqualToString:@"totalPrice"]) {
                if ([self.conditionDic.allKeys containsObject:@"totalPrice"]) {
                    [self.conditionDic removeObjectForKey:@"totalPrice"];
                }
                if ([self.conditionDic.allKeys containsObject:@"totalPriceMin"]) {
                    [self.conditionDic removeObjectForKey:@"totalPriceMin"];
                }
                if ([self.conditionDic.allKeys containsObject:@"totalPriceMax"]) {
                    [self.conditionDic removeObjectForKey:@"totalPriceMax"];
                }
                FilterCellModel *tempModel = nil;
                NSMutableArray <FilterCellModel *>*tempArray = [NSMutableArray array];
                for (FilterCellModel *model in filterModel.content) {
                    if (model.selected) {
                        tempModel = model;
                    } else if (model.valueStr.length > 0) {
                        [tempArray addObject:model];
                    }
                }
                if (tempModel) {
                    self.conditionDic[@"totalPrice"] = tempModel.code;
                } else if (tempArray.count > 0) {
                    for (FilterCellModel *model in tempArray) {
                        self.conditionDic[model.code] = model.valueStr;
                    }
                }
            } else if ([filterModel.key containsString:@"countryId"]) {
                //因为国家的数据结构不一样，所以单独处理过了，这里不用处理了
            } else {
                FilterCellModel *tempModel = nil;
                for (FilterCellModel *model in filterModel.content) {
                    if (model.selected) {
                        tempModel = model;
                        break;
                    }
                }
                if (tempModel) {
                    if ([filterModel.key isEqualToString:@"serviceFeeCode"] || [filterModel.key isEqualToString:@"investmentCode"] || [filterModel.key isEqualToString:@"professionalCode"]) {
                        self.conditionDic[filterModel.key] = tempModel.code;
                    } else {
                        self.conditionDic[filterModel.key] = tempModel.id ?: tempModel.code;
                    }
                } else {
                    if ([self.conditionDic.allKeys containsObject:filterModel.key]) {
                        [self.conditionDic removeObjectForKey:filterModel.key];
                    }
                }
            }
        }
    }
}

- (void)handleCountryFilterDataWithArray:(NSArray *)sourceArray TargetArray:(NSMutableArray *)targetArray {
    if (self.businessType != 102001) {
        NSMutableArray *array = NSMutableArray.array;
        NSString *countryKey = @"";
        NSString *cityKey = @"";
        if (self.businessType == 1) {
            countryKey = @"countryId";
            cityKey = @"cityId";
        } else if (self.businessType == 2) {
            countryKey = @"continentId";
            cityKey = @"studyCountryId";
        } else {
            countryKey = @"continentId";
            cityKey = @"countryId";
        }
        FilterCellModel *nolimitCountryModel = [FilterCellModel modelWithName:@"不限" Code:@""];
        nolimitCountryModel.valueStr = countryKey;
        [array addObject:nolimitCountryModel];
        for (NSDictionary *dic in sourceArray) {
            FilterCellModel *model = [FilterCellModel modelWithName:dic[@"name"] Code:dic[@"id"]];
            model.valueStr = countryKey;
            FilterCellModel *nolimitCityModel = [FilterCellModel modelWithName:@"不限" Code:@""];
            nolimitCityModel.valueStr = cityKey;
            [model.data addObject:nolimitCityModel];
            for (NSDictionary *subDic in dic[@"children"]) {
                FilterCellModel *subModel = [FilterCellModel modelWithName:subDic[@"name"] Code:subDic[@"id"]];
                subModel.valueStr = cityKey;
                [model.data addObject:subModel];
            }
            [array addObject:model];
        }
        [targetArray insertObject:[FilterBtnViewCellModel modelWithName:@"国家"
                                                  Img:@"global_down"
                                            DataArray:@[[QHWFilterModel modelWithTitle:@"国家"
                                                                                   Key:@"countryId"
                                                                               Content:array
                                                                       MutableSelected:NO]]
                                                Color:kColorTheme2a303c]
                          atIndex:0];
    }
}

- (void)handleMainBusinessFilterDataWithDic:(NSDictionary *)dic TargetArray:(NSMutableArray *)targetArray {
    /*1-房产；2-游学；3-移民；4-留学；102001-医疗*/
    if (self.businessType == 1) {
        NSMutableArray *tempPriceFilterArray = NSMutableArray.array;
        FilterCellModel *priceModelMin = FilterCellModel.new;
        priceModelMin.placeHolder = @"最低价格";
        priceModelMin.code = @"totalPriceMin";
        priceModelMin.cellType = CellTypeTextField;
        priceModelMin.size = CGSizeMake(floor((kScreenW-75)/2), 30);
        [tempPriceFilterArray addObject:priceModelMin];
        
        FilterCellModel *priceModelWord = FilterCellModel.new;
        priceModelWord.name = @"至";
        priceModelWord.cellType = CellTypeWord;
        priceModelWord.size = CGSizeMake(25, 30);
        [tempPriceFilterArray addObject:priceModelWord];
        
        FilterCellModel *priceModelMax = FilterCellModel.new;
        priceModelMax.placeHolder = @"最高价格";
        priceModelMax.code = @"totalPriceMax";
        priceModelMax.cellType = CellTypeTextField;
        priceModelMax.size = CGSizeMake(floor((kScreenW-75)/2), 30);
        [tempPriceFilterArray addObject:priceModelMax];
        
        self.priceFilterArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"totalPriceList"]];
        [tempPriceFilterArray addObjectsFromArray:self.priceFilterArray];
        
        [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"总价"
                                                                      Img:@"global_down"
                                                                DataArray:@[[QHWFilterModel modelWithTitle:@"价格区间（万）"
                                                                                                       Key:@"totalPrice"
                                                                                                   Content:tempPriceFilterArray
                                                                                           MutableSelected:NO]]
                                                                    Color:kColorTheme2a303c]];
        
        for (NSDictionary *moreDic in dic[@"moreList"]) {
            NSMutableArray *tempFilterArray = NSMutableArray.array;
            for (NSDictionary *tempItemDic in moreDic[@"itemList"]) {
                [tempFilterArray addObject:[FilterCellModel modelWithName:tempItemDic[@"name"] Code:tempItemDic[@"key"]]];
            }
            if ([moreDic[@"key"] isEqualToString:@"areaCode"]) {
                [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"面积"
                                                                         Img:@"global_down"
                                                                   DataArray:@[[QHWFilterModel modelWithTitle:moreDic[@"title"]
                                                                                                          Key:moreDic[@"key"]
                                                                                                      Content:tempFilterArray
                                                                                              MutableSelected:NO]]
                                                                       Color:kColorTheme2a303c]];
            }
            if ([moreDic[@"key"] isEqualToString:@"deliveryTimeCode"]) {
                [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"交房时间"
                                                                         Img:@"global_down"
                                                                   DataArray:@[[QHWFilterModel modelWithTitle:moreDic[@"title"]
                                                                                                          Key:moreDic[@"key"]
                                                                                                      Content:tempFilterArray
                                                                                              MutableSelected:NO]]
                                                                       Color:kColorTheme2a303c]];
            }
        }
    } else if (self.businessType == 2) {
        NSArray *tempSchemeFilterArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"studyThemeList"]];
        [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"游学主题"
                                                                      Img:@"global_down"
                                                                DataArray:@[[QHWFilterModel modelWithTitle:@"游学主题"
                                                                                                       Key:@"studyThemeId"
                                                                                                   Content:tempSchemeFilterArray
                                                                                           MutableSelected:NO]]
                                                                    Color:kColorTheme2a303c]];
    } else if (self.businessType == 3) {
        NSArray *tempMigrationTypeFilterArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"migrationTypeList"]];
        [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"项目类型"
                                                                      Img:@"global_down"
                                                                DataArray:@[[QHWFilterModel modelWithTitle:@"项目类型"
                                                                                                       Key:@"migrationTypeId"
                                                                                                   Content:tempMigrationTypeFilterArray
                                                                                           MutableSelected:NO]]
                                                                    Color:kColorTheme2a303c]];
        
        NSArray *tempMoneyFilterArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"investmentList"]];
        [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"投资金额"
                                                                      Img:@"global_down"
                                                                DataArray:@[[QHWFilterModel modelWithTitle:@"投资金额"
                                                                                                       Key:@"investmentCode"
                                                                                                   Content:tempMoneyFilterArray
                                                                                           MutableSelected:NO]]
                                                                    Color:kColorTheme2a303c]];
    } else if (self.businessType == 4) {
        self.studyabroadProductTypeArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"produceTypeList"]];
    } else if (self.businessType == 102001) {
        NSArray *tempTypeFilterArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:dic[@"treatmentTypeList"]];
        [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"类型"
                                                                 Img:@"global_down"
                                                           DataArray:@[[QHWFilterModel modelWithTitle:@"类型"
                                                                                                  Key:@"treatmentTypeId"
                                                                                              Content:tempTypeFilterArray
                                                                                      MutableSelected:NO]]
                                                               Color:kColorTheme2a303c]];
        
        NSMutableArray *tempCountryArray = NSMutableArray.array;
        FilterCellModel *nolimitCountryModel = [FilterCellModel modelWithName:@"不限" Code:@""];
        nolimitCountryModel.valueStr = @"countryId";
        [tempCountryArray addObject:nolimitCountryModel];
        for (NSDictionary *tempDic in dic[@"allCountryList"]) {
            FilterCellModel *tempModel = [FilterCellModel modelWithName:tempDic[@"countryName"] Code:tempDic[@"countryId"]];
            tempModel.valueStr = @"countryId";
            [tempCountryArray addObject:tempModel];
        }
        [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"国家"
                                                                 Img:@"global_down"
                                                           DataArray:@[[QHWFilterModel modelWithTitle:@"国家"
                                                                                                  Key:@"countryId"
                                                                                              Content:tempCountryArray
                                                                                      MutableSelected:NO]]
                                                               Color:kColorTheme2a303c]];
    }
//    if (self.businessType == 1 || self.businessType == 2) {
//        NSMutableArray *tempMoreArray = NSMutableArray.array;
//        for (NSDictionary *moreDic in dic[@"moreList"]) {
//            NSMutableArray *tempItemArray = NSMutableArray.array;
//            for (NSDictionary *tempItemDic in moreDic[@"itemList"]) {
//                [tempItemArray addObject:[FilterCellModel modelWithName:tempItemDic[@"name"] Code:tempItemDic[@"key"]]];
//            }
//            [tempMoreArray addObject:[QHWFilterModel modelWithTitle:moreDic[@"title"]
//                                                                Key:moreDic[@"key"]
//                                                            Content:tempItemArray
//                                                    MutableSelected:NO]];
//        }
//        [targetArray addObject:[FilterBtnViewCellModel modelWithName:@"更多筛选"
//                                                                      Img:@"global_down"
//                                                                DataArray:tempMoreArray
//                                                                    Color:kColorTheme2a303c]];
//    }
}

- (void)configStudyabroadFilterData {
//    if (!_studyabroadFilterArray) {
        _studyabroadFilterArray = NSMutableArray.array;
        NSArray *tempEducationFilterArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:self.studyabroadFilterDic[@"educationList"]];
        switch (self.produceTypeCode.integerValue) {
            case 1:
            {
                [self handleCountryFilterDataWithArray:self.studyabroadCountryArray TargetArray:_studyabroadFilterArray];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"学历"
                                                                                     Img:@"global_down"
                                                                               DataArray:@[[QHWFilterModel modelWithTitle:@"学历"
                                                                                                                      Key:@"educationId"
                                                                                                                  Content:tempEducationFilterArray
                                                                                                          MutableSelected:NO]]
                                                                                   Color:kColorTheme2a303c]];
            
                
                NSArray *tempMoneyArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:self.studyabroadFilterDic[@"serviceFeeList"]];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"价格"
                                                                                     Img:@"global_down"
                                                                               DataArray:@[[QHWFilterModel modelWithTitle:@"价格"
                                                                                                                      Key:@"serviceFeeCode"
                                                                                                                  Content:tempMoneyArray
                                                                                                          MutableSelected:NO]]
                                                                                   Color:kColorTheme2a303c]];
            }
                break;
            case 2:
            {
                NSArray *tempProfessionalArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:self.studyabroadFilterDic[@"professionalList"]];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"专业"
                                                                                     Img:@"global_down"
                                                                               DataArray:@[[QHWFilterModel modelWithTitle:@"专业"
                                                                                                                      Key:@"professionalCode"
                                                                                                                  Content:tempProfessionalArray
                                                                                                          MutableSelected:NO]]
                                                                                   Color:kColorTheme2a303c]];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"学历"
                                                                                         Img:@"global_down"
                                                                                   DataArray:@[[QHWFilterModel modelWithTitle:@"学历"
                                                                                                                          Key:@"educationId"
                                                                                                                      Content:tempEducationFilterArray
                                                                                                              MutableSelected:NO]]
                                                                                       Color:kColorTheme2a303c]];
                
                    
                    NSArray *tempServiceArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:self.studyabroadFilterDic[@"serviceDepthList"]];
                    [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"服务深度"
                                                                                         Img:@"global_down"
                                                                                   DataArray:@[[QHWFilterModel modelWithTitle:@"服务深度"
                                                                                                                          Key:@"serviceDepthCode"
                                                                                                                      Content:tempServiceArray
                                                                                                              MutableSelected:NO]]
                                                                                       Color:kColorTheme2a303c]];
            }
                break;
            
            case 3:
            {
                [self handleCountryFilterDataWithArray:self.studyabroadCountryArray TargetArray:_studyabroadFilterArray];
                NSArray *tempLiftTypeArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:self.studyabroadFilterDic[@"liftTypeList"]];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"提升类型"
                                                                                     Img:@"global_down"
                                                                               DataArray:@[[QHWFilterModel modelWithTitle:@"提升类型"
                                                                                                                      Key:@"liftTypeCode"
                                                                                                                  Content:tempLiftTypeArray
                                                                                                          MutableSelected:NO]]
                                                                                   Color:kColorTheme2a303c]];
            }
                break;
            
            case 4:
            {
                NSArray *tempTypeArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:self.studyabroadFilterDic[@"languageTypeList"]];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"考试类型"
                                                                                     Img:@"global_down"
                                                                               DataArray:@[[QHWFilterModel modelWithTitle:@"考试类型"
                                                                                                                      Key:@"languageTypeCode"
                                                                                                                  Content:tempTypeArray
                                                                                                          MutableSelected:NO]]
                                                                                   Color:kColorTheme2a303c]];
            }
                break;
                
            case 5:
            {
                [self handleCountryFilterDataWithArray:self.studyabroadCountryArray TargetArray:_studyabroadFilterArray];
                NSArray *tempVisaTypeArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:self.studyabroadFilterDic[@"visaTypeList"]];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"签证类型"
                                                                                     Img:@"global_down"
                                                                               DataArray:@[[QHWFilterModel modelWithTitle:@"签证类型"
                                                                                                                      Key:@"visaTypeCode"
                                                                                                                  Content:tempVisaTypeArray
                                                                                                          MutableSelected:NO]]
                                                                                   Color:kColorTheme2a303c]];
            }
                break;

                    
            case 6:
            {
                [self handleCountryFilterDataWithArray:self.studyabroadCountryArray TargetArray:_studyabroadFilterArray];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"学历"
                                                                                     Img:@"global_down"
                                                                               DataArray:@[[QHWFilterModel modelWithTitle:@"学历"
                                                                                                                      Key:@"educationId"
                                                                                                                  Content:tempEducationFilterArray
                                                                                                          MutableSelected:NO]]
                                                                                   Color:kColorTheme2a303c]];
                NSArray *tempProfessionalArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:self.studyabroadFilterDic[@"professionalList"]];
                [_studyabroadFilterArray addObject:[FilterBtnViewCellModel modelWithName:@"专业"
                                                                                     Img:@"global_down"
                                                                               DataArray:@[[QHWFilterModel modelWithTitle:@"专业"
                                                                                                                      Key:@"professionalCode"
                                                                                                                  Content:tempProfessionalArray
                                                                                                          MutableSelected:NO]]
                                                                                   Color:kColorTheme2a303c]];
            }
                break;
                
            default:
                break;
        }
//    }
//    return _studyabroadFilterArray;
}

#pragma mark ------------DATA-------------
- (NSMutableArray *)filterArray {
    if (!_filterArray) {
        _filterArray = NSMutableArray.array;
    }
    return _filterArray;
}

- (NSMutableArray *)getTargetArray {
    if (self.businessType == 4) {
        return self.studyabroadFilterArray;
    } else {
        return self.filterArray;
    }
    return NSMutableArray.new;
}

- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (NSMutableDictionary *)conditionDic {
    if (!_conditionDic) {
        _conditionDic = NSMutableDictionary.dictionary;
    }
    return _conditionDic;
}

@end
