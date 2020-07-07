//
//  RateShareView.h
//  Laike
//
//  Created by xiaobu on 2020/7/7.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "QHWShareBottomViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RateShareView : QHWPopView

@property (nonatomic, weak) id<QHWShareBottomViewProtocol>delegate;
@property (nonatomic, strong) NSArray *rateArray;

@end

NS_ASSUME_NONNULL_END
