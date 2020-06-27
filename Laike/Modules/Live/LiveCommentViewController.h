//
//  LiveCommentViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseScrollContentViewController.h"
#import "LiveModel.h"
#import "QHWCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveCommentViewController : QHWBaseScrollContentViewController

@property (nonatomic, strong) LiveModel *liveModel;

@end

@interface LiveCommentListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avtarImgView;//评论人的头像
@property (nonatomic, strong) UILabel *nameLabel;//评论人名字
@property (nonatomic, strong) UILabel *contentLabel;//评论的内容
@property (nonatomic, strong) UILabel *timeLabel;//评论时间
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) QHWCommentModel *commentModel;

@end

NS_ASSUME_NONNULL_END
