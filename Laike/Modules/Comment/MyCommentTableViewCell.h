//
//  MyCommentTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avtarImgView;//头像
@property (nonatomic, strong) UILabel *nameLabel;//名字
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *contentLabel;//评论的内容
@property (nonatomic, strong) UIButton *likeButton;//点赞按钮
@property (nonatomic, strong) UIView *originalContentView;//原内容view
@property (nonatomic, strong) UILabel *originalContentLabel;//原内容内容
@property (nonatomic, strong) MyCommentModel *model;
@property (nonatomic, copy) void (^ longPressBlock)(NSString *commentId);

@end

NS_ASSUME_NONNULL_END
