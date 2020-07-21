//
//  HomeIconTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeIconTableViewCell.h"
#import "QHWBannerModel.h"
#import "CTMediator+ViewController.h"
#import "QHWShareView.h"
#import "UserModel.h"

@interface HomeIconTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, QHWBaseCellProtocol>

@property (nonatomic, strong, readwrite) UICollectionView *collectionView;

@end

@implementation HomeIconTableViewCell

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
    self.btnArray = (NSArray *)data;
    [self.collectionView reloadData];
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.btnArray.count) {
        BtnViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(BtnViewCell.class) forIndexPath:indexPath];
        QHWBannerModel *model = self.btnArray[indexPath.row];
        if ([model.icon containsString:@"http"]) {
            [cell.btnImgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:kPlaceHolderImage_Banner];
        } else {
            cell.btnImgView.image = kImageMake(model.icon);
        }
        cell.btnTitleLabel.text = model.name;
        return cell;
    }
    return UICollectionViewCell.new;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.btnArray.count) {
        QHWBannerModel *model = self.btnArray[indexPath.row];
        [CTMediator.sharedInstance performTarget:self action:kFormat(@"click_%@", model.icon) params:nil];
    }
}

- (void)click_home_news {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"CommunityArticleViewController").new animated:YES];
}

- (void)click_home_activity {
    if (UserModel.shareUser.bindStatus == 2) {
        [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
        return;
    }
    [CTMediator.sharedInstance CTMediator_viewControllerForActivityList];
}

- (void)click_home_live {
    if (UserModel.shareUser.bindStatus == 2) {
        [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
        return;
    }
    [CTMediator.sharedInstance CTMediator_viewControllerForLive];
}

- (void)click_home_screen {
    [CTMediator.sharedInstance CTMediator_viewControllerForGallery];
}

- (void)click_home_article {
    [CTMediator.sharedInstance CTMediator_viewControllerForCommunity];
}

- (void)click_home_card {
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":UserModel.shareUser, @"shareType": @(ShareTypeConsultant)}];
    [shareView show];
}

- (void)click_home_rate {
    [CTMediator.sharedInstance CTMediator_viewControllerForRate];
}

- (void)click_home_school {
    [CTMediator.sharedInstance CTMediator_viewControllerForQSchool];
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
        layout.itemSize = CGSizeMake((kScreenW-30)/4, 55);
        
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:layout Object:self];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:BtnViewCell.class forCellWithReuseIdentifier:NSStringFromClass(BtnViewCell.class)];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end

@implementation BtnViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.btnImgView = UIImageView.ivFrame(CGRectMake(((kScreenW-30)/4-30)/2, 0, 30, 30));
        [self.contentView addSubview:self.btnImgView];
        
        self.btnTitleLabel = UILabel.labelFrame(CGRectMake(0, self.btnImgView.bottom+8, self.width, 17)).labelFont(kFontTheme14).labelTitleColor(kColorTheme000).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:self.btnTitleLabel];
    }
    return self;
}

@end
