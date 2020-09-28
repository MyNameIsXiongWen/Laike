//
//  LiveService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LiveService.h"
#import "UserModel.h"

@implementation LiveService

- (void)getLiveListRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSMutableDictionary *param = @{@"subjectType": @(14),
                                   @"subjectId": UserModel.shareUser.merchantId,
                                   @"currentPage": @(self.itemPageModel.pagination.currentPage),
                                   @"pageSize": @(self.itemPageModel.pagination.pageSize)}.mutableCopy;
    [QHWHttpManager.sharedInstance QHW_POST:kLiveList parameters:param success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:LiveModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getLiveDetailInfoRequestWithLiveId:(NSString *)liveId Complete:(void (^)(BOOL))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSMutableDictionary *params = @{@"id": liveId ?: @""}.mutableCopy;
    NSString *consultantId = [kUserDefault objectForKey:kConstConsultantId];
    if (consultantId) {
        params[@"consultantId"] = consultantId;
    }
    [QHWHttpManager.sharedInstance QHW_POST:kLiveInfo parameters:params success:^(id responseObject) {
        self.liveDetailModel = [LiveModel yy_modelWithJSON:responseObject[@"data"]];
        [self handleLiveDetailCellData];
        complete(YES);
    } failure:^(NSError *error) {
        complete(NO);
    }];
}

- (void)handleLiveDetailCellData {
    QHWBaseModel *organizerModel = [[QHWBaseModel alloc] configModelIdentifier:@"LiveDetailOrganizerTableViewCell" Height:40 Data:@[self.liveDetailModel, @(NO)]];
    organizerModel.headerTitle = @"主办方";
    [self.tableViewDataArray addObject:organizerModel];
    
    QHWBaseModel *guestModel = [[QHWBaseModel alloc] configModelIdentifier:@"LiveDetailOrganizerTableViewCell" Height:40 Data:@[self.liveDetailModel, @(YES)]];
    guestModel.headerTitle = @"主讲嘉宾";
    [self.tableViewDataArray addObject:guestModel];
    
    QHWBaseModel *descModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:0 Data:@{@"data": self.liveDetailModel.mainDescribe ?: @"", @"identifier": @"DescRichTextTableViewCell"}];
    [self.tableViewDataArray addObject:descModel];
    
    QHWBaseModel *contentModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:0 Data:@{@"data": self.liveDetailModel.content ?: @"", @"identifier": @"ViedoRichTextTableViewCell"}];
    contentModel.headerTitle = @"视频内容";
    [self.tableViewDataArray addObject:contentModel];
}

- (NSMutableArray<LiveModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

@end
