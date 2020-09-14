//
//  MessageChatTableViewCell.h
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageChatMsgCellData.h"
#import "ChatMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@class MessageChatTableViewCell;
@protocol MessageChatTableViewCellDelegate <NSObject>

///长按消息
- (void)onLongPressMessage:(MessageChatTableViewCell *)cell;
///消息重发。
- (void)onRetryMessage:(MessageChatTableViewCell *)cell;
///点击消息
- (void)onSelectMessage:(MessageChatTableViewCell *)cell;
///点击消息单元中消息头像
- (void)onSelectMessageAvatar:(MessageChatTableViewCell *)cell;
///撤回消息（2分钟内）
- (void)revokeMessage:(MessageChatTableViewCell *)cell;

@end

@interface MessageChatTableViewCell : UITableViewCell

///当前消息索引
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *avatarImgView;

///容器视图。 包裹了 MesageCell 的各类视图，作为 MessageCell 的“底”，方便进行视图管理与布局。
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *bubbleImgView;

///在消息发送中提供转圈图标，表明消息正在发送。
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

///重发视图。
@property (nonatomic, strong) UIImageView *retryView;
///已读未读
@property (nonatomic, strong) UILabel *statusLabel;

///信息数据类。
@property (readonly) MessageChatMsgCellData *messageData;
@property (nonatomic, strong) ChatMsgModel *msgModel;

@property (nonatomic, weak) id<MessageChatTableViewCellDelegate> delegate;

- (void)fillWithData:(MessageChatMsgCellData *)data;
- (void)onLongPress:(UIGestureRecognizer *)recognizer;
- (void)playVoiceMessage;
- (void)stopVoiceMessage;

@end

NS_ASSUME_NONNULL_END
