//
//  CommentListCell.h
//  GoOverSeas
//
//  Created by manku on 2019/8/8.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "QHWCommentService.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CommentListCellDelegate <NSObject>
@optional

@end

@interface CommentListCell : UITableViewCell

@property (nonatomic, weak) id<CommentListCellDelegate>delegate;

@property (nonatomic, strong) UIImageView *avtarImgView;//评论人的头像
@property (nonatomic, strong) UILabel *nameLabel;//评论人名字
@property (nonatomic, strong) UIButton *likeButton;//点赞按钮
@property (nonatomic, strong) UILabel *contentLabel;//评论的内容
@property (nonatomic, strong) UIButton *allReplyButton;//热门评论-查看X条回复  最新评论没有

@property (nonatomic, strong) QHWCommentService *commentService;
@property (nonatomic, strong) QHWCommentModel *commentModel;

@end

NS_ASSUME_NONNULL_END
