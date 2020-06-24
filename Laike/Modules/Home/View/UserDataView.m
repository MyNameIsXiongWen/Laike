//
//  UserDataView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/29.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "UserDataView.h"

@interface UserDataView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation UserDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        self.collectionView = [UICreateView initWithFrame:self.bounds Layout:layout Object:self];
        self.collectionView.backgroundColor = UIColor.clearColor;
        [self.collectionView registerClass:UserDataCell.class forCellWithReuseIdentifier:NSStringFromClass(UserDataCell.class)];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floor(self.width/self.dataArray.count), self.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UserDataCell.class) forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.countLabel.text = kFormat(@"%@", dic[@"value"]);
    cell.nameLabel.text = dic[@"title"];
    if (self.countColor) {
        cell.countLabel.textColor = self.countColor;
    }
    if (self.nameColor) {
        cell.nameLabel.textColor = self.nameColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectedItemBlock) {
        self.didSelectedItemBlock(indexPath.row);
    }
}

@end

@implementation UserDataCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.countLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kMediumFontTheme14).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:self.countLabel];
        
        self.nameLabel = UILabel.labelInit().labelTitleColor(kColorTheme9399a5).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:self.nameLabel];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

@end
