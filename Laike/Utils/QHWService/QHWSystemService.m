//
//  QHWSystemService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWSystemService.h"
#import "QHWLabelAlertView.h"
#import "UserModel.h"
#import <QiniuSDK.h>
#import "CTMediator+ViewController.h"

@implementation QHWSystemService

+ (void)showLabelAlertViewWithTitle:(NSString *)title Img:(NSString *)img MerchantId:(NSString *)merchantId IndustryId:(NSInteger)industryId BusinessId:(NSString *)businessId DescribeCode:(NSInteger)describeCode PositionCode:(NSInteger)positionCode {
    __block QHWLabelAlertView *alert = [[QHWLabelAlertView alloc] initWithFrame:CGRectZero];
    [alert configWithTitle:title cancleText:@"取消" confirmText:@"确认"];
    alert.contentString = @"去海外商户将会尽快与您联系，为您提供专业海外服务";
    alert.confirmBlock = ^{
        [alert dismiss];
        [QHWSystemService.new authorizeRequestWithMerchantId:merchantId IndustryId:industryId BusinessId:businessId DescribeCode:describeCode PositionCode:positionCode];
    };
    [alert show];
}

- (void)authorizeRequestWithMerchantId:(NSString *)merchantId IndustryId:(NSInteger)industryId BusinessId:(NSString *)businessId DescribeCode:(NSInteger)describeCode PositionCode:(NSInteger)positionCode {
    [QHWHttpLoading show];
    NSMutableDictionary *params = @{@"merchantId": merchantId ?: @"",
                                    @"businessId": businessId ?: @"",
                                    @"channelSourceCode": @"1",
                                    @"channelDetailsCode": @"2",
                                    @"channelDescribeCode": @(describeCode),
                                    @"channelPositionCode": @(positionCode),
                                    @"mobileNumber": UserModel.shareUser.mobileNumber}.mutableCopy;
//    业务唯一标识（1-房产；2游学；3-移民；4-留学；5-头条；6-活动；）
    if (industryId < 7) {
        params[@"industryId"] = @(industryId);
    }
    NSString *consultantId = [kUserDefault objectForKey:kConstConsultantId];
    if (consultantId) {
        params[@"consultantId"] = consultantId;
    }
    [QHWHttpManager.sharedInstance QHW_POST:kSystemAuthorize parameters:params success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"提交成功"];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getCountryDataRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading show];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemCountry parameters:@{} success:^(id responseObject) {
        self.countryArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"data"][@"list"]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getLikeRankRequestWithSubjectType:(NSInteger)subjectType Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemLike parameters:@{@"subjectType": @(subjectType),
                                                                     @"currentPage": @(self.itemPageModel.pagination.currentPage),
                                                                     @"pageSize": @(self.itemPageModel.pagination.pageSize)} success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.consultantArray removeAllObjects];
        }
        [self.consultantArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:QHWConsultantModel.class json:responseObject[@"data"][@"list"]]];
        self.myRanking = [responseObject[@"data"][@"myRanking"] integerValue];
        self.likeCount = [responseObject[@"data"][@"likeCount"] integerValue];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getBannerRequestWithAdvertPage:(NSInteger)advertPage Complete:(void (^)(id _Nullable))complete {
    [QHWHttpLoading show];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemBanner parameters:@{@"advertPage": @(advertPage)} success:^(id responseObject) {
        self.bannerArray = [NSArray yy_modelArrayWithClass:QHWBannerModel.class json:responseObject[@"data"][@"list1"]];
        complete(responseObject);
    } failure:^(NSError *error) {
        complete(nil);
    }];
}

///activityStatus 1:进行中  2:已结束
- (void)getActivityListRequestWithIndustryId:(NSInteger)industryId RegisterStatus:(NSInteger)registerStatus Complete:(void (^)(void))complete {
    NSMutableDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                                    @"pageSize": @(self.itemPageModel.pagination.pageSize),
                                    @"merchantId": UserModel.shareUser.merchantId ?: @""}.mutableCopy;
    if (registerStatus) {
        params[@"activityStatus"] = @(registerStatus);
    } else {
        params[@"industryId"] = @(industryId);
    }
    [QHWHttpLoading show];
    [QHWHttpManager.sharedInstance QHW_POST:kActivityList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.activityArray removeAllObjects];
        }
        [self.activityArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:QHWActivityModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getActivityDetailInfoRequestWithActivityId:(NSString *)activityId Complete:(void (^)(BOOL))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSMutableDictionary *params = @{@"id": activityId ?: @""}.mutableCopy;
    NSString *consultantId = [kUserDefault objectForKey:kConstConsultantId];
    if (consultantId) {
        params[@"consultantId"] = consultantId;
    }
    [QHWHttpManager.sharedInstance QHW_POST:kActivityInfo parameters:params success:^(id responseObject) {
        self.activityDetailModel = [QHWActivityModel yy_modelWithJSON:responseObject[@"data"]];
        self.activityDetailModel.businessType = 17;//为什么不是17？ 安卓抓包显示的是6.....
        if (self.activityDetailModel.coverPathList.count > 0) {
            self.activityDetailModel.coverPath = self.activityDetailModel.coverPathList.firstObject[@"path"];
        }
        [self handleActivityDetailCellData];
        complete(YES);
    } failure:^(NSError *error) {
        complete(NO);
    }];
}

- (void)handleActivityDetailCellData {
    CGFloat organizerHeight = 70 + MAX(22, [self.activityDetailModel.mainDescribe getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
    QHWBaseModel *organizerModel = [[QHWBaseModel alloc] configModelIdentifier:@"ActivityDetailOrganizerTableViewCell" Height:organizerHeight Data:self.activityDetailModel];
    organizerModel.headerTitle = @"主办方";
    [self.tableViewDataArray addObject:organizerModel];
    
    QHWBaseModel *contentModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@{@"data": self.activityDetailModel.activityContent ?: @"", @"identifier": @"ActivityRichTextTableViewCell"}];
    contentModel.headerTitle = @"活动内容";
    [self.tableViewDataArray addObject:contentModel];
}

- (CGFloat)activityDetailHeaderHeight {
    CGFloat height = 15+200;
    height += 20 + MAX(25, [self.activityDetailModel.name getHeightWithFont:kFontTheme18 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
    height += 20 + MAX(22, [self.activityDetailModel.startEnd getHeightWithFont:kFontTheme16 constrainedToSize:CGSizeMake(kScreenW-30-25, CGFLOAT_MAX)]);
    height += 20 + MAX(22, [self.activityDetailModel.addres getHeightWithFont:kFontTheme16 constrainedToSize:CGSizeMake(kScreenW-30-25, CGFLOAT_MAX)]);
    return height;
}

- (void)registerActivityRequestWithActivityId:(NSString *)activityId ColumnList:(NSArray *)columnList {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kActivityRegister parameters:@{@"activityId": activityId ?: @"", @"columnList": columnList} success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"报名成功"];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getHotSearchDataRequestWithBusinessPage:(NSInteger)businessPage Complete:(void (^)(void))complete {
    [QHWHttpLoading show];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemSearchHotData parameters:@{@"industryId": @(businessPage)} success:^(id responseObject) {
        self.hotSearchArray = [NSArray yy_modelArrayWithClass:SearchContentModel.class json:responseObject[@"data"][@"list"]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)getSearchContentDataRequestWithBusinessPage:(NSInteger)businessPage Content:(NSString *)content Complete:(void (^)(void))complete {
//    [QHWHttpManager.sharedInstance QHW_POST:kSystemSearchContentData parameters:@{@"industryId": @(businessPage), @"name": content} success:^(id responseObject) {
//        self.searchResultArray = [NSArray yy_modelArrayWithClass:SearchContentModel.class json:responseObject[@"data"][@"list"]];
//        complete();
//    } failure:^(NSError *error) {
//        complete();
//    }];
    
    NSString *modelStr = @"";
    if (businessPage == 1) {
        modelStr = @"QHWHouseModel";
    } else {
        modelStr = @"QHWMigrationModel";
    }
    NSDictionary *params = @{@"businessType": @(businessPage),
                             @"name": content,
                             @"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(1000)};
    [QHWHttpManager.sharedInstance QHW_POST:kDistributionList parameters:params success:^(id responseObject) {
        self.searchResultArray = [NSArray yy_modelArrayWithClass:SearchContentModel.class json:responseObject[@"data"][@"list"]];
//        NSArray *tempArray = [NSArray yy_modelArrayWithClass:NSClassFromString(modelStr) json:self.itemPageModel.list];
//        for (QHWMainBusinessDetailBaseModel *tempModel in tempArray) {
//            tempModel.businessType = businessPage;
//            QHWBaseModel *baseModel = [[QHWBaseModel alloc] configModelIdentifier:@"QHWMainBusinessTableViewCell" Height:140 Data:@[tempModel, @(2)]];
//            [self.tableViewDataArray addObject:baseModel];
//        }
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}


#pragma mark ------------Action-------------
///主体：0-所有；1-用户；2-商户用户(顾问)；3-商户
- (void)clickConcernRequestWithSubject:(NSInteger)subject SubjectId:(NSString *)subjectId ConcernStatus:(NSInteger)concernStatus Complete:(void (^)(BOOL))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kActionConcern parameters:@{@"subject": @(subject), @"subjectId": subjectId, @"concernStatus": @(concernStatus)} success:^(id responseObject) {
        complete(YES);
    } failure:^(NSError *error) {
        complete(NO);
    }];
}

- (void)clickLikeRequestWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId LikeStatus:(NSInteger)likeStatus Complete:(void (^)(BOOL))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kActionLike parameters:@{@"businessType": @(businessType), @"businessId": businessId, @"likeStatus": @(likeStatus)} success:^(id responseObject) {
        complete(YES);
    } failure:^(NSError *error) {
        complete(NO);
    }];
}

- (void)clickCollectRequestWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId CollectionStatus:(NSInteger)collectionStatus Complete:(void (^)(BOOL))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kActionCollect parameters:@{@"businessType": @(businessType), @"businessId": businessId, @"collectionStatus": @(collectionStatus)} success:^(id responseObject) {
        complete(YES);
    } failure:^(NSError *error) {
        complete(NO);
    }];
}

- (void)uploadImageWithArray:(NSArray *)imgArray Completed:(void (^)(NSMutableArray * _Nonnull))completed {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemQNToken parameters:@{@"guid": UserModel.shareUser.id} success:^(id responseObject) {
        [QHWHttpLoading showWithMaskTypeBlack];
        NSString *token = responseObject[@"data"][@"token"];
        dispatch_group_t group = dispatch_group_create();
        __block NSMutableArray *tempArray = NSMutableArray.array;
        for (QHWImageModel *model in imgArray) {
            NSData *imageData = UIImageJPEGRepresentation(model.image,0.7);
            NSUInteger size =  [imageData length]/1024;
            if (size > 100){
                imageData = UIImageJPEGRepresentation(model.image, 100/size);
            }
            dispatch_group_enter(group);
            QNUploadManager *uploadManager = QNUploadManager.new;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *time = [formatter stringFromDate:[NSDate date]];
            NSString *keyyy = [NSString stringWithFormat:@"%@%lu.jpeg",time, (unsigned long)[imgArray indexOfObject:model]];
            [uploadManager putData:imageData key:keyyy token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"%@", info);
                NSLog(@"%@", resp);
                dispatch_group_leave(group);
                [tempArray addObject:@{@"path": key}];
            } option:nil];
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [QHWHttpLoading dismiss];
            completed(tempArray);
        });
    } failure:^(NSError *error) {
        completed(NSMutableArray.array);
    }];
}

- (void)uploadVideoWithURL:(NSURL *)videoUrl Completed:(void (^)(NSMutableArray * _Nonnull))completed {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemQNToken parameters:@{@"guid": UserModel.shareUser.id} success:^(id responseObject) {
        [QHWHttpLoading showWithMaskTypeBlack];
        NSString *token = responseObject[@"data"][@"token"];
        __block NSMutableArray *tempArray = NSMutableArray.array;
        NSData *imageData = [NSData dataWithContentsOfURL:videoUrl];
        QNUploadManager *uploadManager = QNUploadManager.new;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *time = [formatter stringFromDate:[NSDate date]];
        NSString *keyyy = [NSString stringWithFormat:@"%@.mp4",time];
        [uploadManager putData:imageData key:keyyy token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            [QHWHttpLoading dismiss];
            NSLog(@"%@", info);
            NSLog(@"%@", resp);
            [tempArray addObject:@{@"path": key}];
            completed(tempArray);
        } option:nil];
    } failure:^(NSError *error) {
        completed(NSMutableArray.array);
    }];
}

- (void)getMyCustomizeDataRequest {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemCustomize parameters:@{} success:^(id responseObject) {
//        MyCustomizeModel *customizeModel = [MyCustomizeModel yy_modelWithJSON:responseObject[@"data"]];
//        if (customizeModel.customStatus == 1) {
//            MyCustomizeViewController *vc = MyCustomizeViewController.new;
//            vc.customizeModel = customizeModel;
//            [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
//        } else {
//            [CTMediator.sharedInstance CTMediator_viewControllerForH5WithUrl:kMyCustomizeUrl TitleName:@"我的定制"];
//        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getShareMiniCodeRequestWithBusinessType:(NSInteger)businessType BusinessId:(NSString *)businessId Completed:(void (^)(NSString * _Nonnull))completed {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kSystemGetMiniCode parameters:@{@"businessType": @(businessType), @"businessId": businessId} success:^(id responseObject) {
        completed(responseObject[@"data"][@"qrCodePath"]);
    } failure:^(NSError *error) {
        completed(@"");
    }];
}

#pragma mark ------------DATA-------------
- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

- (NSMutableArray<QHWActivityModel *> *)activityArray {
    if (!_activityArray) {
        _activityArray = NSMutableArray.array;
    }
    return _activityArray;
}

- (NSMutableArray<QHWConsultantModel *> *)consultantArray {
    if (!_consultantArray) {
        _consultantArray = NSMutableArray.array;
    }
    return _consultantArray;
}

@end

@implementation SearchContentModel

- (CGFloat)contentHeight {
    if (!_contentHeight) {
        CGFloat height = [self.name getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(kScreenW-50, CGFLOAT_MAX)];
        _contentHeight = MAX(17, height)+30;
        if (height > 17) {
            _contentWidth = kScreenW-50;
        } else {
            _contentWidth = [self.name getWidthWithFont:kFontTheme14 constrainedToSize:CGSizeMake(CGFLOAT_MAX, 17)];
        }
    }
    return _contentHeight;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [aCoder encodeObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
        for (i=0; i<outCount; i++) {
            objc_property_t property = properties[i];
            const char *char_name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_name];
            id propertyValue = [aDecoder decodeObjectForKey:propertyName];
            if (propertyValue) {
                [self setValue:propertyValue forKey:propertyName];
            }
        }
        free(properties);
    }
    return self;
}

@end
