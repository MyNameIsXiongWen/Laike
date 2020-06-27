//
//  QHWCommentModel.h
//  GoOverSeas
//
//  Created by manku on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWCommentModel : NSObject

///评论唯一标识
@property (nonatomic, copy) NSString *commentId;
///评论内容
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
///头像
@property (nonatomic, copy) NSString *headPath;
///发布者唯一标识
@property (nonatomic, copy) NSString *releaseId;
///发布者名称
@property (nonatomic, copy) NSString *releaseName;
///回复数量
@property (nonatomic, assign) NSInteger answerCount;
///认证状态：1-未认证；2-已认证
@property (nonatomic, assign) NSInteger authenStatus;
///点赞数
@property (nonatomic, assign) NSInteger likeCount;
///点赞状态1-未点赞；2-已点赞
@property (nonatomic, assign) NSInteger likeStatus;
///用户状态：1-匿名；2-非匿名
@property (nonatomic, assign) NSInteger userStatus;

@property (nonatomic, strong) NSMutableArray <QHWCommentModel *>*list;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isReply;//YES-评论详情-所有评论下的回复按钮

///6-头条（评论）7-头条(回复) 19-内容视频（评论） 20-内容视频(回复) 22-内容图文（评论） 23-内容图文(回复)  103001直播
@property (nonatomic, assign) NSInteger businessType;

@property (nonatomic, copy) NSString *subjectHead;
@property (nonatomic, copy) NSString *subjectName;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, assign) NSInteger subjectType;

@end

NS_ASSUME_NONNULL_END
