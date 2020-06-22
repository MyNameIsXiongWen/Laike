//
//  RelatedToMeViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RelatedToMeViewController.h"
#import "RelatedToMeTableViewCell.h"
#import "QHWGeneralTableViewCell.h"
#import <HyphenateLite/HyphenateLite.h>
#import "CTMediator+ViewController.h"
//#import "CommentReplyListViewController.h"

@interface RelatedToMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) EMMessage *latestMessage;

@end

@implementation RelatedToMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = self.currentMessage.from.subjectName;
    self.kNavigationView.titleLabel.textColor = kColorThemefff;
    self.kNavigationView.backgroundColor = kColorThemefb4d56;
    [self.kNavigationView.leftBtn setImage:kImageMake(@"global_back_white") forState:0];
    [self getNewMessage];
}

- (void)getNewMessage {
    [self.currentMessage.conversation loadMessagesStartFromId:self.latestMessage.messageId count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        if (aMessages.count > 0) {
            for (EMMessage *msg in aMessages) {
                if (msg.ext) {
                    MessageModel *msgModel = [MessageModel yy_modelWithDictionary:msg.ext];
                    [self.dataArray insertObject:msgModel atIndex:0];
                }
            }
            [self.tableView reloadData];
            self.latestMessage = aMessages.lastObject;
        }
        if (aMessages.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView showNodataView:self.dataArray.count == 0 offsetY:0 button:nil];
        EMError *error;
        [self.currentMessage.conversation markAllMessagesAsRead:&error];
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentMessage.type == 100000) {
        MessageModel *msgModel = self.dataArray[indexPath.row];
        CGFloat height = 20+55+35;
        height += MAX(20, [msgModel.msg getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-50, CGFLOAT_MAX)]);
        return height;
    }
    if (self.currentMessage.type == 104001) {
        return 70;
    }
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *msgModel = self.dataArray[indexPath.row];
    if (self.currentMessage.type == 100000) {
        SystemContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SystemContentTableViewCell.class)];
        cell.titleLabel.text = msgModel.title;
        cell.contentLabel.text = msgModel.msg;
        cell.timeLabel.text = msgModel.createTime;
        return cell;
    } else if (self.currentMessage.type == 104001) {
        FollowMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(FollowMeTableViewCell.class)];
        cell.titleLabel.text = msgModel.create.subjectName;
        cell.subTitleLabel.text = msgModel.msg;
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:kFilePath(msgModel.create.subjectHead)]];
        return cell;
    } else {
        RelatedToMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RelatedToMeTableViewCell.class)];
        cell.nameLabel.text = msgModel.create.subjectName;
        cell.contentLabel.text = msgModel.title;
        cell.originalContentLabel.text = msgModel.msg;
        cell.timeLabel.text = msgModel.createTime;
        [cell.avtarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(msgModel.create.subjectHead)]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *msgModel = self.dataArray[indexPath.row];
    switch (self.currentMessage.type) {
        case 000000: //行业号消息
            [CTMediator.sharedInstance CTMediator_viewControllerForH5WithUrl:msgModel.url TitleName:msgModel.title];
            break;
            
        case 100000: //系统通知
            break;
            
        case 101002: //提到我的  头条-评论回复，跳转-评论回复详情；
            {
//                CommentReplyListViewController *vc = CommentReplyListViewController.new;
//                vc.commentId = msgModel.create.subjectId;
//                vc.communityType = 1;
//                [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case 101004: //提到我的  海外圈-视频-评论回复，跳转-评论回复详情；
        case 101005: //提到我的  海外圈-图文-评论回复，跳转-评论回复详情；
            {
//                CommentReplyListViewController *vc = CommentReplyListViewController.new;
//                vc.commentId = msgModel.create.subjectId;
//                vc.communityType = 2;
//                [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case 102002: //评论我的  海外圈-视频-评论，跳转-海外圈详情；
        case 102003: //评论我的  海外圈-图文-评论，跳转-海外圈详情；
            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:2];
            break;
        
        case 103003: //赞我的  头条-评论，跳转-头条详情；
            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:1];
            break;
            
        case 103004: //赞我的  头条-回复，跳转-评论回复详情；
            {
//                CommentReplyListViewController *vc = CommentReplyListViewController.new;
//                vc.commentId = msgModel.create.subjectId;
//                vc.communityType = 1;
//                [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
            }
            break;
                
        case 103006: //赞我的  海外圈-视频-评论，跳转-海外圈详情；
        case 103007: //赞我的  海外圈-图文-评论，跳转-海外圈详情；
            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:2];
            break;
                
        case 103008: //赞我的  海外圈-视频-评论回复，跳转-评论回复详情；
        case 103009: //赞我的  海外圈-图文-评论回复，跳转-评论回复详情；
            {
//                CommentReplyListViewController *vc = CommentReplyListViewController.new;
//                vc.commentId = msgModel.create.subjectId;
//                vc.communityType = 2;
//                [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
            }
            break;
        
        case 104001: //关注我的
            [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:msgModel.create.subjectId UserType:msgModel.create.subject BusinessType:0];
            break;
            
        case 105003: //分享我的  用户-详情，跳转-用户详情；
            [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:msgModel.create.subjectId UserType:1 BusinessType:0];
            break;
            
        case 105004: //分享我的  顾问-详情，跳转-顾问详情；
            [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:msgModel.create.subjectId UserType:2 BusinessType:0];
            break;
                    
        case 105006: //分享我的  海外圈-视频-评论，跳转-海外圈详情；
        case 105007: //分享我的  海外圈-图文-评论，跳转-海外圈详情；
            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:2];
            break;
                        
        case 106003: //收藏我的  海外圈-视频-评论，跳转-海外圈详情；
        case 106004: //收藏我的  海外圈-图文-评论，跳转-海外圈详情；
            [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:msgModel.create.subjectId CommunityType:2];
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
        [_tableView registerClass:RelatedToMeTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RelatedToMeTableViewCell.class)];
        [_tableView registerClass:FollowMeTableViewCell.class forCellReuseIdentifier:NSStringFromClass(FollowMeTableViewCell.class)];
        [_tableView registerClass:SystemContentTableViewCell.class forCellReuseIdentifier:NSStringFromClass(SystemContentTableViewCell.class)];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            [self getNewMessage];
        }];
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


@implementation FollowMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(40);
            make.centerY.equalTo(self);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(5, 10));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(15);
            make.top.equalTo(self.leftImageView.mas_top).offset(3);
            make.right.equalTo(self.arrowImageView.mas_left).offset(-10);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.right.equalTo(self.arrowImageView.mas_left).offset(-10);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = UIImageView.ivInit().ivImage(kImageMake(@"arrow_right_gray"));
        [self.contentView addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = UIImageView.ivInit().ivCornerRadius(20);
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme14);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme13);
        [self.contentView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end

@implementation SystemContentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bkgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.right.bottom.mas_equalTo(-10);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.right.mas_equalTo(-15);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(15);
            make.right.bottom.mas_equalTo(-15);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UIView *)bkgView {
    if (!_bkgView) {
        _bkgView = UIView.viewInit().bkgColor(kColorThemefff).cornerRadius(10);
        [self.contentView addSubview:_bkgView];
    }
    return _bkgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme16);
        [self.bkgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme13);
        [self.bkgView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme15);
        [self.bkgView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
