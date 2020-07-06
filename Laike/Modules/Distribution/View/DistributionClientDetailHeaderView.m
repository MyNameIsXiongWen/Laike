//
//  DistributionClientDetailHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionClientDetailHeaderView.h"
#import "QHWTagView.h"

@interface DistributionClientDetailHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) QHWTagView *tagView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *businessKeyLabel;
@property (nonatomic, strong) UILabel *businessValueLabel;
@property (nonatomic, strong) UILabel *productKeyLabel;
@property (nonatomic, strong) UILabel *productValueLabel;
@property (nonatomic, strong) UILabel *infoKeyLabel;
@property (nonatomic, strong) UILabel *infoValueLabel;
@property (nonatomic, strong) DetailProcessView *processView;

@end

@implementation DistributionClientDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(35);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImgView.mas_right).offset(20);
            make.top.equalTo(self.avatarImgView.mas_top);
            make.right.mas_equalTo(-15);
        }];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(18);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.avatarImgView.mas_bottom).offset(40);
        }];
        [self.businessKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(22);
            make.top.equalTo(self.line.mas_bottom).offset(13);
        }];
        [self.businessValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.businessKeyLabel.mas_bottom).offset(5);
        }];
        [self.productKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.businessValueLabel.mas_bottom).offset(15);
        }];
        [self.productValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.productKeyLabel.mas_bottom).offset(5);
        }];
        [self.infoKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.productValueLabel.mas_bottom).offset(15);
        }];
        [self.infoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.infoKeyLabel.mas_bottom).offset(5);
        }];
        [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-20);
            make.height.mas_equalTo(50);
        }];
    }
    return self;
}

- (void)setClientDetailModel:(ClientModel *)clientDetailModel {
    _clientDetailModel = clientDetailModel;
    if (clientDetailModel.headPath.length > 0) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(clientDetailModel.headPath)]];
    } else {
        self.avatarImgView.image = [UIImage imageWithColor:kColorThemefff size:CGSizeMake(50, 50) text:clientDetailModel.realName textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} circular:YES];
    }
    self.nameLabel.text = clientDetailModel.realName;
//    [self.tagView setTagWithTagArray:@[]];
    self.businessValueLabel.text = clientDetailModel.businessName;
    self.productValueLabel.text = clientDetailModel.name;
    self.infoValueLabel.text = clientDetailModel.note;
}

#pragma mark ------------UI-------------
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(32).ivBorderColor(kColorTheme21a8ff);
        [self addSubview:_avatarImgView];
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme24).labelTitleColor(kColorTheme000);
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (QHWTagView *)tagView {
    if (!_tagView) {
        _tagView = [[QHWTagView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagView];
    }
    return _tagView;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self addSubview:_line];
    }
    return _line;
}

- (UILabel *)businessKeyLabel {
    if (!_businessKeyLabel) {
        _businessKeyLabel = UILabel.labelInit().labelText(@"预约业务").labelFont(kFontTheme16).labelTitleColor(kColorTheme000);
        [self addSubview:_businessKeyLabel];
    }
    return _businessKeyLabel;
}

- (UILabel *)businessValueLabel {
    if (!_businessValueLabel) {
        _businessValueLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self addSubview:_businessValueLabel];
    }
    return _businessValueLabel;
}

- (UILabel *)productKeyLabel {
    if (!_productKeyLabel) {
        _productKeyLabel = UILabel.labelInit().labelText(@"预约产品").labelFont(kFontTheme16).labelTitleColor(kColorTheme000);
        [self addSubview:_productKeyLabel];
    }
    return _productKeyLabel;
}

- (UILabel *)productValueLabel {
    if (!_productValueLabel) {
        _productValueLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self addSubview:_productValueLabel];
    }
    return _productValueLabel;
}

- (UILabel *)infoKeyLabel {
    if (!_infoKeyLabel) {
        _infoKeyLabel = UILabel.labelInit().labelText(@"报备信息").labelFont(kFontTheme16).labelTitleColor(kColorTheme000);
        [self addSubview:_infoKeyLabel];
    }
    return _infoKeyLabel;
}

- (UILabel *)infoValueLabel {
    if (!_infoValueLabel) {
        _infoValueLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self addSubview:_infoValueLabel];
    }
    return _infoValueLabel;
}

- (DetailProcessView *)processView {
    if (!_processView) {
        _processView = [[DetailProcessView alloc] initWithFrame:CGRectZero];
        [self addSubview:_processView];
    }
    return _processView;
}

@end


@interface DetailProcessView ()

@property (nonatomic, strong) UIView *leftSelectedView;
@property (nonatomic, strong) UIView *rightUnselectedView;
@property (nonatomic, strong) NSMutableArray *circleArray;

@end

@implementation DetailProcessView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
//        [self addSubview:self.leftSelectedView];
//        [self addSubview:self.rightUnselectedView];
        CGFloat originX = 30;
        CGFloat perWidth = (kScreenW-60)/4;
        [self addSubview:UIView.viewFrame(CGRectMake(30+perWidth/2.0, 10.5, kScreenW-60-perWidth, 1)).bkgColor(kColorThemea4abb3)];
        NSArray *array = @[@"报备", @"预定", @"成交", @"结佣"];
        for (int i=0; i<array.count; i++) {
            UIImageView *imgView = UIImageView.ivFrame((CGRectMake(originX+(perWidth-22)/2.0, 0, 22, 22))).ivCornerRadius(11);
            imgView.backgroundColor = kColorThemea4abb3;
            
            UILabel *label = UILabel.labelFrame(CGRectMake(originX, imgView.bottom+6, perWidth, 22)).labelFont(kFontTheme14).labelTextAlignment(NSTextAlignmentCenter).labelText(array[i]);
            
            [self addSubview:label];
            [self addSubview:imgView];
            [self.circleArray addObject:imgView];
            originX += perWidth;
        }
    }
    return self;
}

- (void)setCurrentProcess:(NSInteger)currentProcess {
    _currentProcess = currentProcess;
    CGFloat perWidth = (kScreenW-60)/4;
//    self.leftSelectedView.width = 40+(currentProcess-1)*perWidth;
//    self.rightUnselectedView.width = kScreenW-84-self.leftSelectedView.width;
//    self.rightUnselectedView.x = self.leftSelectedView.right;
//    if (self.orderStatus == 3) {
//        self.leftSelectedView.backgroundColor = kColorThemea4abb3;
//    } else {
//        self.leftSelectedView.backgroundColor = kColorTheme21a8ff;
//    }
    for (int i=1; i<=self.circleArray.count; i++) {
        UIImageView *imgView = self.circleArray[i-1];
        if (i < currentProcess) {
            if (self.orderStatus == 3) {
                imgView.image = kImageMake(@"crm_task_before_terminate");//灰色的勾
            } else {
                imgView.image = kImageMake(@"crm_task_before_ing");//橙色的勾
            }
        } else if (i == currentProcess) {
            if (self.orderStatus == 3) {
                imgView.image = kImageMake(@"crm_task_current_terminate");//灰色的叹号
            } else if (self.orderStatus == 2) {
                imgView.image = kImageMake(@"crm_task_before_ing");//橙色的勾
            } else {
                imgView.image = kImageMake(@"crm_task_current_ing");//橙色的圈
            }
        } else {
            imgView.image = kImageMake(@"crm_task_after");//灰色的圈
        }
    }
}

- (UIView *)leftSelectedView {
    if (!_leftSelectedView) {
        _leftSelectedView = UIView.viewFrame(CGRectMake(42, 30, 0, 8)).bkgColor(kColorThemea4abb3);
    }
    return _leftSelectedView;
}

- (UIView *)rightUnselectedView {
    if (!_rightUnselectedView) {
        _rightUnselectedView = UIView.viewFrame(CGRectMake(42, 30, kScreenW-84, 8)).bkgColor(kColorThemea4abb3);
    }
    return _rightUnselectedView;
}

- (NSMutableArray *)circleArray {
    if (!_circleArray) {
        _circleArray = NSMutableArray.array;
    }
    return _circleArray;
}

@end
