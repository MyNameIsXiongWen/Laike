//
//  RateKeyBoardView.m
//  Laike
//
//  Created by xiaobu on 2020/6/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RateKeyBoardView.h"

@interface RateKeyBoardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) KeyBoardRightView *rightView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation RateKeyBoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self addSubview:self.rightView];
    }
    return self;
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KeyBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KeyBoardCell.class) forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.row] length] > 0) {
        if (self.clickKeyBoardBlock) {
            self.clickKeyBoardBlock(self.dataArray[indexPath.row]);
        }
    }
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.itemSize = CGSizeMake((self.width-80-10)/3.0, (self.height-10)/4.0);
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 0);
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, 0, self.width-80, self.height) Layout:layout Object:self];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:KeyBoardCell.class forCellWithReuseIdentifier:NSStringFromClass(KeyBoardCell.class)];
    }
    return _collectionView;
}

- (KeyBoardRightView *)rightView {
    if (!_rightView) {
        _rightView = [[KeyBoardRightView alloc] initWithFrame:CGRectMake(self.collectionView.right, 0, 80, self.height)];
    }
    return _rightView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"7", @"8", @"9", @"4", @"5", @"6", @"1", @"2", @"3", @"", @"0", @""];
    }
    return _dataArray;
}

@end

@implementation KeyBoardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.titleLabel = UILabel.labelFrame(self.bounds).labelFont(kMediumFontTheme20).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end

@implementation KeyBoardRightView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.clearBtn = UIButton.btnFrame(CGRectMake(0, 10, self.width-20, (self.height-40)/2)).btnBkgColor(kColorThemef5f5f5).btnTitle(@"AC").btnTitleColor(kColorThemefb4d56).btnFont(kMediumFontTheme20).btnCornerRadius((self.width-20)/2.0).btnAction(self, @selector(clickClearBtn));
        [self addSubview:self.clearBtn];
        
        self.deleteBtn = UIButton.btnFrame(CGRectMake(0, self.clearBtn.bottom+15, self.width-20, self.clearBtn.height)).btnBkgColor(kColorThemef5f5f5).btnTitle(@"<-").btnTitleColor(kColorThemefb4d56).btnFont(kMediumFontTheme20).btnCornerRadius((self.width-20)/2.0).btnAction(self, @selector(clickDeleteBtn));
        [self addSubview:self.deleteBtn];
    }
    return self;
}

- (void)clickClearBtn {
    if (self.clickClearBlock) {
        self.clickClearBlock();
    }
}

- (void)clickDeleteBtn {
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock();
    }
}

@end
