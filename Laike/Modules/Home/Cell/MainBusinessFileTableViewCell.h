//
//  MainBusinessFileTableViewCell.h
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWShadowCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainBusinessFileTableViewCell : UITableViewCell

@end

@interface FileCollectionViewCell : QHWShadowCollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImgView;

@end

NS_ASSUME_NONNULL_END
