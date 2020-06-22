//
//  QHWBottomUserModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/30.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWBottomUserModel : NSObject

@property (nonatomic, copy) NSString *serviceHotline;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *subjectName;
@property (nonatomic, copy) NSString *subjectHead;
@property (nonatomic, copy) NSString *wechatNo;
///主体类型：1-顾问；2-其他
@property (nonatomic, assign) NSInteger subjectType;
@property (nonatomic, assign) NSInteger subjectAuth;
@property (nonatomic, assign) NSInteger consultCount;

@end

NS_ASSUME_NONNULL_END
