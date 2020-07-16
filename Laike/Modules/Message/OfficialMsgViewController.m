//
//  OfficialMsgViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "OfficialMsgViewController.h"

@interface OfficialMsgViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation OfficialMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"官方推荐";
    self.kNavigationView.rightBtn.frame = CGRectMake(kScreenW-90, kStatusBarHeight, 70, 44);
    self.kNavigationView.rightBtn.btnTitle(@"一键已读").btnFont(kFontTheme14).btnTitleColor(kColorTheme21a8ff);
}

- (void)rightNavBtnAction:(UIButton *)sender {
    
}

- (void)getMainData {
    
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfficialMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(OfficialMsgTableViewCell.class)];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:NSClassFromString(@"SystemMessageViewController").new animated:YES];
    } else {
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        [_tableView registerClass:OfficialMsgTableViewCell.class forCellReuseIdentifier:NSStringFromClass(OfficialMsgTableViewCell.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

@end

@implementation OfficialMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        }];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(35);
            make.top.equalTo(self.topLine.mas_bottom);
        }];
        [self.btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.width.mas_equalTo(6);
            make.top.mas_equalTo(10);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = UIButton.btnInit().btnTitle(@"查看更多").btnFont(kFontTheme14).btnTitleColor(kColorThemea4abb3);
        _moreBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = UIView.viewInit().bkgColor(kColorThemefb4d56).cornerRadius(3);
        _redView.hidden = YES;
        [self.contentView addSubview:_redView];
    }
    return _redView;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.viewInit().bkgColor(kColorThemef5f5f5);
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)btmLine {
    if (!_btmLine) {
        _btmLine = UIView.viewInit().bkgColor(kColorThemef5f5f5);
        [self.contentView addSubview:_btmLine];
    }
    return _btmLine;
}

@end