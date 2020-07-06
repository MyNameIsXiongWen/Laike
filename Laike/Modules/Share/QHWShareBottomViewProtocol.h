//
//  QHWShareBottomViewProtocol.h
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QHWShareBottomViewProtocol <NSObject>

- (void)ShareBottomView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image TargetView:(QHWPopView *)targetView;

@end

NS_ASSUME_NONNULL_END
