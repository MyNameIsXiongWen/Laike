//
//  SearchTopView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/1.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTopView : UIView

@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, strong) UIButton *productBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, copy) void (^ clickProductTypeBlock)(NSInteger businessType);
@property (nonatomic, copy) void (^ textFieldValueChangedBlock)(NSString *content);

@end

NS_ASSUME_NONNULL_END

#import "QHWPopView.h"
@interface BusinessTypeView : QHWPopView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^ didSelectItemBlock)(NSInteger index, NSString *title);

@end
