//
//  QHWOptionBaseModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWOptionBaseModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *param;//备用参数
@property (nonatomic, assign) BOOL selected;//是否选中
@end

NS_ASSUME_NONNULL_END
