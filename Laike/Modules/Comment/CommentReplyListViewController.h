//
//  CommentReplyListViewController.h
//  GoOverSeas
//
//  Created by manku on 2019/8/8.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentReplyListViewController : UIViewController

///社区类型 1:头条  2:圈子
@property (nonatomic, assign) NSInteger communityType;
///内容详情类型 1:视频 2:图文
@property (nonatomic, assign) NSInteger fileType;
@property (nonatomic, copy) NSString *commentId;

@end

NS_ASSUME_NONNULL_END
