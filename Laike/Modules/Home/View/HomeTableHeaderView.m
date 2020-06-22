//
//  HomeTableHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeTableHeaderView.h"


@interface HomeTableHeaderView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bkgView;
@property (nonatomic, strong) UserInfoView *userInfoView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeTableHeaderView

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
        [self addSubview:self.bkgView];
//        [self addSubview:self.searchView];
    }
    return self;
}

- (void)clickUserInfoView {
    
}

#pragma mark ------------UI-------------
- (UIView *)bkgView {
    if (!_bkgView) {
        _bkgView = UIImageView.ivFrame(CGRectMake(0, 0, kScreenW, 240)).ivImage(kImageMake(@"mine_bkg"));
    }
    return _bkgView;
}

- (UserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 60, kScreenW, 70)];
        _userInfoView.userInteractionEnabled = YES;
        [_userInfoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserInfoView)]];
    }
    return _userInfoView;
}

- (UITableView *)tableView {
    if (!_tableView) {
//        _tableView = [UICreateView initWithFrame:CGRectMake(0, self.buttonView.bottom, kScreenW, 0) Style:UITableViewStylePlain Object:self];
//        _tableView.sectionFooterHeight = 0;
//        for (NSString *cellString in self.homeService.tableViewCellArray) {
//            [_tableView registerClass:NSClassFromString(cellString) forCellReuseIdentifier:cellString];
//        }
//        [_tableView registerClass:HomeTableHeaderViewSubHeader.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(HomeTableHeaderViewSubHeader.class)];
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end

@implementation UserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.avatarImgView = UIImageView.ivFrame(CGRectMake(15, 0, self.height, self.height)).ivCornerRadius(self.height/2);
        [self addSubview:self.avatarImgView];
        
        self.nameLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.right+10, 5, kScreenW-2000, 33)).labelTitleColor(kColorThemefff).labelFont(kMediumFontTheme24);
        [self addSubview:self.nameLabel];
        
        self.companyLabel = UILabel.labelFrame(CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, 17)).labelTitleColor(kColorThemefff).labelFont(kFontTheme14);
        [self addSubview:self.companyLabel];
        
        self.shareBtn = UIButton.btnFrame(CGRectMake(kScreenW-95, 25, 80, 20)).btnTitle(@"分享名片").btnTitleColor(kColorThemefff).btnFont(kFontTheme14).btnBkgColor([UIColor colorFromHexString:@"566586"]).btnCornerRadius(2).btnAction(self, @selector(clickShareBtn));
        [self addSubview:self.shareBtn];
    }
    return self;
}

- (void)clickShareBtn {
    
}

@end
