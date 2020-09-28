//
//  BrandModel.h
//  Laike
//
//  Created by xiaobu on 2020/9/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrandModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandLogo;
@property (nonatomic, copy) NSString *brandInfo;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSArray *labelList;

@end

NS_ASSUME_NONNULL_END
