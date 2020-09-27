//
//  SearchBkgView.h
//  Laike
//
//  Created by xiaobu on 2020/9/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchBkgView : UIView

@property (nonatomic, strong) UIView *searchBgView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, copy) void (^ clickSearchBkgBlock)(void);

@end

NS_ASSUME_NONNULL_END
