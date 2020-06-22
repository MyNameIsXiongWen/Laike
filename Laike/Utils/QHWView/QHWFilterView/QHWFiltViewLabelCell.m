//
//  QHWFiltViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/19.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWFiltViewLabelCell.h"
#import "UILabel+Category.h"
#import "UIView+Category.h"

@implementation QHWFiltViewLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.cornerRadius(3);
    self.bgView.layer.borderWidth = 0.5;
}

- (void)setModel:(FilterCellModel *)model {
    _model = model;
    _nameLabel.text = model.name;
    _bgView.layer.borderColor = model.selected ? kColorThemefb4d56.CGColor : kColorThemeeee.CGColor;
    _bgView.backgroundColor = model.selected ? kColorThemefff : kColorThemeeee;
    _nameLabel.textColor = model.selected ? kColorThemefb4d56 : kColorTheme666;
}

@end
