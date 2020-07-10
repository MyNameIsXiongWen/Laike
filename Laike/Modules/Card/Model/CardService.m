//
//  CardService.m
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CardService.h"

@implementation CardService

- (void)getCardListDataRequestWithComplete:(void (^)(void))complete {
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

- (void)getCardDetailInfoRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"userId": self.userId ?: @"",
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kActionBrowseInfo parameters:params success:^(id responseObject) {
        self.cardDetailModel = [CardModel yy_modelWithJSON:responseObject[@"data"]];
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        [self.tableViewDataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:CardModel.class json:self.itemPageModel.list]];
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

- (CGFloat)businessHeight {
    if (!_businessHeight) {
        _businessHeight = 10 + 20 + 10 + 10 + MAX(20, [self.title getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-80, CGFLOAT_MAX)]);
    }
    return _businessHeight;
}

@end
