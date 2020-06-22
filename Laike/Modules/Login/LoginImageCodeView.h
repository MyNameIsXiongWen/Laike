//
//  LoginImageCodeView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginImageCodeView : QHWPopView

@property (nonatomic, strong, readonly) UILabel *tipLabel;
@property (nonatomic, copy) NSString *codeBase64;
@property (nonatomic, copy) void (^ getCodeBlock)(void);
@property (nonatomic, copy) void (^ submitBlock)(NSString *code);

@end

NS_ASSUME_NONNULL_END
