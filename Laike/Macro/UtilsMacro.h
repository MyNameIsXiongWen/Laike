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
#define kHouseDetailPath(id) kFormat(@"pages/house/houseDetail?id=%@", id)
#define kStudentDetailPath(id) kFormat(@"pages/study/studyDetail?id=%@", id)
#define kStudyDetailPath(id) kFormat(@"pages/overSea/overSeaDetail?id=%@", id)
#define kMigrationDetailPath(id) kFormat(@"pages/migrate/migrateDetail?id=%@", id)
#define kTreatmentDetailPath(id) kFormat(@"pages/medical/medicalDetail?id=%@", id)
#define kActivityDetailPath(id) kFormat(@"pages/activity/activityDetail?id=%@", id)
#define kArticleDetailPath(id) kFormat(@"pages/headline/headlineDetail?id=%@", id)
#define kConsultantDetailPath(id) kFormat(@"pages/counselor/counselorDetail?id=%@", id)
#define kMerchantDetailPath(id) kFormat(@"pages/merchant/merchantDetail?id=%@", id)
#define kManagerDetailPath(id) kFormat(@"pages/counselor/managerShareDetail?id=%@", id)
#define kLiveDetailPath(id) kFormat(@"pages/video/videoDetail?id=%@", id)

#endif /* UtilsMacro_h */
