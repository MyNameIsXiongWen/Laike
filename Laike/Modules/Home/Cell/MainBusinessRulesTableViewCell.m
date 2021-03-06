//
//  MainBusinessRulesTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MainBusinessRulesTableViewCell.h"
#import "QHWTabScrollView.h"
#import "QHWShareView.h"
#import "QHWHouseModel.h"
#import "UserModel.h"
#import "CTMediator+ViewController.h"

@interface MainBusinessRulesTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QHWBaseCellProtocol>

@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *advisoryBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MainBusinessRulesTableViewCell

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
        [self.tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        [self.advisoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(36);
            make.bottom.mas_equalTo(-15);
        }];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.advisoryBtn.mas_right).offset(20);
            make.size.equalTo(self.advisoryBtn);
//            make.height.equalTo(self.advisoryBtn.mas_width);
            make.bottom.right.mas_equalTo(-15);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.tabScrollView.mas_bottom);
            make.bottom.equalTo(self.advisoryBtn.mas_top);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.dataArray = (NSArray *)data;
    [self.collectionView reloadData];
}

#pragma mark ------------UIScrollViewDelegate-------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.dataArray.count) return;
    NSInteger currentPage = [self currentIndex] % (self.dataArray.count-1);
    [self.tabScrollView scrollToIndex:currentPage];
}

- (NSInteger)currentIndex {
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0)
        return 0;
    
    NSInteger index = (self.collectionView.contentOffset.x + kScreenW * 0.5) / kScreenW;
    return MAX(0,index);
}

#pragma mark ------------UICollectionViewDataSource-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count-1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    return CGSizeMake(kScreenW, [dic[@"height"] floatValue] + 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataArray.count) {
        RulesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RulesCollectionViewCell.class) forIndexPath:indexPath];
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.contentLabel.text = dic[@"content"];
        return cell;
    }
    return UICollectionViewCell.new;
}

#pragma mark ------------UI-------------
- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
        _tabScrollView.itemWidthType = ItemWidthTypeAdaptive;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.textFont = kMediumFontTheme14;
        _tabScrollView.dataArray = @[@"成交佣金", @"合作规则"];
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        };
        [self.contentView addSubview:_tabScrollView];
    }
    return _tabScrollView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:layout Object:self];
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:RulesCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(RulesCollectionViewCell.class)];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)clickAdvisoryBtn {
    QHWHouseModel *model = (QHWHouseModel *)self.dataArray.lastObject;
    kCallTel(model.serviceHotline);
}

- (void)clickShareBtn {
    if (UserModel.shareUser.bindStatus == 2) {
        [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
        return;
    }
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel": self.dataArray.lastObject, @"shareType": @(ShareTypeMainBusiness)}];
    [shareView show];
}

- (UIButton *)advisoryBtn {
    if (!_advisoryBtn) {
        _advisoryBtn = UIButton.btnInit().btnTitle(@"咨询开单助理").btnFont(kFontTheme16).btnTitleColor(kColorTheme21a8ff).btnBorderColor(kColorTheme21a8ff).btnCornerRadius(18).btnAction(self, @selector(clickAdvisoryBtn));
        [self.contentView addSubview:_advisoryBtn];
    }
    return _advisoryBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = UIButton.btnInit().btnTitle(@"一键分享获客").btnFont(kFontTheme16).btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(18).btnAction(self, @selector(clickShareBtn));
        [self.contentView addSubview:_shareBtn];
    }
    return _shareBtn;
}

@end

@implementation RulesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorTheme9399a5).labelNumberOfLines(0);
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}

@end
