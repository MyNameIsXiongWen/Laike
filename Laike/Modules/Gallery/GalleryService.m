//
//  GalleryService.m
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "GalleryService.h"

@implementation GalleryService

- (void)getGalleryFilterDataWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kGalleryFilter parameters:@{} success:^(id responseObject) {
        FilterCellModel *cellModel = [FilterCellModel modelWithName:@"全部" Code:@"0"];
        [self.filterArray addObject:cellModel];
        [self.filterArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"data"][@"tklx"]]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getGalleryListWithType:(NSString *)type Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"galleryType": type ?: @"0",
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kGalleryList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        [self.tableViewDataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:GalleryModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

#pragma mark ------------DATA-------------
- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (NSMutableArray *)filterArray {
    if (!_filterArray) {
        _filterArray = NSMutableArray.array;
    }
    return _filterArray;
}

@end

@implementation GalleryModel

@end
