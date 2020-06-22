//
//  QHWBaseService.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/12/6.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWBaseService : NSObject

@property (nonatomic, strong) NSArray *tableViewCellArray;
@property (nonatomic, strong) NSMutableArray <QHWBaseModel *>*tableViewDataArray;

@end

NS_ASSUME_NONNULL_END
