//
//  HomeService.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeService.h"
#import "QHWBannerModel.h"

@interface HomeService ()

@property (nonatomic, strong) NSMutableArray *requestDataArray;//数据源

@end

@implementation HomeService

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
                                    },
                                    @{@"cell": @"QHWArticleTableViewCell",
                                      @"identifier": @"article",
                                      @"model": @"QHWCommunityArticleModel",
                                      @"businessType": @"5",
                                      @"url": kCommunityArticleList
                                    },
                                    @{@"cell": @"QHWContentTableViewCell",
                                      @"identifier": @"video",
                                      @"model": @"QHWCommunityContentModel",
                                      @"businessType": @"18",
                                      @"url": kCommunityContentList
                                      },
                                    @{@"cell": @"QHWContentTableViewCell",
                                      @"identifier": @"picture",
                                      @"model": @"QHWCommunityContentModel",
                                      @"businessType": @"21",
                                      @"url": kCommunityContentList
                                      },
                                    @{@"cell": @"QHWContentTableViewCell",
                                      @"identifier": @"allContent",
                                      @"model": @"QHWCommunityContentModel",
                                      @"businessType": @"1821",
                                      @"url": kCommunityContentList
                                      },
                                    @{@"cell": @"QHWActivityTableViewCell",
                                      @"identifier": @"activity",
                                      @"model": @"QHWActivityModel",
                                      @"businessType": @"17",
                                      @"url": kActivityList
                                      }];
    }
    return self;
}

- (void)getHomeConsultantDataWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kHomeConsultant parameters:@{} success:^(id responseObject) {
        self.homeModel = [HomeModel yy_modelWithJSON:responseObject[@"data"]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getHomeReportDataWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kHomeReport parameters:@{} success:^(id responseObject) {
        self.reportArray = responseObject[@"data"][@"report1"][@"reportList"];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

///首页产品列表
- (void)getHomePageProductListRequestWithIdentifier:(NSString *)identifier Complete:(void (^)(void))complete {
    __block NSDictionary *dic;
    [self.tableViewCellArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"identifier"] isEqualToString:identifier]) {
            dic = obj;
            *stop = YES;
        }
    }];
    NSString *urlString;
    if (self.pageType == 1) {
        urlString = kProductList;
    } else if (self.pageType == 2) {
        urlString = kDistributionList;
    }
    NSString *modelStr = dic[@"model"];
    NSInteger businessType = [dic[@"businessType"] integerValue];
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"businessType": @(businessType),
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:urlString parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        [self.requestDataArray removeAllObjects];
        self.requestDataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(modelStr) json:self.itemPageModel.list].mutableCopy;
        for (QHWMainBusinessDetailBaseModel *baseModel in self.requestDataArray) {
            baseModel.businessType = businessType;
        }
        [self handleRequestDataArrayWithBusinessType:businessType];
        complete();
    } failure:^(NSError *error) {
        [self handleRequestDataArrayWithBusinessType:businessType];
        complete();
    }];
}

- (void)handleRequestDataArrayWithBusinessType:(NSInteger)businessType {
    CGFloat height = 0;
    for (NSObject *obj in self.requestDataArray) {
//        switch (businessType) {
//            case 1:
//                height = 110;
//                break;
//            case 2:
//            case 3:
//            case 4:
//            case 102001:
//            {
//                QHWMainBusinessDetailBaseModel *model = (QHWMainBusinessDetailBaseModel *)obj;
//                model.businessType = businessType.integerValue;
//                height = model.mainBusinessCellHeight;
//            }
//                break;
//            case 5:
//            {
//                QHWCommunityArticleModel *model = (QHWCommunityArticleModel *)obj;
//                height = model.cellHeight;
//            }
//                break;
//            case 17:
//            {
//                QHWActivityModel *model = (QHWActivityModel *)obj;
//                height = model.cellHeight;
//            }
//                break;
//            case 18:
//            case 21:
//            case 1821:
//            {
//                QHWCommunityContentModel *model = (QHWCommunityContentModel *)obj;
//                height = model.cellHeight;
//            }
//                break;
//
//            default:
//                break;
//        }
        QHWBaseModel *baseModel = [[QHWBaseModel alloc] configModelIdentifier:@"QHWMainBusinessTableViewCell" Height:140 Data:obj];
        [self.tableViewDataArray addObject:baseModel];
    }
}

- (void)handleHomeData {
    [self.tableViewDataArray removeAllObjects];
    if (self.consultantArray.count > 0) {
        QHWBaseModel *userDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"MinePopularityInfoTableViewCell" Height:165 Data:self.consultantArray];
        [self.tableViewDataArray addObject:userDataModel];
    }
    
    if (self.reportArray.count > 0) {
        QHWBaseModel *cardDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"MineCardTableViewCell"
                                                                           Height:175
                                                                             Data:@[self.reportArray, self.homeModel.visitTip ?: @""]];
        [self.tableViewDataArray addObject:cardDataModel];
    }
    
    QHWBaseModel *crmDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"MineCustomerTableViewCell"
                                                                      Height:140
                                                                        Data:@[@{@"value": @(self.homeModel.userCount), @"title": @"CRM"},
                                                                               @{@"value": @(self.homeModel.userDays), @"title": @"获客"}]];
    [self.tableViewDataArray addObject:crmDataModel];
    
    QHWBaseModel *iconDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"MineIconTableViewCell" Height:160 Data:self.iconArray];
    [self.tableViewDataArray addObject:iconDataModel];
    
    if (self.schoolArray.count > 0) {
        QHWBaseModel *schoolDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"MineSchoolTableViewCell" Height:225 Data:self.schoolArray];
        [self.tableViewDataArray addObject:schoolDataModel];
    }
    
    self.headerViewTableHeight = 190-25;
    for (QHWBaseModel *baseModel in self.tableViewDataArray) {
        self.headerViewTableHeight += baseModel.height;
    }
}

#pragma mark ------------DATA-------------
- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (NSMutableArray *)requestDataArray {
    if (!_requestDataArray) {
        _requestDataArray = NSMutableArray.array;
    }
    return _requestDataArray;
}

- (NSMutableArray *)iconArray {
    if (!_iconArray) {
        _iconArray = NSMutableArray.array;
        NSArray *nameArray = @[@"获客资讯", @"活动召集", @"直播邀约", @"霸屏神器", @"海外圈", @"递名片", @"算汇率", @"Q大学"];
        NSArray *iconArray = @[@"home_news", @"home_activity", @"home_live", @"home_screen", @"home_article", @"home_card", @"home_rate", @"home_school"];
        [nameArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QHWBannerModel *model = QHWBannerModel.new;
            model.name = obj;
            model.icon = iconArray[idx];
            [_iconArray addObject:model];
        }];
    }
    return _iconArray;
}

@end
