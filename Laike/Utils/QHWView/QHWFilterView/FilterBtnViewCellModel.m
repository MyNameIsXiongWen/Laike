//
//  FilterBtnViewCellModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "FilterBtnViewCellModel.h"

@implementation FilterBtnViewCellModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dataArray": QHWFilterModel.class};
}

+ (instancetype)modelWithName:(NSString *)name Img:(NSString *)img DataArray:(NSArray *)dataArray Color:(UIColor *)color {
    FilterBtnViewCellModel *model = FilterBtnViewCellModel.new;
    model.name = name;
    model.btnTitleName = name;
    model.img = img;
    model.dataArray = dataArray;
    model.color = color;
    return model;
}

@end
