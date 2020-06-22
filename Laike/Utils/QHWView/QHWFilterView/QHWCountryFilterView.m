//
//  QHWCountryFilterView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWCountryFilterView.h"

@interface QHWCountryFilterView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bottomBlackView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, assign) NSInteger selectedLeftIndex;
@property (nonatomic, assign) NSInteger selectedRightIndex;

@end

@implementation QHWCountryFilterView

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
        [[UIApplication sharedApplication].delegate.window addSubview:self.bottomBlackView];
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBlackView.alpha = 0.3;
        }];
    }
    return self;
}

- (void)setDataArray:(NSArray<FilterCellModel *> *)dataArray {
    _dataArray = dataArray;
    [dataArray enumerateObjectsUsingBlock:^(FilterCellModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.selected) {
            self.selectedLeftIndex = idx;
            *stop = YES;
        }
    }];
    if (self.dataArray.count > 0) {
        [self.leftTableView reloadData];
        [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedLeftIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    if (!self.isTreatment) {
        FilterCellModel *cellModel = dataArray[self.selectedLeftIndex];
        [cellModel.data enumerateObjectsUsingBlock:^(FilterCellModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.selected) {
                self.selectedRightIndex = idx;
                *stop = YES;
            }
        }];
        if (cellModel.data.count > 0) {
            [self.rightTableView reloadData];
            [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRightIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    } else {
//        医疗的国家筛选框 只有一栏
        self.leftTableView.width = kScreenW;
        self.rightTableView.hidden = YES;
    }
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.dataArray.count;
    } else {
        FilterCellModel *cellModel = self.dataArray[self.selectedLeftIndex];
        if (!self.isTreatment) {
            return cellModel.data.count;
        }
    }
    return 0;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.font = kFontTheme14;
    cell.textLabel.width = tableView.width;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (tableView == self.leftTableView) {
        if (indexPath.row == self.selectedLeftIndex) {
            cell.textLabel.textColor = kColorThemefb4d56;
            cell.contentView.backgroundColor = kColorThemefff;
        } else {
            cell.textLabel.textColor = kColorTheme666;
            cell.contentView.backgroundColor = kColorThemef5f5f5;
        }
        cell.textLabel.text = self.dataArray[indexPath.row].name;
    } else {
        FilterCellModel *countryModel = self.dataArray[self.selectedLeftIndex];
        if (indexPath.row == self.selectedRightIndex) {
            cell.textLabel.textColor = kColorThemefb4d56;
        } else {
            cell.textLabel.textColor = kColorTheme666;
        }
        cell.textLabel.text = countryModel.data[indexPath.row].name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        if (indexPath.row != self.selectedLeftIndex) {
            self.selectedLeftIndex = indexPath.row;
            self.selectedRightIndex = 0;
            [tableView reloadData];
            [self.rightTableView reloadData];
            for (FilterCellModel *mmm in self.dataArray) {
                mmm.selected = NO;
            }
            FilterCellModel *countryModel = self.dataArray[indexPath.row];
            countryModel.selected = YES;
            if (countryModel.code.length == 0 || self.isTreatment) {
                [self clickBottomBlackView];
                FilterCellModel *cityModel = [FilterCellModel modelWithName:@"国家" Code:@""];
                cityModel.valueStr = @"cityId";
                self.didSelectedBlock(countryModel, cityModel);
            }
        }
    } else {
        [self clickBottomBlackView];
        FilterCellModel *countryModel = self.dataArray[self.selectedLeftIndex];
        self.selectedRightIndex = indexPath.row;
        for (FilterCellModel *mmm in countryModel.data) {
            mmm.selected = NO;
        }
        FilterCellModel *cityModel = countryModel.data[indexPath.row];
        cityModel.selected = YES;
        if (self.didSelectedBlock) {
            self.didSelectedBlock(countryModel, cityModel);
        }
    }
}

#pragma mark ------------UI-------------
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW*2/5, self.height) Style:UITableViewStylePlain Object:self];
        _leftTableView.rowHeight = 40;
        [_leftTableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self addSubview:_leftTableView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [UICreateView initWithFrame:CGRectMake(kScreenW*2/5, 0, kScreenW*3/5, self.height) Style:UITableViewStylePlain Object:self];
        _rightTableView.rowHeight = 40;
        [_rightTableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self addSubview:_rightTableView];
    }
    return _rightTableView;
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
