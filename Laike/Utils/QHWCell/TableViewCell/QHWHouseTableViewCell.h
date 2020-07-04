//
//  QHWHouseTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWTagView.h"
#import "QHWHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWHouseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *houseImgView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *houseTitleLabel;
@property (nonatomic, strong) UILabel *houseSubTitleLabel;
@property (nonatomic, strong) UILabel *houseMoneyLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) QHWTagView *tagView;
@property (nonatomic, strong) QHWHouseModel *houseModel;

@end

NS_ASSUME_NONNULL_END
