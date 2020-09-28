//
//  BrandTableViewCell.m
//  Laike
//
//  Created by xiaobu on 2020/9/25.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BrandTableViewCell.h"
#import "CTMediator+ViewController.h"

@implementation BrandTableViewCell

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
        self.logoImgView = UIImageView.ivFrame(CGRectMake(20, 15, 130, 65)).ivBorderColor(kColorThemeeee).ivCornerRadius(10);
        self.nameLabel = UILabel.labelFrame(CGRectMake(self.logoImgView.right+15, 23, kScreenW-45, 20)).labelTitleColor(kColorTheme000).labelFont(kFontTheme14);
        self.tagView = [[QHWTagView alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom+15, self.nameLabel.width, 15)];
        self.arrowImgView = UIImageView.ivFrame(CGRectMake(kScreenW-25, 38, 10, 18)).ivImage(kImageMake(@"arrow_right_gray"));
        self.chatBtn = UIButton.btnFrame(CGRectMake(kScreenW-85, 20, 70, 26)).btnCornerRadius(13).btnTitle(@"咨询合作").btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnFont(kFontTheme14).btnAction(self, @selector(clickChatBtn));
        self.line = UIView.viewFrame(CGRectMake(0, 94.5, kScreenW, 0.5)).bkgColor(kColorThemeeee);
        [self.contentView addSubview:self.logoImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.tagView];
        [self.contentView addSubview:self.arrowImgView];
        [self.contentView addSubview:self.chatBtn];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)configCellData:(id)data {
    NSArray *array = (NSArray *)data;
    self.model = (BrandModel *)array.firstObject;
    self.detailCell = [array.lastObject boolValue];
}

- (void)setDetailCell:(BOOL)detailCell {
    _detailCell = detailCell;
    self.arrowImgView.hidden = detailCell;
    self.chatBtn.hidden = !detailCell;
}

- (void)setModel:(BrandModel *)model {
    _model = model;
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.brandLogo)]];
    self.nameLabel.text = model.brandName;
    [self.tagView setTagWithTagArray:model.labelList];
    if (model.labelList.count == 0) {
        self.nameLabel.y = 37;
        self.chatBtn.y = 35;
    } else {
        self.nameLabel.y = 23;
        self.chatBtn.y = 20;
    }
}

- (void)clickChatBtn {
    [CTMediator.sharedInstance CTMediator_viewControllerForChatWithConversationId:nil ReceiverNickName:nil ReceiverHeadPath:nil];
}

@end
