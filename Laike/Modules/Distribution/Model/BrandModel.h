//
//  BrandModel.h
//  Laike
//
//  Created by xiaobu on 2020/9/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QHWMainBusinessDetailBaseModel;
NS_ASSUME_NONNULL_BEGIN

@interface BrandModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandLogo;
@property (nonatomic, copy) NSString *brandIntro;
@property (nonatomic, strong) NSArray *brandTag;
@property (nonatomic, strong) NSArray <QHWMainBusinessDetailBaseModel *>*productList;

@end

NS_ASSUME_NONNULL_END
