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

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>

@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

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
//    [self.view addSubview:self.searchView];
    [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loginSuccess) name:kNotificationHXLoginSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView reloadData];
}

- (void)loginSuccess {
    [self getIMUnreadCount];
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    [self getIMUnreadCount];
}

- (void)getIMUnreadCount {
    NSArray *conversationArray = [EMClient.sharedClient.chatManager getAllConversations];
    NSInteger totalCount = 0;
    NSInteger officialCount = 0;
    for (EMConversation *conversation in conversationArray) {
        totalCount += conversation.unreadMessagesCount;
        EMMessage *msg = conversation.latestMessage;
        if (msg.ext) {
            MessageModel *msgModel = [MessageModel yy_modelWithDictionary:msg.ext];
            if (msgModel.type == 100000) {
                officialCount += conversation.unreadMessagesCount;
            }
        }
    }
    UserModel.shareUser.officialUnreadMsgCount = officialCount;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewMsg object:@(totalCount)];
    [self.tableView reloadData];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MessageTableViewCell.class)];
    MessageModel *model = self.dataArray[indexPath.row];
    cell.logoImgView.image = kImageMake(model.coverPath);
    cell.nameLabel.text = model.title;
    cell.contentLabel.text = model.msg;
    cell.ringImgView.hidden = YES;
    if (indexPath.row == 1) {
        cell.redView.hidden = (UserModel.shareUser.unreadMsgCount-UserModel.shareUser.officialUnreadMsgCount) == 0;
    } else {
        cell.redView.hidden = UserModel.shareUser.officialUnreadMsgCount == 0;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:NSClassFromString(@"SystemMessageViewController").new animated:YES];
    } else {
        [self.navigationController pushViewController:NSClassFromString(@"OfficialMsgViewController").new animated:YES];
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
#pragma mark ------------UI-------------
- (SearchView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 54)];
        WEAKSELF
        _searchView.tapBlock = ^{
            [weakSelf.navigationController pushViewController:NSClassFromString(@"MessageSearchViewController").new animated:YES];
        };
    }
    return _searchView;
}

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

- (NSArray *)dataArray {
    if (!_dataArray) {
        MessageModel *msgModel1 = MessageModel.new;
        msgModel1.title = @"官方推荐";
        msgModel1.msg = @"官方推荐";
        msgModel1.coverPath = @"message_official";
        
        MessageModel *msgModel2 = MessageModel.new;
        msgModel2.title = @"系统消息";
        msgModel2.msg = @"系统消息";
        msgModel2.coverPath = @"message_system";
        
        _dataArray = @[msgModel1, msgModel2];
    }
    return _dataArray;
}

@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kColorThemef5f5f5;
        self.userInteractionEnabled = YES;
        UIView *searchBgView = [UICreateView initWithFrame:CGRectMake(15, 12, self.width-30, 30) BackgroundColor:kColorThemefff CornerRadius:15];
        [self addSubview:searchBgView];
        
        UIImageView *searchImg = UIImageView.ivFrame(CGRectMake(10, 7, 16, 16)).ivImage(kImageMake(@"global_search"));
        [searchBgView addSubview:searchImg];

        UILabel *label = UILabel.labelFrame(CGRectMake(50, 0, searchBgView.width-65, 30)).labelText(@"试试搜索顾问名称、手机号、公司名称").labelFont(kFontTheme14).labelTitleColor(kColorThemec8c8c8);
        [searchBgView addSubview:label];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSearchView)]];
    }
    return self;
}

- (void)clickSearchView {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
