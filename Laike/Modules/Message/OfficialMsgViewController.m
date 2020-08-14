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
#import "CTMediator+ViewController.h"
#import "UserModel.h"

@interface OfficialMsgViewController () <UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) EMConversation *currentConversation;

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
    self.kNavigationView.rightBtn.btnTitle(@"一键已读").btnFont(kFontTheme14).btnTitleColor(kColorThemefff);
    self.kNavigationView.titleLabel.textColor = kColorThemefff;
    self.kNavigationView.backgroundColor = kColorTheme21a8ff;
    [self.kNavigationView.leftBtn setImage:kImageMake(@"global_back_white") forState:0];
    [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
    [self getIMUnreadCount];
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    [self getIMUnreadCount];
}

- (void)getIMUnreadCount {
    NSArray *conversationArray = [EMClient.sharedClient.chatManager getAllConversations];
    if (conversationArray.count > 0) {
        NSInteger count = 0;
        NSInteger officialCount = 0;
        for (EMConversation *conversation in conversationArray) {
            count += conversation.unreadMessagesCount;
            EMMessage *msg = conversation.latestMessage;
            if (msg.ext) {
                MessageModel *msgModel = [MessageModel yy_modelWithDictionary:msg.ext];
                if (msgModel.type == 100000) {
                    officialCount += conversation.unreadMessagesCount;
                    self.currentConversation = conversation;
                    [self.dataArray removeAllObjects];
                    [conversation loadMessagesStartFromId:nil count:1000 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
                        for (EMMessage *tempEMMsg in aMessages) {
                            if (tempEMMsg.ext) {
                                MessageModel *tempEMMsgModel = [MessageModel yy_modelWithDictionary:tempEMMsg.ext];
                                tempEMMsgModel.message = tempEMMsg;
                                tempEMMsgModel.isRead = tempEMMsg.isRead;
                                tempEMMsgModel.unreadMsgCount = tempEMMsg.isRead ? 0 : 1;
                                [self.dataArray insertObject:tempEMMsgModel atIndex:0];
                            }
                        }
                        [self.tableView reloadData];
                        [self.tableView showNodataView:self.dataArray.count == 0 offsetY:0 button:nil];
                    }];
                    break;
                }
            }
        }
        UserModel.shareUser.officialUnreadMsgCount = officialCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewMsg object:@(count)];
    } else {
        [self.tableView reloadData];
        [self.tableView showNodataView:self.dataArray.count == 0 offsetY:0 button:nil];
    }
}

- (void)rightNavBtnAction:(UIButton *)sender {
    for (MessageModel *msgModel in self.dataArray) {
        msgModel.isRead = YES;
        msgModel.unreadMsgCount = 0;
    }
    EMError *error;
    [self.currentConversation markAllMessagesAsRead:&error];
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
    if (msgModel.clickStatus == 3) {
        return 45 + MAX(17, [msgModel.title getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
    }
    return 85 + MAX(17, [msgModel.title getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfficialMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(OfficialMsgTableViewCell.class)];
    MessageModel *msgModel = self.dataArray[indexPath.row];
    cell.titleLabel.text = msgModel.title;
    cell.timeLabel.text = msgModel.createTime;
    cell.redView.hidden = msgModel.isRead;
    cell.moreBtn.hidden = cell.btmLine.hidden = msgModel.clickStatus == 3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *msgModel = self.dataArray[indexPath.row];
    msgModel.isRead = YES;
    EMError *error;
    [self.currentConversation markMessageAsReadWithId:msgModel.message.messageId error:&error];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewMsg object:@(UserModel.shareUser.unreadMsgCount - msgModel.unreadMsgCount)];
    msgModel.unreadMsgCount = 0;
    switch (msgModel.clickStatus) {
        case 1: //原生页面
        {
            switch (msgModel.businessType) {
                case 1:
                case 2:
                case 3:
                case 4:
                case 102001: //产品详情
                    [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:msgModel.businessType BusinessId:msgModel.businessId];
                    break;
                
                case 5: //海外头条
                    [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.businessId CommunityType:1];
                    break;

                case 18:
                case 21:
                case 1821: //海外圈
                    [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.businessId CommunityType:2];
                    break;
                
                case 24: //Q大学专业课堂
                case 27: //Q大学产品学习
                    [CTMediator.sharedInstance CTMediator_viewControllerForQSchoolDetailWithSchoolId:msgModel.businessId];
                    break;

                case 103001: //视频
                    [CTMediator.sharedInstance CTMediator_viewControllerForLiveDetailWithLiveId:msgModel.businessId];
                    break;

                case 17: //活动
                    [CTMediator.sharedInstance CTMediator_viewControllerForActivityDetailWithActivityId:msgModel.businessId];
                    break;
                    
                case 101003: //霸屏海报列表-页面
                    [CTMediator.sharedInstance CTMediator_viewControllerForGallery];
                    break;
                    
                case 101002: //发布海外圈
                    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"CommunityPublishViewController").new animated:YES];
                    break;
                    
                case 103010: //海外圈-视频
                case 103011: //海外圈-图文
                    [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.businessId CommunityType:2];
                    break;

                default:
                    break;
            }
        }
            break;
        
        case 2: //H5
            [CTMediator.sharedInstance CTMediator_viewControllerForH5WithUrl:msgModel.url TitleName:msgModel.title];
            break;
            
        default:
            break;
    }
    
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
        _tableView.backgroundColor = kColorThemef5f5f5;
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
