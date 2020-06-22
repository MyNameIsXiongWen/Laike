//
//  MineBannerTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MineBannerTableViewCell.h"

@implementation MineBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellData:(id)data {
    self.bannerView.imgArray = (NSArray *)data;
}

- (QHWCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[QHWCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, 90)];
        _bannerView.imgCornerRadius = 10;
        [self.shadowView addSubview:_bannerView];
    }
    return _bannerView;
}

@end
