//
//  FilterBtnViewCellModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterBtnViewCellModel : NSObject

@property (nonatomic, copy) NSString *btnTitleName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSArray <QHWFilterModel *>*dataArray;
+ (instancetype)modelWithName:(NSString *)name Img:(NSString *)img DataArray:(NSArray *)dataArray Color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
