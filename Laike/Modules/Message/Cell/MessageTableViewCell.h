//
//  MessageTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/10.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UIImageView *ringImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *msgCountLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIView *redView;

@end

NS_ASSUME_NONNULL_END
