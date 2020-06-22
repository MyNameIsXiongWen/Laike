//
//  RelatedToMeViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RelatedToMeViewController : UIViewController

@property (nonatomic, strong) MessageModel *currentMessage;

@end

@interface FollowMeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *line;

@end

@interface SystemContentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
