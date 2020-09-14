//
//  ChatMoreView.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "ChatMoreView.h"

@interface ChatMoreView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *data;

@end

@implementation ChatMoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.moreCollectionView];
        UIView *line = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee);
        [self addSubview:line];
    }
    return self;
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatMoreViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ChatMoreViewCell.class) forIndexPath:indexPath];
    NSDictionary *dic = self.data[indexPath.row];
    cell.imgView.image = kImageMake(dic[@"image"]);
    cell.titlaLabel.text = dic[@"title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.data[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(moreView:didSelectMoreCell:)]) {
        [_delegate moreView:self didSelectMoreCell:dic[@"image"]];
    }
}

#pragma mark ------------UI-------------
- (UICollectionView *)moreCollectionView {
    if (!_moreCollectionView) {
        CGFloat margin = (kScreenW-240-75)/2;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 25;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        flowLayout.itemSize = CGSizeMake(60, 102);
        
        _moreCollectionView = [UICreateView initWithFrame:self.bounds Layout:flowLayout Object:self];
        _moreCollectionView.backgroundColor = kColorThemef5f5f5;
        [_moreCollectionView registerClass:[ChatMoreViewCell class] forCellWithReuseIdentifier:NSStringFromClass(ChatMoreViewCell.class)];
    }
    return _moreCollectionView;
}

- (NSArray *)data {
    if (!_data) {
        _data = @[
//        @{@"image": @"chat_scheme", @"title": @"案例"},
//                  @{@"image": @"chat_evaluate", @"title": @"评价TA"},
                  @{@"image": @"chat_album", @"title": @"相册"},
                  @{@"image": @"chat_camera", @"title": @"拍照"},
//                  @{@"image": @"chat_video", @"title": @"短视频"},
//                  @{@"image": @"chat_location", @"title": @"位置"}
        ];
    }
    return _data;
}

@end

@implementation ChatMoreViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titlaLabel];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = UIImageView.ivFrame(CGRectMake(0, 20, 60, 60));
    }
    return _imgView;
}

- (UILabel *)titlaLabel {
    if (!_titlaLabel) {
        _titlaLabel = UILabel.labelFrame(CGRectMake(0, self.imgView.bottom+5, 60, 17)).labelFont(kFontTheme12).labelTitleColor(kColorTheme666).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _titlaLabel;
}

@end
