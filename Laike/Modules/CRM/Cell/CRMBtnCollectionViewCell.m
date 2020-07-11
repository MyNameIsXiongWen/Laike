//
//  CRMBtnCollectionViewCell.m
//  ManKu_Merchant
//
//  Created by jason on 2019/1/18.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "CRMBtnCollectionViewCell.h"

@implementation CRMBtnCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleBtn.layer.borderColor = kColorTheme707070.CGColor;
    self.titleBtn.layer.borderWidth = 0.5;
    self.titleBtn.layer.cornerRadius = 8;
    self.titleBtn.layer.masksToBounds = YES;
}

- (void)setItemSelected:(BOOL)itemSelected {
    _itemSelected = itemSelected;
    self.titleBtn.selected = itemSelected;
    if (itemSelected) {
        self.titleBtn.layer.borderColor = kColorTheme21a8ff.CGColor;
        [self.titleBtn setTitleColor:kColorTheme21a8ff forState:UIControlStateSelected];
        [self.titleBtn setBackgroundColor:kColor(33, 168, 255, 0.3)];
    } else {
        self.titleBtn.layer.borderColor = kColorTheme707070.CGColor;
        [self.titleBtn setBackgroundColor:kColorThemefff];
    }
}

@end
