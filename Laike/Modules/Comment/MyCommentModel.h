//
//  MyCommentModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCommentModel : NSObject

///评论唯一标识
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *subjectName;
@property (nonatomic, copy) NSString *subjectHead;
///标题（1-评论，内容标题；2-回复，评论内容）
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *displayTitleString;
@property (nonatomic, copy) NSMutableAttributedString *titleAttrString;
///评论内容
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
///点赞数
@property (nonatomic, assign) NSInteger likesCount;
///点赞状态1-未点赞；2-已点赞s
@property (nonatomic, assign) NSInteger likeStatus;
///被评论/回复主题，删除状态：1-未删除；2-已删除
@property (nonatomic, assign) NSInteger deleteStatus;
///评论状态：1-评论；2-回复
@property (nonatomic, assign) NSInteger commentStatus;
///被评论/回复主题：1-用户；2-顾问;3-商户
@property (nonatomic, assign) NSInteger subject;
///业务类型：;1-头条（评论）；2-头条(回复)；3-攻略（评论）；4-攻略（回复）
@property (nonatomic, assign) NSInteger businessType;

@property (nonatomic, assign) CGFloat cellHeight;
//@property (nonatomic, assign) CGFloat contentHeight;

@end

NS_ASSUME_NONNULL_END
