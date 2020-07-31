//
//  UtilsMacro.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/4/26.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h
#import <Colours.h>

#define kUserDefault [NSUserDefaults standardUserDefaults]

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define kImageMake(img) [UIImage imageNamed:img inBundle:nil compatibleWithTraitCollection:nil]
#define kColor(a,b,c,d) [UIColor colorWithRed:a / 255.0 green:b / 255.0 blue:c / 255.0 alpha:d]
#define kColorFromHexString(hex) [UIColor colorFromHexString:hex]
#define kFormat(string, args...)  [NSString stringWithFormat:string, args]
#define kCallTel(phoneNo) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNo]] options:@{} completionHandler:^(BOOL success) {}]

#define kHomeIndex @"https://m.qhiwi.com/home"
#define kFilePath(path) [path containsString:@"http"] ? path : kFormat(@"http://file.qhiwi.com/%@", path)
#define kMiniCodePath(path) [path containsString:@"http"] ? path : kFormat(@"https://m.qhiwi.com/site/file/%@", path)
#define kHouseDetailPath(id, userId) kFormat(@"pages/house/houseDetail?id=%@&managerId=%@", id, userId)
#define kStudentDetailPath(id, userId) kFormat(@"pages/study/studyDetail?id=%@&managerId=%@", id, userId)
#define kStudyDetailPath(id, userId) kFormat(@"pages/overSea/overSeaDetail?id=%@&managerId=%@", id, userId)
#define kMigrationDetailPath(id, userId) kFormat(@"pages/migrate/migrateDetail?id=%@&managerId=%@", id, userId)
#define kTreatmentDetailPath(id, userId) kFormat(@"pages/medical/medicalDetail?id=%@&managerId=%@", id, userId)
#define kActivityDetailPath(id, userId) kFormat(@"pages/activity/activityDetail?id=%@&managerId=%@", id, userId)
#define kArticleDetailPath(id, userId) kFormat(@"pages/headline/headlineDetail?id=%@&managerId=%@", id, userId)
#define kContentDetailPath(id, userId) kFormat(@"pages/counselor/managerShareDetail?id=%@&managerId=%@", id, userId)
#define kConsultantDetailPath(id, userId) kFormat(@"pages/counselor/counselorDetail?id=%@&managerId=%@", id, userId)
#define kMerchantDetailPath(id, userId) kFormat(@"pages/merchant/merchantDetail?id=%@&managerId=%@", id, userId)
#define kLiveDetailPath(id, userId) kFormat(@"pages/video/videoDetail?id=%@&managerId=%@", id, userId)

#endif /* UtilsMacro_h */
