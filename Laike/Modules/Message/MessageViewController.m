//
//  MessageViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import <HyphenateLite/HyphenateLite.h>
#import "UserModel.h"
#import "MessageModel.h"
#import <UserNotifications/UserNotifications.h>
#import "ChatViewController.h"
#import "ChatEmojiUtil.h"

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate, EMClientDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MessageViewController

- (void)dealloc {
    [EMClient.sharedClient.chatManager removeDelegate:self];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationHXLoginSuccess object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"消息";
    self.kNavigationView.titleLabel.textColor = kColorThemefff;
    self.kNavigationView.backgroundColor = kColorTheme21a8ff;
    self.kNavigationView.leftBtn.hidden = YES;
    [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
    [EMClient.sharedClient addDelegate:self delegateQueue:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loginSuccess) name:kNotificationHXLoginSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getIMConversationList];
    [self getIMUnreadCount];
}

- (void)loginSuccess {
    [self getIMUnreadCount];
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice {
    [SVProgressHUD showInfoWithStatus:@"您的账号已在另一端登录"];
    [UserModel logout];
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    [self getIMUnreadCount];
    for (EMMessage *message in aMessages) {
        EMConversation *conversation = [EMClient.sharedClient.chatManager getConversation:message.conversationId type:EMConversationTypeChat createIfNotExist:YES];
        MessageModel *model = MessageModel.new;
        model.conversation = conversation;
        model.message = message;
        model.msgTimeStamp = message.timestamp;
        model.unreadMsgCount = 1;
        for (MessageModel *msgModel in self.dataArray) {
            //如果已知列表存在新消息会话人，那么删除旧的，插入新的
            if ([msgModel.conversation.conversationId isEqualToString:message.conversationId]) {
                model.unreadMsgCount = msgModel.unreadMsgCount+1;
                [self.dataArray removeObject:msgModel];
                break;
            }
        }
        [self.dataArray insertObject:model atIndex:2];
    }
    [self.tableView reloadData];
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground) {
        UNMutableNotificationContent *content = UNMutableNotificationContent.new;
        content.body = @"您有一条新消息";
        content.sound = UNNotificationSound.defaultSound;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"noticeId" content:content trigger:nil];
        [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }
}

- (void)getIMConversationList {
    [self.dataArray removeObjectsInRange:NSMakeRange(2, self.dataArray.count-2)];
    NSArray *conversationArray = [EMClient.sharedClient.chatManager getAllConversations];
    for (EMConversation *conversation in conversationArray) {
        MessageModel *model = MessageModel.new;
        model.conversation = conversation;
        EMMessage *message = conversation.latestMessage;
        MessageModel *msgModel = [MessageModel yy_modelWithDictionary:message.ext];
        if (message && msgModel.type == 0) {//排除系统消息和官方推荐
            model.message = message;
            model.msgTimeStamp = message.timestamp;
            if (message.direction == EMMessageDirectionSend) {
                model.unreadMsgCount = 0;
            } else {
                model.unreadMsgCount = conversation.unreadMessagesCount;
            }
            [self.dataArray addObject:model];
        }
    }
    [self sortedByTime];
    [self.tableView reloadData];
}

- (void)getIMUnreadCount {
    NSArray *conversationArray = [EMClient.sharedClient.chatManager getAllConversations];
    NSInteger totalCount = 0;
    NSInteger officialCount = 0;
    NSInteger systemCount = 0;
    for (EMConversation *conversation in conversationArray) {
        totalCount += conversation.unreadMessagesCount;
        EMMessage *msg = conversation.latestMessage;
        if (msg.ext) {
            MessageModel *msgModel = [MessageModel yy_modelWithDictionary:msg.ext];
            if (msgModel.type == 100000) {
                officialCount += conversation.unreadMessagesCount;
            } else if (msgModel.type != 0) {
                systemCount += conversation.unreadMessagesCount;
            }
        }
    }
    MessageModel *officialModel = self.dataArray.firstObject;
    officialModel.unreadMsgCount = officialCount;
    MessageModel *systemModel = self.dataArray[1];
    systemModel.unreadMsgCount = systemCount;
    
    UserModel *user = UserModel.shareUser;
    user.officialUnreadMsgCount = officialCount;
    user.unreadMsgCount = totalCount;
    user.systemUnreadMsgCount = systemCount;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewMsg object:nil];
    [self.tableView reloadData];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MessageTableViewCell.class)];
    MessageModel *model = self.dataArray[indexPath.row];
    if (indexPath.row < 2) {
        cell.logoImgView.image = kImageMake(model.coverPath);
        cell.nameLabel.text = model.title;
        cell.contentLabel.text = model.msg;
        cell.redView.hidden = model.unreadMsgCount == 0;
    } else {
        if (model.unreadMsgCount > 99) {
            cell.msgCountLabel.text = @"···";
        } else {
            cell.msgCountLabel.text = [NSString stringWithFormat:@"%d", model.unreadMsgCount];
        }
        cell.msgCountLabel.hidden = !model.unreadMsgCount;
        cell.timeLabel.text = model.msgTime;
        
        NSDictionary *ext = model.message.ext;
        if (model.message.direction == EMMessageDirectionSend) {
            cell.nameLabel.text = ext[@"nickname_to"];
            [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(ext[@"avatar_to"])] placeholderImage:kPlaceHolderImage_Avatar];
        } else {
            cell.nameLabel.text = ext[@"nickname_from"];
            [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(ext[@"avatar_from"])] placeholderImage:kPlaceHolderImage_Avatar];
        }
        if (cell.nameLabel.text.length == 0) {
            cell.nameLabel.text = model.conversation.conversationId;
        }
        
        EMMessageBody *body = model.message.body;
        switch (body.type) {
            case EMMessageBodyTypeText:
            {
                EMTextMessageBody *textBody = (EMTextMessageBody *)body;
                ChatEmojiUtil *emojiUtil = ChatEmojiUtil.new;
                [emojiUtil getRichTextAttributeString:textBody.text Font:kFontTheme14];
                cell.contentLabel.attributedText = emojiUtil.richTextAttribute;
            }
                break;
            
            case EMMessageBodyTypeImage:
                cell.contentLabel.text = @"[图片]";
                break;
                
            case EMMessageBodyTypeVoice:
                cell.contentLabel.text = @"[语音]";
                break;
                
            case EMMessageBodyTypeVideo:
                cell.contentLabel.text = @"[视频]";
                break;
                
            case EMMessageBodyTypeCustom:
            {
                EMCustomMessageBody *customBody = (EMCustomMessageBody *)body;
                NSDictionary *dictionary = customBody.ext;
                if ([dictionary isKindOfClass:NSDictionary.class]) {
                    if ([dictionary[@"message_attr_is_subject"] boolValue]) { //业务消息
                        switch ([dictionary[@"message_attr_subject_id"] integerValue]) {
                            case 1:
                                cell.contentLabel.text = @"[房产]";
                                break;
                            case 2:
                                cell.contentLabel.text = @"[游学]";
                                break;
                            case 3:
                                cell.contentLabel.text = @"[移民]";
                                break;
                            case 4:
                                cell.contentLabel.text = @"[留学]";
                                break;
                            case 102001:
                                cell.contentLabel.text = @"[医疗]";
                                break;
                                
                            default:
                                cell.contentLabel.text = @"[产品]";
                                break;
                        }
                    }
                    if ([dictionary[@"message_attr_is_authorize"] boolValue]) { //授权消息
                        cell.contentLabel.text = @"[授权]";
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:NSClassFromString(@"OfficialMsgViewController").new animated:YES];
    } else if (indexPath.row == 1) {
        [self.navigationController pushViewController:NSClassFromString(@"SystemMessageViewController").new animated:YES];
    } else {
        MessageModel *model = self.dataArray[indexPath.row];
        model.unreadMsgCount = 0;
        ChatViewController *chatVC = ChatViewController.new;
        chatVC.conversation = model.conversation;
        NSDictionary *ext = model.message.ext;
        if (model.message.direction == EMMessageDirectionSend) {
            chatVC.receiverNickName = ext[@"nickname_to"];
            chatVC.receiverHeadPath = ext[@"avatar_to"];
        } else {
            chatVC.receiverNickName = ext[@"nickname_from"];
            chatVC.receiverHeadPath = ext[@"avatar_from"];
        }
        WEAKSELF
        chatVC.updateBlock = ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf getIMConversationList];
            });
        };
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        return NSArray.array;
    }
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MessageModel *model = self.dataArray[indexPath.row];
        [EMClient.sharedClient.chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
            [self.dataArray removeObject:model];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }];
    return @[deleteAction];
}

/**自定义设置iOS11系统下的左滑删除按钮大小*/
//开始编辑左滑删除
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        return;
    }
    if (@available(iOS 11.0, *)) {
        for (UIView * subView in tableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
                UIButton * deleteButton = subView.subviews[0];
                [deleteButton setImage:kImageMake(@"message_delete") forState:0];
            }
        }
    }
}

- (NSMutableArray *)sortedByTime {
    NSMutableArray *array = (NSMutableArray *)[self.dataArray sortedArrayUsingComparator:^NSComparisonResult(MessageModel*  _Nonnull obj1, MessageModel*  _Nonnull obj2) {
        if (obj1.msgTimeStamp > 0 && obj2.msgTimeStamp > 0) {
//            NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:obj1.msgTimeStamp/1000];
//            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:obj2.msgTimeStamp/1000];
//            return [date2 compare:date1];
            if (obj1.msgTimeStamp < obj2.msgTimeStamp) {
                return NSOrderedDescending;
            }
        }
        return NSOrderedAscending;
    }];
    return array;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ------------UI-------------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kBottomBarHeight-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = kColorThemef5f5f5;
        [_tableView registerClass:MessageTableViewCell.class forCellReuseIdentifier:NSStringFromClass(MessageTableViewCell.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        MessageModel *msgModel1 = MessageModel.new;
        msgModel1.title = @"官方推荐";
        msgModel1.msg = @"官方推荐";
        msgModel1.coverPath = @"message_official";
        
        MessageModel *msgModel2 = MessageModel.new;
        msgModel2.title = @"系统消息";
        msgModel2.msg = @"系统消息";
        msgModel2.coverPath = @"message_system";
        
        _dataArray = @[msgModel1, msgModel2].mutableCopy;
    }
    return _dataArray;
}

@end
