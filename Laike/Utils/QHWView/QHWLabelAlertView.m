//
//  QHWLabelAlertView.m
//  Guider
//
//  Created by xiaobu on 2019/10/24.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWLabelAlertView.h"

@interface QHWLabelAlertView ()

@property (nonatomic , strong , readwrite) UILabel *contentLbl;

@end

static const float selfWidth = 280;

@implementation QHWLabelAlertView
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(selfWidth - 30);
            make.height.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    CGFloat height = 0;
    if (contentString.length > 0) {
        self.contentLbl.text = contentString;
        height = MAX([contentString getHeightWithFont:kFontTheme15 constrainedToSize:CGSizeMake(selfWidth - 30, CGFLOAT_MAX)], 21);
        [self.contentLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
    self.height = self.selfHeight + height;
    self.frame = CGRectMake((kScreenW - selfWidth)/2, (kScreenH - self.height)/2, selfWidth, self.height);
}

- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = UILabel.labelInit().labelFont(kFontTheme15).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:_contentLbl];
    }
    return _contentLbl;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
