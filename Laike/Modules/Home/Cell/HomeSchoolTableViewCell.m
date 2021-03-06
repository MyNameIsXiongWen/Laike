//
//  HomeSchoolTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeSchoolTableViewCell.h"
#import "QHWTableSectionHeaderView.h"
#import "QHWSchoolModel.h"
#import "CTMediator+ViewController.h"

@interface HomeSchoolTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, QHWBaseCellProtocol>

@property (nonatomic, strong) QHWTableSectionHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HomeSchoolTableViewCell

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
        [self.contentView addSubview:self.headerView];
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
        QHWSchoolModel *model = self.dataArray[indexPath.row];
        [cell.bkgImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.coverPath)]];
        cell.titleLabel.text = model.title;
        cell.playImageView.hidden = model.fileType == 1;
        return cell;
    }
    return UICollectionViewCell.new;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataArray.count) {
        QHWSchoolModel *model = (QHWSchoolModel *)self.dataArray[indexPath.row];
        [CTMediator.sharedInstance CTMediator_viewControllerForQSchoolDetailWithSchoolId:model.id];
    }
}

#pragma mark ------------UI-------------
- (QHWTableSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QHWTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 55)];
        _headerView.titleLabel.text = @"Q大学";
        _headerView.titleLabel.font = kMediumFontTheme24;
        [_headerView.moreBtn setTitle:@"全部课程" forState:0];
        _headerView.moreBtn.hidden = NO;
        _headerView.moreBtn.userInteractionEnabled = NO;
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
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.mas_equalTo(self.bkgImgView);
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

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = UIImageView.ivInit().ivImage(kImageMake(@"video_play"));
        _playImageView.hidden = YES;
        [self.bkgImgView addSubview:_playImageView];
    }
    return _playImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(2);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
