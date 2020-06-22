//
//  QHWLabelAlertView.h
//  Guider
//
//  Created by xiaobu on 2019/10/24.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWLabelAlertView : QHWAlertView
@property (nonatomic , strong , readonly) UILabel *contentLbl;
@property (nonatomic , copy) NSString *contentString;

@end

NS_ASSUME_NONNULL_END
