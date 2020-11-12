//
//  WalletModel.h
//  Laike
//
//  Created by xiaobu on 2020/11/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *createTime;
///交易金额（单位分）
@property (nonatomic, copy) NSString *transactionMoney;
///支付状态：1-增加；2-支出；
@property (nonatomic, assign) NSInteger paymentStatus;

@end

NS_ASSUME_NONNULL_END
