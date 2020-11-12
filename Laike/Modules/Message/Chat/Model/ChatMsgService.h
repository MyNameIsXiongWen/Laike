//
//  ChatMsgService.h
//  XuanWoJia
//
//  Created by xiaobu on 2019/10/30.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatMsgService : NSObject

///打电话
- (void)callPhoneRequestWithStaffId:(NSString *)staffId storeId:(NSString *)storeId;
///展示电话
- (void)showPhoneRequestWithStaffIMAccount:(NSString *)staffIMAccount;
///发送自定义消息
- (void)sendMsgRequestWithType:(NSString *)type StaffIMAccount:(NSString *)staffIMAccount;
- (void)addRecordRequestWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
