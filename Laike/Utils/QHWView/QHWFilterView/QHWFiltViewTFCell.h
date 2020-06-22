//
//  QHWFiltViewTFCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/19.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWFilterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QHWFiltViewTFCell : UICollectionViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) FilterCellModel *model;
@property (nonatomic, copy) void (^ textValueChangedBlock)(NSString *str);

@end

NS_ASSUME_NONNULL_END
