//
//  QHWCategoryModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/22.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWCategoryModel : NSObject

@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
