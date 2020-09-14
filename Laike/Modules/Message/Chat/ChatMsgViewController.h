//
//  ChatMsgViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageChatMsgCellData.h"
#import "MessageTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class ChatMsgViewController;

@protocol ChatMsgViewControllerDelegate <NSObject>

@optional
///控制器点击回调
- (void)didTapInMessageController:(ChatMsgViewController *)controller;

///隐藏长按菜单后的回调
- (void)didHideMenuInMessageController:(ChatMsgViewController *)controller;

///显示长按菜单前的回调
- (BOOL)messageController:(ChatMsgViewController *)controller willShowMenuInCell:(UIView *)view;

///点击消息头像委托
- (void)messageController:(ChatMsgViewController *)controller onSelectMessageAvatar:(MessageTableViewCell *)cell;

///点击消息内容委托
- (void)messageController:(ChatMsgViewController *)controller onSelectMessageContent:(MessageTableViewCell *)cell;

@end

@interface ChatMsgViewController : UIViewController <EMChatManagerDelegate>

@property (nonatomic, copy) NSString *receiverNickName;
@property (nonatomic, copy) NSString *receiverHeadPath;
///获取超时消息的时间间隔
@property (nonatomic, assign) NSInteger timeInterval;
//当前时间戳
@property (nonatomic, assign) NSInteger nowTimeInterval;
///设置会话
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, weak) id<ChatMsgViewControllerDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
///发送消息,所有消息都是这个方法
- (void)sendMessage:(MessageChatMsgCellData *)msg;
- (void)scrollToBottom:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
