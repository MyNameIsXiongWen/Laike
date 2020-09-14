//
//  ChatGifView.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "ChatGifView.h"

@interface ChatGifView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *allFaceModelArray;
@property (nonatomic, assign) int currentFaceModelIndex;

@end

@implementation ChatGifView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.gifCollectionView];
//        [self addSubview:self.pageControl];
        [self addSubview:self.menuView];
        UIView *line1 = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemef5f5f5);
        [self addSubview:line1];
        UIView *line2 = UIView.viewFrame(CGRectMake(20, self.height-35.5, kScreenW-40, 0.5)).bkgColor(kColorThemeeee);
        [self addSubview:line2];
        self.currentFaceModelIndex = 0;
    }
    return self;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self gifViewReloadWithScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self gifViewReloadWithScrollView:scrollView];
}

- (void)gifViewReloadWithScrollView:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x/kScreenW;
    int count = 0;
    int currentMenuIndex = 0;//当前menu索引（切换表情样式）
    int currentGifIndex = 0;//当前gif索引（当前menu表情下的当前页）
    for (LZFaceModel *face in self.data) {
        face.faceSelected = NO;
    }
    for (int i=0; i<self.data.count; i++) {
        LZFaceModel *faceModel = self.data[i];
        currentGifIndex = index-count;
        count += faceModel.listArray.count;
        if (index < count) {
            currentMenuIndex = i;
            faceModel.faceSelected = YES;
            break;
        }
    }
    [self.menuView.menuCollectionView reloadData];
    if (self.currentFaceModelIndex != currentMenuIndex) {
        self.currentFaceModelIndex = currentMenuIndex;
//        LZFaceModel *faceModel = self.data[currentMenuIndex];
//        self.pageControl.numberOfPages = faceModel.listArray.count;
    }
//    self.pageControl.currentPage = currentGifIndex;
//    [self.pageControl.collectionView reloadData];
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.allFaceModelArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.allFaceModelArray[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class) forIndexPath:indexPath];
    cell.imgView.backgroundColor = UIColor.clearColor;
    NSArray *array = self.allFaceModelArray[indexPath.section];
    LZFaceImgModel *faceImgModel = array[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:faceImgModel.imageSrc]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.allFaceModelArray[indexPath.section];
    LZFaceImgModel *faceImgModel = array[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(gifView:didSelectGif:)]) {
        [_delegate gifView:self didSelectGif:faceImgModel];
    }
}

#pragma mark ------------UI-------------
- (UICollectionView *)gifCollectionView {
    if (!_gifCollectionView) {
        CGFloat space = (kScreenW-240-40)/3;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 25;
        flowLayout.minimumLineSpacing = space;
        flowLayout.sectionInset = UIEdgeInsetsMake(30, 20, 30, 20);
        flowLayout.itemSize = CGSizeMake(60, 60);
        
        _gifCollectionView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, self.height-45) Layout:flowLayout Object:self];
        _gifCollectionView.pagingEnabled = YES;
        _gifCollectionView.alwaysBounceHorizontal = YES;
        [_gifCollectionView registerClass:[QHWImageViewCell class] forCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class)];
    }
    return _gifCollectionView;
}

//- (HouseDetailPageControl *)pageControl{
//    if (!_pageControl) {
//        _pageControl = [[HouseDetailPageControl alloc] initWithFrame:CGRectMake(0, 195, kScreenW, 4)];
//        LZFaceModel *faceModel = self.data.firstObject;
//        _pageControl.numberOfPages = faceModel.listArray.count;
//    }
//    return _pageControl;
//}

- (ChatGifMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[ChatGifMenuView alloc] initWithFrame:CGRectMake(0, self.height-35, kScreenW, 35)];
        _menuView.dataArray = self.data;
        WEAKSELF
        _menuView.selectFaceBlock = ^(NSInteger index) {
            int count = 0;
            for (int i=0; i<weakSelf.data.count; i++) {
                LZFaceModel *faceModel = weakSelf.data[i];
                if (i < index) {
                    count += faceModel.listArray.count;
                } else if (i == index) {
                    [weakSelf.gifCollectionView setContentOffset:CGPointMake(count*kScreenW, 0)];
                    [weakSelf gifViewReloadWithScrollView:weakSelf.gifCollectionView];
                    break;
                }
            }
        };
    }
    return _menuView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = NSMutableArray.array;
        NSArray *array = [NSArray yy_modelArrayWithClass:LZFaceModel.class json:[kUserDefault objectForKey:@""]];
        for (int i=0; i<array.count; i++) {
            LZFaceModel *faceModel = array[i];
            NSMutableArray *tempArray = NSMutableArray.array;
            for (int j=0; j<faceModel.list.count; j++) {
                LZFaceImgModel *imgModel = faceModel.list[j];
                [tempArray addObject:imgModel];
                if (tempArray.count % 8 == 0 || j == faceModel.list.count-1) {
                    if (tempArray.count > 0) {
                        [faceModel.listArray addObject:tempArray];
                        [self.allFaceModelArray addObject:tempArray];
                        tempArray = NSMutableArray.array;
                    }
                }
            }
            [_data addObject:faceModel];
        }
        if (_data.count > 0) {
            LZFaceModel *faceModel = _data.firstObject;
            faceModel.faceSelected = YES;
        }
    }
    return _data;
}

- (NSMutableArray *)allFaceModelArray {
    if (!_allFaceModelArray) {
        _allFaceModelArray = NSMutableArray.array;
    }
    return _allFaceModelArray;
}

@end


@interface ChatGifMenuView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ChatGifMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.menuCollectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatGifMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ChatGifMenuCell.class) forIndexPath:indexPath];
    LZFaceModel *faceModel = self.dataArray[indexPath.row];
    [cell.menuImgView sd_setImageWithURL:[NSURL URLWithString:faceModel.typeImage]];
    cell.menuImgView.backgroundColor = faceModel.faceSelected ? kColorThemeeee : UIColor.clearColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (LZFaceModel *face in self.dataArray) {
        face.faceSelected = NO;
    }
    LZFaceModel *faceModel = self.dataArray[indexPath.row];
    faceModel.faceSelected = YES;
    if (self.selectFaceBlock) {
        self.selectFaceBlock(indexPath.row);
    }
    [collectionView reloadData];
}

#pragma mark ------------UI-------------
- (UICollectionView *)menuCollectionView {
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
        flowLayout.itemSize = CGSizeMake(40, 25);
        
        _menuCollectionView = [UICreateView initWithFrame:self.bounds Layout:flowLayout Object:self];
        _menuCollectionView.alwaysBounceHorizontal = YES;
        [_menuCollectionView registerClass:[ChatGifMenuCell class] forCellWithReuseIdentifier:NSStringFromClass(ChatGifMenuCell.class)];
    }
    return _menuCollectionView;
}

@end

@implementation ChatGifMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.menuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.mas_equalTo(-15);
        }];
        UIView *line = UIView.viewFrame(CGRectMake(39.5, 0, 0.5, 25)).bkgColor(kColorThemef5f5f5);
        [self.contentView addSubview:line];
    }
    return self;
}

- (UIImageView *)menuImgView {
    if (!_menuImgView) {
        _menuImgView = [UICreateView initWithFrame:CGRectZero ImageUrl:@"" Image:kImageMake(@"") ContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:_menuImgView];
    }
    return _menuImgView;
}

@end
