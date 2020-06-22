//
//  QHWConsultantModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWConsultantModel : NSObject

@property (nonatomic, copy) NSString *id;
///名称
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, copy) NSString *userDescribe;
///头像
@property (nonatomic, copy) NSString *headPath;
///行业名称
@property (nonatomic, copy) NSString *industryName;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *qrCode;
///评分
@property (nonatomic, copy) NSString *compositeScore;
@property (nonatomic, copy) NSString *overallScore;
///咨询量
@property (nonatomic, assign) NSInteger consultCount;

@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, assign) CGFloat industryNameWidth;

@end

NS_ASSUME_NONNULL_END
