//
//  SelectCountryView.m
//  Laike
//
//  Created by xiaobu on 2020/7/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "SelectCountryView.h"

@interface SelectCountryView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bottomBlackView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, assign) NSInteger selectedLeftIndex;

@end

@implementation SelectCountryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.popType = PopTypeBottom;
        self.backgroundView.backgroundColor = UIColor.clearColor;
//        [[UIApplication sharedApplication].delegate.window addSubview:self.bottomBlackView];
//        [UIView animateWithDuration:0.25 animations:^{
//            self.bottomBlackView.alpha = 0.3;
//        }];
    }
    return self;
}

- (void)setDataArray:(NSArray<FilterCellModel *> *)dataArray {
    _dataArray = dataArray;
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.dataArray.count;
    } else {
        FilterCellModel *cellModel = self.dataArray[self.selectedLeftIndex];
        return cellModel.children.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.font = kFontTheme14;
    cell.textLabel.width = tableView.width;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (tableView == self.leftTableView) {
        if (indexPath.row == self.selectedLeftIndex) {
            cell.textLabel.textColor = kColorTheme21a8ff;
            cell.contentView.backgroundColor = kColorThemefff;
        } else {
            cell.textLabel.textColor = kColorTheme666;
            cell.contentView.backgroundColor = kColorThemef5f5f5;
        }
        cell.textLabel.text = self.dataArray[indexPath.row].name;
    } else {
        FilterCellModel *countryModel = self.dataArray[self.selectedLeftIndex];
        FilterCellModel *cityModel = countryModel.children[indexPath.row];
        cell.textLabel.textColor = cityModel.selected ? kColorTheme21a8ff : kColorTheme666;
        cell.textLabel.text = cityModel.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        if (indexPath.row != self.selectedLeftIndex) {
            self.selectedLeftIndex = indexPath.row;
            [tableView reloadData];
            [self.rightTableView reloadData];
        }
    } else {
        FilterCellModel *countryModel = self.dataArray[self.selectedLeftIndex];
        FilterCellModel *cityModel = countryModel.children[indexPath.row];
        cityModel.selected = !cityModel.selected;
        if (self.didSelectedBlock) {
            self.didSelectedBlock(cityModel);
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = cityModel.selected ? kColorTheme21a8ff : kColorTheme666;
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
        _bottomBlackView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, kScreenH-self.height)).bkgColor(kColorTheme000);
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
