//
//  CommunityService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityService.h"

@implementation CommunityService

- (void)getCoummunityDataWithComplete:(void (^)(void))complete {
    [QHWHttpLoading show];
    NSString *urlStr;
    NSMutableDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                                    @"pageSize": @(self.itemPageModel.pagination.pageSize)}.mutableCopy;
    NSString *modelClass;
    if (self.communityType == 1) {
        urlStr = kCommunityArticleList;
        modelClass = @"QHWCommunityArticleModel";
        params[@"industryId"] = @(self.businessType);
    } else {
        urlStr = kCommunityContentList;
        modelClass = @"QHWCommunityContentModel";
        params[@"fileType"] = @"0";
    }
    [QHWHttpManager.sharedInstance QHW_POST:urlStr parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:NSClassFromString(modelClass) json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)deleteCommentRequestWithContentId:(NSString *)contentId Complete:(nonnull void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kCommunityDelete parameters:@{@"id": contentId} success:^(id responseObject) {
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

@end
