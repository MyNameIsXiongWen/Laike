//
//  ChatInputViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInputBar.h"
#import "ChatMoreView.h"
#import "ChatGifView.h"
#import "ChatFaceView.h"
#import "ChatCommonWordView.h"
#import "ChatInputBarTopView.h"
#import "MessageChatMsgCellData.h"
#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ChatInputViewController;
@protocol ChatInputViewControllerDelegate <NSObject>

- (void)inputController:(ChatInputViewController *)inputController didChangeHeight:(CGFloat)height;
- (void)inputController:(ChatInputViewController *)inputController didSendMessage:(MessageChatMsgCellData *)msg;

@end

@interface ChatInputViewController : UIViewController

@property (nonatomic, copy) NSString *receiverNickName;
@property (nonatomic, copy) NSString *receiverHeadPath;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) QHWMainBusinessDetailBaseModel *mainBusinessModel;
@property (nonatomic, strong) ChatInputBar *inputBar;
@property (nonatomic, strong) ChatMoreView *moreView;
@property (nonatomic, strong) ChatGifView *gifView;
@property (nonatomic, strong) ChatFaceView *faceView;
@property (nonatomic, strong) ChatInputBarTopView *topView;
@property (nonatomic, strong) ChatCommonWordView *commonWordView;
@property (nonatomic, weak) id<ChatInputViewControllerDelegate> delegate;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
