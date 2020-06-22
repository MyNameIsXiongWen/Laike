//
//  RelatedToMeTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RelatedToMeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avtarImgView;//头像
@property (nonatomic, strong) UILabel *nameLabel;//名字
@property (nonatomic, strong) UILabel *contentLabel;//相关操作
@property (nonatomic, strong) UIView *originalContentView;//原内容view
@property (nonatomic, strong) UILabel *originalContentLabel;//原内容内容
@property (nonatomic, strong) UILabel *timeLabel;//时间

@end

NS_ASSUME_NONNULL_END
