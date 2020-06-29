//
//  QSchoolService.h
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "QHWSchoolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSchoolService : QHWBaseService

@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) QHWSchoolModel *schoolModel;

- (void)getSchoolDataWithLearnType:(NSInteger)learnType Complete:(void (^)(void))complete;

- (void)getSchoolDetailInfoRequestWithSchoolId:(NSString *)schoolId Complete:(void (^)(BOOL status))complete;

@end

NS_ASSUME_NONNULL_END
