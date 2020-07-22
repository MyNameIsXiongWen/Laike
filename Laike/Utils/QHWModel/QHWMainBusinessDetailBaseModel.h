//
//  QHWMainBusinessDetailBaseModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWConsultantModel.h"
#import "QHWBottomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QHWActivityModel;
@interface QHWMainBusinessDetailBaseModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *htmlUrl;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *merchantHead;
@property (nonatomic, copy) NSString *serviceHotline;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *discounts;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, strong) UIImage *snapShotImage;
///分销状态 1-不是分销；2-分销产品
@property (nonatomic, assign) NSInteger distributionStatus;

///收藏状态：1-未收藏；2-已收藏
@property (nonatomic, assign) NSInteger collectionStatus;
///咨询量
@property (nonatomic, assign) NSInteger consultCount;

@property (nonatomic, strong) NSArray <QHWConsultantModel *>*consultantList;
@property (nonatomic, strong) NSArray <QHWActivityModel *>*activityList;
@property (nonatomic, strong) NSArray *bannerList;
@property (nonatomic, strong) QHWBottomUserModel *bottomData;

@property (nonatomic, assign) CGFloat mainBusinessCellHeight;
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
