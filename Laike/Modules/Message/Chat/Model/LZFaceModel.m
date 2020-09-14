//
//  LZFaceModel.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "LZFaceModel.h"

@implementation LZFaceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": LZFaceImgModel.class
             };
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = NSMutableArray.array;
    }
    return _listArray;
}

@end

@implementation LZFaceImgModel

@end
