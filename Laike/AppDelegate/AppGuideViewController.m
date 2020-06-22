//
//  AppGuideViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/10/7.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "AppGuideViewController.h"
#import "CTMediator+ViewController.h"
#import "QHWImageViewCell.h"
#import "AppDelegate.h"

@interface AppGuideViewController () <UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UIButton *jumpButton;

@end

@implementation AppGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.goButton];
    [self.view addSubview:self.jumpButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int a = scrollView.contentOffset.x/kScreenW;
    self.goButton.hidden = a != (self.imageArray.count-1);
//    self.jumpButton.hidden = a > 0;
}

- (void)clickGoBtn {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = [CTMediator.sharedInstance CTMediator_viewControllerForLogin];
}

#pragma mark ------------UICollectionView-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class) forIndexPath:indexPath];
    cell.imgView.image = kImageMake(self.imageArray[indexPath.row]);
    cell.imgView.contentMode = UIViewContentModeScaleToFill;
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

#pragma mark ------------UI初始化-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(kScreenW, kScreenH+kStatusBarHeight);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, -kStatusBarHeight, kScreenW, kScreenH+kStatusBarHeight) Layout:layout Object:self];
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:QHWImageViewCell.class forCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class)];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UIButton *)jumpButton{
    if (!_jumpButton) {
        _jumpButton = [UICreateView initWithFrame:CGRectMake(kScreenW-100, kStatusBarHeight+30, 80, 30) Title:@"跳过" Image:nil SelectedImage:nil Font:kFontTheme14 TitleColor:UIColor.whiteColor BackgroundColor:kColorTheme2a303c CornerRadius:15];
        [_jumpButton addTarget:self action:@selector(clickGoBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpButton;
}

- (UIButton *)goButton{
    if (!_goButton) {
        _goButton = [UICreateView initWithFrame:CGRectMake(20, kScreenH-kBottomDangerHeight-60, kScreenW-40, 40) Title:@"立即体验" Image:nil SelectedImage:nil Font:kFontTheme18 TitleColor:UIColor.whiteColor BackgroundColor:kColorTheme2a303c CornerRadius:20];
        _goButton.showsTouchWhenHighlighted = NO;
        [_goButton addTarget:self action:@selector(clickGoBtn) forControlEvents:UIControlEventTouchUpInside];
        _goButton.hidden = YES;
    }
    return _goButton;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        if (kStatusBarHeight > 20) {
            _imageArray = @[@"appGuide_xsmax1", @"appGuide_xsmax2", @"appGuide_xsmax3", @"appGuide_xsmax4", @"appGuide_xsmax5"].mutableCopy;
        } else {
            _imageArray = @[@"appGuide_8p1", @"appGuide_8p2", @"appGuide_8p3", @"appGuide_8p4", @"appGuide_8p5"].mutableCopy;
        }
    }
    return _imageArray;
}

@end
