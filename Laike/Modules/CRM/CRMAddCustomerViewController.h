//
//  CRMAddCustomerViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/1.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRMAddCustomerViewController : UIViewController

@end

@interface CRMTextFieldView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
