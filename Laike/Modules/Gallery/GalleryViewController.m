//
//  GalleryViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryService.h"
#import "QHWImageViewCell.h"

@interface GalleryViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) GalleryService *galleryService;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"霸屏海报";
    [self getFilterDataRequest];
}

- (void)getMainData {
    NSString *code = @"0";
    if (self.selectedIndex > 0) {
        FilterCellModel *cellModel = self.galleryService.filterArray[self.selectedIndex];
        code = cellModel.code;
    }
    [self.galleryService getGalleryListWithType:code Complete:^{
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.collectionView PageModel:self.galleryService.itemPageModel];
        [self.collectionView showNodataView:self.galleryService.tableViewDataArray.count == 0 offsetY:0 button:nil];
    }];
}

- (void)getFilterDataRequest {
    [self.galleryService getGalleryFilterDataWithComplete:^{
        [self.tableView reloadData];
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.galleryService.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.font = kFontTheme14;
    cell.textLabel.width = tableView.width;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row == self.selectedIndex) {
        cell.textLabel.textColor = kColorTheme2a303c;
        cell.textLabel.font = kMediumFontTheme12;
        cell.contentView.backgroundColor = kColorThemefff;
    } else {
        cell.textLabel.textColor = kColorTheme666;
        cell.textLabel.font = kFontTheme12;
        cell.contentView.backgroundColor = kColorThemef5f5f5;
    }
    FilterCellModel *cellModel = self.galleryService.filterArray[indexPath.row];
    cell.textLabel.text = cellModel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.selectedIndex) {
        self.selectedIndex = indexPath.row;
        self.galleryService.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
        [tableView reloadData];
    }
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.galleryService.tableViewDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class) forIndexPath:indexPath];
    GalleryModel *model = (GalleryModel *)self.galleryService.tableViewDataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.imgPath)]];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithRecognizeSimultaneouslyFrame:CGRectMake(0, kTopBarHeight, 80, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.backgroundColor = kColorThemef5f5f5;
        _tableView.rowHeight = 40;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = floor((kScreenW-110)/2.0);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, width*1.5);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [UICreateView initWithFrame:CGRectMake(self.tableView.right, kTopBarHeight, kScreenW-self.tableView.right, kScreenH-kTopBarHeight) Layout:flowLayout Object:self];
        [_collectionView registerClass:QHWImageViewCell.class forCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_collectionView RefreshBlock:^{
            self.galleryService.itemPageModel.pagination.currentPage = 1;
            [self getMainData];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_collectionView RefreshBlock:^{
            self.galleryService.itemPageModel.pagination.currentPage++;
            [self getMainData];
        }];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


- (GalleryService *)galleryService {
    if (!_galleryService) {
        _galleryService = GalleryService.new;
    }
    return _galleryService;
}

@end