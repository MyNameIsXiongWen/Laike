//
//  ChatMsgModel.h
//  XuanWoJia
//
//  Created by jason on 2019/8/14.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatMsgModel : QHWBaseModel

///对方是否已读
@property (nonatomic, assign) BOOL isPeerReaded;
@property (nonatomic, assign) CGSize size;
+ (NSInteger)getSecondFormStartTime:(long long)startTimeStamp;//该消息和当前消息时间差（秒）
+ (NSInteger)getMinuteFormStartTime:(long long)startTimeStamp EndTime:(long long)endTimeStamp;
+ (ChatMsgModel *)createTimeMessageModel:(long long)timeStamp;
+ (ChatMsgModel *)createRevokeMessageModelIsSelf:(BOOL)isSelf;

@end

NS_ASSUME_NONNULL_END
