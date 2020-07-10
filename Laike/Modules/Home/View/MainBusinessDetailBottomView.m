//
//  MainBusinessDetailBottomView.m
//  GoOverSeas
//
//  Created by manku on 2019/7/30.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MainBusinessDetailBottomView.h"
#import "QHWHouseModel.h"
#import "QHWStudyModel.h"
#import "QHWMigrationModel.h"
#import "QHWStudentModel.h"
#import "UserModel.h"
#import <UIButton+WebCache.h>
#import "QHWSystemService.h"
#import "CTMediator+ViewController.h"

@interface MainBusinessDetailBottomView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *onlineButton;
@property (nonatomic, strong) UIButton *phoneButton;
@property (nonatomic, strong) ActivityRegisterView *activityView;

@end
@implementation MainBusinessDetailBottomView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.lineView];
        [self addSubview:self.subjectButton];
        [self addSubview:self.nameLabel];
        [self addSubview:self.consultationLabel];
//        [self addSubview:self.onlineButton];
//        [self addSubview:self.phoneButton];
        [self addSubview:self.rightOperationButton];
        [self addKeyboardNotification];
    }
    return self;
}

- (void)setDetailModel:(QHWMainBusinessDetailBaseModel *)detailModel {
    _detailModel = detailModel;
    [self.subjectButton sd_setImageWithURL:[NSURL URLWithString:kFilePath(self.detailModel.bottomData.subjectHead)] forState:0];
    self.nameLabel.text = self.detailModel.bottomData.subjectName;
    self.consultationLabel.text = kFormat(@"咨询量：%ld", (long)self.detailModel.bottomData.consultCount);
}

- (void)subjectButtonClick {
//    if (self.businessType == 102001 || self.businessType == 103001) {
//        [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.detailModel.bottomData.subjectId UserType:3 BusinessType:self.businessType];
//    } else {
//        [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:self.detailModel.bottomData.subjectId UserType:self.detailModel.bottomData.subjectType == 1 ? 3 : 2 BusinessType:self.businessType];
//    }
}

- (void)rightOperationButtonClick {
    if (self.rightOperationBlock) {
        self.rightOperationBlock();
    }
}

- (void)phoneButtonClick {
    kCallTel(self.detailModel.bottomData.serviceHotline);
}

- (void)onlineButtonClick {
    if (self.businessType == 17) {
        QHWActivityModel *activityModel = (QHWActivityModel *)self.detailModel;
        CGFloat viewH = activityModel.registerModeList.count * 50 + 70 + 40;
        self.activityView = [[ActivityRegisterView alloc] initWithFrame:CGRectMake(40, (kScreenH-viewH)/2.0, kScreenW-80, viewH)];
        self.activityView.registerModeList = activityModel.registerModeList;
        self.activityView.confirmBlock = ^(NSArray * _Nonnull columnList) {
            QHWSystemService *service = QHWSystemService.new;
            [service registerActivityRequestWithActivityId:activityModel.id ColumnList:columnList];
        };
        [self.activityView show];
    } else {
        if (self.businessType == 103001) {
            [QHWSystemService showLabelAlertViewWithTitle:@"报名" Img:@"" MerchantId:self.detailModel.bottomData.subjectId IndustryId:self.businessType BusinessId:self.detailModel.id DescribeCode:12 PositionCode:self.detailModel.bottomData.subjectType == 1 ? 3: 7];
        } else {
            [QHWSystemService showLabelAlertViewWithTitle:@"预约咨询" Img:@"" MerchantId:self.detailModel.bottomData.subjectId IndustryId:self.businessType BusinessId:self.detailModel.id DescribeCode:6 PositionCode:self.detailModel.bottomData.subjectType == 1 ? 3: 7];
        }
    }
}

#pragma mark ------------键盘通知-------------
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShow:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        self.activityView.y = (kScreenH-frame.size.height-self.activityView.height)/2.0;
    }];
}

- (void)keyboardWillBeHiden:(NSNotification *)notification {
     self.activityView.y = (kScreenH-self.activityView.height)/2.0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark ------------UI-------------
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee);
    }
    return _lineView;
}

- (UIButton *)subjectButton {
    if (!_subjectButton) {
        _subjectButton = UIButton.btnFrame(CGRectMake(15, 15, 40, 40)).btnCornerRadius(20).btnAction(self, @selector(subjectButtonClick));
    }
    return _subjectButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelFrame(CGRectMake(self.subjectButton.right+5, 15, kScreenW-295, 20)).labelFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium]).labelTitleColor(kColorTheme2a303c);
    }
    return _nameLabel;
}

- (UILabel *)consultationLabel {
    if (!_consultationLabel) {
        _consultationLabel = UILabel.labelFrame(CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, 20)).labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3);
    }
    return _consultationLabel;
}

- (UIButton *)phoneButton {
    if (!_phoneButton) {
        _phoneButton = UIButton.btnFrame(CGRectMake(kScreenW-120, 15, 100, 45)).btnTitle(@"打电话").btnFont(kFontTheme14).btnTitleColor(kColorThemefff).btnBkgColor(kColorThemeed2530).btnCornerRadius(4).btnAction(self, @selector(phoneButtonClick));
    }
    return _phoneButton;
}

- (UIButton *)onlineButton {
    if (!_onlineButton) {
        _onlineButton = UIButton.btnFrame(CGRectMake(kScreenW-120-110, 15, 100, 45)).btnTitle(@"在线问").btnFont(kFontTheme14).btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme3cb584).btnCornerRadius(4).btnAction(self, @selector(onlineButtonClick));
    }
    return _onlineButton;
}

- (UIButton *)rightOperationButton {
    if (!_rightOperationButton) {
        _rightOperationButton = UIButton.btnFrame(CGRectMake(kScreenW-120-110, 15, 210, 45)).btnTitle(@"微信推广获客").btnFont(kFontTheme18).btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(4).btnAction(self, @selector(rightOperationButtonClick));
    }
    return _rightOperationButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface ActivityRegisterView ()

@property (nonatomic, strong) NSMutableArray *tfArray;

@end

@implementation ActivityRegisterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.popType = PopTypeCenter;
        UILabel *titleLabel = UILabel.labelFrame(CGRectMake(0, 20, self.width, 30)).labelText(@"立即报名").labelFont(kFontTheme16).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:titleLabel];
        
        UIButton *btn = UIButton.btnFrame(CGRectMake(0, self.height-40, self.width, 40)).btnTitle(@"立即报名").btnFont(kFontTheme14).btnTitleColor(kColorThemefb4d56).btnAction(self, @selector(clickRegisterBtn));
        [self addSubview:btn];
        [self addSubview:UIView.viewFrame(CGRectMake(0, self.height-40, self.width, 0.5)).bkgColor(kColorThemeeee)];
        self.tfArray = NSMutableArray.array;
    }
    return self;
}

- (void)setRegisterModeList:(NSArray *)registerModeList {
    _registerModeList = registerModeList;
    CGFloat originY =70;
    for (int i=0; i<registerModeList.count; i++) {
        NSDictionary *dic = registerModeList[i];
        UITextField *tf = UITextField.tfFrame(CGRectMake(10, originY, self.width-20, 40)).tfFont(kFontTheme14).tfTextColor(kColorThemea4abb3).tfBorderColor(kColorThemea4abb3).tfCornerRadius(3).tfPlaceholder(kFormat(@"请输入%@", dic[@"name"]));
        tf.tag = i;
        if (i==0) {
            [tf becomeFirstResponder];
        }
        [self addSubview:tf];
        originY += 50;
        [self.tfArray addObject:tf];
    }
}

- (void)clickRegisterBtn {
    NSMutableArray *columnArray = NSMutableArray.array;
    for (int i=0; i<self.tfArray.count; i++) {
        UITextField *tf = self.tfArray[i];
        NSDictionary *dic = self.registerModeList[i];
        if (tf.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:kFormat(@"请输入%@", dic[@"name"])];
            return;
        }
        [columnArray addObject:@{@"columnId": dic[@"id"], @"columnValue": tf.text}];
    }
    if (self.confirmBlock) {
        self.confirmBlock(columnArray);
    }
    [self dismiss];
}

@end
