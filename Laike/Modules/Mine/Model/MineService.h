//
//  MineService.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineService : QHWBaseService

@property (nonatomic, strong) UserModel *userModel;
- (void)getMineInfoRequestComplete:(void (^)(void))complete;
- (void)updateMineInfoRequestWithParam:(NSDictionary *)param Complete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
