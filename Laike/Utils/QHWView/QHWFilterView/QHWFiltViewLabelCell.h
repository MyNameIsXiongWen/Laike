//
//  QHWFiltViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/19.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWFilterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QHWFiltViewLabelCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) FilterCellModel *model;
@end

NS_ASSUME_NONNULL_END
