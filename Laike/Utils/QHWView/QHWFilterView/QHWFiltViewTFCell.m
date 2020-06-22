//
//  QHWFiltViewTFCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/1/19.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWFiltViewTFCell.h"

@interface QHWFiltViewTFCell() <UITextFieldDelegate>

@end

@implementation QHWFiltViewTFCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)setModel:(FilterCellModel *)model {
    _model = model;
    _textField.text = model.valueStr;
    _textField.placeholder = model.placeHolder;
    self.line.frame = CGRectMake(0, model.size.height-0.5, model.size.width, 0.5);
    self.textField.frame = CGRectMake(0, 0, model.size.width, model.size.height);
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewFrame(CGRectMake(0, self.height-0.5, self.width, 0.5)).bkgColor(kColorTheme999);
    }
    return _line;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = UITextField.tfFrame(self.bounds).tfTextColor(kColorTheme2a303c).tfFont(kFontTheme16);
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(handleTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
        [_textField addTarget:self action:@selector(handleTextFieldEditAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)handleTextFieldEditAction:(UITextField *)textField {
//    self.model.valueStr = textField.text;
}

- (void)handleTextFieldAction:(UITextField *)textField {
    if ([self.model.valueStr isEqualToString:textField.text]) {
        return;
    }
    self.model.valueStr = textField.text;
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(textField.text);
    }
}

#pragma mark ------------UITextFieldDelegate-------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    if (textField.text.length == 10) {
        return NO;
    }
    if ([string iSNumStr]) {
        return YES;
    }
    return NO;
}

@end
