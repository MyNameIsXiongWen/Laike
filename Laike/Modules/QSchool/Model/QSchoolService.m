//
//  QSchoolService.m
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QSchoolService.h"

@implementation QSchoolService

- (void)getSchoolDataWithLearnType:(NSInteger)learnType Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
//    学习类型：1-专业课堂；2-产品学习
    NSDictionary *params = @{@"learnType": @(learnType),
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kSchoolList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        [self.tableViewDataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:QHWSchoolModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getSchoolDetailInfoRequestWithSchoolId:(NSString *)schoolId Complete:(void (^)(BOOL))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSchoolInfo parameters:@{@"id": schoolId ?: @""} success:^(id responseObject) {
        self.schoolModel = [QHWSchoolModel yy_modelWithJSON:responseObject[@"data"]];
        [self handleDetailCellData];
        complete(YES);
    } failure:^(NSError *error) {
        complete(NO);
    }];
}

- (void)handleDetailCellData {
    QHWBaseModel *organizerModel = [[QHWBaseModel alloc] configModelIdentifier:@"QSchoolDetailOrganizerTableViewCell" Height:60 Data:self.schoolModel];
    [self.tableViewDataArray addObject:organizerModel];
    
    QHWBaseModel *contentModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:50 Data:@{@"data": self.schoolModel.content ?: @"", @"identifier": @"contentRichTextTableViewCell"}];
    [self.tableViewDataArray addObject:contentModel];
}

#pragma mark ------------DATA-------------
- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

@end
