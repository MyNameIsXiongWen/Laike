//
//  QHWShadowTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/2/27.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWShadowTableViewCell.h"

@interface QHWShadowTableViewCell ()

@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation QHWShadowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(3);
            make.right.mas_equalTo(-3);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UICreateView initWithFrame:CGRectZero BackgroundColor:UIColor.clearColor CornerRadius:0];
        [self.contentView addSubview:_shadowView];
        _shadowView.userInteractionEnabled = YES;
    }
    return _shadowView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UICreateView initWithFrame:CGRectZero ImageUrl:@"" Image:[kImageMake(@"bgimg_10") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch] ContentMode:UIViewContentModeScaleToFill];
        _bgImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgImgView];
    }
    return _bgImgView;
}

@end
