//
//  ChatMsgViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ChatMsgViewController.h"
#import "MessageChatTableViewCell.h"
#import "MessageChatSystemTableViewCell.h"
#import "MessageChatMsgCellData.h"
#import "ChatMsgModel.h"
#import "UserModel.h"
//#import "ChatPlayVideoViewController.h"
#import "QHWPhotoBrowser.h"
#import "CTMediator+ViewController.h"

static NSInteger const MsgCount = 50;
@interface ChatMsgViewController () <UITableViewDelegate, UITableViewDataSource, MessageChatTableViewCellDelegate>

@property (nonatomic, strong) NSArray *tableViewCellArray;
@property (nonatomic, strong) NSMutableArray *msgArray;
@property (nonatomic, strong) NSMutableArray *allImgSrcArray;
@property (nonatomic, strong) EMMessage *msgForGet;
///是否滑动到底部
@property (nonatomic, assign) BOOL isScrollBottom;
///当前播放语音的cell
@property (nonatomic, strong) MessageChatTableViewCell *currentVoiceCell;

@end

@implementation ChatMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewController)];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.tableView];
    
    [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
    _msgArray = NSMutableArray.array;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self markMessageRead];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.currentVoiceCell) {
        if (self.currentVoiceCell.messageData.isPlaying) {
            [self.currentVoiceCell stopVoiceMessage];
            self.currentVoiceCell = nil;
        }
    }
}

- (void)markMessageRead {
    EMError *error;
    [self.conversation markAllMessagesAsRead:&error];
}

- (void)setConversation:(EMConversation *)conversation {
    _conversation = conversation;
    [self getNewMessage];
}

- (void)getNewMessage {
    [self.conversation loadMessagesStartFromId:self.msgForGet.messageId count:MsgCount searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        if (aError) {
            return;
        }
        if (self.tableView.mj_header.refreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        self.tableView.mj_header.hidden = aMessages.count < MsgCount;
        
        self.msgForGet = aMessages.firstObject;
        
        NSMutableArray *tempMsgArray = NSMutableArray.array;
        for (NSInteger i=0; i<aMessages.count; i++) {
            EMMessage *msg = aMessages[i];
            ChatMsgModel *msgModel = ChatMsgModel.new;
            msgModel.isPeerReaded = msg.isRead;
//            if (msg.status == TIM_MSG_STATUS_LOCAL_REVOKED) {
//                msgModel.identifier = @"MessageChatSystemTableViewCell";
//                msgModel.height = 37;
//                msgModel.data = kFormat(@"%@撤回了一条消息", msg.direction == EMMessageDirectionSend ? @"你" : @"TA");
//            } else {
                MessageChatMsgCellData *cellData = MessageChatMsgCellData.new;
                cellData.innerMessage = msg;
                cellData.identifier = msg.from;
                cellData.isSelf = msg.direction == EMMessageDirectionSend;
                if (cellData.isSelf) {
                    cellData.avatarUrl = [NSURL URLWithString:kFilePath(UserModel.shareUser.headPath)];
                } else {
                    cellData.avatarUrl = [NSURL URLWithString:kFilePath(msg.ext[@"avatar_from"])];
                };
                msgModel.data = cellData;
                msgModel.size = cellData.contentSize;
                CGFloat height = msgModel.size.height+15;
                height = MAX(height, 55);
                msgModel.height = height;
                msgModel.identifier = cellData.cellReuseIdentifier;
//            }
            [self addTimeMessageWithCurrentMsg:msg MsgAray:tempMsgArray];
            [tempMsgArray addObject:msgModel];
        }
        [tempMsgArray addObjectsFromArray:self.msgArray];
        self.msgArray = tempMsgArray;
        [self getAllImageSrcArray];
        [self markMessageRead];
        [self.tableView reloadData];
    }];
}

- (void)getAllImageSrcArray {
    [self.allImgSrcArray removeAllObjects];
    for (ChatMsgModel *msgModel in self.msgArray) {
        if ([msgModel.data isKindOfClass:MessageChatMsgCellData.class]) {
            MessageChatMsgCellData *cellData = (MessageChatMsgCellData *)msgModel.data;
            EMMessageBody *elem = cellData.innerMessage.body;
            if (elem.type == EMMessageBodyTypeImage) {
                [self.allImgSrcArray addObject:cellData.innerMessage];
            }
            else if (elem.type == EMMessageBodyTypeCustom) {
                EMCustomMessageBody *customElem = (EMCustomMessageBody *)elem;
                NSDictionary *dictionary = customElem.ext;
                if (dictionary) {
                    if ([dictionary[@"type"] isEqualToString:@"images"]) {
                        [self.allImgSrcArray addObject:dictionary[@"data"]];
                    }
                }
            }
        }
    }
}

#pragma mark ------------EMChatManagerDelegate-------------
//收到消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (NSInteger i=aMessages.count-1; i>=0; i--) {
        EMMessage *msg = aMessages[i];
        if (![msg.conversationId isEqualToString:self.conversation.conversationId]) {
            continue;
        }
        ChatMsgModel *msgModel = ChatMsgModel.new;
        MessageChatMsgCellData *cellData = MessageChatMsgCellData.new;
        cellData.innerMessage = msg;
        cellData.identifier = msg.from;
        cellData.isSelf = msg.direction == EMMessageDirectionSend;
        if (cellData.isSelf) {
            cellData.avatarUrl = [NSURL URLWithString:UserModel.shareUser.headPath];
        } else {
            cellData.avatarUrl = [NSURL URLWithString:kFilePath(msg.ext[@"avatar_from"])];
        };
        msgModel.data = cellData;
        msgModel.size = cellData.contentSize;
        CGFloat height = msgModel.size.height+15;
        height = MAX(height, 55);
        msgModel.height = height;
        msgModel.identifier = cellData.cellReuseIdentifier;
        [self addTimeMessageWithCurrentMsg:msg MsgAray:self.msgArray];
        [self.msgArray addObject:msgModel];
        if ([cellData.cellReuseIdentifier isEqualToString:@"MessageChatImageTableViewCell"]) {
            [self.allImgSrcArray addObject:msg];
        }
    }
    [self markMessageRead];
    [self.tableView reloadData];
    [self scrollToBottom:YES];
}

//收到Cmd消息
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
        NSLog(@"收到的action是 -- %@",body.action);
        if ([body.action isEqualToString:@"authorize_cmd_msg"]) {
            NSDictionary *ext = message.ext;
            NSString *messageId = ext[@"message_attr_authorize_from_message_id"];
            for (ChatMsgModel *tempMsgModel in self.msgArray) {
                MessageChatMsgCellData *tempData = (MessageChatMsgCellData *)tempMsgModel.data;
                EMMessage *tempEMMsg = tempData.innerMessage;
                NSMutableDictionary *tempExt = tempEMMsg.ext.mutableCopy;
                if ([messageId isEqualToString:tempEMMsg.messageId]) {
                    tempExt[@"message_attr_authorize_status"] = ext[@"message_attr_authorize_status"];
                    tempExt[@"message_attr_authorize_phone"] = ext[@"message_attr_authorize_phone"];
                    tempEMMsg.ext = tempExt.copy;
                    [EMClient.sharedClient.chatManager updateMessage:tempEMMsg completion:^(EMMessage *aMessage, EMError *aError) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }];
                    break;
                }
            }
        }
    }
}

//收到已读回执
- (void)messagesDidRead:(NSArray *)aMessages {
    for (NSInteger i=self.msgArray.count-1; i>=0; i--) {
        ChatMsgModel *msg = self.msgArray[i];
        if (msg.isPeerReaded) {
            break;
        }
        msg.isPeerReaded = YES;
    }
    [self.tableView reloadData];
}

//收到消息撤回
- (void)messagesDidRecall:(NSArray *)aMessages {
    for (int i=0; i<self.msgArray.count; i++) {
        ChatMsgModel *msg = self.msgArray[i];
        id msgData = msg.data;
        if ([msgData isKindOfClass:MessageChatMsgCellData.class]) {
            MessageChatMsgCellData *cellData = (MessageChatMsgCellData *)msgData;
//            if ((cellData.innerMessage.locator.seq == locator.seq)) {
//                [self.msgArray replaceObjectAtIndex:i withObject:[ChatMsgModel createRevokeMessageModelIsSelf:locator.isSelf]];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                break;
//            }
        }
    }
}

#pragma mark ------------发送消息-------------
- (void)sendMessage:(MessageChatMsgCellData *)msgData {
    ChatMsgModel *msgModel = ChatMsgModel.new;
//    if (msgData.status == Msg_Status_Fail) {//重发消息
//        for (int i=0; i<self.msgArray.count; i++) {
//            ChatMsgModel *tempMsg = self.msgArray[i];
//            if (tempMsg.data == msgData) {
//                NSInteger row = [self.msgArray indexOfObject:msgData];
//                [self.msgArray removeObjectAtIndex:row];
//                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        }
//    }
    msgData.status = Msg_Status_Sending;
    msgModel.data = msgData;
    msgModel.size = msgData.contentSize;
    CGFloat height = msgModel.size.height+15;
    height = MAX(height, 55);
    msgModel.height = height;
    msgModel.identifier = msgData.cellReuseIdentifier;
    [self addTimeMessageWithCurrentMsg:msgData.innerMessage MsgAray:self.msgArray];
    [self.msgArray addObject:msgModel];
    if ([msgData.cellReuseIdentifier isEqualToString:@"MessageChatImageTableViewCell"]) {
        [self.allImgSrcArray addObject:msgData.innerMessage];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self scrollToBottom:YES];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [EMClient.sharedClient.chatManager sendMessage:msgData.innerMessage progress:^(int progress) {
            
        } completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [self changeMsg:msgModel Status:Msg_Status_Fail];
                return;
            }
            [self changeMsg:msgModel Status:Msg_Status_Succ];
        }];
    });
}

- (void)changeMsg:(ChatMsgModel *)msg Status:(TMsgStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        MessageChatMsgCellData *msgData = (MessageChatMsgCellData *)msg.data;
        msgData.status = status;
        NSInteger index = [self.msgArray indexOfObject:msg];
        MessageChatTableViewCell *cell = (MessageChatTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell fillWithData:msgData];
    });
}

- (void)addTimeMessageWithCurrentMsg:(EMMessage *)currentMsg MsgAray:(NSMutableArray *)tempMsgArray {
    if (tempMsgArray.count == 0) {
        [tempMsgArray addObject:[ChatMsgModel createTimeMessageModel:currentMsg.timestamp]];
    } else {
        ChatMsgModel *lastMsgModel = tempMsgArray.lastObject;
        if ([lastMsgModel.data isKindOfClass:NSString.class]) {
            return;
        }
        MessageChatMsgCellData *cellData = (MessageChatMsgCellData *)lastMsgModel.data;
        EMMessage *lastMsg = cellData.innerMessage;
        NSInteger minute = [ChatMsgModel getMinuteFormStartTime:lastMsg.timestamp EndTime:currentMsg.timestamp];
        if (minute > 5) {
            [tempMsgArray addObject:[ChatMsgModel createTimeMessageModel:currentMsg.timestamp]];
        }
    }
}

- (void)scrollToBottom:(BOOL)animate {
    if (self.msgArray.count > 0) {
        if (self.msgArray.count-1 < [self.tableView numberOfRowsInSection:0]) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animate];
        }
    }
}

- (void)didTapViewController {
    if(_delegate && [_delegate respondsToSelector:@selector(didTapInMessageController:)]){
        [_delegate didTapInMessageController:self];
    }
}

//防止拖动tableView时产生的BUG
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
}

#pragma mark ------------UITableViewDelagate-------------

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isScrollBottom == NO) {
        [self scrollToBottom:NO];
        if (indexPath.row == self.msgArray.count-1) {
            _isScrollBottom = YES;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMsgModel *model = self.msgArray[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMsgModel *msgModel = self.msgArray[indexPath.row];
    if ([msgModel.data isKindOfClass:NSString.class]) {
        MessageChatSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:msgModel.identifier];
        cell.contentLabel.text = (NSString *)msgModel.data;
        return cell;
    } else {
        if ([msgModel.identifier isEqualToString:@"MessageChatTableViewCell"]) {
            MessageChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MessageChatTableViewCell.class)];
            return cell;
        } else {
            MessageChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:msgModel.identifier];
            cell.index = indexPath.row;
            cell.msgModel = msgModel;
            [cell fillWithData:msgModel.data];
            cell.delegate = self;
            return cell;
        }
    }
}

#pragma mark ------------MessageChatTableViewCellDelegate-------------
- (void)onSelectMessage:(MessageChatTableViewCell *)cell {
    EMMessageBody *elem = cell.messageData.innerMessage.body;
    switch (elem.type) {
        case EMMessageBodyTypeImage:
            [self selectImage:cell.messageData.innerMessage];
            break;
            
        case EMMessageBodyTypeVoice:
        {
            for (int i=0; i<self.msgArray.count; i++) {
                ChatMsgModel *msgModel = self.msgArray[i];
                MessageChatMsgCellData *cellData = (MessageChatMsgCellData *)msgModel.data;
                if ([cellData isKindOfClass:MessageChatMsgCellData.class]) {
                    //把正在播放的语音停止
                    if (cellData.isPlaying) {
                        MessageChatTableViewCell *voiceCell = (MessageChatTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        [voiceCell stopVoiceMessage];
                        self.currentVoiceCell = nil;
                        //如果正在播放的正好是当前点击的这一个消息，那么只要停止播放就可以了
                        if (i == cell.index) {
                            return;
                        }
                    }
                }
            }
            if (cell.messageData.isPlaying) {
                [cell stopVoiceMessage];
                self.currentVoiceCell = nil;
            } else {
                [cell playVoiceMessage];
                self.currentVoiceCell = cell;
            }
        }
            break;
            
        case EMMessageBodyTypeCustom:
        {
            EMCustomMessageBody *customElem = (EMCustomMessageBody *)elem;
            NSDictionary *dictionary = customElem.ext;
            if ([dictionary isKindOfClass:NSDictionary.class]) {
                if ([dictionary[@"message_attr_is_subject"] boolValue]) { //业务消息
                    [self selectMainBusiness:dictionary];
                }
                if ([dictionary[@"message_attr_is_authorize"] boolValue]) { //授权消息
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)onLongPressMessage:(MessageChatTableViewCell *)cell {
    
}

- (void)onRetryMessage:(MessageChatTableViewCell *)cell {
//    UILabel *msgLabel = [UICreateView initWithFrame:CGRectMake(0, 60, 280, 21) Text:@"确定要重发此消息吗？" Font:kFontTheme15 TextColor:ColorFromHexString(@"888888") BackgroundColor:UIColor.whiteColor];
//    msgLabel.textAlignment = NSTextAlignmentCenter;
//    LZAlertView *alertView = [[LZAlertView alloc] initWithFrame:CGRectZero];
//    [alertView configTitle:@"提示" ContentView:msgLabel CancelText:@"取消" ConfirmText:@"确定"];
//    [alertView show];
//    WEAKSELF
//    __weak typeof(cell) wCell = cell;
//    alertView.confirmBlock = ^{
//        [weakSelf sendMessage:wCell.messageData];
//    };
}

- (void)onSelectMessageAvatar:(MessageChatTableViewCell *)cell {
    MessageChatMsgCellData *msgData = cell.messageData;
    if (!msgData.isSelf) {
//        NSArray *array;
//        if (msgData.avatarUrl.relativeString.length > 0) {
//            array = @[msgData.avatarUrl.relativeString];
//        } else {
//            array = @[kImageMake(@"")];
//        }
//        QHWPhotoBrowser *browser = [[QHWPhotoBrowser alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) ImgArray:array.mutableCopy CurrentIndex:0];
//        [browser show];
    }
}

- (void)selectImage:(EMMessage *)message {
    NSInteger index = 0;
    for (EMMessage *msg in self.allImgSrcArray) {
        if (msg == message) {
            index = [self.allImgSrcArray indexOfObject:msg];
        }
    }
    QHWPhotoBrowser *photoBrowser = [[QHWPhotoBrowser alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) ImgArray:self.allImgSrcArray CurrentIndex:index];
    [photoBrowser show];
}

- (void)revokeMessage:(MessageChatTableViewCell *)cell {
    [EMClient.sharedClient.chatManager recallMessageWithMessageId:cell.messageData.innerMessage.messageId completion:^(EMError *aError) {
        if (aError) {
            return;
        }
        [self.msgArray replaceObjectAtIndex:[self.msgArray indexOfObject:cell.msgModel] withObject:[ChatMsgModel createRevokeMessageModelIsSelf:YES]];
        [self.tableView reloadData];
    }];
}

- (void)selectMainBusiness:(NSDictionary *)ext {
    EMCustomMsgModel *model = [EMCustomMsgModel yy_modelWithDictionary:ext];
    [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:model.message_attr_subject_id BusinessId:model.message_attr_subject_detail_id];
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
        _tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-100-kBottomDangerHeight-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.backgroundColor = kColorThemef5f5f5;
        for (NSString *cell in self.tableViewCellArray) {
            [_tableView registerClass:NSClassFromString(cell) forCellReuseIdentifier:cell];
        }
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            [self getNewMessage];
        }];
    }
    return _tableView;
}

- (NSArray *)tableViewCellArray {
    if (!_tableViewCellArray) {
        _tableViewCellArray = @[@"MessageChatBusinessTableViewCell",
                                @"MessageChatGoodsTableViewCell",
                                @"MessageChatImageTableViewCell",
                                @"MessageChatFaceTableViewCell",
                                @"MessageChatTextTableViewCell",
                                @"MessageChatVoiceTableViewCell",
                                @"MessageChatVideoTableViewCell",
                                @"MessageChatSystemTableViewCell",
                                @"MessageChatLocationTableViewCell",
                                @"MessageChatEvaluateTableViewCell",
                                @"MessageChatPhoneTableViewCell",
                                @"MessageChatHouseTypeTableViewCell",
                                @"MessageChatTableViewCell"];
    }
    return _tableViewCellArray;
}

- (NSMutableArray *)msgArray {
    if (!_msgArray) {
        _msgArray = NSMutableArray.array;
    }
    return _msgArray;
}

- (NSMutableArray *)allImgSrcArray {
    if (!_allImgSrcArray) {
        _allImgSrcArray = NSMutableArray.array;
    }
    return _allImgSrcArray;
}

@end
