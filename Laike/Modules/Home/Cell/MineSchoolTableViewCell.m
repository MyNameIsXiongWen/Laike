//
//  MineSchoolTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MineSchoolTableViewCell.h"
#import "QHWTableSectionHeaderView.h"

@interface MineSchoolTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, QHWBaseCellProtocol>

@property (nonatomic, strong) QHWTableSectionHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MineSchoolTableViewCell

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
        [self addSubview:self.headerView];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.dataArray = (NSArray *)data;
    [self.collectionView reloadData];
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(2, self.dataArray.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataArray.count) {
        HomeSchoolSubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HomeSchoolSubCollectionViewCell.class) forIndexPath:indexPath];
        [cell.bkgImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(@"")]];
        cell.titleLabel.text = @"视频的标题，最多显量示两行就可以";
        return cell;
    }
    return UICollectionViewCell.new;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataArray.count) {
//        QHWBannerModel *model = self.btnArray[indexPath.row];
        
    }
}

#pragma mark ------------UI-------------
- (QHWTableSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QHWTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 55)];
        _headerView.titleLabel.text = @"Q大学";
        [_headerView.moreBtn setTitle:@"全部课程" forState:0];
        _headerView.moreBtn.hidden = NO;
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake((kScreenW-40)/2, 160);
        
        _collectionView = [UICreateView initWithFrame:CGRectMake(15, self.headerView.bottom, kScreenW-30, 160) Layout:layout Object:self];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:HomeSchoolSubCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(HomeSchoolSubCollectionViewCell.class)];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end


@implementation HomeSchoolSubCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.bkgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(110);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.bkgImgView.mas_bottom).offset(5);
        }];
    }
    return self;
}

//- (void)setBannerModel:(QHWBannerModel *)bannerModel {
//    _bannerModel = bannerModel;
//    [self.bkgImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(bannerModel.advertPath)] placeholderImage:kPlaceHolderImage_Banner];
//    self.titleLabel.text = bannerModel.title;
//    self.subTitleLabel.text = bannerModel.subtitle;
//}

#pragma mark ------------UI-------------
- (UIImageView *)bkgImgView {
    if (!_bkgImgView) {
        _bkgImgView = UIImageView.ivInit().ivBkgColor(kColorThemeeee).ivCornerRadius(5);
        [self.contentView addSubview:_bkgImgView];
    }
    return _bkgImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kMediumFontTheme16).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(2);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
