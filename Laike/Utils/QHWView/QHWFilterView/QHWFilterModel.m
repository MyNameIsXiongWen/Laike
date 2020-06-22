//
//  QHWFilterModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWFilterModel.h"

@implementation QHWFilterModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content": FilterCellModel.class};
}

+ (instancetype)modelWithTitle:(NSString *)title Key:(NSString *)key Content:(NSArray *)content MutableSelected:(BOOL)mutableSelected {
    QHWFilterModel *model = QHWFilterModel.new;
    model.title = title;
    model.key = key;
    model.content = content;
    model.mutableSelected = mutableSelected;
    return model;
}

@end

@implementation FilterCellModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data": FilterCellModel.class};
}

- (CGSize)size {
    if (_size.width == 0 && _size.height == 0) {
        _size = CGSizeMake((kScreenW-60)/4, 30);
    }
    return _size;
}

+ (instancetype)modelWithName:(NSString *)name Code:(NSString *)code {
    FilterCellModel *model = FilterCellModel.new;
    model.name = name;
    model.code = code;
    model.size = CGSizeMake((kScreenW-60)/4, 30);
    return model;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = NSMutableArray.array;
    }
    return _data;
}

@end
