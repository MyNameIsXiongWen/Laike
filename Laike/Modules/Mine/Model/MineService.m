//
//  MineService.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MineService.h"

@implementation MineService

- (void)getMineInfoRequestComplete:(void (^)(void))complete {
    [QHWHttpManager.sharedInstance QHW_POST:kMineInfo parameters:@{} success:^(id responseObject) {
        [UserModel clearUser];
        UserModel *model = [UserModel yy_modelWithJSON:responseObject[@"data"]];
        [model keyArchiveUserModel];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)updateMineInfoRequestWithParam:(NSDictionary *)param Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kMineEdit parameters:param success:^(id responseObject) {
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

@end
