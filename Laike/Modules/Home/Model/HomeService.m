//
//  HomeService.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeService.h"

@interface HomeService ()

@property (nonatomic, strong) NSMutableArray *requestDataArray;//数据源

@end

@implementation HomeService

- (void)getHomeDataWithComplete:(void (^)(BOOL, id _Nonnull))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kHomePage parameters:@{} success:^(id responseObject) {
        self.homeModel = [HomeModel yy_modelWithJSON:responseObject[@"data"]];
        [self handleHomeData];
        if (complete) {
            complete(YES, responseObject);
        }
    } failure:^(NSError *error) {
        if (complete) {
            complete(NO, error);
        }
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
    NSString *modelStr = dic[@"model"];
    NSString *urlString = dic[@"url"];
    NSDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:urlString parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        NSArray *targetArray = [NSArray yy_modelArrayWithClass:NSClassFromString(modelStr) json:self.itemPageModel.list];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.requestDataArray removeAllObjects];
        }
        self.requestDataArray = targetArray.mutableCopy;
        [self handleRequestDataArrayWithDic:dic];
        complete();
    } failure:^(NSError *error) {
        [self handleRequestDataArrayWithDic:dic];
        complete();
    }];
}

- (void)handleRequestDataArrayWithDic:(NSDictionary *)dic {
    NSString *cellStr = dic[@"cell"];
    NSString *businessType = dic[@"businessType"];
    
    CGFloat height = 0;
    for (NSObject *obj in self.requestDataArray) {
//        switch (businessType.integerValue) {
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
        QHWBaseModel *baseModel = [[QHWBaseModel alloc] configModelIdentifier:cellStr Height:height Data:obj];
        [self.tableViewDataArray addObject:baseModel];
    }
}

- (void)handleHomeData {
    
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

@end
