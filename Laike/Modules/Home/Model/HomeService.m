//
//  HomeService.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeService.h"
#import "QHWBannerModel.h"
#import "QHWSchoolModel.h"

@interface HomeService ()

@property (nonatomic, strong) NSMutableArray *requestDataArray;//数据源
@property (nonatomic, strong) NSArray <QHWSchoolModel *>*schoolArray;//

@end

@implementation HomeService

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

- (void)getSchoolDataWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
//    学习类型：1-专业课堂；2-产品学习
    [QHWHttpManager.sharedInstance QHW_POST:kSchoolList parameters:@{@"learnType": @(1),
                                                                     @"currentPage": @(1),
                                                                     @"pageSize": @(2)} success:^(id responseObject) {
        self.schoolArray = [NSArray yy_modelArrayWithClass:QHWSchoolModel.class json:responseObject[@"data"][@"list"]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

///首页产品列表
- (void)getHomePageProductListRequestWithBusinessType:(NSInteger)businessType Complete:(void (^)(void))complete {
//    __block NSDictionary *dic;
//    [self.tableViewCellArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj[@"identifier"] isEqualToString:identifier]) {
//            dic = obj;
//            *stop = YES;
//        }
//    }];
//    NSString *modelStr = dic[@"model"];
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"businessType": @(businessType),
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kProductList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        NSArray *targetArray = [NSArray yy_modelArrayWithClass:QHWMainBusinessDetailBaseModel.class json:self.itemPageModel.list];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.requestDataArray removeAllObjects];
        }
        self.requestDataArray = targetArray.mutableCopy;
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
        QHWBaseModel *baseModel = [[QHWBaseModel alloc] configModelIdentifier:@"QHWMainBusinessTableViewCell" Height:height Data:obj];
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
                                                                             Data:@[self.reportArray, self.homeModel.visitTip]];
        [self.tableViewDataArray addObject:cardDataModel];
    }
    
    QHWBaseModel *crmDataModel = [[QHWBaseModel alloc] configModelIdentifier:@"MineCustomerTableViewCell"
                                                                      Height:140
                                                                        Data:@[@{@"value": @(self.homeModel.userCount), @"title": @"CRM"},
                                                                               @{@"value": @(self.homeModel.userDays), @"title": @"获客"},
                                                                               @{@"value": @(self.homeModel.clueCount), @"title": @"公客"}]];
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
