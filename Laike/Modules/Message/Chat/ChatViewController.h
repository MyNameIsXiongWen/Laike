//
//  ChatViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HyphenateLite/HyphenateLite.h>
#import "QHWMainBusinessDetailBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController

@property (nonatomic, copy) NSString *receiverNickName;
@property (nonatomic, copy) NSString *receiverHeadPath;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) QHWMainBusinessDetailBaseModel *mainBusinessModel;
@property (nonatomic, copy) void (^ updateBlock)(void);

@end

NS_ASSUME_NONNULL_END
