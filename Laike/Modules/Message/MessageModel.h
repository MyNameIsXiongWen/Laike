//
//  MessageModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class EMConversation;
@class MessageUserModel;
@class EMMessage;
@interface MessageModel : NSObject

/*000000-行业号消息 (对应之前 type=1),标题、封面图、点击跳转-htmlUrl
100000-官方推荐
101001-系统消息-提到我的，攻略-评论回复，id评论唯一标识，跳转-评论回复详情；
101002-系统消息-提到我的，头条-评论回复，id评论唯一标识，跳转-评论回复详情；
101003-系统消息-提到我的，问答-提问回复，id回答唯一标识，跳转-回答详情；
101004-系统消息-提到我的，海外圈-评论回复，id回答唯一标识，跳转-评论回复详情；
102001-系统消息-评论我的，攻略-评论，id内容唯一标识，跳转-攻略详情
102002-系统消息-评论我的，海外圈-评论，id内容唯一标识，跳转-海外圈详情
103001-系统消息-赞我的，攻略-评论，id内容唯一标识，跳转-攻略详情
103002-系统消息-赞我的，攻略-回复，id评论唯一标识，跳转-评论回复详情；
103003-系统消息-赞我的，头条-评论，id内容唯一标识，跳转-头条详情；
103004-系统消息-赞我的，头条-回复，id评论唯一标识，跳转-评论回复详情；
103005-系统消息-赞我的，问答-回复，id回答唯一标识，跳转-回答详情；
104001-系统消息-关注我的，跳转-根据主体状态-subject：1-个人主页；2-顾问主页；3-商家店铺；
105001-系统消息-分享我的，攻略-详情，id攻略唯一标识，跳转-攻略详情；
105002-系统消息-分享我的，问答-提问，id提问唯一标识，跳转-提问详情；
105003-系统消息-分享我的，用户-详情，id提问唯一标识，跳转-用户详情；
105004-系统消息-分享我的，顾问-详情，id提问唯一标识，跳转-顾问详情；
105005-系统消息-分享我的，店铺-详情，id提问唯一标识，跳转-店铺详情；
106001-系统消息-收藏我的，攻略-详情，id攻略唯一标识，跳转-攻略详情；
106002-系统消息-收藏我的，问答-提问，id提问唯一标识，跳转-提问详情；*/
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) MessageUserModel *create;
@property (nonatomic, strong) MessageUserModel *from;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) EMMessage *message;

@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *msgTime;
@property (nonatomic, assign) long long msgTimeStamp;
@property (nonatomic, assign) NSInteger unreadMsgCount;

@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, copy) NSString *businessId;
///点击状态：1-原生页面；2-H5地址；3-文本不跳转
@property (nonatomic, assign) NSInteger clickStatus;
@property (nonatomic, assign) BOOL isRead;

@end

@interface MessageUserModel : NSObject

@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *subjectHead;
@property (nonatomic, copy) NSString *subjectName;
///主体：1-用户；2-顾问;3-商户；4-行业号；5-系统
@property (nonatomic, assign) NSInteger subject;

@end

NS_ASSUME_NONNULL_END
