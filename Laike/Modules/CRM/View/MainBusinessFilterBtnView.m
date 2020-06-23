//
//  MainBusinessFilterBtnView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MainBusinessFilterBtnView.h"

@interface MainBusinessFilterBtnView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MainBusinessFilterBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(FilterCollectionViewCell.class) forIndexPath:indexPath];
    FilterBtnViewCellModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.textColor = model.color;
    cell.imgView.image = kImageMake(model.img);
    cell.nameLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterBtnViewCellModel *model = self.dataArray[indexPath.row];
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(model);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenW/self.dataArray.count, 50);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:layout Object:self];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:FilterCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(FilterCollectionViewCell.class)];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIView *)line {
    if (!_line) {
        _line = [UICreateView initWithFrame:CGRectZero BackgroundColor:kColorThemeeee CornerRadius:0];
        [self addSubview:_line];
    }
    return _line;
}

@end

@implementation FilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.nameLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:self.nameLabel];
        
        self.imgView = UIImageView.ivInit();
        [self.contentView addSubview:self.imgView];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.centerX.equalTo(self.contentView.mas_centerX).offset(-12);
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(7, 4));
        }];
    }
    return self;
}

@end
