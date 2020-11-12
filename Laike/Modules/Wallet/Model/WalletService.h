//
//  WalletService.h
//  Laike
//
//  Created by xiaobu on 2020/11/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletService : QHWBaseService

@property (nonatomic, strong) QHWItemPageModel *itemPageModel;

- (void)getWalletInfoRequestWithComplete:(void (^)(NSDictionary *_Nullable dataDic))complete;
- (void)getWalletListRequestWithComplete:(void (^)(void))complete;
- (void)withdrawRequestWithMoney:(NSString *)money Complete:(void (^)(NSInteger status))complete;
- (void)bindAlipayRequestWithAccount:(NSString *)account Name:(NSString *)name Complete:(void (^)(void))complete;
- (void)signinRequestWithComplete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
