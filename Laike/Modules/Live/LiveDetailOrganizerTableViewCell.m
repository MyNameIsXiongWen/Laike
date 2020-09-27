//
//  LiveDetailOrganizerTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/30.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LiveDetailOrganizerTableViewCell.h"
#import "LiveModel.h"
#import "QHWBaseCellProtocol.h"
#import "QHWSystemService.h"

@interface LiveDetailOrganizerTableViewCell () <QHWBaseCellProtocol>

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) LiveModel *liveModel;

@end

@implementation LiveDetailOrganizerTableViewCell

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
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(40);
            make.top.mas_equalTo(0);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(70);
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.avatarImgView.mas_centerY);
        }];
//        [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-15);
//            make.centerY.equalTo(self.avatarImgView);
//            make.width.mas_equalTo(50);
//            make.height.mas_equalTo(20);
//        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    NSArray *array = (NSArray *)data;
    self.liveModel = array.firstObject;
    BOOL hidden = [array.lastObject boolValue];
//    self.attentionButton.hidden = hidden;
//    self.attentionButton.selected = self.liveModel.concernStatus == 2;
//    if (self.attentionButton.selected) {
//        self.attentionButton.backgroundColor = kColorTheme999;
//    } else {
//        self.attentionButton.backgroundColor = kColorThemefb4d56;
//    }
    if (hidden) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(self.liveModel.mainHead)]];
        self.nameLabel.text = self.liveModel.mainName;
    } else {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(self.liveModel.bottomData.subjectHead)]];
        self.nameLabel.text = self.liveModel.bottomData.subjectName;
    }
}

- (void)attentionButtonClick:(UIButton *)btn {
    NSInteger concernStatus = self.liveModel.concernStatus == 1 ? 2 : 1;
    [QHWSystemService.new clickConcernRequestWithSubject:3 SubjectId:self.liveModel.bottomData.subjectId ConcernStatus:concernStatus Complete:^(BOOL status) {
        if (status) {
            self.liveModel.concernStatus = concernStatus;
            btn.selected = concernStatus == 2;
            if (btn.selected) {
                btn.backgroundColor = kColorTheme999;
            } else {
                btn.backgroundColor = kColorThemefb4d56;
            }
        }
    }];
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(20);
        [self.contentView addSubview:_avatarImgView];
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kMediumFontTheme16).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIButton *)attentionButton {
    if (!_attentionButton) {
        _attentionButton = UIButton.btnInit().btnTitle(@"+ 关注").btnSelectedTitle(@"已关注").btnTitleColor(kColorThemefff).btnBkgColor(kColorThemefb4d56).btnFont(kFontTheme11).btnCornerRadius(10);
        [_attentionButton addTarget:self action:@selector(attentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionButton];
    }
    return _attentionButton;
}

@end
