//
//  CRMTopOperationView.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMTopOperationView.h"
#import "CTMediator+ViewController.h"
#import "QHWShareView.h"
#import "UserModel.h"

@interface CRMTopOperationView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) OperationCollectionSubView *leftOperationView;
@property (nonatomic, strong) OperationCollectionSubView *rightOperationView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CRMTopOperationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
//        self.leftOperationView = [[OperationCollectionSubView alloc] initWithFrame:CGRectMake(0, 0, self.width/2, 70)];
//        [self addSubview:self.leftOperationView];
//        
//        self.rightOperationView = [[OperationCollectionSubView alloc] initWithFrame:CGRectMake(self.leftOperationView.right, 0, self.leftOperationView.width, 70)];
//        [self addSubview:self.rightOperationView];
//        
//        [self addSubview:UIView.viewFrame(CGRectMake(self.leftOperationView.right, 10, 0.5, 50)).bkgColor(kColorThemeeee)];
//        
//        self.cornerRadius(10).bkgColor(kColorThemefff);
////        [self addShadowWithRadius:10 Opacity:0.2];
//        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowOpacity = 0.5;
//        self.layer.shadowRadius = 10;
//        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setDataArray:(NSArray<TopOperationModel *> *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
//    NSDictionary *leftDic = dataArray.firstObject;
//    NSDictionary *rightDic = dataArray.lastObject;
//    self.leftOperationView.dataDic = leftDic;
//    self.rightOperationView.dataDic = rightDic;
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OperationCollectionSubView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(OperationCollectionSubView.class) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TopOperationModel *model = self.dataArray[indexPath.row];
    [CTMediator.sharedInstance performTarget:self action:kFormat(@"click_%@", model.identifier) params:nil];
}

//公司产品
- (void)click_home_product {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"CompanyProductViewController").new animated:YES];
}

//发海外圈
- (void)click_community_content {
//    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"CommunityPublishViewController").new animated:YES];
    [CTMediator.sharedInstance CTMediator_viewControllerForCommunity];
}

//名片
- (void)click_home_card {
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":UserModel.shareUser, @"shareType": @(ShareTypeConsultant)}];
    [shareView show];
}

//客户进度
- (void)click_customerProcess {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"DistributionClientViewController").new animated:YES];
}

//报备客户
- (void)click_bookAppointment {
    [CTMediator.sharedInstance CTMediator_viewControllerForBookAppointmentWithBusinessId:@"" BusinessName:@"" BusinessType:0];
}

//分享海报
- (void)click_home_gallery {
    [CTMediator.sharedInstance CTMediator_viewControllerForGallery];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kScreenW-30)/2, 70);
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionView = [UICreateView initWithFrame:self.bounds Layout:layout Object:self];
        [_collectionView registerClass:OperationCollectionSubView.class forCellWithReuseIdentifier:NSStringFromClass(OperationCollectionSubView.class)];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

@end

@implementation OperationCollectionSubView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.borderColor(kColorThemeeee).cornerRadius(5);
        self.logoImgView = UIImageView.ivFrame(CGRectMake(20, 15, 40, 40));
        [self.contentView addSubview:self.logoImgView];
        
        self.titleLabel = UILabel.labelFrame(CGRectMake(self.logoImgView.right+10, 17, self.width-65, 20)).labelTitleColor(kColorTheme000).labelFont(kFontTheme14);
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitleLabel = UILabel.labelFrame(CGRectMake(self.titleLabel.left, self.titleLabel.bottom, self.width-65, 17)).labelTitleColor(kColorTheme999).labelFont(kFontTheme12);
        [self.contentView addSubview:self.subTitleLabel];
    }
    return self;
}

- (void)setModel:(TopOperationModel *)model {
    _model = model;
    self.logoImgView.image = kImageMake(model.logo);
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
}

@end

@implementation TopOperationModel

+ (instancetype)initialWithLogo:(NSString *)logo Title:(NSString *)title SubTitle:(NSString *)subTitle Identifier:(NSString *)identifier {
    TopOperationModel *model = TopOperationModel.new;
    model.logo = logo;
    model.title = title;
    model.subTitle = subTitle;
    model.identifier = identifier;
    return model;
}

@end
