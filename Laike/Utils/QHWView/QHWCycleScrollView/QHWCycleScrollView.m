//
//  QHWCycleScrollView.h
//  MyProject
//
//  Created by xiaobu on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWCycleScrollView.h"
#import "QHWImageViewCell.h"
#import "QHWCycleScrollViewFlowLayout.h"
#import "QHWBannerModel.h"

@interface QHWCycleScrollView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) QHWCycleScrollViewFlowLayout *flowLayout;
@property (nonatomic,assign) NSInteger totalItems;//item总数
@property (nonatomic,assign) NSUInteger lastpage;//上页

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) QHWPageControl *pageControl;
@property (nonatomic,strong) UILabel *pageLabel;

@end

@implementation QHWCycleScrollView {
    float _oldPoint;
    NSInteger _dragDirection;
}

#pragma mark ------------life cycle-------------
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageGroups:(NSArray *)imageGroups {
    QHWCycleScrollView *cycleScrollView = [[QHWCycleScrollView alloc] initWithFrame:frame];
    cycleScrollView.infiniteLoop = infiniteLoop;
    cycleScrollView.imgArray = imageGroups;
    return cycleScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self addSubview:self.pageLabel];
    }
    return self;
}

- (void)initialization {
    //初始化
    _infiniteLoop = YES;
    _autoScroll = YES;
    _isZoom = NO;
    _itemWidth = self.width;
    _itemSpace = 10;
    _imgCornerRadius = 0;
    _autoScrollTimeInterval = 5;
    self.pageControl.hidden = NO;
    self.pageLabel.hidden = YES;
}

- (CGFloat )defaultSpace {
    return (kScreenW - self.itemWidth)/2;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.flowLayout.minimumLineSpacing = self.itemSpace;
    if (self.collectionView.contentOffset.x == 0 && _totalItems > 0) {
        if (_totalItems <= 1) {
            self.collectionView.x = self.betweenGap;
            return;
        }
        else {
            self.collectionView.x = 0;
        }
        NSInteger targeIndex = 0;
        if(self.infiniteLoop){//无线循环
            // 如果是无限循环，应该默认把 collection 的 item 滑动到 中间位置。
            // 注意：此处 totalItems 的数值，其实是图片数组数量的 100 倍。
            // 乘以 0.5 ，正好是取得中间位置的 item 。图片也恰好是图片数组里面的第 0 个。
            targeIndex = _totalItems * 0.5;
        }
        else {
            targeIndex = 0;
        }
        //设置图片默认位置
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targeIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self.collectionView setContentOffset:CGPointMake(targeIndex*(self.itemSpace+self.itemWidth), 0) animated:NO];
        _oldPoint = self.collectionView.contentOffset.x;
    }
}

#pragma mark ------------UIScrollViewDelegate-------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imgArray.count) return; // 解决清除timer时偶尔会出现的问题
    NSInteger currentPage = [self currentIndex] % self.imgArray.count;
    self.pageControl.currentPage = currentPage;
    [self.pageControl.collectionView reloadData];
    self.pageLabel.text = kFormat(@"%ld/%ld", currentPage+1, self.imgArray.count);
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollToIndex:)]) {
        [self.delegate cycleScrollView:self scrollToIndex:currentPage];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldPoint = scrollView.contentOffset.x;
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imgArray.count) return; // 解决清除timer时偶尔会出现的问题
}

//手离开屏幕的时候
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //判断滑动速度
    if (velocity.x > 0) {
        _dragDirection = 1;
    }
    else if (velocity.x < 0){
        _dragDirection = -1;
    }
    else{
        _dragDirection = 0;
    }
}

// 松开手指滑动开始减速的时候，设置滑动动画
- (void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView {
    if (self.infiniteLoop) {
        _oldPoint = scrollView.contentOffset.x;
        NSInteger currentPage = [self currentIndex];
        if (currentPage == self.lastpage) {
            currentPage += _dragDirection;
        }
        if (currentPage < _totalItems) {
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [self.collectionView setContentOffset:CGPointMake(currentPage*(self.itemSpace+self.itemWidth), 0) animated:YES];
            self.lastpage = currentPage;
            _dragDirection = 0;
        }
    }
}

- (void)adjustWhenControllerViewWillAppear {
    [self scrollViewWillBeginDecelerating:self.collectionView];
}

- (float)nextPointCurrentPoint:(int)shouldPage {
    return (shouldPage+1)/2*self.itemWidth+self.itemSpace;
}

- (float)lastPointCurrentPoint:(int)shouldPage {
    shouldPage = -shouldPage;
    return -(shouldPage+1)/2*self.itemWidth-self.itemSpace;
}

#pragma mark ------------UICollectionView Datasource-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class) forIndexPath:indexPath];
    long itemIndex = (int) indexPath.item % self.imgArray.count;
    id object = self.imgArray[itemIndex];
    if ([object isKindOfClass:QHWBannerModel.class]) {
        QHWBannerModel *banner = (QHWBannerModel *)object;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(banner.advertPath)] placeholderImage:kPlaceHolderImage_Banner];
    } else if ([object isKindOfClass:NSDictionary.class]) {
        NSDictionary *fileDic = (NSDictionary *)object;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(fileDic[@"path"])] placeholderImage:kPlaceHolderImage_Banner];
    } else if ([object isKindOfClass:UIImage.class]) {
        UIImage *image = (UIImage *)object;
        cell.imgView.image = image;
        cell.playImageView.hidden = NO;
    } else if ([object isKindOfClass:NSString.class]) {
        NSString *imagePath = (NSString *)object;
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:kPlaceHolderImage_Banner];
        } else {
            cell.imgView.image = kImageMake(imagePath);
        }
    }
    cell.imgView.layer.cornerRadius = self.imgCornerRadius;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = (int) indexPath.item % self.imgArray.count;
    id object = self.imgArray[itemIndex];
    if ([object isKindOfClass:QHWBannerModel.class]) {
        QHWBannerModel *banner = (QHWBannerModel *)object;
        [banner setBannerTapAction];
    }
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self currentIndex] % self.imgArray.count];
    }
}

#pragma mark ------------private-------------
- (void)setupTimer {
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)automaticScroll {
    if(self.totalItems == 0) return;
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (NSInteger)currentIndex {
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0)
        return 0;
    
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//水平滑动
        index = (self.collectionView.contentOffset.x + (self.itemWidth + self.itemSpace) * 0.5) / (self.itemSpace + self.itemWidth);
    }
    else {
        index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5)/ self.flowLayout.itemSize.height;
    }
    return MAX(0,index);
}

- (NSInteger)getCurrentAbsoluteIndex {
    if (self.imgArray.count > 0) {
        return [self currentIndex] % self.imgArray.count;
    }
    return 0;
}

- (void)scrollToIndex:(NSInteger)index {
    if(index >= self.totalItems) {//滑到最后则调到中间
        if(self.infiniteLoop) {
            index = self.totalItems * 0.5;
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            [self.collectionView setContentOffset:CGPointMake(index*(self.itemSpace+self.itemWidth), 0) animated:YES];
        }
        return;
    }
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView setContentOffset:CGPointMake(index*(self.itemSpace+self.itemWidth), 0) animated:YES];
}

#pragma mark ------------setter or getter-------------
- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, self.height);
}

- (void)setItemSpace:(CGFloat)itemSpace {
    _itemSpace = itemSpace;
    self.flowLayout.minimumLineSpacing = itemSpace;
}

- (void)setBetweenGap:(CGFloat)betweenGap {
    _betweenGap = betweenGap;
    self.itemWidth = self.width - betweenGap * 2;
    self.flowLayout.itemSize = CGSizeMake(self.itemWidth, self.height);
}

-(void)setIsZoom:(BOOL)isZoom {
    _isZoom = isZoom;
    self.flowLayout.isZoom = isZoom;
}

-(void)setImgArray:(NSArray *)imgArray {
    _imgArray = imgArray;
    self.pageControl.numberOfPages = imgArray.count;
    self.pageLabel.text = kFormat(@"1/%ld", imgArray.count);
    //如果循环则1000倍，
    if(imgArray.count > 1) {
        _totalItems = self.infiniteLoop ? imgArray.count * 1000 : imgArray.count;
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        _totalItems = imgArray.count;
        //不循环
        self.collectionView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    [self.collectionView reloadData];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    //创建之前，停止定时器
    [self invalidateTimer];
    if (autoScroll) {
        [self setupTimer];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self.collectionView setContentOffset:CGPointMake(selectIndex*(self.itemSpace+self.itemWidth), 0) animated:YES];
}

- (void)setPageControlLabel:(BOOL)pageControlLabel {
    _pageControlLabel = pageControlLabel;
    self.pageControl.hidden = YES;
    self.pageLabel.hidden = NO;
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        _collectionView = [UICreateView initWithFrame:self.bounds Layout:self.flowLayout Object:self];
        _collectionView.scrollsToTop = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:QHWImageViewCell.class forCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class)];
    }
    return _collectionView;
}

- (QHWCycleScrollViewFlowLayout *)flowLayout {
    if(!_flowLayout) {
        _flowLayout = [[QHWCycleScrollViewFlowLayout alloc]init];
        _flowLayout.isZoom = self.isZoom;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.itemSize = CGSizeMake(_itemWidth, self.height);
    }
    return _flowLayout;
}

- (QHWPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[QHWPageControl alloc] initWithFrame:CGRectMake(0, self.height-14, self.width, 4)];
    }
    return _pageControl;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = UILabel.labelFrame(CGRectMake(self.width-50, self.height-35, 50, 25)).labelFont(kFontTheme11).labelTitleColor(kColorThemefff).labelTextAlignment(NSTextAlignmentCenter).labelBkgColor([UIColor colorWithWhite:0 alpha:0.3]);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 50, 25) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft cornerRadii:CGSizeMake(12.5, 12.5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = CGRectMake(0, 0, 50, 25);
        maskLayer.path = maskPath.CGPath;
        _pageLabel.layer.mask = maskLayer;
    }
    return _pageLabel;
}

@end
