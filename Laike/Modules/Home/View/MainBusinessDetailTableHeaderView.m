//
//  MainBusinessDetailTableHeaderView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/26.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MainBusinessDetailTableHeaderView.h"
#import "QHWHouseModel.h"
#import "QHWStudyModel.h"
#import "QHWMigrationModel.h"
#import "QHWStudentModel.h"
#import "QHWTreatmentModel.h"
#import "QHWSystemService.h"

@interface MainBusinessDetailTableHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *paramsArray;
@property (nonatomic, strong) NSArray *paramsKeyArray;

@end

@implementation MainBusinessDetailTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(220);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-45);
            make.top.equalTo(self.cycleScrollView.mas_bottom).offset(15);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.mas_equalTo(kScreenW-31);
            make.height.mas_equalTo(73*3+2);
            make.bottom.mas_equalTo(-15);
        }];
        [self.discountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-15);
        }];
//        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(15);
//            make.bottom.equalTo(self.discountView.mas_top).offset(-15);
//        }];
//        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.left.equalTo(self.descLabel.mas_right).offset(5);
//            make.right.mas_equalTo(-15);
//            make.height.mas_equalTo(16);
//            make.bottom.equalTo(self.discountView.mas_top).offset(-15);
//        }];
    }
    return self;
}

- (void)setDetailModel:(QHWMainBusinessDetailBaseModel *)detailModel {
    _detailModel = detailModel;
    [self handleParamsDataWithModel:detailModel];
}

- (void)handleParamsDataWithModel:(QHWMainBusinessDetailBaseModel *)detailModel {
    [self.paramsArray removeAllObjects];
    NSArray *valueArray;
    CGFloat width=0, height=0;
    self.nameLabel.text = detailModel.name;
    switch (self.businessType) {
        case 1:
        {
            QHWHouseModel *houseModel = (QHWHouseModel *)detailModel;
            valueArray = @[kFormat(@"¥%@万", [NSString formatterWithMoneyValue:houseModel.totalPrice]),
                           houseModel.houseTypeName ?: @"",
                           kFormat(@"%@-%@m²", [NSString formatterWithValue:houseModel.areaMin], [NSString formatterWithValue:houseModel.areaMax]),
                           kFormat(@"%@%%", [NSString formatterWithValue:houseModel.firstPaymentRate]),
                           houseModel.propertyYearsName ?: @"",
                           kFormat(@"%@%%", houseModel.yearReturnRate),
                           houseModel.deliveryTime ?: @"",
                           houseModel.deliveryStandardName ?: @"",
                           houseModel.houseTypeName ?: @""];
            self.descLabel.text = kFormat(@"%@·%@", houseModel.countryName, houseModel.cityName);
            [self.tagView setTagWithTagArray:houseModel.labelList];
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.bottom.equalTo(self.discountView.mas_top).offset(-15);
            }];
            [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.descLabel.mas_right).offset(5);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(16);
                make.bottom.equalTo(self.discountView.mas_top).offset(-15);
            }];
            width = floor((kScreenW-31)/3.0)*3+1;
            height = 73*3+2;
        }
            break;
        
        case 2:
        {
            QHWStudyModel *studyModel = (QHWStudyModel *)detailModel;
            valueArray = @[studyModel.studyThemeName ?: @"",
                           kFormat(@"%ld天", (long)studyModel.tripCycle),
                           studyModel.studyCountryName ?: @"",
                           kFormat(@"¥%@万", [NSString formatterWithMoneyValue:studyModel.serviceFee]),
                           studyModel.departureCityName ?: @"",
                           studyModel.studentObjectName ?: @"",
                           kFormat(@"%ld-%ld岁", studyModel.ageMin, studyModel.ageMax),
                           kFormat(@"%@-%@", studyModel.tripStartDate, studyModel.tripEndDate),
                           studyModel.entryEndDate ?: @""];
            width = floor((kScreenW-31)/3.0)*3+1;
            height = 73*3+2;
        }
            break;
        
        case 3:
        {
            QHWMigrationModel *migrationModel = (QHWMigrationModel *)detailModel;
            valueArray = @[migrationModel.dentityTypeName ?: @"",
                           migrationModel.handleCycle ?: @"",
                           kFormat(@"¥%@万", [NSString formatterWithMoneyValue:migrationModel.serviceFee]),
                           migrationModel.residencyRequirement ?: @""];
            width = floor((kScreenW-31)/2.0)*2+1;
            height = 73*2+1.5;
            self.nameLabel.text = kFormat(@"%@+%@", migrationModel.migrationItem, migrationModel.name);
        }
            break;
        
        case 4:
        {
            QHWStudentModel *studentModel = (QHWStudentModel *)detailModel;
//            valueArray = @[studentModel.educationString ?: @"",
//                           kFormat(@"%ld个月", (long)studentModel.applyCycle),
//                           studentModel.countryName ?: @"",
//                           kFormat(@"¥%@万", [NSString formatterWithMoneyValue:studentModel.serviceFee]),
//                           studentModel.feesModeName ?: @"",
//                           studentModel.feesStatusName ?: @""];
            width = floor((kScreenW-31)/3.0)*3+1;
            height = 73*ceil(studentModel.groupList.count/3.0)+1+(ceil(studentModel.groupList.count/3.0)-1)*0.5;
            [studentModel.groupList enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.paramsArray addObject:@{@"paramsKey": obj[@"key"], @"paramsValue": obj[@"value"]}];
            }];
        }
            break;
            
        case 102001:
        {
            QHWTreatmentModel *treatmentModel = (QHWTreatmentModel *)detailModel;
            valueArray = @[treatmentModel.treatmentTypeList.firstObject[@"name"] ?: @"",
                           treatmentModel.countryName ?: @"",
                           kFormat(@"¥%@万", [NSString formatterWithMoneyValue:treatmentModel.serviceFee])];
            self.descLabel.text = treatmentModel.subtitle;
            [self.tagView setTagWithTagArray:treatmentModel.labelList];
            if (treatmentModel.labelList.count > 0) {
                [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.right.mas_equalTo(-15);
                    make.height.mas_equalTo(16);
                    make.bottom.equalTo(self.discountView.mas_top).offset(-15);
                }];
                [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.right.mas_equalTo(-15);
                    make.bottom.equalTo(self.tagView.mas_top).offset(-10);
                }];
            } else {
                [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.right.mas_equalTo(-15);
                    make.bottom.equalTo(self.discountView.mas_top).offset(-15);
                }];
            }
            
            width = floor((kScreenW-31)/3.0)*3+1;
            height = 73+1;
        }
            break;
            
        default:
            break;
    }
    self.cycleScrollView.imgArray = detailModel.bannerList;
    self.discountView.discountNameLabel.text = detailModel.discounts;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    if (self.businessType != 4) {
        [self.paramsKeyArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.paramsArray addObject:@{@"paramsKey": obj, @"paramsValue": valueArray[idx]}];
        }];
    }
    [self.collectionView reloadData];
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.paramsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.paramsArray[indexPath.row];
    ParamInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ParamInfoCollectionCell.class) forIndexPath:indexPath];
    cell.paramKeyLabel.text = dic[@"paramsKey"];
    cell.paramValueLabel.text = dic[@"paramsValue"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.businessType == 3) {
        return CGSizeMake(floor((kScreenW-31)/2.0), 73);
    }
    return CGSizeMake(floor((kScreenW-31)/3.0), 73);
}

#pragma mark ------------Action-------------
- (void)clickCollectBtn:(UIButton *)btn {
    NSInteger collectStatus = self.detailModel.collectionStatus == 1 ? 2 : 1;
    [QHWSystemService.new clickCollectRequestWithBusinessType:self.businessType BusinessId:self.detailModel.id CollectionStatus:collectStatus Complete:^(BOOL status) {
        if (status) {
            self.detailModel.collectionStatus = collectStatus;
            btn.selected = (collectStatus == 2);
        }
    }];
}


#pragma mark ------------UI-------------
- (QHWCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[QHWCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 220)];
        _cycleScrollView.itemSpace = 0;
        _cycleScrollView.pageControlLabel = YES;
        [self addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme16).labelNumberOfLines(0);
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12).labelNumberOfLines(0);
        [self addSubview:_descLabel];
    }
    return _descLabel;
}

- (QHWTagView *)tagView {
    if (!_tagView) {
        _tagView = [[QHWTagView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagView];
    }
    return _tagView;
}

- (DiscountView *)discountView {
    if (!_discountView) {
        _discountView = [[DiscountView alloc] initWithFrame:CGRectZero];
        [self addSubview:_discountView];
    }
    return _discountView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        layout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0.5, 0);
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:layout Object:self];
        _collectionView.backgroundColor = kColorThemeeee;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:ParamInfoCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(ParamInfoCollectionCell.class)];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray *)paramsArray {
    if (!_paramsArray) {
        _paramsArray = NSMutableArray.array;
    }
    return _paramsArray;
}

- (NSArray *)paramsKeyArray {
    if (!_paramsKeyArray) {
        switch (self.businessType) {
            case 1:
                _paramsKeyArray = @[@"总价", @"户型", @"面积", @"首付", @"产权", @"平均年回报率", @"交房时间", @"交房标准", @"物业类型"];
                break;
            
            case 2:
                _paramsKeyArray = @[@"游学主题", @"行程天数", @"游学国家/城市", @"费用价格", @"出发城市", @"招生对象率", @"年龄要求", @"行程时间", @"出发日期"];
                break;
            
            case 3:
                _paramsKeyArray = @[@"身份类型", @"办理周期", @"办理费用", @"居住要求"];
                break;
            
            case 4:
                _paramsKeyArray = @[@"学历阶段", @"办理周期", @"申请国家", @"服务费用", @"付款方式", @"第三方费用"];
                break;
                
            case 102001:
                _paramsKeyArray = @[@"医疗类型", @"目标国家", @"价格"];
                break;
                
            default:
                break;
        }
    }
    return _paramsKeyArray;
}

@end

@implementation DiscountView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.discountLabel = UILabel.labelFrame((CGRectMake(15, 7, 16, 16))).labelTitleColor(kColorThemefff).labelText(@"惠").labelBkgColor(kColorThemefb4d56).labelCornerRadius(2).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:self.discountLabel];
        self.discountNameLabel = UILabel.labelFrame((CGRectMake(self.discountLabel.right+10, 7, kScreenW-70, 16))).labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme12);
        [self addSubview:self.discountNameLabel];
//        self.getDiscountBtn = UIButton.btnFrame(CGRectMake(kScreenW-75, 0, 60, 30)).btnFont(kFontTheme12).btnBkgColor(kColorThemefb4d56).btnTitleColor(kColorThemefff).btnTitle(@"免费领取").btnCornerRadius(15).btnAction(self, @selector(clickGetDiscountBtn));
//        [self addSubview:self.getDiscountBtn];
    }
    return self;
}

- (void)clickGetDiscountBtn {
    if (self.clickBtnBlock) {
        self.clickBtnBlock();
    }
}

@end

@implementation ParamInfoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kColorThemefff;
        self.paramKeyLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:self.paramKeyLabel];
        self.paramValueLabel = UILabel.labelInit().labelFont([UIFont systemFontOfSize:16 weight:UIFontWeightMedium]).labelTitleColor(kColorThemefb4d56).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:self.paramValueLabel];
    }
    [self.paramKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(15);
    }];
    [self.paramValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
    }];
    return self;
}

@end
