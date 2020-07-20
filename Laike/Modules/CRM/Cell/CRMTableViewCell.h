//
//  CRMTableViewCell.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWTagView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRMTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) QHWTagView *tagView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *convertBtn;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, copy) void (^ clickConvertBlock)(void);
@property (nonatomic, copy) void (^ clickContactBlock)(void);

@end

NS_ASSUME_NONNULL_END
