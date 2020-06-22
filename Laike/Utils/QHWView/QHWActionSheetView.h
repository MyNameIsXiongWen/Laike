//
//  QHWActionSheetView.h
//  MANKUProject
//
//  Created by xiaobu on 2019/7/11.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "QHWPopView.h"
@class QHWActionSheetView;

@protocol QHWActionSheetViewDelegate <NSObject>

- (void)actionSheetViewSelectedIndex:(NSInteger)index WithActionSheetView:(QHWActionSheetView *)actionsheetView;

@end

@class QHWActionSheetTableViewCell;
@interface QHWActionSheetView : QHWPopView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
@property (nonatomic, weak) id <QHWActionSheetViewDelegate>sheetDelegate;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *identifier;

@end

@interface QHWActionSheetTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;

@end
