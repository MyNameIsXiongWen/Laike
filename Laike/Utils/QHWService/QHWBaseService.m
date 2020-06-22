//
//  QHWBaseService.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/12/6.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"

@implementation QHWBaseService

- (NSMutableArray *)tableViewDataArray {
    if (!_tableViewDataArray) {
        _tableViewDataArray = NSMutableArray.array;
    }
    return _tableViewDataArray;
}

- (NSArray *)tableViewCellArray {
    if (!_tableViewCellArray) {
        _tableViewCellArray = NSArray.array;
    }
    return _tableViewCellArray;
}

@end
