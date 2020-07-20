//
//  HouseDetailConfigTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HouseDetailConfigTableViewCell.h"

@interface HouseDetailConfigTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QHWBaseCellProtocol>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation HouseDetailConfigTableViewCell

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
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-20);
        }];
        UIView *line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.bottom.left.right.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.dataArray = data;
    [self.collectionView reloadData];
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataArray[section];
    return [dic[@"data"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ConfigCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ConfigCollectionCell.class) forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.section];
    cell.nameLabel.text = dic[@"data"][indexPath.row][@"name"];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        ConfigCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(ConfigCollectionHeaderView.class) forIndexPath:indexPath];
        NSDictionary *dic = self.dataArray[indexPath.section];
        headerView.nameLabel.text = dic[@"title"];
        headerView.imgView.image = kImageMake(dic[@"img"]);
        return headerView;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
        footerView.backgroundColor = kColorThemeeee;
        return footerView;
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 30;
        layout.minimumLineSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        layout.headerReferenceSize = CGSizeMake(kScreenW-30, 62);
        layout.footerReferenceSize = CGSizeMake(kScreenW-30, 0.5);
        layout.itemSize = CGSizeMake(floor((kScreenW-40-100)/3), 20);
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:layout Object:self];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:ConfigCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(ConfigCollectionCell.class)];
        [_collectionView registerClass:ConfigCollectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(ConfigCollectionHeaderView.class)];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end

@implementation ConfigCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.imgView = UIImageView.ivFrame(CGRectMake(0, 0, 10, 20)).ivImage(kImageMake(@""));
        [self.contentView addSubview:self.imgView];
        self.nameLabel = UILabel.labelInit().labelTitleColor(kColorTheme9399a5).labelFont(kFontTheme14);
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

@end

@implementation ConfigCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.imgView = UIImageView.ivInit().ivImage(kImageMake(@""));
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.width.mas_equalTo(22);
            make.centerY.equalTo(self);
        }];
        self.nameLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme16);
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(0);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
