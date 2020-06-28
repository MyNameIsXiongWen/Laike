//
//  RateModel.h
//  Laike
//
//  Created by xiaobu on 2020/6/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RateModel : NSObject

@property (nonatomic, copy) NSString *currencyName;
@property (nonatomic, copy) NSString *rate;

@end

NS_ASSUME_NONNULL_END
