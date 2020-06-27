//
//  CardService.m
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CardService.h"

@implementation CardService

- (void)getCardDataRequestWithComplete:(void (^)(void))complete {
    NSString *urlString;
    NSString *identifier;
    if (self.cardType == 1) {
        urlString = kActionBrowseList;
        identifier = @"VisitorTableViewCell";
    } else if (self.cardType == 2) {
        urlString = kActionLikeList;
        identifier = @"VisitorTableViewCell";
    } else if (self.cardType == 3) {
        urlString = kFansList;
        identifier = @"QHWGeneralTableViewCell";
    }
    NSDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:urlString parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        for (NSDictionary *dic in self.itemPageModel.list) {
            CardModel *card = [CardModel yy_modelWithDictionary:dic];
            card.cardType = self.cardType;
            QHWBaseModel *baseModel = [[QHWBaseModel alloc] configModelIdentifier:identifier Height:80 Data:card];
            [self.tableViewDataArray addObject:baseModel];
        }
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

@end

@implementation CardModel

@end
