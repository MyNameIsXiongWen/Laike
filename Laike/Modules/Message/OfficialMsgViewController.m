//
//  OfficialMsgViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "OfficialMsgViewController.h"
#import <HyphenateLite/HyphenateLite.h>
#import "MessageModel.h"

@interface OfficialMsgViewController () <UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation OfficialMsgViewController

- (void)dealloc {
    [EMClient.sharedClient.chatManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"官方推荐";
    self.kNavigationView.rightBtn.frame = CGRectMake(kScreenW-90, kStatusBarHeight, 70, 44);
    self.kNavigationView.rightBtn.btnTitle(@"一键已读").btnFont(kFontTheme14).btnTitleColor(kColorTheme21a8ff);
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
            if (msgModel.type == 100000) {
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
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewMsg object:@(count)];
    [self.tableView reloadData];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    NSArray *conversationArray = [EMClient.sharedClient.chatManager getAllConversations];
    for (EMConversation *conversation in conversationArray) {
        EMError *error;
        [conversation markAllMessagesAsRead:&error];
    }
    for (MessageModel *msgModel in self.dataArray) {
        msgModel.unreadMsgCount = 0;
    }
    [self.tableView reloadData];
}

- (void)getMainData {
    
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *msgModel = self.dataArray[indexPath.row];
    return 80 + MAX(17, [msgModel.title getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30, kCGFontIndexMax)]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfficialMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(OfficialMsgTableViewCell.class)];
    MessageModel *msgModel = self.dataArray[indexPath.row];
    cell.titleLabel.text = msgModel.title;
    cell.timeLabel.text = msgModel.createTime;
    cell.redView.hidden = msgModel.unreadMsgCount == 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MessageModel *msgModel = self.dataArray[indexPath.row];
//    switch (self.currentMessage.type) {
//        case 000000: //行业号消息
//            [CTMediator.sharedInstance CTMediator_viewControllerForH5WithUrl:msgModel.url TitleName:msgModel.title];
//            break;
//
//        case 100000: //系统通知
//            break;
//
//        case 101002: //提到我的  头条-评论回复，跳转-评论回复详情；
//            {
//                CommentReplyListViewController *vc = CommentReplyListViewController.new;
//                vc.commentId = msgModel.create.subjectId;
//                vc.communityType = 1;
//                [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
//            }
//            break;
//
//        case 101004: //提到我的  海外圈-视频-评论回复，跳转-评论回复详情；
//        case 101005: //提到我的  海外圈-图文-评论回复，跳转-评论回复详情；
//            {
//                CommentReplyListViewController *vc = CommentReplyListViewController.new;
//                vc.commentId = msgModel.create.subjectId;
//                vc.communityType = 2;
//                [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
//            }
//            break;
//
//        case 102002: //评论我的  海外圈-视频-评论，跳转-海外圈详情；
//        case 102003: //评论我的  海外圈-图文-评论，跳转-海外圈详情；
//            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:2];
//            break;
//
//        case 103003: //赞我的  头条-评论，跳转-头条详情；
//            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:1];
//            break;
//
//        case 103004: //赞我的  头条-回复，跳转-评论回复详情；
//            {
//                CommentReplyListViewController *vc = CommentReplyListViewController.new;
//                vc.commentId = msgModel.create.subjectId;
//                vc.communityType = 1;
//                [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
//            }
//            break;
//
//        case 103006: //赞我的  海外圈-视频-评论，跳转-海外圈详情；
//        case 103007: //赞我的  海外圈-图文-评论，跳转-海外圈详情；
//            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:2];
//            break;
//
//        case 103008: //赞我的  海外圈-视频-评论回复，跳转-评论回复详情；
//        case 103009: //赞我的  海外圈-图文-评论回复，跳转-评论回复详情；
//            {
//                CommentReplyListViewController *vc = CommentReplyListViewController.new;
//                vc.commentId = msgModel.create.subjectId;
//                vc.communityType = 2;
//                [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
//            }
//            break;
//
//        case 104001: //关注我的
//            [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:msgModel.create.subjectId UserType:msgModel.create.subject BusinessType:0];
//            break;
//
//        case 105003: //分享我的  用户-详情，跳转-用户详情；
//            [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:msgModel.create.subjectId UserType:1 BusinessType:0];
//            break;
//
//        case 105004: //分享我的  顾问-详情，跳转-顾问详情；
//            [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:msgModel.create.subjectId UserType:2 BusinessType:0];
//            break;
//
//        case 105006: //分享我的  海外圈-视频-评论，跳转-海外圈详情；
//        case 105007: //分享我的  海外圈-图文-评论，跳转-海外圈详情；
//            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:2];
//            break;
//
//        case 106003: //收藏我的  海外圈-视频-评论，跳转-海外圈详情；
//        case 106004: //收藏我的  海外圈-图文-评论，跳转-海外圈详情；
//            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:2];
//            break;
//
//        default:
//            break;
//    }
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
        [_tableView registerClass:OfficialMsgTableViewCell.class forCellReuseIdentifier:NSStringFromClass(OfficialMsgTableViewCell.class)];
        [self.view addSubview:_tableView];
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

@implementation OfficialMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        }];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(35);
            make.top.equalTo(self.topLine.mas_bottom);
        }];
        [self.btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.width.mas_equalTo(6);
            make.top.mas_equalTo(10);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = UIButton.btnInit().btnTitle(@"查看更多").btnFont(kFontTheme14).btnTitleColor(kColorThemea4abb3);
        _moreBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = UIView.viewInit().bkgColor(kColorThemefb4d56).cornerRadius(3);
        _redView.hidden = YES;
        [self.contentView addSubview:_redView];
    }
    return _redView;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.viewInit().bkgColor(kColorThemef5f5f5);
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)btmLine {
    if (!_btmLine) {
        _btmLine = UIView.viewInit().bkgColor(kColorThemef5f5f5);
        [self.contentView addSubview:_btmLine];
    }
    return _btmLine;
}

@end
