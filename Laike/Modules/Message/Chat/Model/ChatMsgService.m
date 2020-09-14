//
//  ChatMsgService.m
//  XuanWoJia
//
//  Created by xiaobu on 2019/10/30.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "ChatMsgService.h"
#import "UserModel.h"

@implementation ChatMsgService


- (void)callPhoneRequestWithStaffId:(NSString *)staffId storeId:(NSString *)storeId {
    /*
    source 数据来源 1门店详情 2全景方案 3实景案例 4商品 5组合商品 6家居指南 7买手探店 8灵感美图 9新家服务 10优惠券 11-IM内拨打电话 12我的预约-商家预约
    sourceId 对应的数据来源编号
    relType 业务类型 1门店 2顾问
    relId 业务类型编号  门店id/顾问id
    */
//    kCallTel(<#phoneNo#>)
}

- (void)showPhoneRequestWithStaffIMAccount:(NSString *)staffIMAccount {
//    [LZHttpLoading showWithMaskTypeBlack];
//    [LZHttpManager.sharedInstance LZ_GET:kFormat(@"%@%@", kStoreShowPhone, staffIMAccount) parameters:nil success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
}

- (void)sendMsgRequestWithType:(NSString *)type StaffIMAccount:(NSString *)staffIMAccount {
//    [LZHttpLoading showWithMaskTypeBlack];
//    [LZHttpManager.sharedInstance LZ_GET:kFormat(@"%@%@/%@", kStorekSendMsg, type, staffIMAccount) parameters:nil success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
}

@end
