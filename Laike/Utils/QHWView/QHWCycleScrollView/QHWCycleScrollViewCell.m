//
//  QHWCycleScrollViewCell.m
//  QHWCycleScrollView
//
//  Created by cheyr on 2019/2/27.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import "QHWCycleScrollViewCell.h"

@implementation QHWCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    self.imageView.frame = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:self.imgCornerRadius];
    CAShapeLayer *maskLayer = CAShapeLayer.new;
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = UIImageView.ivInit();
    }
    return _imageView;
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = UIImageView.ivInit().ivImage(kImageMake(@"video_play"));
        _playImageView.hidden = YES;
        [self.contentView addSubview:_playImageView];
    }
    return _playImageView;
}

@end
