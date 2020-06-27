//
//  LiveListViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LiveListViewController.h"
#import "LiveService.h"
#import "LiveDetailViewController.h"
#import "QHWImageViewCell.h"

@interface LiveListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LiveService *service;

@end

@implementation LiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"直播邀约";
    self.view.backgroundColor = kColorThemef5f5f5;
    [self getLiveListRequest];
}

- (void)getLiveListRequest {
    [self.service getLiveListRequestWithComplete:^{
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.collectionView PageModel:self.service.itemPageModel];
        [self.collectionView reloadData];
        [self.collectionView showNodataView:self.service.dataArray.count == 0 offsetY:0 button:nil];
    }];
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.service.dataArray.count-1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenW, 220);
    }
    return CGSizeMake((kScreenW-30)/2.0, 175);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QHWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class) forIndexPath:indexPath];
        LiveModel *model = self.service.dataArray.firstObject;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.coverPath)]];
        return cell;
    } else {
        if (indexPath.item < self.service.dataArray.count-1) {
            LiveCollectionVieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LiveCollectionVieCell.class) forIndexPath:indexPath];
            LiveModel *model = self.service.dataArray[indexPath.item + 1];
            [cell.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.coverPath)]];
            cell.titleLabel.text = model.name;
            cell.liveCountLabel.text = kFormat(@"%ld人次观看", model.browseCount);
            return cell;
        }
    }
    return UICollectionViewCell.new;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LiveModel *model = self.service.dataArray.firstObject;
        [self pushToDetailVCWithModel:model];
    } else {
        if (indexPath.item < self.service.dataArray.count-1) {
            LiveModel *model = self.service.dataArray[indexPath.item + 1];
            [self pushToDetailVCWithModel:model];
        }
    }
}

- (void)clickHeaderView {
    LiveModel *model = self.service.dataArray.firstObject;
    [self pushToDetailVCWithModel:model];
}

- (void)pushToDetailVCWithModel:(LiveModel *)model {
    LiveDetailViewController *detailVC = LiveDetailViewController.new;
    detailVC.liveId = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Layout:layout Object:self];
        [_collectionView registerClass:QHWImageViewCell.class forCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class)];
        [_collectionView registerClass:LiveCollectionVieCell.class forCellWithReuseIdentifier:NSStringFromClass(LiveCollectionVieCell.class)];
        [self.view addSubview:_collectionView];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_collectionView RefreshBlock:^{
            self.service.itemPageModel.pagination.currentPage = 1;
            [self getLiveListRequest];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_collectionView RefreshBlock:^{
            self.service.itemPageModel.pagination.currentPage++;
            [self getLiveListRequest];
        }];
    }
    return _collectionView;
}

- (LiveService *)service {
    if (!_service) {
        _service = LiveService.new;
    }
    return _service;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation LiveCollectionVieCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.cornerRadius(5).bkgColor(kColorThemef5f5f5);
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(90);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.coverImgView.mas_bottom).offset(10);
        }];
        [self.liveCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = UIImageView.ivInit();
        [self.contentView addSubview:_coverImgView];
    }
    return _coverImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kMediumFontTheme16).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(2);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)liveCountLabel {
    if (!_liveCountLabel) {
        _liveCountLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorTheme666);
        [self.contentView addSubview:_liveCountLabel];
    }
    return _liveCountLabel;
}

@end
