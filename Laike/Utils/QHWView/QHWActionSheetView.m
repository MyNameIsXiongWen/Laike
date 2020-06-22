//
//  QHWActionSheetView.m
//  MANKUProject
//
//  Created by xiaobu on 2019/7/11.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "QHWActionSheetView.h"

@interface QHWActionSheetView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, copy) NSString *titleString;//第一个分区区头的标题

@end

@implementation QHWActionSheetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.titleString = title;
//        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
        [self addSubview:self.tableview];
        self.popType = PopTypeBottom;
    }
    return self;
}

#pragma mark ------------UITableView Delegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 44 + kBottomDangerHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.titleString.length > 0) {
            return 44;
        } else {
            return 0.01f;
        }
    }else{
        return 7;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, 7) BackgroundColor:kColorThemeeee CornerRadius:0];
    if (section == 0) {
        UILabel *titleLbl = [UICreateView initWithFrame:CGRectMake(20, 0, kScreenW - 40, 44) Text:self.titleString Font:kFontTheme12 TextColor:kColorThemefb4d56 BackgroundColor:UIColor.clearColor];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        
        UIView *line = [UICreateView initWithFrame:CGRectMake(0, 43.5, kScreenW, 0.5) BackgroundColor:kColorThemeeee CornerRadius:0];
        if (self.titleString.length > 0) {
            headerView.backgroundColor = UIColor.whiteColor;
            headerView.height = 44;
            [self clipViewWithView:headerView corner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
            [headerView addSubview:titleLbl];
            [headerView addSubview:line];
        } else {
            [titleLbl removeFromSuperview];
            [line removeFromSuperview];
        }
    }
    return headerView;
}

- (void)clipViewWithView:(UIView *)view corner:(UIRectCorner)corner cornerRadii:(CGSize)cornerRadii{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(10, 10)].CGPath;
    view.layer.mask = shapeLayer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWActionSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QHWActionSheetTableViewCell.class)];
    if (indexPath.section == 1) {
        cell.titleLabel.text = @"取消";
    }
    else {
        cell.titleLabel.text = self.dataArray[indexPath.row];
        cell.line.hidden = indexPath.row == self.dataArray.count-1;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.sheetDelegate respondsToSelector:@selector(actionSheetViewSelectedIndex:WithActionSheetView:)]) {
            [self.sheetDelegate actionSheetViewSelectedIndex:indexPath.row WithActionSheetView:self];
        }
    }
    [self dismiss];
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [UICreateView initWithFrame:self.bounds Style:UITableViewStylePlain Object:self];
        _tableview.backgroundColor = UIColor.clearColor;
        [_tableview registerClass:QHWActionSheetTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWActionSheetTableViewCell.class)];
        
    }
    return _tableview;
}

@end

@implementation QHWActionSheetTableViewCell

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
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UICreateView initWithFrame:CGRectMake(20, 7, kScreenW-40, 30) Text:@"" Font:kFontTheme18 TextColor:kColorTheme2a303c BackgroundColor:UIColor.whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [UICreateView initWithFrame:CGRectMake(20, CGRectGetHeight(self.bounds)-0.5, kScreenW-40, 0.5) BackgroundColor:kColorThemeeee CornerRadius:0];
        _line.hidden = YES;
    }
    return _line;
}

@end
