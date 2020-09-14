//
//  ChatInputBarTopView.m
//  XuanWoJia
//
//  Created by jason on 2019/9/27.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "ChatInputBarTopView.h"

@interface ChatInputBarTopView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *data;

@end

@implementation ChatInputBarTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kColorThemefff;
        [self addSubview:self.moreCollectionView];
        [self addSubview:UIView.viewFrame(CGRectMake(0, 39.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return self;
}

- (void)setCommonWordBtnSelected:(BOOL)commonWordBtnSelected {
    _commonWordBtnSelected = commonWordBtnSelected;
    [self.moreCollectionView reloadData];
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatInputBarTopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ChatInputBarTopViewCell.class) forIndexPath:indexPath];
    NSDictionary *dic = self.data[indexPath.row];
    cell.tagLabel.text = dic[@"title"];
    if (indexPath.row == 0) {
        cell.cellSelected = self.commonWordBtnSelected;
    } else {
        cell.cellSelected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.data[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(inputBarTopView_didClickTopView:didSelectTopCell:)]) {
        [_delegate inputBarTopView_didClickTopView:self didSelectTopCell:dic[@"identifier"]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.data[indexPath.row];
    return CGSizeMake([dic[@"title"] getWidthWithFont:kFontTheme12 constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)]+30, 30);
}

#pragma mark ------------UI-------------
- (UICollectionView *)moreCollectionView {
    if (!_moreCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
        
        _moreCollectionView = [UICreateView initWithFrame:CGRectMake(0, 0, self.width-75, 40) Layout:flowLayout Object:self];
        [_moreCollectionView registerClass:[ChatInputBarTopViewCell class] forCellWithReuseIdentifier:NSStringFromClass(ChatInputBarTopViewCell.class)];
    }
    return _moreCollectionView;
}

- (NSArray *)data {
    if (!_data) {
        _data = @[
//        @{@"identifier": @"chat_commonWords", @"title": @"常用语"},
                  @{@"identifier": @"chat_wantPhone", @"title": @"获取联系方式"},
//                  @{@"identifier": @"chat_goods", @"title": @"商品"}
        ];
    }
    return _data;
}

@end

@implementation ChatInputBarTopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setCellSelected:(BOOL)cellSelected {
    _cellSelected = cellSelected;
    self.tagLabel.textColor = cellSelected ? UIColor.whiteColor : kColorTheme666;
    self.contentView.layer.borderColor = cellSelected ? kColorThemefb4d56.CGColor : kColorTheme666.CGColor;
    self.contentView.backgroundColor = cellSelected ? kColorThemefb4d56 : UIColor.whiteColor;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorTheme666).labelTextAlignment(NSTextAlignmentCenter);
        [self.contentView addSubview:_tagLabel];
    }
    return _tagLabel;
}

@end
