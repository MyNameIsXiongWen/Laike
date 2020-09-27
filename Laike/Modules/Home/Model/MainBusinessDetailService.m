//
//  MainBusinessDetailService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/26.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MainBusinessDetailService.h"
#import "QHWHouseModel.h"
#import "QHWStudyModel.h"
#import "QHWMigrationModel.h"
#import "QHWStudentModel.h"
#import "QHWTreatmentModel.h"
#import "QHWBaseModel.h"

@implementation MainBusinessDetailService

- (instancetype)init {
    if (self == [super init]) {
        self.tableViewCellArray = @[@"ConsultantTableCell",
                                    @"ActivityTableViewCell",
                                    @"RichTextTableViewCell",
                                    @"RichTextWithTitleTableViewCell",
                                    @"HouseDetailConfigTableViewCell",
                                    @"QHWHouseTableViewCell",
                                    @"MainBusinessFileTableViewCell",
                                    @"MainBusinessRulesTableViewCell",
                                    @"BrandTableViewCell"];
    }
    return self;
}

- (void)getMainBusinessDetailInfoRequest:(void (^)(BOOL status))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSString *urlStr;
    Class modelClass;
    switch (self.businessType) {
        case 1:
            urlStr = kHouseInfo;
            modelClass = QHWHouseModel.class;
            break;
        
        case 2:
            urlStr = kStudyInfo;
            modelClass = QHWStudyModel.class;
            break;
        
        case 3:
            urlStr = kMigrationInfo;
            modelClass = QHWMigrationModel.class;
            break;
        
        case 4:
            urlStr = kStudentInfo;
            modelClass = QHWStudentModel.class;
            break;
            
        case 102001:
            urlStr = kTreatmentInfo;
            modelClass = QHWTreatmentModel.class;
            break;
            
        default:
            break;
    }
    NSMutableDictionary *params = @{@"id": self.businessId}.mutableCopy;
    NSString *consultantId = [kUserDefault objectForKey:kConstConsultantId];
    if (consultantId) {
        params[@"consultantId"] = consultantId;
    }
    [QHWHttpManager.sharedInstance QHW_POST:urlStr parameters:params success:^(id responseObject) {
        self.detailModel = [modelClass yy_modelWithJSON:responseObject[@"data"]];
        self.detailModel.businessType = self.businessType;
        for (QHWConsultantModel *tempConsultant in self.detailModel.consultantList) {
            tempConsultant.businessType = self.businessType;
            tempConsultant.businessId = self.businessId;
            tempConsultant.merchantId = self.detailModel.bottomData.subjectId;
        }
        [self handleDetailModelData];
//        [self.activityService getActivityListRequestWithMerchantId:responseObject[@"data"][@"merchantId"] IndustryId:self.businessType RegisterStatus:0 Complete:^{
//            if (self.activityService.activityArray.count > 0) {
//                QHWBaseModel *activityModel = [[QHWBaseModel alloc] configModelIdentifier:@"ActivityTableViewCell" Height:225 Data:@[self.activityService.activityArray]];
//                activityModel.headerTitle = @"最新活动";
//                activityModel.showMoreBtn = YES;
//                [self.tableViewDataArray insertObject:activityModel atIndex:1];
//            }
//            complete(YES);
//        }];
        complete(YES);
    } failure:^(NSError *error) {
        complete(NO);
    }];
}

- (void)handleDetailModelData {
    self.headerViewHeight = 220;
    self.detailModel.brandInfo = BrandModel.new;
    if (self.detailModel.brandInfo) {
        QHWBaseModel *brandModel = [[QHWBaseModel alloc] configModelIdentifier:@"BrandTableViewCell" Height:95 Data:@[@[self.detailModel.brandInfo, @(NO)]]];
        brandModel.headerTitle = @"品牌方";
        [self.tableViewDataArray addObject:brandModel];
    }
    if (self.detailModel.distributionStatus == 2) {
        NSString *commissionStr = self.detailModel.commissionRate ?: @"";
        NSString *ruleStr = self.detailModel.distributionRules ?: @"";
        if (commissionStr.length > 0 || ruleStr.length > 0) {
            CGFloat commissionHeight = [commissionStr getHeightWithFont:kFontTheme13 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)];
            CGFloat ruleHeight = [ruleStr getHeightWithFont:kFontTheme13 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)];
            QHWBaseModel *recommendModel = [[QHWBaseModel alloc] configModelIdentifier:@"MainBusinessRulesTableViewCell"
                                                                                Height:106+MAX(commissionHeight, ruleHeight)
                                                                                  Data:@[@[@{@"content": commissionStr, @"height": @(commissionHeight)},@{@"content": ruleStr, @"height": @(ruleHeight)}, self.detailModel]]];
            recommendModel.headerTitle = @"推荐成交";
            [self.tableViewDataArray addObject:recommendModel];
        }
        
        if (self.detailModel.distributionManual.length > 0) {
            QHWBaseModel *fileModel = [[QHWBaseModel alloc] configModelIdentifier:@"MainBusinessFileTableViewCell" Height:75 Data:@[@[self.detailModel.distributionManual]]];
            fileModel.headerTitle = @"项目资料";
            [self.tableViewDataArray addObject:fileModel];
        }
    }
    CGFloat collectionViewHeight=0;
    switch (self.businessType) {
        case 1:
        {
            QHWHouseModel *houseModel = (QHWHouseModel *)self.detailModel;
            collectionViewHeight = 73*3+2;
            [self handleHouseDetailCellData:houseModel];
            NSString *ssss = kFormat(@"%@·%@", houseModel.countryName, houseModel.cityName);
            self.headerViewHeight += 15 + MAX(16, [ssss getHeightWithFont:kFontTheme12 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
        }
            break;
        
        case 2:
        {
            QHWStudyModel *studyModel = (QHWStudyModel *)self.detailModel;
            collectionViewHeight += 73*3+2;
            [self handleStudyDetailCellData:studyModel];
        }
            break;
        
        case 3:
        {
            QHWMigrationModel *migrationModel = (QHWMigrationModel *)self.detailModel;
            collectionViewHeight += 73*2+1.5;
            NSString *nameString = kFormat(@"%@+%@", migrationModel.migrationItem, migrationModel.name);
            self.headerViewHeight += 15 + MAX(25, [nameString getHeightWithFont:kFontTheme16 constrainedToSize:CGSizeMake(kScreenW-60, CGFLOAT_MAX)]);
            [self handleMigrationDetailCellData:migrationModel];
        }
            break;
        
        case 4:
        {
            QHWStudentModel *studentModel = (QHWStudentModel *)self.detailModel;
            collectionViewHeight = 73*ceil(studentModel.groupList.count/3.0)+1+(ceil(studentModel.groupList.count/3.0)-1)*0.5;
            [self handleStudentDetailCellData:studentModel];
        }
            break;
        
        case 102001:
        {
            QHWTreatmentModel *treatmentModel = (QHWTreatmentModel *)self.detailModel;
            collectionViewHeight += 73+1;
            [self handleTreatmentDetailCellData:treatmentModel];
            self.headerViewHeight += 15 + MAX(16, [treatmentModel.subtitle getHeightWithFont:kFontTheme12 constrainedToSize:CGSizeMake(kScreenW-30, CGFLOAT_MAX)]);
            if (treatmentModel.labelList.count > 0) {
                self.headerViewHeight += 10+16;
            }
        }
            break;
            
        default:
            break;
    }
    if (self.businessType != 3) {
        self.headerViewHeight += 15 + MAX(25, [self.detailModel.name getHeightWithFont:kFontTheme16 constrainedToSize:CGSizeMake(kScreenW-60, CGFLOAT_MAX)]);
    }
    self.headerViewHeight += 15 + 30;
    self.headerViewHeight += 15 + collectionViewHeight;
    for (QHWBaseModel *baseModel in self.tableViewDataArray) {
        [self.tabDataArray addObject:baseModel.headerTitle];
    }
}

- (void)handleHouseDetailCellData:(QHWHouseModel *)houseModel {
    QHWBaseModel *introModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": houseModel.intro ?: @"", @"identifier": @"ProjectIntro"}]];
    introModel.headerTitle = @"项目简介";
    introModel.footerTitle = @"咨询楼盘更多信息";
    [self.tableViewDataArray addObject:introModel];
    
    
    NSMutableArray *tempArray = NSMutableArray.array;
    NSDictionary *educationDic = @{@"img": @"config_education", @"title": @"教育", @"content": houseModel.educationDescription ?: @"", @"identifier": @"Education"};
    QHWBaseModel *tempEduModel = [[QHWBaseModel alloc] configModelIdentifier:@"Education" Height:100 Data:educationDic];
    [tempArray addObject:tempEduModel];
    NSDictionary *shoppingDic = @{@"img": @"config_shopping", @"title": @"购物", @"content": houseModel.shoppingDescription ?: @"", @"identifier": @"Shopping"};
    QHWBaseModel *tempShoModel = [[QHWBaseModel alloc] configModelIdentifier:@"Shopping" Height:100 Data:shoppingDic];
    [tempArray addObject:tempShoModel];
    NSDictionary *relaxDic = @{@"img": @"config_relax", @"title": @"休闲", @"content": houseModel.relaxationRecreation ?: @"", @"identifier": @"Relax"};
    QHWBaseModel *tempRelModel = [[QHWBaseModel alloc] configModelIdentifier:@"Relax" Height:100 Data:relaxDic];
    [tempArray addObject:tempRelModel];
    NSDictionary *trafficDic = @{@"img": @"config_traffic", @"title": @"交通", @"content": houseModel.trafficDescription ?: @"", @"identifier": @"Traffic"};
    QHWBaseModel *tempTraModel = [[QHWBaseModel alloc] configModelIdentifier:@"Traffic" Height:100 Data:trafficDic];
    [tempArray addObject:tempTraModel];
    NSDictionary *medicalDic = @{@"img": @"config_hospital", @"title": @"医疗", @"content": houseModel.medicalDescription ?: @"", @"identifier": @"Medical"};
    QHWBaseModel *tempMedModel = [[QHWBaseModel alloc] configModelIdentifier:@"Medical" Height:100 Data:medicalDic];
    [tempArray addObject:tempMedModel];
    
    QHWBaseModel *facilityModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextWithTitleTableViewCell" Height:100 Data:tempArray];
    facilityModel.headerTitle = @"周边设施";
    facilityModel.footerTitle = @"咨询配套学区情况";
    [self.tableViewDataArray addObject:facilityModel];
    
    
    NSDictionary *airDic = @{@"img": @"house_aircondition", @"title": @"空调设施", @"data": houseModel.airConditionerConfigList ?: @[]};
    NSDictionary *kitchenDic = @{@"img": @"house_kitchen", @"title": @"厨房配置", @"data": houseModel.kitchenConfigList ?: @[]};
    NSDictionary *bathRoomDic = @{@"img": @"house_bathroom", @"title": @"卫浴配置", @"data": houseModel.bathroomConfigList ?: @[]};
    NSDictionary *parkingDic = @{@"img": @"house_parking", @"title": @"停车场", @"data": houseModel.parkConfigList ?: @[]};
    NSDictionary *gardenDic = @{@"img": @"house_garden", @"title": @"花园配置", @"data": houseModel.gardenConfigList ?: @[]};
    QHWBaseModel *propertyFeeModel = [[QHWBaseModel alloc] configModelIdentifier:@"HouseDetailConfigTableViewCell" Height:[self getHouseConfigHeight:houseModel] Data:@[@[airDic, kitchenDic, bathRoomDic, parkingDic, gardenDic]]];
    propertyFeeModel.headerTitle = @"物业配套";
    propertyFeeModel.footerTitle = @"咨询物业费用情况";
    [self.tableViewDataArray addObject:propertyFeeModel];
    
    
//    QHWBaseModel *likeHouseModel = [[QHWBaseModel alloc] configModelIdentifier:@"QHWHouseTableViewCell" Height:110 Data:houseModel.alikeList];
//    likeHouseModel.headerTitle = @"相似房源";
//    [self.tableViewDataArray addObject:likeHouseModel];
}

- (void)handleStudyDetailCellData:(QHWStudyModel *)studyModel {
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in studyModel.tripDescribeList) {
        NSDictionary *temDic = @{@"title": kFormat(@"%@ | %@", dic[@"timeNode"], dic[@"title"]), @"content": dic[@"content"] ?: @"", @"identifier": dic[@"id"]};
        QHWBaseModel *tempModel = [[QHWBaseModel alloc] configModelIdentifier:dic[@"id"] Height:100 Data:temDic];
        [tempArray addObject:tempModel];
    }
    QHWBaseModel *tripDetailModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextWithTitleTableViewCell" Height:100 Data:tempArray];
    tripDetailModel.headerTitle = @"详细行程";
    tripDetailModel.footerTitle = @"获取行程单";
    [self.tableViewDataArray addObject:tripDetailModel];
    
    QHWBaseModel *feeModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": studyModel.costDescribe ?: @"", @"identifier": @"FeeDescribe"}]];
    feeModel.headerTitle = @"费用说明";
    feeModel.footerTitle = @"获取优惠折扣";
    [self.tableViewDataArray addObject:feeModel];
    
    QHWBaseModel *tripPlanModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": studyModel.tripReady ?: @"", @"identifier": @"TripPlan"}]];
    tripPlanModel.headerTitle = @"行前准备";
    tripPlanModel.footerTitle = @"获取准备手册";
    [self.tableViewDataArray addObject:tripPlanModel];
    
    QHWBaseModel *questionModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": studyModel.commonProblem ?: @"", @"identifier": @"StudyQuestion"}]];
    questionModel.headerTitle = @"常见问题";
    questionModel.footerTitle = @"我要提问";
    [self.tableViewDataArray addObject:questionModel];
}

- (void)handleMigrationDetailCellData:(QHWMigrationModel *)migrationModel {
    QHWBaseModel *introModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": migrationModel.projectDescribe ?: @"", @"identifier": @"ProjectIntro"}]];
    introModel.headerTitle = @"项目简介";
    introModel.footerTitle = @"咨询项目更多信息";
    [self.tableViewDataArray addObject:introModel];
    
    QHWBaseModel *projectFeatureModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": migrationModel.projectFeature ?: @"", @"identifier": @"ProjectFeature"}]];
    projectFeatureModel.headerTitle = @"项目优势";
    projectFeatureModel.footerTitle = @"咨询更多优势";
    [self.tableViewDataArray addObject:projectFeatureModel];
    
    QHWBaseModel *applyConditionModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": migrationModel.applyCondition ?: @"", @"identifier": @"ApplyCondition"}]];
    applyConditionModel.headerTitle = @"申请条件";
    applyConditionModel.footerTitle = @"咨询是否满足条件";
    [self.tableViewDataArray addObject:applyConditionModel];
    
    QHWBaseModel *applyProcessModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": migrationModel.applyProcess ?: @"", @"identifier": @"ApplyProcess"}]];
    applyProcessModel.headerTitle = @"申请流程";
    [self.tableViewDataArray addObject:applyProcessModel];
    
    QHWBaseModel *feeModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": migrationModel.costDescribe ?: @"", @"identifier": @"Fee"}]];
    feeModel.headerTitle = @"费用详情";
    feeModel.footerTitle = @"获取减免优惠";
    [self.tableViewDataArray addObject:feeModel];
    
    QHWBaseModel *companyFeatureModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": migrationModel.companyFeature ?: @"", @"identifier": @"CompanyFeature"}]];
    companyFeatureModel.headerTitle = @"公司优势";
    [self.tableViewDataArray addObject:companyFeatureModel];
}

- (void)handleStudentDetailCellData:(QHWStudentModel *)studentModel {
    QHWBaseModel *serviceIntroModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": studentModel.serviceContent ?: @"", @"identifier": @"ServiceIntro"}]];
    serviceIntroModel.headerTitle = @"服务介绍";
    serviceIntroModel.footerTitle = @"查询更多信息";
    [self.tableViewDataArray addObject:serviceIntroModel];
    
    QHWBaseModel *feeDetailModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": studentModel.costDescribe ?: @"", @"identifier": @"FeeDetail"}]];
    feeDetailModel.headerTitle = @"费用明细";
    feeDetailModel.footerTitle = @"获取优惠折扣";
    [self.tableViewDataArray addObject:feeDetailModel];
    
    QHWBaseModel *serviceCaseModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": studentModel.successCase ?: @"", @"identifier": @"ServiceCase"}]];
    serviceCaseModel.headerTitle = @"服务案例";
    serviceCaseModel.footerTitle = @"获取案例资料";
    [self.tableViewDataArray addObject:serviceCaseModel];
    
    QHWBaseModel *serviceProcessModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": studentModel.serviceProcess ?: @"", @"identifier": @"ServiceProcess"}]];
    serviceProcessModel.headerTitle = @"服务流程";
    [self.tableViewDataArray addObject:serviceProcessModel];
    
    QHWBaseModel *questionModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": studentModel.commonProblem ?: @"", @"identifier": @"StudentQuestion"}]];
    questionModel.headerTitle = @"常见问题";
    questionModel.footerTitle = @"我要提问";
    [self.tableViewDataArray addObject:questionModel];
}

- (void)handleTreatmentDetailCellData:(QHWTreatmentModel *)treatmentModel {
    QHWBaseModel *consultantModel = [[QHWBaseModel alloc] configModelIdentifier:@"ConsultantTableCell" Height:140 Data:treatmentModel.consultantList];
    consultantModel.headerTitle = @"医疗顾问";
    [self.tableViewDataArray addObject:consultantModel];
    
    QHWBaseModel *goodsContentModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": treatmentModel.goodsContent ?: @"", @"identifier": @"GoodsContent"}]];
    goodsContentModel.headerTitle = @"商品内容";
    [self.tableViewDataArray addObject:goodsContentModel];
    
    QHWBaseModel *successCaseModel = [[QHWBaseModel alloc] configModelIdentifier:@"RichTextTableViewCell" Height:100 Data:@[@{@"data": treatmentModel.successCase ?: @"", @"identifier": @"SuccessCase"}]];
    successCaseModel.headerTitle = @"成功案例";
    [self.tableViewDataArray addObject:successCaseModel];
}

- (CGFloat)getHouseConfigHeight:(QHWHouseModel *)model {
    CGFloat height = 62*5;
    if (model.airConditionerConfigList.count > 0) {
        NSInteger row = ceil(model.airConditionerConfigList.count/3.0);
        height += row*20 + (row-1)*30 + 30;
    }
    if (model.kitchenConfigList.count > 0) {
        NSInteger row = ceil(model.kitchenConfigList.count/3.0);
        height += row*20 + (row-1)*30 + 30;
    }
    if (model.bathroomConfigList.count > 0) {
        NSInteger row = ceil(model.bathroomConfigList.count/3.0);
        height += row*20 + (row-1)*30 + 30;
    }
    if (model.parkConfigList.count > 0) {
        NSInteger row = ceil(model.parkConfigList.count/3.0);
        height += row*20 + (row-1)*30 + 30;
    }
    if (model.gardenConfigList.count > 0) {
        NSInteger row = ceil(model.gardenConfigList.count/3.0);
        height += row*20 + (row-1)*30 + 30;
    }
    return height;
}

- (QHWSystemService *)activityService {
    if (!_activityService) {
        _activityService = QHWSystemService.new;
    }
    return _activityService;
}

- (NSMutableArray *)tabDataArray {
    if (!_tabDataArray) {
        _tabDataArray = NSMutableArray.array;
    }
    return _tabDataArray;
}

@end
