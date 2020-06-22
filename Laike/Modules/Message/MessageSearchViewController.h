//
//  MessageSearchViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageSearchViewController : UIViewController

@end

@interface MessageSearchTopView : UIView

@property (nonatomic, strong) UIImageView *searchImgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, copy) void (^ textFieldValueChangedBlock)(NSString *content);
@property (nonatomic, copy) void (^ textFieldEndBlock)(NSString *content);

@end

@interface MessageSearchHeaderView : UIView

@property (nonatomic, strong) UIImageView *searchImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, copy) void (^ tapSearchBlock)(NSString *content);

@end

NS_ASSUME_NONNULL_END
