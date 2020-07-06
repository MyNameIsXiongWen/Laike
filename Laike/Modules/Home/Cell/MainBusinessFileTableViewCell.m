//
//  MainBusinessFileTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MainBusinessFileTableViewCell.h"
#import "PDFDetailViewController.h"

@interface MainBusinessFileTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, QHWBaseCellProtocol>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MainBusinessFileTableViewCell

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
            make.edges.equalTo(self.contentView);
        }];
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
    if (indexPath.item < self.dataArray.count) {
        FileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(FileCollectionViewCell.class) forIndexPath:indexPath];
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.titleLabel.text = dic[@"fileName"];
        return cell;
    }
    return UICollectionViewCell.new;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataArray.count) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        PDFDetailViewController *vc = PDFDetailViewController.new;
        vc.filePath = dic[@"filePath"];
        [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake(165, 65);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:layout Object:self];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:FileCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(FileCollectionViewCell.class)];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end

@implementation FileCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.bottom.right.mas_equalTo(-8);
            make.width.mas_equalTo(30);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.right.equalTo(self.typeImgView.mas_left).offset(-8);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorTheme000);
        [self.shadowView addSubview:_titleLabel];
    }
    return _titleLabel;
} 

- (UIImageView *)typeImgView {
    if (!_typeImgView) {
        _typeImgView = UIImageView.ivInit().ivImage(kImageMake(@"home_screen"));
        [self.shadowView addSubview:_typeImgView];
    }
    return _typeImgView;
}

@end
