//
//  QHWCommentService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWCommentService.h"
#import "CommentKeyboardAccessoryView.h"

@interface QHWCommentService ()

@property (nonatomic, strong) CommentKeyboardAccessoryView *keyboardAccessoryView;

@end

@implementation QHWCommentService

- (void)getCommentListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSString *urlStr;
    if (self.communityType == 1) {
        urlStr = kCommunityArticleCommentList;
    } else {
        urlStr = kCommunityContentCommentList;
    }
    [QHWHttpManager.sharedInstance QHW_POST:urlStr parameters:@{@"id": self.communityId,
                                                                @"currentPage": @(self.itemPageModel.pagination.currentPage),
                                                                @"pageSize": @(self.itemPageModel.pagination.pageSize)} success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:QHWCommentModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)addCommentRequestWithContent:(NSString *)content {
    if ([NSString isEmpty:content]) {
        [SVProgressHUD showInfoWithStatus:@"请输入评论内容"];
        return;
    }
    NSString *urlStr, *businessIdKey, *businessIdValue;
    NSMutableDictionary *params = NSMutableDictionary.dictionary;
    switch (self.commentType) {
        case CommentTypeArticleAdd:
            urlStr = kCommunityArticleCommentAdd;
            businessIdKey = @"articleId";
            businessIdValue = self.communityId;
            break;
        
        case CommentTypeArticleReply:
            urlStr = kCommunityArticleCommentReply;
            businessIdKey = @"commentId";
            businessIdValue = self.commentId;
            break;
        
        case CommentTypeContentAdd:
            urlStr = kCommunityContentCommentAdd;
            businessIdKey = @"id";
            businessIdValue = self.communityId;
            break;
        
        case CommentTypeContentReply:
            urlStr = kCommunityContentCommentReply;
            businessIdKey = @"commentId";
            businessIdValue = self.commentId;
            break;
            
        case CommentTypeLiveAdd:
            urlStr = kLiveCommentAdd;
            businessIdKey = @"businessId";
            businessIdValue = self.communityId;
            break;
                
        case CommentTypeQSchoolAdd:
            urlStr = kSchoolCommentAdd;
            businessIdKey = @"id";
            businessIdValue = self.communityId;
            break;
            
        default:
            break;
    }
    params = @{businessIdKey: businessIdValue, @"content": content, @"userStatus": @"2"}.mutableCopy;
    if (kLiveCommentAdd) {
        params[@"businessType"] = @"103001";
    }
    [QHWHttpLoading show];
    [QHWHttpManager.sharedInstance QHW_POST:urlStr parameters:params success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"评论成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddCommentSuccess object:nil];
        [UIView animateWithDuration:0.25 animations:^{
            [self.keyboardAccessoryView dismissSelf];
        }];
    } failure:^(NSError *error) {
        
    }];
}

- (void)deleteCommentRequestWithCommentId:(NSString *)commentId Complete:(nonnull void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kDeleteMyComment parameters:@{@"id": commentId} success:^(id responseObject) {
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getReplyListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading show];
    NSString *urlStr;
    if (self.communityType == 1) {
        urlStr = kCommunityArticleReplyList;
    } else {
        urlStr = kCommunityContentReplyList;
    }
    [QHWHttpManager.sharedInstance QHW_POST:urlStr parameters:@{@"commentId": self.commentId ?: @"",
                                                                @"currentPage": @(self.itemPageModel.pagination.currentPage),
                                                                @"pageSize": @(self.itemPageModel.pagination.pageSize)} success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        self.commentModel = [QHWCommentModel yy_modelWithJSON:responseObject[@"data"]];
        self.commentModel.isReply = YES;
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:QHWCommentModel.class json:self.itemPageModel.list]];
        for (QHWCommentModel *model in self.dataArray) {
            model.isReply = YES;
        }
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getMyCommentListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kMyCommentList parameters:@{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                                                                        @"pageSize": @(self.itemPageModel.pagination.pageSize)} success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:MyCommentModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getLiveCommentListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kLiveCommentList parameters:@{@"businessId": self.communityId,
                                                                          @"businessType": @"103001",
                                                                          @"currentPage": @(self.itemPageModel.pagination.currentPage),
                                                                          @"pageSize": @(self.itemPageModel.pagination.pageSize)} success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:QHWCommentModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getQSchoolCommentListRequestComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSchoolCommentList parameters:@{@"id": self.communityId,
                                                                            @"currentPage": @(self.itemPageModel.pagination.currentPage),
                                                                            @"pageSize": @(self.itemPageModel.pagination.pageSize)} success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:QHWCommentModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)showCommentKeyBoardWithCommentName:(NSString *)commentName {
    [self.keyboardAccessoryView dismissSelf];
    NSString *placeHolderstr = @"写评论";
    if (commentName.length > 0) {
        placeHolderstr = [NSString stringWithFormat:@"回复%@:",commentName];
    }
    self.keyboardAccessoryView = [[CommentKeyboardAccessoryView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) placeHolder:placeHolderstr];
    [self.keyboardAccessoryView.accessoryTextView becomeFirstResponder];
    WEAKSELF
    self.keyboardAccessoryView.sendCommentBlock = ^(NSString * _Nonnull content) {
        [weakSelf addCommentRequestWithContent:content];
    };
    [UIView animateWithDuration:0.25 animations:^{
        [self.keyboardAccessoryView show];
    }];
}

#pragma mark ------------DATA-------------
- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

@end
