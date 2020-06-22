//
//  QHWPopView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/9.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PopTypeTop,
    PopTypeCenter,
    PopTypeBottom,
    PopTypeRight
} PopType;

@interface QHWPopView : UIView

@property (nonatomic, assign) PopType popType;

@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, assign) CGFloat bkgViewAlpha;

- (void)show;
- (void)dismiss;
- (void)popView_cancel;

@end

NS_ASSUME_NONNULL_END
