//
//  CommunityTableHeaderView.m
//  GoOverSeas
//
//  Created by 熊文 on 2020/5/17.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityTableHeaderView.h"
#import "QHWCycleScrollView.h"

@interface CommunityTableHeaderView ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) QHWCycleScrollView *bannerView;

@end

@implementation CommunityTableHeaderView

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
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(100);
        }];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.bannerView.mas_bottom);
            make.height.mas_equalTo(40);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.leftLabel.mas_top);
            make.height.equalTo(self.leftLabel);
        }];
    }
    return self;
}

- (void)setCommunityType:(NSInteger)communityType {
    _communityType = communityType;
    if (communityType == 1) {
        self.leftLabel.text = @"权威机构";
        self.rightLabel.text = @"机构认证 >";
    } else {
        self.leftLabel.text = @"专家顾问";
        self.rightLabel.text = @"专家认证 >";
    }
}

- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    self.bannerView.hidden = bannerArray.count == 0;
    if (bannerArray.count > 0) {
        self.bannerView.imgArray = bannerArray;
    } else {
        [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
    }
}

#pragma mark ------------UI-------------
- (QHWCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[QHWCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, 100)];
        _bannerView.imgCornerRadius = 5;
        [self addSubview:_bannerView];
    }
    return _bannerView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = UILabel.labelInit().labelFont(kMediumFontTheme15).labelTitleColor(kColorTheme2a303c);
        [self addSubview:_leftLabel];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentRight);
        _rightLabel.userInteractionEnabled = YES;
        [_rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCertificate)]];
        [self addSubview:_rightLabel];
    }
    return _rightLabel;
}

@end
