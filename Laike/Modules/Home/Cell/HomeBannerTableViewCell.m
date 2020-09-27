//
//  HomeBannerTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeBannerTableViewCell.h"

@implementation HomeBannerTableViewCell

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
        [self.contentView addSubview:self.bannerView];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.bannerView.imgArray = (NSArray *)data;
}

- (QHWCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[QHWCycleScrollView alloc] initWithFrame:CGRectMake(10, 0, kScreenW-20, 110)];
        _bannerView.imgCornerRadius = 10;
    }
    return _bannerView;
}

@end
