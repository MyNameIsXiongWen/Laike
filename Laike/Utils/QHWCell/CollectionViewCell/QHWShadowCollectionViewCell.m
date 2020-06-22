//
//  QHWShadowCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/2/27.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWShadowCollectionViewCell.h"

@interface QHWShadowCollectionViewCell ()

@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation QHWShadowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImgView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UICreateView initWithFrame:CGRectZero BackgroundColor:UIColor.clearColor CornerRadius:0];
        [self.contentView addSubview:_shadowView];
    }
    return _shadowView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UICreateView initWithFrame:CGRectMake(-5, -5, self.bounds.size.width+10, self.bounds.size.height+10) ImageUrl:@"" Image:[kImageMake(@"bgimg_5") resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch] ContentMode:UIViewContentModeScaleToFill];
    }
    return _bgImgView;
}

@end
