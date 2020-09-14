//
//  MessageChatSystemTableViewCell.m
//  XuanWoJia
//
//  Created by jason on 2019/8/15.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatSystemTableViewCell.h"

@implementation MessageChatSystemTableViewCell

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
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelFrame(CGRectMake(0, 10, kScreenW, 17)).labelFont(kFontTheme14).labelTitleColor(kColorTheme666).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _contentLabel;
}

@end
