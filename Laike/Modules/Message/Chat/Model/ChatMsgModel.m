//
//  ChatMsgModel.m
//  XuanWoJia
//
//  Created by jason on 2019/8/14.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "ChatMsgModel.h"

@implementation ChatMsgModel

+ (NSInteger)getSecondFormStartTime:(long long)startTimeStamp {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTimeStamp/1000];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitSecond;
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:NSDate.date options:0];
    return delta.second;
}

+ (NSInteger)getMinuteFormStartTime:(long long)startTimeStamp EndTime:(long long)endTimeStamp {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTimeStamp/1000];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTimeStamp/1000];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMinute;
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    return delta.minute;
}

+ (ChatMsgModel *)createTimeMessageModel:(long long)timeStamp {
    ChatMsgModel *timeModel = ChatMsgModel.new;
    timeModel.height = 37;
    timeModel.identifier = @"MessageChatSystemTableViewCell";
    if (!timeStamp) {
        timeModel.data = [NSString getMsgTimeByDate:NSDate.date];
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
        timeModel.data = [NSString getMsgTimeByDate:date];
    }
    return timeModel;
}

+ (ChatMsgModel *)createRevokeMessageModelIsSelf:(BOOL)isSelf {
    ChatMsgModel *timeModel = ChatMsgModel.new;
    timeModel.height = 37;
    timeModel.identifier = @"MessageChatSystemTableViewCell";
    if (isSelf) {
        timeModel.data = @"你撤回了一条消息";
    } else {
        timeModel.data = @"他撤回了一条消息";
    }
    return timeModel;
}

@end
