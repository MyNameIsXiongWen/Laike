//
//  QHWCommentService.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "QHWCommentModel.h"
#import "MyCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CommentTypeArticleAdd = 0,
    CommentTypeArticleReply,    
    CommentTypeContentAdd,
    CommentTypeContentReply,
    CommentTypeLiveAdd
} CommentType;

@interface QHWCommentService : QHWBaseService

@property (nonatomic, copy) NSString *communityId;
@property (nonatomic, copy) NSString *commentId;
///社区类型 1:头条  2:圈子
@property (nonatomic, assign) NSInteger communityType;
///只有内容相关才会用到 1:视频 2:图文
@property (nonatomic, assign) NSInteger fileType;
@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) NSMutableArray *dataArray;

///评论回复列表页的原评论内容
@property (nonatomic, strong) QHWCommentModel *commentModel;

- (void)getCommentListRequestComplete:(void (^)(void))complete;
- (void)addCommentRequestWithContent:(NSString *)content;
- (void)deleteCommentRequestWithCommentId:(NSString *)commentId Complete:(void (^)(void))complete;

- (void)getReplyListRequestComplete:(void (^)(void))complete;
- (void)getMyCommentListRequestComplete:(void (^)(void))complete;

- (void)getLiveCommentListRequestComplete:(void (^)(void))complete;

- (void)showCommentKeyBoardWithCommentName:(NSString *)commentName;

@end

NS_ASSUME_NONNULL_END
