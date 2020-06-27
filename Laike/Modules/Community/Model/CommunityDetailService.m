//
//  CommunityDetailService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityDetailService.h"

@implementation CommunityDetailService

- (void)getCommunityDetailRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSString *urlStr;
    if (self.communityType == 1) {
        urlStr = kCommunityArticleDetail;
    } else {
        urlStr = kCommunityContentDetail;
    }
    NSMutableDictionary *params = @{@"id": self.communityId}.mutableCopy;
    NSString *consultantId = [kUserDefault objectForKey:kConstConsultantId];
    if (consultantId) {
        params[@"consultantId"] = consultantId;
    }
    [QHWHttpManager.sharedInstance QHW_POST:urlStr parameters:params success:^(id responseObject) {
        self.detailModel = [CommunityDetailModel yy_modelWithJSON:responseObject[@"data"]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

@end

@implementation CommunityDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bottomData": QHWBottomUserModel.class,
             @"subjectData": QHWBottomUserModel.class,
             @"businessList": BusinessListModel.class
             };
}

- (NSString *)sourceStr {
    return self.source == 1 ? @"原创" : @"转载";
}

- (CGFloat)headerTopHeight {
    CGFloat nameHeight = MAX(23, [self.name getHeightWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
    return nameHeight+110+17;
}

- (CGFloat)headerContentHeight {
    NSString *contentString;
    if (self.title.length > 0) {
        contentString = kFormat(@"%@\n%@", self.title, self.content);
    } else {
        contentString = self.content;
    }
    CGFloat contentHeight = MAX(20, [contentString getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
    return contentHeight+100+500;
}

@end

@implementation BusinessListModel

@end
