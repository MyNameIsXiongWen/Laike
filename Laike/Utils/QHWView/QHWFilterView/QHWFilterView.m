//
//  QHWFilterView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWFilterView.h"
#import "QHWFiltViewLabelCell.h"
#import "QHWFiltViewTFCell.h"
#import "QHWFiltViewWordCell.h"
#import "QHWFiltHeaderView.h"
#import "QHWFilterModel.h"

@interface QHWFilterView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (nonatomic, strong) UIView *bottomBlackView;

@end

@implementation QHWFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.popType = PopTypeTop;
        self.backgroundView.backgroundColor = UIColor.clearColor;
        [self addSubview:self.buttonBgView];
        [[UIApplication sharedApplication].delegate.window addSubview:self.bottomBlackView];
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBlackView.alpha = 0.3;
        }];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)clickResetButton {
    [self endEditing:YES];
    for (QHWFilterModel *filterModel in self.dataArray) {
        for (FilterCellModel *model in filterModel.content) {
            if (model.cellType == 0) {
                model.selected = NO;
            } else if (model.cellType == 1) {
                model.valueStr = @"";
            }
        }
    }
    [self.collectionView reloadData];
//    [self changeConditionParams];
    [self clickBottomBlackView];
    if (self.clickResetBlock) {
        self.clickResetBlock();
    }
}

- (void)clickConfirmButton {
    [self endEditing:YES];
    for (QHWFilterModel *filterModel in self.dataArray) {
        if ([filterModel.key isEqualToString:@"totalPrice"]) {
            __block FilterCellModel *selectedModel = nil;
            [filterModel.content enumerateObjectsUsingBlock:^(FilterCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.selected) {
                    selectedModel = obj;
                    *stop = YES;
                }
            }];
            if (!selectedModel) {
                if (filterModel.content[0].valueStr.length > 0 && filterModel.content[2].valueStr.length == 0) {
                    [SVProgressHUD showInfoWithStatus:kFormat(@"请输入%@", filterModel.content[2].placeHolder)];
                    return;
                } else if (filterModel.content[2].valueStr.length > 0 && filterModel.content[0].valueStr.length == 0) {
                    [SVProgressHUD showInfoWithStatus:kFormat(@"请输入%@", filterModel.content[0].placeHolder)];
                    return;
                }
            }
            break;
        }
    }
    [self clickBottomBlackView];
    if (self.clickConfirmBlock) {
        self.clickConfirmBlock();
    }
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    QHWFilterModel *filterModel = self.dataArray[section];
    return filterModel.content.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWFilterModel *filterModel = self.dataArray[indexPath.section];
    FilterCellModel *model = filterModel.content[indexPath.row];
    return model.size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    QHWFiltHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([QHWFiltHeaderView class]) forIndexPath:indexPath];
    QHWFilterModel *filterModel = self.dataArray[indexPath.section];
    view.titleLabel.text = filterModel.title;
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block QHWFilterModel *filterModel = self.dataArray[indexPath.section];
    FilterCellModel *model = filterModel.content[indexPath.row];
    if (model.cellType == 0) {
        QHWFiltViewLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWFiltViewLabelCell.class) forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (model.cellType == 1) {
        QHWFiltViewTFCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWFiltViewTFCell.class) forIndexPath:indexPath];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        cell.model = model;
        cell.textValueChangedBlock = ^(NSString * _Nonnull str) {
            NSMutableArray *reloadArray = [NSMutableArray array];
            for (int i = 0; i < filterModel.content.count; i++) {
                FilterCellModel *tempModel = filterModel.content[i];
                if (tempModel.cellType == 0) {
                    if (tempModel.selected) {
                        tempModel.selected = NO;
                        [reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    }
                }
            }
            [reloadArray addObject:indexPath];
            [collectionView reloadItemsAtIndexPaths:reloadArray];
        };
        return cell;
    } else {
        QHWFiltViewWordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWFiltViewWordCell.class) forIndexPath:indexPath];
        cell.wordLabel.text = model.name;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWFilterModel *filterModel = self.dataArray[indexPath.section];
    FilterCellModel *model = filterModel.content[indexPath.row];
    model.selected = !model.selected;
    NSMutableArray *reloadArray = [NSMutableArray arrayWithObjects:indexPath, nil];
    for (int i = 0; i < filterModel.content.count; i++) {
        FilterCellModel *tempModel = filterModel.content[i];
        if (tempModel.cellType == 1) {
            if (tempModel.valueStr.length > 0) {
                tempModel.valueStr = @"";
                [reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            }
        }
        if (tempModel.selected && ![tempModel isEqual:model]) {
            tempModel.selected = NO;
            [reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        }
    }
    [collectionView reloadItemsAtIndexPaths:reloadArray];
//    [self changeConditionParams];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    for (QHWFilterModel *filterModel in self.dataArray) {
        if ([filterModel.key isEqualToString:@"totalPrice"]) {
            FilterCellModel *model1 = filterModel.content[0];
            FilterCellModel *model2 = filterModel.content[2];
            
            if (model2.valueStr.length > 0 && model1.valueStr.length > 0) {
                if (model2.valueStr.floatValue < model1.valueStr.floatValue) {
                    NSString *tempStr = model2.valueStr;
                    model2.valueStr = model1.valueStr;
                    model1.valueStr = tempStr;
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:2 inSection:0]]];
                    break;
                }
            }
        }
    }
}

-(void)changeConditionParams {
    for (int i = 0;i < self.dataArray.count;i++) {
        QHWFilterModel *filterModel = self.dataArray[i];
        if (![filterModel.key isEqualToString:@"totalPrice"]) {
            FilterCellModel *tempModel = nil;
            for (FilterCellModel *model in filterModel.content) {
                if (model.selected) {
                    tempModel = model;
                }
            }
            if (tempModel) {
                [_conditionDic setObject:tempModel.code forKey:filterModel.key];
            } else {
                [_conditionDic removeObjectForKey:filterModel.key];
            }
        } else {
            [_conditionDic removeObjectForKey:@"totalPriceMin"];
            [_conditionDic removeObjectForKey:@"totalPriceMax"];
            FilterCellModel *tempModel = nil;
            NSMutableArray<FilterCellModel *> *tempArray = [NSMutableArray array];
            for (FilterCellModel *model in filterModel.content) {
                if (model.selected) {
                    tempModel = model;
                }
                if (model.valueStr.length > 0) {
                    [tempArray addObject:model];
                }
            }
            if (tempModel) {
                [_conditionDic setObject:tempModel.code forKey:@"totalPrice"];
            } else if (tempArray.count > 0) {
                for (FilterCellModel *model in tempArray) {
                    [_conditionDic setObject:model.valueStr forKey:model.code];
                }
            } else {
                [_conditionDic removeObjectForKey:@"totalPriceMin"];
                [_conditionDic removeObjectForKey:@"totalPriceMax"];
            }
        }
    }
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.headerReferenceSize = CGSizeMake(kScreenW, 60);
        
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, self.height-60) Layout:flowLayout Object:self];
        [_collectionView registerClass:QHWFiltViewTFCell.class forCellWithReuseIdentifier:NSStringFromClass(QHWFiltViewTFCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:@"QHWFiltViewLabelCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(QHWFiltViewLabelCell.class)];
        [_collectionView registerClass:[QHWFiltViewWordCell class] forCellWithReuseIdentifier:NSStringFromClass(QHWFiltViewWordCell.class)];
        [_collectionView registerClass:[QHWFiltHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([QHWFiltHeaderView class])];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIView *)buttonBgView {
    if (!_buttonBgView) {
        _buttonBgView = UIView.viewFrame(CGRectMake(0, self.height-60, kScreenW, 60));
        UIButton *resetButton = UIButton.btnFrame(CGRectMake(15, 10, (kScreenW-60)/2.0, 40)).btnTitle(@"重置筛选").btnTitleColor(kColorTheme666).btnBkgColor(kColorThemeeee).btnCornerRadius(20).btnAction(self, @selector(clickResetButton));
        UIButton *confirmButton = UIButton.btnFrame(CGRectMake(resetButton.right+30, 10, (kScreenW-60)/2.0, 40)).btnTitle(@"确定").btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(20).btnAction(self, @selector(clickConfirmButton));
        [_buttonBgView addSubview:resetButton];
        [_buttonBgView addSubview:confirmButton];
    }
    return _buttonBgView;
}

- (UIView *)bottomBlackView {
    if (!_bottomBlackView) {
        _bottomBlackView = UIView.viewFrame(CGRectMake(0, self.bottom, kScreenW, kScreenH-self.bottom)).bkgColor(kColorTheme000);
        _bottomBlackView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBottomBlackView)];
        [_bottomBlackView addGestureRecognizer:tap];
    }
    return _bottomBlackView;
}

- (void)clickBottomBlackView {
    [self dismiss];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomBlackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bottomBlackView removeFromSuperview];
    }];
}

- (void)popView_cancel {
    [self clickBottomBlackView];
}

@end
