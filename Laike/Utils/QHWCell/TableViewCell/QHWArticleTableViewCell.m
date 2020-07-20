//
//  QHWArticleTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/13.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWArticleTableViewCell.h"
#import "QHWImageViewCell.h"
#import "QHWImageModel.h"
#import "QHWCellBottomShareView.h"
#import "QHWShareView.h"

#define itemWidth (kScreenW-30-10)/3
@interface QHWArticleTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) UILabel *articleTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *articleIssuerLabel;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UICollectionView *collectionView;//图片
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) QHWCellBottomShareView *shareView;

///动态类型 取值范围：1-多图动态 2-少图动态 3-纯文字动态
@property (nonatomic, assign) ArticleType articleType;

@end

@implementation QHWArticleTableViewCell

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
        
    }
    return self;
}

- (void)setType:(ArticleType)articleType introduction:(NSString *)introduction {
    self.articleType = articleType;
    self.articleTitleLabel.height = self.articleModel.titleHeight;
    if (articleType == ArticleTypeImage) {
        self.articleTitleLabel.width = kScreenW-30;
        self.collectionView.frame = CGRectMake(15, self.articleTitleLabel.bottom+15, kScreenW-30, itemWidth);
        self.collectionView.hidden = NO;
        self.headImgView.y = self.collectionView.bottom + 15;
    } else if (articleType == ArticleTypeBoth) {
        self.articleTitleLabel.width = kScreenW-150;
        self.collectionView.frame = CGRectMake(kScreenW-120, self.articleTitleLabel.y, 105, 70);
        self.collectionView.hidden = NO;
        self.headImgView.bottom = self.collectionView.bottom;
    } else if (articleType == ArticleTypeText){
        self.articleTitleLabel.width = kScreenW-30;
        self.collectionView.hidden = YES;
        self.headImgView.y = self.articleTitleLabel.bottom + 15;
    }
    self.articleIssuerLabel.centerY = self.headImgView.centerY;
    self.shareView.y = self.headImgView.bottom + 10;
    self.lineView.y = self.shareView.bottom+8;
}

- (void)setArticleModel:(QHWCommunityArticleModel *)articleModel {
    _articleModel = articleModel;
    NSInteger type;
    if (articleModel.coverPathList.count > 2) {
        type = ArticleTypeImage;
    } else if (articleModel.coverPathList.count == 0) {
        type = ArticleTypeText;
    } else {
        type = ArticleTypeBoth;
    }
    [self setType:type introduction:articleModel.articleDescribe];
    
    self.articleTitleLabel.text = articleModel.name;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(articleModel.merchantHead)] placeholderImage:kPlaceHolderImage_Avatar];
    self.articleIssuerLabel.text = kFormat(@"%@ · %@", articleModel.merchantName, articleModel.createTime);
}

#pragma mark ------------UICollectionView-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.articleModel.coverPathList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.articleModel.coverPathList.count > 2) {
        return CGSizeMake(itemWidth, itemWidth);
    } else if (self.articleModel.coverPathList.count == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(105, 70);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class) forIndexPath:indexPath];
    if (indexPath.row < self.articleModel.coverPathList.count) {
        id imgObject = self.articleModel.coverPathList[indexPath.row];
        if ([imgObject isKindOfClass:NSString.class]) {
            NSString *imgSrc = (NSString *)imgObject;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgSrc] placeholderImage:kPlaceHolderImage_Banner];
        } else if ([imgObject isKindOfClass:QHWImageModel.class]) {
            QHWImageModel *imgModel = (QHWImageModel *)imgObject;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgModel.imageSrc] placeholderImage:kPlaceHolderImage_Banner];
        } else if ([imgObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *imgDic = (NSDictionary *)imgObject;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(imgDic[@"path"])] placeholderImage:kPlaceHolderImage_Banner];
        }
        cell.imgView.layer.cornerRadius = 5;
    }
    return cell;
}

#pragma mark ------------UI-------------
- (UILabel *)articleTitleLabel {
    if (!_articleTitleLabel) {
        _articleTitleLabel = UILabel.labelFrame(CGRectMake(15, 15, kScreenW-30, 20)).labelFont([UIFont systemFontOfSize:15 weight:UIFontWeightMedium]).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self.contentView addSubview:_articleTitleLabel];
    }
    return _articleTitleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [UICreateView initWithFrame:CGRectMake(15, 15, kScreenW-30, 70) Layout:layout Object:self];
        [_collectionView registerClass:QHWImageViewCell.class forCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class)];
        _collectionView.scrollEnabled = NO;
        _collectionView.userInteractionEnabled = NO;
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = UIImageView.ivFrame(CGRectMake(15, 0, 16, 16)).ivCornerRadius(8).ivBorderColor(kColorThemeeee);
        [self.contentView addSubview:_headImgView];
    }
    return _headImgView;
}

- (UILabel *)articleIssuerLabel {
    if (!_articleIssuerLabel) {
        _articleIssuerLabel = UILabel.labelFrame(CGRectMake(self.headImgView.right + 10, 10, kScreenW-150, 17)).labelFont(kFontTheme11).labelTitleColor(kColorTheme9399a5);
        _articleIssuerLabel.numberOfLines = 0;
        [self.contentView addSubview:_articleIssuerLabel];
    }
    return _articleIssuerLabel;
}

- (QHWCellBottomShareView *)shareView {
    if (!_shareView) {
        _shareView = [[QHWCellBottomShareView alloc] initWithFrame:CGRectMake(0, self.headImgView.bottom+10, kScreenW, 22)];
        WEAKSELF
        _shareView.clickShareBlock = ^{
            QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":weakSelf.articleModel, @"shareType": @(ShareTypeArticle)}];
            [shareView show];
        };
        [self.contentView addSubview:_shareView];
    }
    return _shareView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UICreateView initWithFrame:CGRectMake(15, self.shareView.bottom+8, kScreenW-30, 0.5) BackgroundColor:kColorThemeeee CornerRadius:0];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

@end
