//
//  HomeModel.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"clientData": HomeClientModel.class};
}

@end

@implementation HomeClientModel

@end
