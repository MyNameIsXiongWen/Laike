//
//  CommunityDetailRecommendTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityDetailRecommendTableViewCell.h"
#import "CommunityDetailService.h"
#import "CTMediator+ViewController.h"

@interface CommunityDetailRecommendTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CommunityDetailRecommendTableViewCell

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
        [self.contentView addSubview:UILabel.labelFrame(CGRectMake(15, 0, kScreenW-30, 60)).labelText(@"为您推荐").labelTitleColor(kColorTheme2a303c).labelFont(kMediumFontTheme18)];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.mas_equalTo(60);
        }];
    }
    return self;
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RecommendCollectionViewCell.class) forIndexPath:indexPath];
    BusinessListModel *model = self.dataArray[indexPath.row];
    [cell.bkgImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.coverPath)]];
    cell.titleLabel.text = model.name;
    cell.priceLabel.text = kFormat(@"¥%@万起", [NSString formatterWithMoneyValue:model.price]);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BusinessListModel *model = self.dataArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:model.businessType BusinessId:model.businessId];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(250, 200);
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 15, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:layout Object:self];
        [_collectionView registerClass:RecommendCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(RecommendCollectionViewCell.class)];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end

@implementation RecommendCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kColorThemef5f5f5;
        self.cornerRadius(5);
        [self.bkgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(140);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.bkgImgView.mas_bottom).offset(5);
        }];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-5);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UIImageView *)bkgImgView {
    if (!_bkgImgView) {
        _bkgImgView = UIImageView.ivInit().ivBkgColor(kColorThemeeee);
        [self.contentView addSubview:_bkgImgView];
    }
    return _bkgImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(2);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = UILabel.labelInit().labelTitleColor(kColorThemefb4d56).labelFont(kFontTheme13);
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

@end
