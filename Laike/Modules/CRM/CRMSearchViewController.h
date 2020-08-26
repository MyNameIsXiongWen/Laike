//
//  CRMSearchViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/7.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRMSearchViewController : UIViewController

@end

@interface MessageSearchTopView : UIView

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *searchImgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, copy) void (^ textFieldValueChangedBlock)(NSString *content);
@property (nonatomic, copy) void (^ textFieldEndBlock)(NSString *content);

@end

NS_ASSUME_NONNULL_END
