//
//  BrandView.m
//  Laike
//
//  Created by xiaobu on 2020/9/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BrandView.h"
#import "BrandModel.h"
#import "CTMediator+ViewController.h"

@interface BrandView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *rightArrowBtn;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BrandView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UIView *bkgView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 45)).viewAction(self, @selector(clickMore));
        [self addSubview:bkgView];
        
        self.titleLabel = UILabel.labelFrame(CGRectMake(10, 5, 70, 40)).labelFont(kMediumFontTheme16).labelTitleColor(kColorTheme000).labelText(@"推荐品牌");
        [self.titleLabel sizeToFit];
        self.titleLabel.height = 40;
        self.descLabel = UILabel.labelFrame(CGRectMake(self.titleLabel.right+10, 5, 200, 40)).labelFont(kFontTheme14).labelTitleColor(kColorTheme999).labelText(@"精选全球优质品牌");
        [self.descLabel sizeToFit];
        self.descLabel.height = 40;
        self.rightArrowBtn = UIButton.btnFrame(CGRectMake(self.descLabel.right+10, 5, kScreenW-self.descLabel.right-20, 40)).btnImage(kImageMake(@"arrow_right_gray"));
        self.rightArrowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.rightArrowBtn.userInteractionEnabled = NO;
        [bkgView addSubview:self.titleLabel];
        [bkgView addSubview:self.descLabel];
        [bkgView addSubview:self.rightArrowBtn];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)clickMore {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"BrandViewController").new animated:YES];
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(BrandCollectionViewCell.class) forIndexPath:indexPath];
    BrandModel *model = self.dataArray[indexPath.row];
    [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.brandLogo)]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BrandModel *model = self.dataArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForBrandDetailWithBrandId:model.id];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(130, 65);
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, 45, kScreenW, 65) Layout:layout Object:self];
        [_collectionView registerClass:BrandCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(BrandCollectionViewCell.class)];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

@end

@implementation BrandCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.borderColor(kColorThemeeee).cornerRadius(10);
        self.logoImgView = UIImageView.ivFrame(self.bounds);
        [self.contentView addSubview:self.logoImgView];
    }
    return self;
}

@end
