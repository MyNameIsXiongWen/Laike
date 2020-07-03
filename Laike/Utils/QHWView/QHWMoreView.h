//
//  QHWMoreView.h
//  XuanWoJia
//
//  Created by jason on 2019/7/26.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWMoreView : QHWPopView

- (instancetype)initWithFrame:(CGRect)frame ViewArray:(NSArray *)viewArray;

@property (nonatomic, copy) void (^ clickBtnBlock)(NSString *identifier);

@end

NS_ASSUME_NONNULL_END
