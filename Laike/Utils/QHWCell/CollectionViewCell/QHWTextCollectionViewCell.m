//
//  QHWTextCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/18.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWTextCollectionViewCell.h"

@implementation QHWTextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = kColorTheme2a303c;
    }
    return self;
}

- (void)setTitleText:(NSString *)titleText{
    self.textLabel.text = titleText;
    CGFloat itemWidth = [titleText getWidthWithFont:kFontTheme12 constrainedToSize:CGSizeMake(1000, 30)];
    if (itemWidth > kScreenW - 60){
        itemWidth = kScreenW - 60;
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.textLabel.width = itemWidth;
    self.contentView.width = self.textLabel.width + 20;
}

- (void)setContentViewCornerRadius:(CGFloat)contentViewCornerRadius {
    self.contentView.layer.cornerRadius = contentViewCornerRadius;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UICreateView initWithFrame:CGRectMake(10, 0, 0, self.contentView.height) Text:@"" Font:kFontTheme12 TextColor:kColorTheme2a303c BackgroundColor:UIColor.clearColor];
        _textLabel.numberOfLines = 1;
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}

@end
