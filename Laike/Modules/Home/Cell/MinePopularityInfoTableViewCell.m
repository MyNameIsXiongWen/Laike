//
//  MinePopularityInfoTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MinePopularityInfoTableViewCell.h"
#import "QHWTableSectionHeaderView.h"

@interface MinePopularityInfoTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, QHWBaseCellProtocol>

@property (nonatomic, strong) QHWTableSectionHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MinePopularityInfoTableViewCell

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
        self.contentView.backgroundColor = self.backgroundColor = UIColor.clearColor;
        [self.shadowView addSubview:self.headerView];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.dataArray = (NSArray *)data;
    [self.collectionView reloadData];
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePopularitySubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HomePopularitySubCollectionViewCell.class) forIndexPath:indexPath];
    [cell.consultantImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(kImageLogo)]];
    cell.consultantNameLabel.text = @"戴维数";
    cell.consultantCountLabel.text = @"223";
//    QHWConsultantModel *model = self.dataArray[indexPath.row];
//    [cell.consultantImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)] placeholderImage:kPlaceHolderImage_Avatar];
//    cell.consultantNameLabel.text = model.name;
//    WEAKSELF
//    cell.clickConsultBlock = ^{
//        [QHWSystemService showLabelAlertViewWithTitle:@"预约咨询" Img:@"" MerchantId:weakSelf.merchantId IndustryId:14 BusinessId:weakSelf.merchantId DescribeCode:6 PositionCode:8];
//    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    QHWConsultantModel *model = self.dataArray[indexPath.row];
//    [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:model.id UserType:2 BusinessType:self.businessType];
}

#pragma mark ------------UI-------------
- (QHWTableSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QHWTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, 55)];
        _headerView.titleLabel.text = @"人气王";
        _headerView.moreBtn.hidden = NO;
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake((kScreenW-30)/3, 80);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, self.headerView.bottom, kScreenW-30, 80) Layout:layout Object:self];
        [_collectionView registerClass:HomePopularitySubCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(HomePopularitySubCollectionViewCell.class)];
        [self.shadowView addSubview:_collectionView];
    }
    return _collectionView;
}

@end

@implementation HomePopularitySubCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.consultantImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.size.mas_offset(CGSizeMake(40, 40));
            make.centerX.equalTo(self.contentView);
        }];
        [self.consultantNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.consultantImgView.mas_bottom).offset(3);
            make.left.right.mas_offset(0);
        }];
        [self.consultantCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.consultantNameLabel.mas_bottom).offset(2);
            make.left.right.mas_offset(0);
        }];
    }
    return self;
}

- (void)clickConsultBtn {
    if (self.clickConsultBlock) {
        self.clickConsultBlock();
    }
}

#pragma mark ------------UI-------------
- (UIImageView *)consultantImgView {
    if (!_consultantImgView) {
        _consultantImgView = UIImageView.ivInit().ivCornerRadius(20).ivMode(UIViewContentModeScaleAspectFit);
        [self.contentView addSubview:_consultantImgView];
    }
    return _consultantImgView;
}

- (UILabel *)consultantNameLabel {
    if (!_consultantNameLabel) {
        _consultantNameLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme13).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:_consultantNameLabel];
    }
    return _consultantNameLabel;
}

- (UILabel *)consultantCountLabel {
    if (!_consultantCountLabel) {
        _consultantCountLabel = UILabel.labelInit().labelTitleColor(kColorTheme999).labelFont(kFontTheme11).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:_consultantCountLabel];
    }
    return _consultantCountLabel;
}

@end
