//
//  ChatCommonWordView.m
//  XuanWoJia
//
//  Created by jason on 2019/9/27.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "ChatCommonWordView.h"
//#import "LZGeneralTableViewCell.h"

@implementation ChatCommonWordView

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
        [self addSubview:self.tableView];
        [self addSubview:self.addBtn];
        [self addSubview:self.addLabel];
        [self addSubview:self.settingBtn];
        [self addSubview:UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
        [self addSubview:UIView.viewFrame(CGRectMake(0, self.height-0.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
        [self getCommonWordListRequest];
    }
    return self;
}

- (void)clickSettingBtn {
    if ([self.delegate respondsToSelector:@selector(commonWordView_didClickSettingBtn)]) {
        [self.delegate commonWordView_didClickSettingBtn];
    }
}

- (void)clickAddBtn {
    if ([self.delegate respondsToSelector:@selector(commonWordView_didClickAddBtn)]) {
        [self.delegate commonWordView_didClickAddBtn];
    }
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LZGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LZGeneralTableViewCell.class)];
//    ChatCommonWordModel *model = self.dataArray[indexPath.row];
//    cell.titleLabel.textColor = kColorThemeBlack70;
//    cell.titleLabel.text = model.userImCommonLanguageContent;
//    cell.arrowImageView.hidden = YES;
//    return cell;
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(commonWordView_didClickTableViewIndexpath:)]) {
        [self.delegate commonWordView_didClickTableViewIndexpath:self.dataArray[indexPath.row]];
    }
}

- (void)getCommonWordListRequest {
//    [LZHttpLoading show];
//    [LZHttpManager.sharedInstance LZ_GET:kUserCommonWordList parameters:nil success:^(id responseObject) {
//        self.dataArray = [NSArray yy_modelArrayWithClass:ChatCommonWordModel.class json:responseObject[@"data"]];
//        [self.tableView reloadData];
//        self.addLabel.text = [NSString stringWithFormat:@"新增常用语（%lu/20）", (unsigned long)self.dataArray.count];
//    } failure:^(NSError *error) {
//
//    }];
}

#pragma mark ------------UI-------------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, 185) Style:UITableViewStylePlain Object:self];
//        [_tableView registerClass:LZGeneralTableViewCell.class forCellReuseIdentifier:NSStringFromClass(LZGeneralTableViewCell.class)];
    }
    return _tableView;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UICreateView initWithFrame:CGRectMake(20, self.tableView.bottom, 40, 40) Title:@"" Image:kImageMake(@"message_commonword_add") SelectedImage:nil Font:nil TitleColor:nil BackgroundColor:nil CornerRadius:0];
        [_addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _addBtn;
}

- (UILabel *)addLabel {
    if (!_addLabel) {
        _addLabel = [UICreateView initWithFrame:CGRectMake(self.addBtn.right, self.tableView.bottom, kScreenW-110, 40) Text:@"新增常用语（0/20）" Font:kFontTheme14 TextColor:kColorThemefb4d56 BackgroundColor:UIColor.whiteColor];
        _addLabel.userInteractionEnabled = YES;
        [_addLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddBtn)]];
    }
    return _addLabel;
}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UICreateView initWithFrame:CGRectMake(kScreenW-60, self.tableView.bottom, 60, 40) Title:@"" Image:kImageMake(@"message_commonword_setting") SelectedImage:nil Font:nil TitleColor:nil BackgroundColor:nil CornerRadius:0];
        [_settingBtn addTarget:self action:@selector(clickSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

@end
