//
//  MessageChatMsgCellData.h
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyphenateLite/HyphenateLite.h>
#import "ChatEmojiUtil.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DownloadProgress)(NSInteger curSize, NSInteger totalSize);
typedef void (^DownloadResponse)(int code, NSString *desc, NSString *path);

/**
 *  消息状态枚举
 */
typedef NS_ENUM(NSUInteger, TMsgStatus) {
    Msg_Status_Init, //消息创建
    Msg_Status_Sending, //消息发送中
    Msg_Status_Succ, //消息发送成功
    Msg_Status_Fail, //消息发送失败
};

@interface MessageChatMsgCellData : NSObject

///信息发送者 ID
@property (nonatomic, strong) NSString *identifier;
///信息发送者头像 url
@property (nonatomic, strong) NSURL *avatarUrl;
///cell标识符
@property (nonatomic, strong) NSString *cellReuseIdentifier;
@property (nonatomic, assign) BOOL isSelf;

///消息状态
@property (nonatomic, assign) TMsgStatus status;
///展示消息
@property (nonatomic, strong) EMMessage *innerMessage;
@property (nonatomic, strong) ChatEmojiUtil *emojiUtil;

//语音
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isDownloadingVoice;

@property (nonatomic, assign) BOOL isDownloadingSnapshot;
@property (nonatomic, assign) BOOL isDownloadingVideo;

///是否是业务消息
@property (nonatomic, assign) BOOL message_attr_is_subject;
///是否是授权消息
@property (nonatomic, assign) BOOL message_attr_is_authorize;
///授权消息状态  0 等待 1 同意 2 拒绝
@property (nonatomic, assign) NSInteger message_attr_authorize_status;

///整个cell高度
- (CGFloat)cellHeight;
///内容大小
- (CGSize)contentSize;
- (CGSize)getImageSizeBySize:(CGSize)imgSize;

@end

@interface EMCustomMsgModel : NSObject

///业务分类id（房产、游学、移民、留学、医疗）
@property (nonatomic, assign) NSInteger message_attr_subject_id;
///业务详情id
@property (nonatomic, copy) NSString *message_attr_subject_detail_id;
///业务图片
@property (nonatomic, copy) NSString *message_attr_subject_img;
///业务标题
@property (nonatomic, copy) NSString *message_attr_subject_content;
///业务副标题
@property (nonatomic, copy) NSString *message_attr_subject_sub_content;
///业务底部信息
@property (nonatomic, copy) NSString *message_attr_subject_bottom;

@property (nonatomic, assign) CGFloat msgHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat subContentHeight;

@end

NS_ASSUME_NONNULL_END
