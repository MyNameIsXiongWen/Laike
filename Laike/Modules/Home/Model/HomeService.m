//
//  HomeService.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeService.h"
#import "QHWBannerModel.h"
#import "UserModel.h"

@interface HomeService ()

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
        UserModel *user = UserModel.shareUser;
        user.merchantId = self.homeModel.merchantId;
        user.merchantName = self.homeModel.merchantName;
        user.merchantInfo = self.homeModel.merchantInfo;
        user.qrCode = self.homeModel.qrCode;
        user.mobileNumber = self.homeModel.mobileNumber;
        user.userCount = self.homeModel.userCount;
//        user.crmCount = self.homeModel.clientData.crmCount;
//        user.clueCount = self.homeModel.clueCount;
//        user.distributionCount = self.homeModel.distributionCount;
        user.bindStatus = self.homeModel.bindStatus;
        user.distributionStatus = self.homeModel.distributionStatus;
        [user keyArchiveUserModel];
        [self getHomeReportCountDataRequestWithComplete:complete];
//        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getHomeReportDataWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kHomeReport parameters:@{} success:^(id responseObject) {
        self.reportArray = [responseObject[@"data"][@"report1"][@"reportList"] mutableCopy];
        for (int i=0; i<self.reportArray.count; i++) {
            NSMutableDictionary *dic = [self.reportArray[i] mutableCopy];
            NSMutableArray *array = [dic[@"groupList"] mutableCopy];
            [array removeObjectAtIndex:1];
            dic[@"groupList"] = array;
            self.reportArray[i] = dic;
            if (i == 2 && self.reportArray.count == 3) {
                UserModel *user = UserModel.shareUser;
                user.visitCount = [array[0][@"value"] integerValue];
                user.likeCount = [array[1][@"value"] integerValue];
                user.fansCount = [array[2][@"value"] integerValue];
                [user keyArchiveUserModel];
            }
        }
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getHomeReportCountDataRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kHomeReportCount parameters:@{} success:^(id responseObject) {
        UserModel *user = UserModel.shareUser;
        user.likeCount = [responseObject[@"data"][@"likeCount"] integerValue];
        user.distributionCount = [responseObject[@"data"][@"distributionCount"] integerValue];
        user.crmCount = [responseObject[@"data"][@"crmCount"] integerValue];
        user.clueCount = [responseObject[@"data"][@"clueCount"] integerValue];
        user.consultCount = [responseObject[@"data"][@"consultCount"] integerValue];
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
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        NSArray *tempArray = [NSArray yy_modelArrayWithClass:NSClassFromString(modelStr) json:self.itemPageModel.list];
        for (QHWMainBusinessDetailBaseModel *tempModel in tempArray) {
            tempModel.businessType = businessType;
            QHWBaseModel *baseModel = [[QHWBaseModel alloc] configModelIdentifier:@"QHWMainBusinessTableViewCell" Height:140 Data:@[tempModel, @(self.pageType)]];
            [self.tableViewDataArray addObject:baseModel];
        }
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)handleHomeData {
    [self.tableViewDataArray removeAllObjects];
    if (self.consultantArray.count > 0) {
        QHWBaseModel *userDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"HomePopularityInfoTableViewCell" Height:165 Data:self.consultantArray];
        [self.tableViewDataArray addObject:userDataModel];
    }

    if (self.bannerArray.count > 0) {
        QHWBaseModel *bannerModel = QHWBaseModel.new;
        [bannerModel configModelIdentifier:@"HomeBannerTableViewCell" Height:130 Data:self.bannerArray];
        [self.tableViewDataArray addObject:bannerModel];
    }
    
    if (self.reportArray.count > 0) {
        QHWBaseModel *cardDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"HomeCardTableViewCell"
                                                                           Height:175
                                                                             Data:@{@"data": self.reportArray,
                                                                                    @"tip": self.homeModel.visitTip ?: @"",
                                                                                    @"title": @"名片数据"}];
        [self.tableViewDataArray addObject:cardDataModel];
    }

    UserModel *user = UserModel.shareUser;
    QHWBaseModel *crmDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"HomeCustomerTableViewCell"
                                                                      Height:140
                                                                        Data:@[@{@"value": @(user.crmCount), @"title": @"客户"},
                                                                               @{@"value": @(user.consultCount), @"title": @"线索"}]];
    [self.tableViewDataArray addObject:crmDataModel];
    
    QHWBaseModel *iconDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"HomeIconTableViewCell" Height:160 Data:self.iconArray];
    [self.tableViewDataArray addObject:iconDataModel];
    
    if (self.schoolArray.count > 0) {
        QHWBaseModel *schoolDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"HomeSchoolTableViewCell" Height:225 Data:self.schoolArray];
        [self.tableViewDataArray addObject:schoolDataModel];
    }
    
    self.headerViewTableHeight = 190-25 + 30;
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
