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
        UserModel *user = UserModel.shareUser;
        NSDictionary *dic = @{@"merchantName": user.merchantName ?: @"",
                              @"merchantInfo": user.merchantInfo ?: @"",
                              @"qrCode": user.qrCode ?: @"",
                              @"mobileNumber": user.mobileNumber ?: @"",
                              @"userCount": @(user.userCount),
                              @"clueCount": @(user.clueCount),
                              @"crmCount": @(user.crmCount),
                              @"likeCount": @(user.likeCount),
                              @"fansCount": @(user.fansCount),
                              @"visitCount": @(user.visitCount),
                              @"distributionCount": @(user.distributionCount),
                              @"distributionStatus": @(user.distributionStatus)};
        
        [UserModel clearUser];
        self.userModel = [UserModel yy_modelWithJSON:responseObject[@"data"]];
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.userModel setValue:obj forKey:key];
        }];
        [self.userModel keyArchiveUserModel];
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

- (UserModel *)userModel {
    if (!_userModel) {
        _userModel = UserModel.shareUser;
    }
    return _userModel;
}

@end
