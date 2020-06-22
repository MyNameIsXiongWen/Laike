//
//  QHWBaseModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/6/4.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWBaseModel.h"

@implementation QHWBaseModel

- (instancetype)configModelIdentifier:(NSString *)identifier Height:(CGFloat)height Data:(id)data {
    if (self == [super init]) {
        self.identifier = identifier;
        self.height = height;
        self.data = data;
    }
    return self;
}

- (instancetype)configModelIdentifier:(NSString *)identifier Height:(CGFloat)height Width:(CGFloat)width Data:(id)data{
    if (self == [super init]) {
        self.identifier = identifier;
        self.height = height;
        self.width = width;
        self.data = data;
    }
    return self;
}

@end
