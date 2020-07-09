//
//  QSchoolShareView.h
//  Laike
//
//  Created by xiaobu on 2020/7/9.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "QHWSchoolModel.h"
#import "QHWShareBottomViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSchoolShareView : QHWPopView

@property (nonatomic, strong) QHWSchoolModel *schoolModel;
@property (nonatomic, weak) id<QHWShareBottomViewProtocol>delegate;

@end

NS_ASSUME_NONNULL_END
