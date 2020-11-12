//
//  SigninView.h
//  Laike
//
//  Created by xiaobu on 2020/11/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SigninView : QHWPopView

@property (nonatomic, copy) void (^ clickSigninBlock)(void);

@end

NS_ASSUME_NONNULL_END
