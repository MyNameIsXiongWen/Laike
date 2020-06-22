//
//  SystemMessageViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "MessageTableViewCell.h"
#import <HyphenateLite/HyphenateLite.h>
#import "UserModel.h"
#import "MessageModel.h"
#import "RelatedToMeViewController.h"

@interface SystemMessageViewController () <UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SystemMessageViewController

- (void)dealloc {
    [EMClient.sharedClient.chatManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"系统消息";
    self.kNavigationView.titleLabel.textColor = kColorThemefff;
    self.kNavigationView.backgroundColor = kColorThemefb4d56;
    [self.kNavigationView.leftBtn setImage:kImageMake(@"global_back_white") forState:0];
    [self.view addSubview:self.tableView];
    [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
    [self getIMUnreadCount];
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    [self getIMUnreadCount];
}

- (void)getIMUnreadCount {
    NSArray *conversationArray = [EMClient.sharedClient.chatManager getAllConversations];
    NSInteger count = 0;
    for (EMConversation *conversation in conversationArray) {
        count += conversation.unreadMessagesCount;
        EMMessage *msg = conversation.latestMessage;
        if (msg.ext) {
            MessageModel *msgModel = [MessageModel yy_modelWithDictionary:msg.ext];
            msgModel.unreadMsgCount = conversation.unreadMessagesCount;
            msgModel.conversation = conversation;
            for (MessageModel *tempModel in self.dataArray) {
                if (tempModel.type == msgModel.type) {
                    [self.dataArray removeObject:tempModel];
                    break;
                }
            }
            [self.dataArray insertObject:msgModel atIndex:0];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewMsg object:@(count)];
    [self.tableView reloadData];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MessageTableViewCell.class)];
    MessageModel *msgModel = self.dataArray[indexPath.row];
    cell.nameLabel.text = msgModel.from.subjectName;
    cell.timeLabel.text = msgModel.createTime;
    cell.contentLabel.text = msgModel.msg;
    cell.msgCountLabel.text = kFormat(@"%d", msgModel.unreadMsgCount);
    cell.msgCountLabel.hidden = msgModel.unreadMsgCount == 0;
    [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(msgModel.from.subjectHead)]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *msgModel = self.dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewMsg object:@(UserModel.shareUser.unreadMsgCount - msgModel.unreadMsgCount)];
    msgModel.unreadMsgCount = 0;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    RelatedToMeViewController *vc = RelatedToMeViewController.new;
    vc.currentMessage = msgModel;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = kColorThemef5f5f5;
        [_tableView registerClass:MessageTableViewCell.class forCellReuseIdentifier:NSStringFromClass(MessageTableViewCell.class)];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

@end
