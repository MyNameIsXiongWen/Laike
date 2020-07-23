//
//  QHWPageControl.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/25.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWPageControl.h"

@interface QHWPageControl ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end
@implementation QHWPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentPage = 0;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    self.collectionView.width = [self pageControlWidth];
    self.collectionView.left = (self.width - [self pageControlWidth])/2;
    [self.collectionView reloadData];
}

#pragma mark ------------UICollectionView DataSource-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    if (indexPath.item < self.numberOfPages && self.currentPage < self.numberOfPages) {
        cell.contentView.layer.cornerRadius = 2;
        cell.contentView.layer.masksToBounds = YES;
        if (indexPath.item == self.currentPage) {
            cell.contentView.backgroundColor = kColorTheme21a8ff;
        } else {
            cell.contentView.backgroundColor = kColorTheme2a303c;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(indexPath.item == self.currentPage? 13 : 4, 4);
}


// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [UICreateView initWithFrame:CGRectMake((self.width - [self pageControlWidth])/2, 0, [self pageControlWidth], 4) Layout:layout Object:self];
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
    }
    return _collectionView;
}

- (CGFloat)pageControlWidth{
    CGFloat width = 0;
    if (self.numberOfPages > 1) {
        width = 13 +(self.numberOfPages - 1)*9;
    }
    return width;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
