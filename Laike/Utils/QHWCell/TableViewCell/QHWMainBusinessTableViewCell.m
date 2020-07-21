//
//  QHWMainBusinessTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWMainBusinessTableViewCell.h"
#import "QHWHouseModel.h"
#import "QHWStudyModel.h"
#import "QHWStudentModel.h"
#import "QHWMigrationModel.h"
#import "QHWTreatmentModel.h"
#import "QHWShareView.h"

@interface QHWMainBusinessTableViewCell ()

@property (nonatomic, strong) QHWMainBusinessDetailBaseModel *detailModel;

@end

@implementation QHWMainBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.houseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(120, 80));
        }];
        [self.houseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.houseImgView.mas_right).offset(10);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.houseImgView.mas_top);
        }];
        [self.houseSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.houseTitleLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.houseTitleLabel.mas_bottom).offset(5);
        }];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.houseTitleLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(16);
            make.top.equalTo(self.houseSubTitleLabel.mas_bottom).offset(5);
        }];
        [self.houseMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.houseTitleLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.bottom.equalTo(self.houseImgView.mas_bottom);
        }];
        [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(22);
            make.top.equalTo(self.houseImgView.mas_bottom).offset(19);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(0.5);
        }];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.houseImgView);
            make.height.mas_equalTo(25);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    QHWMainBusinessDetailBaseModel *model = (QHWMainBusinessDetailBaseModel *)data;
    self.detailModel = model;
    [self.houseImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.coverPath)] placeholderImage:kPlaceHolderImage_Banner];
    self.houseTitleLabel.text = model.name;
    switch (model.businessType) {
        case 1:
        {
            QHWHouseModel *houseModel = (QHWHouseModel *)model;
            self.houseSubTitleLabel.text = kFormat(@"%@-%@㎡", [NSString formatterWithValue:houseModel.areaMin], [NSString formatterWithValue:houseModel.areaMax]);
            self.houseMoneyLabel.text = kFormat(@"¥ %@万起", [NSString formatterWithMoneyValue:houseModel.totalPrice]);
            self.addressLabel.text = houseModel.countryName;
            [self.tagView setTagWithTagArray:houseModel.labelList];
        }
            break;
        case 2:
        {
            QHWStudyModel *studyModel = (QHWStudyModel *)model;
            self.houseSubTitleLabel.text = kFormat(@"%ld天", studyModel.tripCycle);
            self.houseMoneyLabel.text = kFormat(@"¥ %@万", [NSString formatterWithMoneyValue:studyModel.serviceFee]);
            [self.tagView setTagWithTagArray:@[studyModel.countryName ?: @"", studyModel.studyCityName ?: @"", studyModel.studyThemeName ?: @""]];
        }
            break;
        case 3:
        {
            QHWMigrationModel *migrationModel = (QHWMigrationModel *)model;
            self.houseSubTitleLabel.text = kFormat(@"%@万", [NSString formatterWithMoneyValue:migrationModel.serviceFee]);
            self.houseMoneyLabel.text = kFormat(@"¥ %@万", [NSString formatterWithMoneyValue:migrationModel.investmentQuota]);
            [self.tagView setTagWithTagArray:@[migrationModel.dentityTypeName ?: @"", migrationModel.handleCycle ?: @""]];
        }
            break;
        case 4:
        {
            QHWStudentModel *studentModel = (QHWStudentModel *)model;
            self.houseMoneyLabel.text = kFormat(@"¥ %@万", [NSString formatterWithMoneyValue:studentModel.serviceFee]);
            NSMutableArray *tempArray = NSMutableArray.array;
            for (NSDictionary *dic in studentModel.educationList) {
                [tempArray addObject:dic[@"name"]];
            }
            [self.tagView setTagWithTagArray:tempArray];
        }
            break;
            
        default:
        {
            QHWTreatmentModel *treatmentModel = (QHWTreatmentModel *)model;
            self.houseSubTitleLabel.text = treatmentModel.countryName;
            self.houseMoneyLabel.text = kFormat(@"¥ %@万", [NSString formatterWithMoneyValue:treatmentModel.serviceFee]);
            NSMutableArray *tempArray = NSMutableArray.array;
            for (NSDictionary *dic in treatmentModel.treatmentTypeList) {
                [tempArray addObject:dic[@"name"]];
            }
            [self.tagView setTagWithTagArray:tempArray];
        }
            break;
    }
}

- (UIImageView *)houseImgView {
    if (!_houseImgView) {
        _houseImgView = UIImageView.ivInit().ivCornerRadius(2);
        [self.contentView addSubview:_houseImgView];
    }
    return _houseImgView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = UILabel.labelInit().labelTitleColor(kColorThemefff).labelFont(kFontTheme12).labelBkgColor([UIColor colorWithWhite:0.0 alpha:0.2]).labelTextAlignment(NSTextAlignmentCenter);
        [self.houseImgView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UILabel *)houseTitleLabel {
    if (!_houseTitleLabel) {
        _houseTitleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium]);
        [self.contentView addSubview:_houseTitleLabel];
    }
    return _houseTitleLabel;
}

- (UILabel *)houseSubTitleLabel {
    if (!_houseSubTitleLabel) {
        _houseSubTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12);
        [self.contentView addSubview:_houseSubTitleLabel];
    }
    return _houseSubTitleLabel;
}

- (UILabel *)houseMoneyLabel {
    if (!_houseMoneyLabel) {
        _houseMoneyLabel = UILabel.labelInit().labelTitleColor(kColorThemefb4d56).labelFont(kFontTheme14);
        [self.contentView addSubview:_houseMoneyLabel];
    }
    return _houseMoneyLabel;
}

- (QHWTagView *)tagView {
    if (!_tagView) {
        _tagView = [[QHWTagView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_tagView];
    }
    return _tagView;
}

- (QHWCellBottomShareView *)shareView {
    if (!_shareView) {
        _shareView = [[QHWCellBottomShareView alloc] initWithFrame:CGRectZero];WEAKSELF
        _shareView.clickShareBlock = ^{
//            if (self.isDistribution && UserModel.shareUser.bindStatus == 2) {
//                [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
//                return;
//            }
            QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":weakSelf.detailModel, @"shareType": @(ShareTypeMainBusiness)}];
            [shareView show];
        };
        [self.contentView addSubview:_shareView];
    }
    return _shareView;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end
