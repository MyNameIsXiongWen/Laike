//
//  BrandTableViewCell.h
//  Laike
//
//  Created by xiaobu on 2020/9/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWTagView.h"
#import "BrandModel.h"
#import "QHWBaseCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrandTableViewCell : UITableViewCell <QHWBaseCellProtocol>

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) QHWTagView *tagView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) BrandModel *model;
@property (nonatomic, assign) BOOL detailCell;

@end

NS_ASSUME_NONNULL_END
