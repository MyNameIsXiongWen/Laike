//
//  HomeDynamicTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/9/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeDynamicTableViewCell.h"

@interface HomeDynamicTableViewCell ()

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation HomeDynamicTableViewCell

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
        [self.bkgView addSubview:self.avatarImgView];
        [self.bkgView addSubview:self.infoLabel];
    }
    return self;
}

- (void)configCellData:(id)data {
    NSDictionary *dic = (NSDictionary *)data;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(dic[@"headpath"])]];
    self.infoLabel.text = dic[@"tip"];
}

- (UIView *)bkgView {
    if (!_bkgView) {
        _bkgView = UIView.viewFrame(CGRectMake(10, 0, kScreenW-20, 50)).borderColor(kColorThemeeee).cornerRadius(10);
        [self.contentView addSubview:_bkgView];
    }
    return _bkgView;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivFrame(CGRectMake(30, 10, 30, 30)).ivCornerRadius(15);
    }
    return _avatarImgView;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.right+15, 10, self.bkgView.width-self.avatarImgView.right-30, 30)).labelFont(kFontTheme14).labelTitleColor(kColorTheme707070);
    }
    return _infoLabel;
}

@end
