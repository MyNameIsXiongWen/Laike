//
//  PublishImgViewCell.m
//  GoOverSeas
//
//  Created by zhaoxiafei on 2019/3/19.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "PublishImgViewCell.h"

@implementation PublishImgViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.button];
    }
    return self;
}
-(void)handleButtoAction:(UIButton *)button
{
    if (self.closeAction) {
        self.closeAction();
    }
}
-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7.5, self.width - 7.5, self.height - 7.5)];
    }
    return _bgImageView;
}
-(UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(self.width - 15, 0, 15, 15);
        [_button setImage:[UIImage imageNamed:@"publish_close"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(handleButtoAction:) forControlEvents:UIControlEventTouchUpInside];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    }
    return _button;
}

@end
