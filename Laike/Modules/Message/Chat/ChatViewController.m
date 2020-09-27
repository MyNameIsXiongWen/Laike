//
//  ChatViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ChatViewController.h"
#import <IQKeyboardManager.h>
#import "ChatInputViewController.h"
#import "ChatMsgViewController.h"
#import "MessageChatMsgCellData.h"
#import "UserModel.h"

@interface ChatViewController () <ChatInputViewControllerDelegate, ChatMsgViewControllerDelegate>

@property (nonatomic, strong) ChatInputViewController *inputController;
@property (nonatomic, strong) ChatMsgViewController *msgController;

@end

@implementation ChatViewController

- (void)dealloc {
    [EMClient.sharedClient.chatManager removeDelegate:self.msgController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.kNavigationView.title = self.receiverNickName;
    self.kNavigationView.titleLabel.textColor = kColorThemefff;
    self.kNavigationView.backgroundColor = kColorTheme21a8ff;
    [self.kNavigationView.leftBtn setImage:kImageMake(@"global_back_white") forState:0];
   [self.view addSubview:self.msgController.view];
   [self.view addSubview:self.inputController.view];
//   [self getUserProfile];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager.sharedManager.enableAutoToolbar = YES;
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        [self saveDraft];
        if (self.updateBlock) {
            self.updateBlock();
        }
    }
}

- (void)getUserProfile {
//    [TIMFriendshipManager.sharedInstance getUsersProfile:@[self.conversation.getReceiver] forceUpdate:YES succ:^(NSArray<TIMUserProfile *> *profiles) {
//        TIMUserProfile *profile = profiles.firstObject;
//        NSDictionary *userInfo = profile.customInfo;
        self.inputController.conversation = self.conversation;
        if (self.mainBusinessModel) {
            self.inputController.mainBusinessModel = self.mainBusinessModel;
        }
        self.msgController.conversation = self.conversation;
//        self.nameLabel.text = profile.nickname;
//    } fail:^(int code, NSString *msg) {
//
//    }];
}

#pragma mark ------------ChatInputViewControllerDelegate-------------
- (void)inputController:(ChatInputViewController *)inputController didChangeHeight:(CGFloat)height {
    WEAKSELF
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.msgController.view.height = weakSelf.view.height - height-kTopBarHeight;
        weakSelf.msgController.tableView.height = weakSelf.msgController.view.height;
        weakSelf.inputController.view.y = weakSelf.msgController.view.bottom;
        weakSelf.inputController.view.height = height;
        [weakSelf.msgController scrollToBottom:NO];
    } completion:nil];
}

- (void)inputController:(ChatInputViewController *)inputController didSendMessage:(MessageChatMsgCellData *)msg {
    [self.msgController sendMessage:msg];
}

//发送消息
- (void)sendMessage:(MessageChatMsgCellData *)message {
    [self.msgController sendMessage:message];
}

//保存草稿
- (void)saveDraft {
    NSString *draft = self.inputController.inputBar.inputTextView.text;
    draft = [draft stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
//    if (draft.length) {
//        TIMMessageDraft *msg = [TIMMessageDraft new];
//        TIMTextElem *text = [TIMTextElem new];
//        [text setText:draft];
//        [msg addElem:text];
//        [self.conversation setDraft:msg];
//    } else {
//        [self.conversation setDraft:nil];
//    }
}

#pragma mark ------------ChatMsgViewControllerDelegate-------------
- (void)didTapInMessageController:(ChatMsgViewController *)controller {
    [self.inputController reset];
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

- (ChatInputViewController *)inputController {
    if (!_inputController) {
        _inputController = [[ChatInputViewController alloc] init];
        if ([self.conversation.conversationId isEqualToString:kHXCustomerServiceId]) {
            _inputController.view.frame = CGRectMake(0, kScreenH-60-kBottomDangerHeight, kScreenW, 60+kBottomDangerHeight);
        } else {
            _inputController.view.frame = CGRectMake(0, kScreenH-100-kBottomDangerHeight, kScreenW, 100+kBottomDangerHeight);
        }
        _inputController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _inputController.delegate = self;
        _inputController.conversation = self.conversation;
        _inputController.receiverHeadPath = self.receiverHeadPath;
        _inputController.receiverNickName = self.receiverNickName;
        if (self.mainBusinessModel) {
            _inputController.mainBusinessModel = self.mainBusinessModel;
        }
        [self addChildViewController:_inputController];
    }
    return _inputController;
}

- (ChatMsgViewController *)msgController {
    if (!_msgController) {
        _msgController = [[ChatMsgViewController alloc] init];
        _msgController.view.frame = CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-self.inputController.view.height-kTopBarHeight);
        _msgController.delegate = self;
        _msgController.conversation = self.conversation;
        _msgController.receiverHeadPath = self.receiverHeadPath;
        _msgController.receiverNickName = self.receiverNickName;
        [self addChildViewController:_msgController];
    }
    return _msgController;
}

@end
